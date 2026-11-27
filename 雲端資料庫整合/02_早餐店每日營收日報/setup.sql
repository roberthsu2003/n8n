-- =============================================================
-- 範例 02：早餐店每日營收日報
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 以台灣時間 (Asia/Taipei) 產生「最近 30 天 ＋ 今天」約 1,750 筆訂單，可重複執行
-- 💡 每次上課重新執行，都會以當下的日期動態產生全新隨機訂單與時間
-- 資料表與欄位都用中文命名，PostgreSQL 可以直接使用，不需要加雙引號
-- =============================================================

SET TIME ZONE 'Asia/Taipei';

DROP TABLE IF EXISTS public.早餐訂單明細;
DROP TABLE IF EXISTS public.早餐訂單;
DROP TABLE IF EXISTS public.早餐品項;

-- 1. 菜單
CREATE TABLE public.早餐品項 (
    編號      SERIAL PRIMARY KEY,
    品名      TEXT NOT NULL UNIQUE,
    類別      TEXT NOT NULL,          -- 漢堡 / 蛋餅 / 吐司 / 點心 / 飲料
    單價      INT  NOT NULL,
    熱門權重  INT  NOT NULL DEFAULT 1 -- 產生假資料用，數字越大越常被點
);

-- 2. 訂單（一張單）
CREATE TABLE public.早餐訂單 (
    編號      BIGSERIAL PRIMARY KEY,
    下單時間  TIMESTAMP NOT NULL,          -- 台灣時間
    點餐方式  TEXT      NOT NULL,          -- 內用 / 外帶 / 外送平台
    訂單金額  INT       NOT NULL DEFAULT 0
);

-- 3. 訂單明細（一張單有好幾個品項）
CREATE TABLE public.早餐訂單明細 (
    編號      BIGSERIAL PRIMARY KEY,
    訂單編號  BIGINT NOT NULL REFERENCES public.早餐訂單(編號) ON DELETE CASCADE,
    品項編號  INT    NOT NULL REFERENCES public.早餐品項(編號),
    數量      INT    NOT NULL,
    單價      INT    NOT NULL
);

INSERT INTO public.早餐品項 (品名, 類別, 單價, 熱門權重) VALUES
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

-- 4. 產生訂單：最近 30 天 ＋ 今天（共 31 天），每天 06:00～13:00 營業
--    平日每天約 45～60 單、週末約 60～75 單；07:00～09:00 是尖峰
--    每次執行不固定亂數種子，訂單日期、下單時間（到秒）與金額都會重新隨機產生
INSERT INTO public.早餐訂單 (下單時間, 點餐方式)
SELECT
    d::DATE
      + make_interval(hours => 6)
      + make_interval(mins => (
            CASE
                WHEN r < 0.15 THEN floor(random() * 60)        -- 06:00～07:00
                WHEN r < 0.70 THEN 60  + floor(random() * 120) -- 07:00～09:00 尖峰
                WHEN r < 0.90 THEN 180 + floor(random() * 120) -- 09:00～11:00
                ELSE               300 + floor(random() * 120) -- 11:00～13:00
            END)::INT)
      + make_interval(secs => floor(random() * 60)::INT),
    CASE
        WHEN random() < 0.35 THEN '內用'
        WHEN random() < 0.75 THEN '外帶'
        ELSE '外送平台'
    END
FROM generate_series(CURRENT_DATE - 30, CURRENT_DATE, INTERVAL '1 day') AS d
CROSS JOIN LATERAL generate_series(
    1,
    CASE WHEN EXTRACT(ISODOW FROM d) >= 6 THEN 60 ELSE 45 END + floor(random() * 16)::INT
) AS n
CROSS JOIN LATERAL (SELECT random() AS r WHERE n IS NOT NULL) AS rr  -- 加上 n 讓每一筆都重新抽亂數
ORDER BY 1;

-- 5. 產生訂單明細：每單 1～3 個餐點，依照「熱門權重」加權抽選，大部分訂單會加一杯飲料
WITH 抽選 AS (
    SELECT o.編號 AS 訂單編號, m.編號 AS 品項編號, m.單價,
           1 + floor(random() * random() * 3)::INT AS 數量
    FROM public.早餐訂單 o
    CROSS JOIN LATERAL generate_series(1, 1 + floor(random() * 3)::INT) AS k
    CROSS JOIN LATERAL (
        SELECT mi.編號, mi.單價
        FROM public.早餐品項 mi
        WHERE mi.類別 <> '飲料' AND k IS NOT NULL AND o.編號 IS NOT NULL  -- 參照外層欄位，每筆都重新抽
        ORDER BY -ln(random()) / mi.熱門權重   -- 加權隨機抽樣
        LIMIT 1
    ) AS m
    UNION ALL
    SELECT o.編號, m.編號, m.單價, 1
    FROM public.早餐訂單 o
    CROSS JOIN LATERAL (
        SELECT mi.編號, mi.單價
        FROM public.早餐品項 mi
        WHERE mi.類別 = '飲料' AND o.編號 IS NOT NULL
        ORDER BY -ln(random()) / mi.熱門權重
        LIMIT 1
    ) AS m
    WHERE random() < 0.8
)
INSERT INTO public.早餐訂單明細 (訂單編號, 品項編號, 數量, 單價)
SELECT 訂單編號, 品項編號, 數量, 單價 FROM 抽選;

-- 6. 回填每張訂單的訂單金額
UPDATE public.早餐訂單 o
SET 訂單金額 = s.金額
FROM (
    SELECT 訂單編號, SUM(數量 * 單價) AS 金額
    FROM public.早餐訂單明細
    GROUP BY 訂單編號
) AS s
WHERE s.訂單編號 = o.編號;

-- 7. 驗證：最近 8 天每日營收（含昨天與今天，對照台灣時間）
SELECT
    下單時間::DATE AS 日期,
    CASE 下單時間::DATE
        WHEN CURRENT_DATE     THEN '今天'
        WHEN CURRENT_DATE - 1 THEN '昨天'
        ELSE to_char(下單時間, 'Dy')
    END AS 備註,
    COUNT(*)      AS 訂單數,
    SUM(訂單金額) AS 營收
FROM public.早餐訂單
WHERE 下單時間::DATE >= CURRENT_DATE - 7
GROUP BY 1
ORDER BY 1;
