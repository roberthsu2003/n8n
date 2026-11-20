-- =============================================================
-- 範例 02：早餐店每日營收日報
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 會自動產生「最近 30 天」約 1,700 筆訂單，可重複執行
-- 💡 隔了幾週再上課，重新執行一次就會產生以「今天」為基準的新資料
-- =============================================================

DROP TABLE IF EXISTS public.bf_order_items;
DROP TABLE IF EXISTS public.bf_orders;
DROP TABLE IF EXISTS public.bf_menu_items;

-- 1. 菜單
CREATE TABLE public.bf_menu_items (
    id       SERIAL PRIMARY KEY,
    name     TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,          -- 漢堡 / 蛋餅 / 吐司 / 點心 / 飲料
    price    INT  NOT NULL,
    weight   INT  NOT NULL DEFAULT 1 -- 熱門程度（產生假資料用，數字越大越常被點）
);

-- 2. 訂單（一張單）
CREATE TABLE public.bf_orders (
    id           BIGSERIAL PRIMARY KEY,
    ordered_at   TIMESTAMP NOT NULL,          -- 點餐時間（台灣時間）
    channel      TEXT      NOT NULL,          -- 內用 / 外帶 / 外送平台
    total_amount INT       NOT NULL DEFAULT 0
);

-- 3. 訂單明細（一張單有好幾個品項）
CREATE TABLE public.bf_order_items (
    id           BIGSERIAL PRIMARY KEY,
    order_id     BIGINT NOT NULL REFERENCES public.bf_orders(id) ON DELETE CASCADE,
    menu_item_id INT    NOT NULL REFERENCES public.bf_menu_items(id),
    quantity     INT    NOT NULL,
    unit_price   INT    NOT NULL
);

INSERT INTO public.bf_menu_items (name, category, price, weight) VALUES
    ('豬肉起司蛋堡',   '漢堡', 65, 9),
    ('卡啦雞腿堡',     '漢堡', 75, 8),
    ('牛肉起司堡',     '漢堡', 80, 4),
    ('鮪魚蛋堡',       '漢堡', 55, 5),
    ('原味蛋餅',       '蛋餅', 30, 6),
    ('起司蛋餅',       '蛋餅', 40, 9),
    ('玉米蛋餅',       '蛋餅', 40, 6),
    ('培根蛋餅',       '蛋餅', 45, 7),
    ('火腿蛋吐司',     '吐司', 40, 6),
    ('肉鬆蛋吐司',     '吐司', 45, 4),
    ('花生厚片',       '吐司', 30, 3),
    ('巧克力厚片',     '吐司', 30, 3),
    ('薯餅',           '點心', 25, 8),
    ('蘿蔔糕（煎）',   '點心', 35, 7),
    ('麥克雞塊 5 塊',  '點心', 45, 5),
    ('大冰奶',         '飲料', 30, 10),
    ('大冰紅',         '飲料', 25, 7),
    ('熱豆漿',         '飲料', 20, 5),
    ('美式咖啡',       '飲料', 40, 6),
    ('鮮奶茶',         '飲料', 45, 5);

-- 固定亂數種子：每次執行產生的資料分布都一樣，方便老師對答案
SELECT setseed(0.2026);

-- 4. 產生訂單：最近 30 天（不含今天），每天 06:00～13:00 營業
--    平日每天約 45～60 單、週末約 60～75 單；07:00～09:00 是尖峰
INSERT INTO public.bf_orders (ordered_at, channel)
SELECT
    d::DATE
      + make_interval(hours => 6)
      + make_interval(mins => (
            CASE
                WHEN r < 0.15 THEN floor(random() * 60)        -- 06:00～07:00
                WHEN r < 0.70 THEN 60  + floor(random() * 120) -- 07:00～09:00 尖峰
                WHEN r < 0.90 THEN 180 + floor(random() * 120) -- 09:00～11:00
                ELSE               300 + floor(random() * 120) -- 11:00～13:00
            END)::INT),
    CASE
        WHEN random() < 0.35 THEN '內用'
        WHEN random() < 0.75 THEN '外帶'
        ELSE '外送平台'
    END
FROM generate_series(CURRENT_DATE - 30, CURRENT_DATE - 1, INTERVAL '1 day') AS d
CROSS JOIN LATERAL generate_series(
    1,
    CASE WHEN EXTRACT(ISODOW FROM d) >= 6 THEN 60 ELSE 45 END + floor(random() * 16)::INT
) AS n
CROSS JOIN LATERAL (SELECT random() AS r WHERE n IS NOT NULL) AS rr  -- 加上 n 讓每一筆都重新抽亂數
ORDER BY 1;

-- 5. 產生訂單明細：每單 1～3 個餐點，依照 weight 熱門程度加權抽選，大部分訂單會加一杯飲料
WITH picks AS (
    SELECT o.id AS order_id, m.id AS menu_item_id, m.price,
           1 + floor(random() * random() * 3)::INT AS quantity
    FROM public.bf_orders o
    CROSS JOIN LATERAL generate_series(1, 1 + floor(random() * 3)::INT) AS k
    CROSS JOIN LATERAL (
        SELECT mi.id, mi.price
        FROM public.bf_menu_items mi
        WHERE mi.category <> '飲料' AND k IS NOT NULL AND o.id IS NOT NULL  -- 參照外層欄位，每筆都重新抽
        ORDER BY -ln(random()) / mi.weight   -- 加權隨機抽樣
        LIMIT 1
    ) AS m
    UNION ALL
    SELECT o.id, m.id, m.price, 1
    FROM public.bf_orders o
    CROSS JOIN LATERAL (
        SELECT mi.id, mi.price
        FROM public.bf_menu_items mi
        WHERE mi.category = '飲料' AND o.id IS NOT NULL
        ORDER BY -ln(random()) / mi.weight
        LIMIT 1
    ) AS m
    WHERE random() < 0.8
)
INSERT INTO public.bf_order_items (order_id, menu_item_id, quantity, unit_price)
SELECT order_id, menu_item_id, quantity, price FROM picks;

-- 6. 回填每張訂單的總金額
UPDATE public.bf_orders o
SET total_amount = s.amount
FROM (
    SELECT order_id, SUM(quantity * unit_price) AS amount
    FROM public.bf_order_items
    GROUP BY order_id
) AS s
WHERE s.order_id = o.id;

-- 7. 驗證：最近 7 天每日營收
SELECT ordered_at::DATE AS 日期, COUNT(*) AS 訂單數, SUM(total_amount) AS 營收
FROM public.bf_orders
WHERE ordered_at >= CURRENT_DATE - 7
GROUP BY 1
ORDER BY 1;
