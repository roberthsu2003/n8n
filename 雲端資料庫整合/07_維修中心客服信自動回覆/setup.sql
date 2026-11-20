-- =============================================================
-- 範例 07：維修中心客服信自動回覆
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 建立客服工單資料表，n8n 每處理一封客服信就新增一筆
-- 資料表與欄位都用中文命名，PostgreSQL 可以直接使用，不需要加雙引號
-- =============================================================

DROP VIEW  IF EXISTS public.維修工單統計;
DROP TABLE IF EXISTS public.維修工單;

CREATE TABLE public.維修工單 (
    編號       BIGSERIAL PRIMARY KEY,
    郵件編號   TEXT UNIQUE,                     -- Gmail 信件 ID（避免同一封信建立兩張工單）
    顧客信箱   TEXT NOT NULL,
    主旨       TEXT,
    問題分類   TEXT NOT NULL,                   -- 保固查詢 / 維修費用 / 送修流程 / 故障排除 / 進度查詢 / 其他
    緊急程度   TEXT NOT NULL DEFAULT '一般',    -- 一般 / 緊急
    問題摘要   TEXT,                            -- AI 摘要的客人問題
    知識庫有答案 BOOLEAN NOT NULL DEFAULT TRUE,   -- FAQ 裡找得到答案嗎？找不到要人工處理
    處理狀態   TEXT NOT NULL DEFAULT '草稿待審', -- 草稿待審 / 已回覆 / 需人工處理
    建立時間   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 主管看的統計：各分類工單數
CREATE VIEW public.維修工單統計 AS
SELECT 問題分類,
       COUNT(*)                                    AS 工單數,
       COUNT(*) FILTER (WHERE 緊急程度 = '緊急')   AS 緊急件,
       COUNT(*) FILTER (WHERE NOT 知識庫有答案)       AS 需人工處理
FROM public.維修工單
GROUP BY 問題分類
ORDER BY 工單數 DESC;

-- 授權給 service_role（若之後想用 Supabase 節點讀取工單）
--（DO 區塊：在非 Supabase 的 PostgreSQL 執行時會自動略過）
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
        GRANT SELECT, INSERT, UPDATE, DELETE ON public.維修工單 TO service_role;
        GRANT SELECT ON public.維修工單統計 TO service_role;
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO service_role;
    END IF;
END $$;

-- 幾筆歷史工單，讓資料表一開始不是空的
INSERT INTO public.維修工單 (郵件編號, 顧客信箱, 主旨, 問題分類, 緊急程度, 問題摘要, 知識庫有答案, 處理狀態, 建立時間) VALUES
    ('demo-001', 'amy.chen@example.com',  '筆電螢幕有一條線',     '故障排除', '一般', '筆電螢幕出現垂直亮線，想知道是否在保固內', TRUE,  '已回覆',     NOW() - INTERVAL '3 days'),
    ('demo-002', 'kevin.lin@example.com', '手機泡水了很急',       '故障排除', '緊急', '手機掉進水裡無法開機，詢問處理方式',       TRUE,  '已回覆',     NOW() - INTERVAL '2 days'),
    ('demo-003', 'joy.wang@example.com',  '請問送修要多久',       '送修流程', '一般', '詢問平板送修所需天數',                     TRUE,  '已回覆',     NOW() - INTERVAL '1 day'),
    ('demo-004', 'tom.wu@example.com',    '可以幫我修無人機嗎',   '其他',     '一般', '詢問是否維修空拍機',                       FALSE, '需人工處理', NOW() - INTERVAL '5 hours');

SELECT * FROM public.維修工單統計;
