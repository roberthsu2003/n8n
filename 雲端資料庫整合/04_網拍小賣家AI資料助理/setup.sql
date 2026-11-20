-- =============================================================
-- 範例 04：網拍小賣家 AI 資料助理
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 會產生「最近 180 天」約 1,000 筆訂單，可重複執行
-- ⚠️ 執行前請先把第 7 段的密碼 'ChangeMe_2026!' 改成自己的密碼
-- =============================================================

DROP VIEW  IF EXISTS public.shop_order_details;
DROP TABLE IF EXISTS public.shop_orders;
DROP TABLE IF EXISTS public.shop_customers;
DROP TABLE IF EXISTS public.shop_products;

-- 1. 商品（文青選物小店）
CREATE TABLE public.shop_products (
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL UNIQUE,
    category   TEXT NOT NULL,            -- 文具 / 杯具 / 香氛 / 包袋 / 居家
    price      INT  NOT NULL,            -- 售價
    cost       INT  NOT NULL,            -- 進貨成本
    stock      INT  NOT NULL,            -- 目前庫存
    weight     INT  NOT NULL DEFAULT 1   -- 熱門程度（產生假資料用）
);
COMMENT ON TABLE  public.shop_products IS '商品資料';
COMMENT ON COLUMN public.shop_products.stock IS '目前庫存數量';

-- 2. 顧客
CREATE TABLE public.shop_customers (
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    city       TEXT NOT NULL,
    joined_at  DATE NOT NULL
);

-- 3. 訂單（為了讓 AI 好寫 SQL，一筆訂單只買一種商品）
CREATE TABLE public.shop_orders (
    id           SERIAL PRIMARY KEY,
    order_date   DATE NOT NULL,
    customer_id  INT  NOT NULL REFERENCES public.shop_customers(id),
    product_id   INT  NOT NULL REFERENCES public.shop_products(id),
    quantity     INT  NOT NULL,
    unit_price   INT  NOT NULL,          -- 成交單價（有時會打折）
    channel      TEXT NOT NULL,          -- 蝦皮 / 官網 / IG 私訊 / 市集
    status       TEXT NOT NULL           -- 已完成 / 已取消 / 退貨
);

INSERT INTO public.shop_products (name, category, price, cost, stock, weight) VALUES
    ('手帳本 A5 點陣',         '文具', 380, 150, 42, 8),
    ('手帳本 A6 方格',         '文具', 320, 120, 7,  6),
    ('黃銅原子筆',             '文具', 590, 260, 15, 4),
    ('和紙膠帶 5 入組',        '文具', 250,  90, 88, 9),
    ('植物插畫貼紙包',         '文具', 120,  35, 3,  7),
    ('皮革筆袋',               '文具', 680, 300, 12, 3),
    ('手作陶瓷馬克杯',         '杯具', 480, 180, 9,  8),
    ('雙層玻璃咖啡杯',         '杯具', 420, 160, 26, 6),
    ('不鏽鋼保溫隨行杯',       '杯具', 750, 330, 31, 7),
    ('日式手沖濾杯',           '杯具', 560, 220, 5,  4),
    ('琺瑯杯 經典白',          '杯具', 390, 140, 0,  5),
    ('大豆蠟燭 白茶',          '香氛', 650, 210, 18, 7),
    ('大豆蠟燭 雪松',          '香氛', 650, 210, 2,  6),
    ('擴香瓶 尤加利',          '香氛', 880, 320, 14, 5),
    ('精油 薰衣草 10ml',       '香氛', 450, 150, 40, 6),
    ('香氛蠟片 3 入',          '香氛', 360, 110, 8,  4),
    ('帆布托特包 米白',        '包袋', 590, 210, 23, 8),
    ('帆布托特包 墨綠',        '包袋', 590, 210, 6,  6),
    ('防潑水後背包',           '包袋', 1680, 720, 11, 4),
    ('小方包 焦糖色',          '包袋', 980, 400, 4,  3),
    ('環保購物袋',             '包袋', 180,  50, 120, 5),
    ('亞麻抱枕套',             '居家', 520, 190, 17, 4),
    ('木質杯墊 4 入',          '居家', 280,  90, 55, 6),
    ('乾燥花束 小',            '居家', 450, 160, 9,  5),
    ('掛布 山景',              '居家', 790, 290, 13, 3),
    ('陶瓷小花器',             '居家', 380, 130, 1,  4),
    ('桌上型月曆 2027',        '文具', 350, 110, 64, 7),
    ('明信片 台灣街景 10 入',  '文具', 200,  60, 75, 6),
    ('鑰匙圈 木頭小鳥',        '居家', 220,  70, 30, 5),
    ('雨傘 自動開收',          '居家', 690, 280, 19, 4);

