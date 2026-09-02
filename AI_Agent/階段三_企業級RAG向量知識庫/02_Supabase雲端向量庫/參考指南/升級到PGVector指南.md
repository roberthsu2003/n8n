# 🔄 從 Simple Vector Store 升級到 PGVector 完整指南

本指南將協助您將 RAG 系統從**記憶體儲存**升級到**PostgreSQL 持久化儲存**。

---

## 📊 **升級前後對比**

| 項目 | Simple Vector Store | PGVector |
|------|-------------------|----------|
| **儲存位置** | ❌ 記憶體（重啟消失） | ✅ PostgreSQL 資料庫 |
| **資料持久性** | ❌ 不持久 | ✅ 永久儲存 |
| **資料容量** | ⚠️ 受記憶體限制 | ✅ 可儲存大量資料 |
| **重啟後** | ❌ 資料消失 | ✅ 資料保留 |
| **多用戶** | ⚠️ 共用同一個 Key | ✅ 可建立多個資料表 |
| **成本** | 🆓 免費 | 🆓 免費（開源） |
| **設定難度** | 🟢 超簡單 | 🟡 需要安裝 PostgreSQL |

---

## 🚀 **步驟 1：安裝 PostgreSQL**

### **Mac 系統（使用 Homebrew）**

```bash
# 安裝 PostgreSQL
brew install postgresql@17

# 啟動 PostgreSQL 服務
brew services start postgresql@17

# 確認 PostgreSQL 運行中
psql --version
```

### **Windows 系統**

1. 下載 PostgreSQL 安裝程式：https://www.postgresql.org/download/windows/
2. 執行安裝程式，記住設定的密碼
3. 確認 PostgreSQL 服務已啟動

### **Linux 系統**

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib

# 啟動服務
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

---

## 🔧 **步驟 2：安裝 PGVector 擴展**

### **Mac 系統**

```bash
# 使用 Homebrew 安裝
brew install pgvector

# 連接到 PostgreSQL
psql postgres

# 在 psql 中執行
CREATE EXTENSION IF NOT EXISTS vector;

# 確認安裝成功
\dx vector
```

### **從原始碼安裝**

```bash
# 下載 PGVector
git clone https://github.com/pgvector/pgvector.git
cd pgvector

# 編譯並安裝
make
make install

# 重啟 PostgreSQL
brew services restart postgresql@17
```

---

## 📦 **步驟 3：建立 RAG 專用資料庫**

```sql
-- 連接到 PostgreSQL
psql postgres

-- 建立新資料庫
CREATE DATABASE n8n_rag_db;

-- 連接到新資料庫
\c n8n_rag_db

-- 啟用 PGVector 擴展
CREATE EXTENSION IF NOT EXISTS vector;

-- 確認擴展已啟用
SELECT * FROM pg_extension WHERE extname = 'vector';

-- 建立文件儲存表（PGVector 節點會自動建立，但您也可以手動建立）
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT,
    metadata JSONB,
    embedding vector(1536)  -- OpenAI 的 text-embedding-3-small 是 1536 維度
);

-- 建立索引以加速向量搜尋
CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops);
```

---

## 🔑 **步驟 4：在 n8n 中設定 PostgreSQL 憑證**

1. 開啟 n8n
2. 點擊右上角的 **Settings** → **Credentials**
3. 點擊 **Add credential**
4. 搜尋並選擇 **Postgres**

**填入以下資訊**：

```
Host: localhost
Database: n8n_rag_db
User: 您的使用者名稱（通常是系統使用者名稱）
Password: 您的密碼（如果沒設定可能為空）
Port: 5432
SSL Mode: disable（本地開發）
```

5. 點擊 **Test connection** 確認連線成功
6. 儲存憑證

---

## 🔄 **步驟 5：修改工作流程**

### **修改索引流程（Workflow 1A 和 1B）**

開啟原本的 `01_RAG文件索引_本機上傳.json`，進行以下修改：

