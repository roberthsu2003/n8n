-- ==============================================================================
-- n8n 教學用：Supabase (PostgreSQL) 範例資料庫結構
-- ==============================================================================

-- 1. 啟用 pgvector 擴充功能（若需實作 AI Agent 向量資料庫檢索）
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. 建立客戶資料表 (customers)
CREATE TABLE IF NOT EXISTS public.customers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(50),
    vip_level VARCHAR(20) DEFAULT 'Standard',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. 建立訂單資料表 (orders)
CREATE TABLE IF NOT EXISTS public.orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id BIGINT REFERENCES public.customers(id) ON DELETE CASCADE,
    total_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(30) DEFAULT 'pending', -- pending, paid, shipped, cancelled
    items JSONB DEFAULT '[]'::JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. 建立 AI 向量知識庫資料表 (documents - 供 RAG 與 AI Agent 檢索)
CREATE TABLE IF NOT EXISTS public.documents (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::JSONB,
    embedding VECTOR(1536) -- 支援 OpenAI text-embedding-3-small (1536維)
);

-- 5. 建立向量相似度搜尋函數 (RPC Function 供 n8n 呼叫)
CREATE OR REPLACE FUNCTION match_documents (
  query_embedding VECTOR(1536),
  match_count INT DEFAULT 5,
  filter JSONB DEFAULT '{}'::JSONB
) RETURNS TABLE (
  id BIGINT,
  content TEXT,
  metadata JSONB,
  similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.id,
    d.content,
    d.metadata,
    1 - (d.embedding <=> query_embedding) AS similarity
  FROM public.documents d
  WHERE d.metadata @> filter
  ORDER BY d.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;

-- 6. 插入基礎測試資料
INSERT INTO public.customers (name, email, phone, vip_level)
VALUES 
    ('王小明', 'ming@example.com', '0912-345-678', 'Gold'),
    ('李美麗', 'mary@example.com', '0922-111-222', 'Silver'),
    ('張大同', 'david@example.com', '0933-888-999', 'Standard')
ON CONFLICT (email) DO NOTHING;

INSERT INTO public.orders (order_number, customer_id, total_amount, status, items)
VALUES 
    ('ORD-2026-001', 1, 1500.00, 'paid', '[{"name": "人體工學椅", "price": 1500, "qty": 1}]'::JSONB),
    ('ORD-2026-002', 2, 890.00, 'pending', '[{"name": "無線滑鼠", "price": 890, "qty": 1}]'::JSONB)
ON CONFLICT (order_number) DO NOTHING;