SELECT setseed(0.88);

-- 4. 顧客：60 位，分布在各縣市
INSERT INTO public.shop_customers (name, city, joined_at)
SELECT
    (ARRAY['陳','林','黃','張','李','王','吳','劉','蔡','楊','許','鄭','謝','郭','洪'])[1 + floor(random()*15)::INT]
  || (ARRAY['怡君','雅婷','家豪','志明','佳穎','宗翰','欣妤','冠廷','詩涵','柏宇','雅雯','俊賢','思妤','子晴','承恩'])[1 + floor(random()*15)::INT],
    (ARRAY['台北市','台北市','台北市','新北市','新北市','桃園市','台中市','台中市','台南市','高雄市','新竹市','宜蘭縣','花蓮縣'])[1 + floor(random()*13)::INT],
    CURRENT_DATE - (200 + floor(random() * 500))::INT
FROM generate_series(1, 60);

-- 5. 訂單：最近 180 天，越接近現在訂單越多（生意越來越好），週末較多
INSERT INTO public.shop_orders (order_date, customer_id, product_id, quantity, unit_price, channel, status)
SELECT
    o.order_date,
    1 + floor(random() * 60)::INT,
    p.id,
    CASE WHEN random() < 0.8 THEN 1 WHEN random() < 0.7 THEN 2 ELSE 3 END,
    CASE WHEN random() < 0.15 THEN round(p.price * 0.9) ELSE p.price END,
    CASE
        WHEN random() < 0.50 THEN '蝦皮'
        WHEN random() < 0.70 THEN '官網'
        WHEN random() < 0.75 THEN 'IG 私訊'
        ELSE '市集'
    END,
    CASE
        WHEN random() < 0.92 THEN '已完成'
        WHEN random() < 0.6  THEN '已取消'
        ELSE '退貨'
    END
FROM (
    SELECT d::DATE AS order_date, n
    FROM generate_series(CURRENT_DATE - 180, CURRENT_DATE - 1, INTERVAL '1 day') AS d
    CROSS JOIN LATERAL generate_series(
        1,
        (2 + (180 - (CURRENT_DATE - d::DATE)) / 60.0          -- 隨時間成長
           + CASE WHEN EXTRACT(ISODOW FROM d) >= 6 THEN 2 ELSE 0 END
           + random() * 3)::INT
    ) AS n
) AS o
CROSS JOIN LATERAL (
    SELECT sp.id, sp.price
    FROM public.shop_products sp
    WHERE o.n IS NOT NULL AND o.order_date IS NOT NULL   -- 參照外層欄位，每筆訂單都重新抽
    ORDER BY -ln(random()) / sp.weight
    LIMIT 1
) AS p;

-- 6. 方便 AI 查詢的檢視表：每筆訂單直接帶出商品名稱、分類、顧客縣市、金額與毛利
CREATE VIEW public.shop_order_details AS
SELECT
    o.id            AS order_id,
    o.order_date,
    o.status,
    o.channel,
    p.name          AS product_name,
    p.category,
    o.quantity,
    o.unit_price,
    o.quantity * o.unit_price                AS amount,
    o.quantity * (o.unit_price - p.cost)     AS profit,
    c.name          AS customer_name,
    c.city
FROM public.shop_orders o
JOIN public.shop_products  p ON p.id = o.product_id
JOIN public.shop_customers c ON c.id = o.customer_id;

-- 7. 建立「唯讀」資料庫帳號給 AI 使用：只能 SELECT，不能新增、修改、刪除
--    ⚠️ 請把密碼改成自己的，並記下來（n8n 建立第二個 Postgres 憑證時要用）
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ai_readonly') THEN
        CREATE ROLE ai_readonly LOGIN;
    END IF;
END $$;
ALTER ROLE ai_readonly PASSWORD 'ChangeMe_2026!';                -- 每次執行都會把密碼設成這裡的值
ALTER ROLE ai_readonly SET default_transaction_read_only = on;  -- 連線預設為唯讀交易
ALTER ROLE ai_readonly SET statement_timeout = '10s';           -- 防止 AI 寫出跑太久的查詢
GRANT USAGE  ON SCHEMA public TO ai_readonly;
GRANT SELECT ON public.shop_products, public.shop_customers, public.shop_orders, public.shop_order_details TO ai_readonly;

-- 8. 驗證：最近 30 天銷售額前 5 名商品
SELECT product_name, SUM(quantity) AS 銷售數量, SUM(amount) AS 銷售額
FROM public.shop_order_details
WHERE status = '已完成' AND order_date >= CURRENT_DATE - 30
GROUP BY product_name
ORDER BY 銷售額 DESC
LIMIT 5;