#### **原本的節點結構**：
```
📤 表單觸發器
  ↓
📄 提取檔案內容
  ↓
🏷️ 設定文件資訊
  ↓
✂️ 遞迴字元分割器
  ↓
💾 Simple Vector Store (插入) ← 🧠 Google Gemini 嵌入
```

#### **修改後的節點結構**：
```
📤 表單觸發器
  ↓
📄 提取檔案內容
  ↓
🏷️ 設定文件資訊
  ↓
✂️ 遞迴字元分割器
  ↓
💾 PGVector Vector Store (插入) ← 🧠 Google Gemini 嵌入
```

#### **具體操作**：

1. **刪除 Simple Vector Store 節點**
2. **新增 PGVector Vector Store 節點**：
   - 搜尋節點：`PGVector`
   - 拖曳到畫布
   
3. **設定 PGVector 節點**：
   ```
   Operation Mode: Insert Documents
   
   Postgres Credential: [選擇剛才建立的憑證]
   
   Table Name: documents (預設即可)
   
   Options:
   ├─ Clear Store: 關閉（避免每次都清空）
   └─ Metadata: [可選] 設定額外的元資料
   ```

4. **連接節點**：
   - 將 `✂️ 遞迴字元分割器` 連接到 `PGVector Vector Store`
   - 將 `🧠 Google Gemini 嵌入` 連接到 `PGVector Vector Store` 的 **Embeddings** 輸入

---

### **修改查詢流程（Workflow 2A 和 2B）**

開啟原本的 `03_RAG智能問答_基礎版.json`，進行以下修改：

#### **原本的節點結構**：
```
💬 Chat Trigger
  ↓
🤖 AI Agent ← 🧠 Google Gemini Chat Model
  ↓
🔍 Vector Store Tool
  ↓
💾 Simple Vector Store (檢索) ← 🧠 Embeddings Google Gemini
  ↓
💬 Respond to Chat
```

#### **修改後的節點結構**：
```
💬 Chat Trigger
  ↓
🤖 AI Agent ← 🧠 Google Gemini Chat Model
  ↓
🔍 Vector Store Tool
  ↓
💾 PGVector Vector Store (檢索) ← 🧠 Embeddings Google Gemini
  ↓
💬 Respond to Chat
```

#### **具體操作**：

1. **刪除 Simple Vector Store 節點**
2. **新增 PGVector Vector Store 節點**：
   
3. **設定 PGVector 節點**：
   ```
   Operation Mode: Retrieve Documents (As Vector Store for Chain/Tool)
   
   Postgres Credential: [選擇相同的憑證]
   
   Table Name: documents
   
   Options:
   └─ Top K: 4 (檢索數量，可調整)
   ```

4. **連接節點**：
   - 保持原本的連接結構
   - 只需將 Simple Vector Store 替換為 PGVector Vector Store

---

## ✅ **步驟 6：測試新系統**

### **1. 測試索引功能**

1. 執行 **Workflow 1A**（本機上傳）
2. 上傳一個測試文件
3. 檢查執行日誌，確認成功

**驗證資料已儲存**：
```sql
-- 在 psql 中查詢
\c n8n_rag_db

-- 查看儲存的文件數量
SELECT COUNT(*) FROM documents;

-- 查看文件內容
SELECT id, content, metadata FROM documents LIMIT 5;
```

### **2. 測試查詢功能**

1. 執行 **Workflow 2A**（基礎問答）
2. 開啟對話介面
3. 提出測試問題
4. 確認 AI 可以正確回答

### **3. 測試持久性**

1. 重啟 n8n
   ```bash
   # 如果使用 npm
   # 先停止，再重新啟動
   n8n start
   ```

2. 再次開啟 **Workflow 2A**
3. 提出相同的問題
4. ✅ 確認資料沒有消失，AI 仍然可以回答

---

## 🎯 **步驟 7：優化與進階設定**

