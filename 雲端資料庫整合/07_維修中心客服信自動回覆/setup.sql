-- =============================================================
-- 範例 07：維修中心客服信自動回覆
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 建立客服工單資料表，n8n 每處理一封客服信就新增一筆
-- =============================================================

DROP VIEW  IF EXISTS public.repair_ticket_summary;
DROP TABLE IF EXISTS public.repair_tickets;

CREATE TABLE public.repair_tickets (
    id            BIGSERIAL PRIMARY KEY,
    gmail_id      TEXT UNIQUE,                    -- Gmail 信件 ID（避免同一封信建立兩張工單）
    customer_email TEXT NOT NULL,
    subject       TEXT,
    category      TEXT NOT NULL,                  -- 保固查詢 / 維修費用 / 送修流程 / 故障排除 / 進度查詢 / 其他
    urgency       TEXT NOT NULL DEFAULT '一般',   -- 一般 / 緊急
    summary       TEXT,                           -- AI 摘要的客人問題
    found_in_faq  BOOLEAN NOT NULL DEFAULT TRUE,  -- FAQ 裡找得到答案嗎？找不到要人工處理
    status        TEXT NOT NULL DEFAULT '草稿待審', -- 草稿待審 / 已回覆 / 需人工處理
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 主管看的統計：各分類工單數
CREATE VIEW public.repair_ticket_summary AS
SELECT category,
       COUNT(*)                                  AS 工單數,
       COUNT(*) FILTER (WHERE urgency = '緊急')  AS 緊急件,
       COUNT(*) FILTER (WHERE NOT found_in_faq) AS 需人工處理
FROM public.repair_tickets
GROUP BY category
ORDER BY 工單數 DESC;

-- 幾筆歷史工單，讓資料表一開始不是空的
INSERT INTO public.repair_tickets (gmail_id, customer_email, subject, category, urgency, summary, found_in_faq, status, created_at) VALUES
    ('demo-001', 'amy.chen@example.com',  '筆電螢幕有一條線',     '故障排除', '一般', '筆電螢幕出現垂直亮線，想知道是否在保固內', TRUE,  '已回覆', NOW() - INTERVAL '3 days'),
    ('demo-002', 'kevin.lin@example.com', '手機泡水了很急',       '故障排除', '緊急', '手機掉進水裡無法開機，詢問處理方式',       TRUE,  '已回覆', NOW() - INTERVAL '2 days'),
    ('demo-003', 'joy.wang@example.com',  '請問送修要多久',       '送修流程', '一般', '詢問平板送修所需天數',                     TRUE,  '已回覆', NOW() - INTERVAL '1 day'),
    ('demo-004', 'tom.wu@example.com',    '可以幫我修無人機嗎',   '其他',     '一般', '詢問是否維修空拍機',                       FALSE, '需人工處理', NOW() - INTERVAL '5 hours');

SELECT * FROM public.repair_ticket_summary;
