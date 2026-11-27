-- =============================================================
-- 範例 04：網拍小賣家 AI 資料助理
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 會產生「最近 180 天」約 1,000 筆訂單，可重複執行
-- ⚠️ 執行前請先把第 7 段的密碼 'ChangeMe_2026!' 改成自己的密碼
-- 資料表與欄位都用中文命名，PostgreSQL 可以直接使用，不需要加雙引號
-- =============================================================

SET TIME ZONE 'Asia/Taipei';

DROP VIEW  IF EXISTS public.網拍訂單明細;
DROP TABLE IF EXISTS public.網拍訂單;
DROP TABLE IF EXISTS public.網拍顧客;
DROP TABLE IF EXISTS public.網拍商品;

-- 1. 商品（文青選物小店）
CREATE TABLE public.網拍商品 (
    編號      SERIAL PRIMARY KEY,
    商品名稱  TEXT NOT NULL UNIQUE,
    類別      TEXT NOT NULL,            -- 文具 / 杯具 / 香氛 / 包袋 / 居家
    售價      INT  NOT NULL,
    成本      INT  NOT NULL,            -- 進貨成本
    庫存      INT  NOT NULL,            -- 目前庫存數量
    熱門權重  INT  NOT NULL DEFAULT 1   -- 產生假資料用，數字越大越常被買
);

-- 2. 顧客
CREATE TABLE public.網拍顧客 (
    編號      SERIAL PRIMARY KEY,
    姓名      TEXT NOT NULL,
    縣市      TEXT NOT NULL,
    加入日期  DATE NOT NULL
);

-- 3. 訂單（為了讓 AI 好寫 SQL，一筆訂單只買一種商品）
CREATE TABLE public.網拍訂單 (
    編號      SERIAL PRIMARY KEY,
    訂單日期  DATE NOT NULL,
    顧客編號  INT  NOT NULL REFERENCES public.網拍顧客(編號),
    商品編號  INT  NOT NULL REFERENCES public.網拍商品(編號),
    數量      INT  NOT NULL,
    成交單價  INT  NOT NULL,          -- 有時會打折
    銷售通路  TEXT NOT NULL,          -- 蝦皮 / 官網 / IG 私訊 / 市集
    訂單狀態  TEXT NOT NULL           -- 已完成 / 已取消 / 退貨
);

INSERT INTO public.網拍商品 (商品名稱, 類別, 售價, 成本, 庫存, 熱門權重) VALUES
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

-- 4. 顧客：60 位，分布在各縣市
INSERT INTO public.網拍顧客 (姓名, 縣市, 加入日期)
SELECT
    (ARRAY['陳','林','黃','張','李','王','吳','劉','蔡','楊','許','鄭','謝','郭','洪'])[1 + floor(random()*15)::INT]
  || (ARRAY['怡君','雅婷','家豪','志明','佳穎','宗翰','欣妤','冠廷','詩涵','柏宇','雅雯','俊賢','思妤','子晴','承恩'])[1 + floor(random()*15)::INT],
    (ARRAY['台北市','台北市','台北市','新北市','新北市','桃園市','台中市','台中市','台南市','高雄市','新竹市','宜蘭縣','花蓮縣'])[1 + floor(random()*13)::INT],
    CURRENT_DATE - (200 + floor(random() * 500))::INT
FROM generate_series(1, 60);

-- 5. 訂單：最近 180 天 ＋ 今天，越接近現在訂單越多（生意越來越好），週末較多
INSERT INTO public.網拍訂單 (訂單日期, 顧客編號, 商品編號, 數量, 成交單價, 銷售通路, 訂單狀態)
SELECT
    o.訂單日期,
    1 + floor(random() * 60)::INT,
    p.編號,
    CASE WHEN random() < 0.8 THEN 1 WHEN random() < 0.7 THEN 2 ELSE 3 END,
    CASE WHEN random() < 0.15 THEN round(p.售價 * 0.9) ELSE p.售價 END,
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
    SELECT d::DATE AS 訂單日期, n
    FROM generate_series(CURRENT_DATE - 180, CURRENT_DATE, INTERVAL '1 day') AS d
    CROSS JOIN LATERAL generate_series(
        1,
        (2 + (180 - (CURRENT_DATE - d::DATE)) / 60.0          -- 隨時間成長
           + CASE WHEN EXTRACT(ISODOW FROM d) >= 6 THEN 2 ELSE 0 END
           + random() * 3)::INT
    ) AS n
) AS o
CROSS JOIN LATERAL (
    SELECT sp.編號, sp.售價
    FROM public.網拍商品 sp
    WHERE o.n IS NOT NULL AND o.訂單日期 IS NOT NULL   -- 參照外層欄位，每筆訂單都重新抽
    ORDER BY -ln(random()) / sp.熱門權重
    LIMIT 1
) AS p;

-- 6. 方便 AI 查詢的檢視表：每筆訂單直接帶出商品名稱、分類、顧客縣市、金額與毛利
CREATE VIEW public.網拍訂單明細 AS
SELECT
    o.編號                          AS 訂單編號,
    o.訂單日期,
    o.訂單狀態,
    o.銷售通路,
    p.商品名稱,
    p.類別,
    o.數量,
    o.成交單價,
    o.數量 * o.成交單價             AS 金額,
    o.數量 * (o.成交單價 - p.成本)  AS 毛利,
    c.姓名                          AS 顧客姓名,
    c.縣市
FROM public.網拍訂單 o
JOIN public.網拍商品 p ON p.編號 = o.商品編號
JOIN public.網拍顧客 c ON c.編號 = o.顧客編號;

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
ALTER ROLE ai_readonly SET timezone = 'Asia/Taipei';            -- 確保 AI 寫 CURRENT_DATE 時為台灣時間
GRANT USAGE  ON SCHEMA public TO ai_readonly;
GRANT SELECT ON public.網拍商品, public.網拍顧客, public.網拍訂單, public.網拍訂單明細 TO ai_readonly;

-- 8. 驗證：最近 30 天銷售額前 5 名商品
SELECT 商品名稱, SUM(數量) AS 銷售數量, SUM(金額) AS 銷售額
FROM public.網拍訂單明細
WHERE 訂單狀態 = '已完成' AND 訂單日期 >= CURRENT_DATE - 30
GROUP BY 商品名稱
ORDER BY 銷售額 DESC
LIMIT 5;