### **1. 調整向量搜尋參數**

在 PGVector 節點中：
```
Top K: 4-8 (檢索數量)
  - 太少：可能資訊不足
  - 太多：可能混入不相關資訊

Distance Strategy: cosine (預設)
  - cosine: 餘弦相似度（推薦）
  - euclidean: 歐幾里得距離
  - inner_product: 內積
```

### **2. 建立更好的索引**

```sql
-- 如果資料量大，使用 HNSW 索引（更快）
CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops);

-- 如果資料量小，使用 IVFFlat 索引（省記憶體）
CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
```

### **3. 設定 Collection（資料集合）**

根據[官方文件](https://github.com/n8n-io/n8n-docs/blob/main/docs/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.vectorstorepgvector.md)：

> "A collection provides a way to separate datasets in PGVector."

在 PGVector 節點中：
```
Options:
└─ Use Collection: 開啟
   ├─ Collection Name: product_docs (產品文件)
   └─ Collection Table Name: collections
```

這樣可以建立多個獨立的資料集，例如：
- `product_docs` - 產品文件
- `company_policies` - 公司政策
- `customer_support` - 客戶支援

---

## 📊 **資料管理與維護**

### **查看資料庫狀態**

```sql
-- 查看所有文件數量
SELECT COUNT(*) FROM documents;

-- 查看儲存空間使用
SELECT pg_size_pretty(pg_total_relation_size('documents'));

-- 查看最近新增的文件
SELECT id, content, metadata, created_at 
FROM documents 
ORDER BY created_at DESC 
LIMIT 10;
```

### **清空資料**

```sql
-- 清空特定資料表
TRUNCATE TABLE documents;

-- 或刪除特定條件的資料
DELETE FROM documents WHERE metadata->>'source' = 'local_upload';
```

### **備份資料**

```bash
# 備份整個資料庫
pg_dump -U 您的使用者名稱 n8n_rag_db > rag_backup.sql

# 恢復資料庫
psql -U 您的使用者名稱 n8n_rag_db < rag_backup.sql
```

---

## ❓ **常見問題排除**

### **Q1: 連線失敗 "connection refused"**

**解決方法**：
```bash
# 確認 PostgreSQL 正在運行
brew services list | grep postgresql

# 如果沒有運行，啟動它
brew services start postgresql@17
```

### **Q2: "extension vector does not exist"**

**解決方法**：
```bash
# 重新安裝 PGVector
brew reinstall pgvector

# 重新連線並建立擴展
psql -d n8n_rag_db -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

### **Q3: 查詢速度很慢**

**解決方法**：
```sql
-- 建立適當的索引
CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops);

-- 分析資料表以優化查詢計畫
ANALYZE documents;
```

### **Q4: 如何查看 embedding 維度？**

```sql
-- 查詢向量維度
SELECT pg_typeof(embedding), 
       vector_dims(embedding) as dimensions
FROM documents 
LIMIT 1;
```

---

## 🎉 **完成檢查清單**

- [ ] PostgreSQL 已安裝並運行
- [ ] PGVector 擴展已安裝
- [ ] n8n_rag_db 資料庫已建立
- [ ] n8n 中的 PostgreSQL 憑證已設定並測試成功
- [ ] Workflow 1A/1B 已修改為使用 PGVector
- [ ] Workflow 2A/2B 已修改為使用 PGVector
- [ ] 測試上傳文件成功
- [ ] 測試查詢功能正常
- [ ] 重啟 n8n 後資料仍然存在 ✅
- [ ] 已設定資料庫備份機制

---

## 📚 **延伸閱讀**

- [PGVector 官方文件](https://github.com/pgvector/pgvector)
- [n8n PGVector 節點文件](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.vectorstorepgvector/)
- [PostgreSQL 官方文件](https://www.postgresql.org/docs/)

---

**🎓 恭喜！您已經成功升級到真正的持久化向量儲存系統！**
