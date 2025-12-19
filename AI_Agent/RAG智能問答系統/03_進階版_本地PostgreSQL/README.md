# 🔴 RAG 進階版 - 本地 PostgreSQL

## 📖 什麼是這個版本？

這是 **完全掌控的 RAG 實作**，使用 **PostgreSQL + PGVector** 本地部署，提供 **100% 資料控制**和**零成本無限制**使用！

**核心理念**：完全本地化、零依賴雲端、企業級控制

---

## 🎯 為什麼選擇本地 PostgreSQL？

### **核心優勢**

| 特點 | 說明 | 價值 |
|------|------|------|
| 💯 **完全控制** | 資料 100% 在本地 | 符合資安規範 |
| 🆓 **零成本** | PostgreSQL 免費開源 | 無使用限制 |
| 🚀 **最快速度** | 本地查詢無延遲 | <10ms 響應時間 |
| 📊 **無限制** | 沒有資料量限制 | 可儲存數百萬文件 |
| 🔧 **完全客製** | 可自由調整所有設定 | 符合特殊需求 |
| 🛡️ **離線運作** | 不需要網路連線 | 內網環境可用 |

---

## 🆚 三個版本完整對比

| 特性 | 入門版 | 基礎版（Supabase） | 進階版（PostgreSQL） |
|------|--------|-------------------|-------------------|
| **儲存位置** | 記憶體 | ☁️ Supabase 雲端 | 💻 本地資料庫 |
| **資料持久性** | ❌ | ✅ | ✅ |
| **資料控制** | ✅ 本地 | ⚠️ 雲端 | ✅ **100% 本地** |
| **設定複雜度** | 🟢 零設定 | 🟢 簡單 | 🟡 **中等** |
| **技術門檻** | 🟢 零 | 🟢 零 | 🟡 **需終端機** |
| **管理方式** | ❌ 無 | ✅ 視覺化 | 💻 **終端機/SQL** |
| **資料量限制** | <50 文件 | <1000（免費額度） | ✅ **無限制** |
| **查詢速度** | 🐢 較慢 | 🏃 快 | 🚀 **最快** |
| **成本** | 免費 | 免費額度/付費 | 🆓 **完全免費** |
| **離線運作** | ✅ | ❌ 需要網路 | ✅ **可離線** |
| **資料備份** | ❌ | ✅ 自動 | ⚙️ **需手動設定** |
| **適用場景** | 學習測試 | 快速部署 | **企業生產** |

---

## 🎯 最適合的使用情境

### ✅ **強烈建議使用本地 PostgreSQL**

#### **1. 企業內部系統**
```
需求：公司資料不能外流
解決：100% 本地儲存，符合資安規範
範例：人事系統、財務資料、客戶資料
```

#### **2. 大規模文件庫**
```
需求：需要儲存 >10,000 份文件
解決：無資料量限制，零成本
範例：技術文件庫、法規資料庫
```

#### **3. 零成本需求**
```
需求：長期使用，控制成本
解決：完全免費，無隱藏費用
範例：非營利組織、教育機構
```

#### **4. 高效能要求**
```
需求：查詢延遲 <100ms
解決：本地查詢，最快速度
範例：即時客服系統、交易系統
```

#### **5. 離線環境**
```
需求：內網環境，無法連外
解決：完全本地運作
範例：軍事、醫療、工廠系統
```

### ⚠️ **不建議本地 PostgreSQL 的情況**

#### **快速原型驗證**
```
問題：需要快速展示給客戶
建議：先用基礎版（Supabase），5分鐘設定
```

#### **技術能力不足**
```
問題：團隊不熟悉終端機和資料庫
建議：使用基礎版，有視覺化介面
```

#### **不想維護**
```
問題：沒有人力維護資料庫
建議：使用基礎版，自動管理
```

---

## 📦 系統架構

### **完整架構圖**

```
本地部署架構
┌─────────────────────────────────────────────┐
│            RAG 本地系統                      │
├─────────────────────────────────────────────┤
│                                             │
│  📤 索引流程                                 │
│  ├─ Workflow 1A: 本機上傳                   │
│  └─ Workflow 1B: Google Drive 同步          │
│         ↓                                   │
│  💾 PostgreSQL + PGVector                   │
│  ├─ 本地資料庫（~/.postgresql/data）         │
│  ├─ Vector 擴展支援                          │
│  ├─ 完全控制                                 │
│  └─ 零成本使用                               │
│         ↓                                   │
│  💬 查詢流程                                 │
│  ├─ Workflow 2A: 基礎問答                   │
│  └─ Workflow 2B: 來源過濾問答               │
│                                             │
└─────────────────────────────────────────────┘
```

### **資料流程**

```
1. 文件上傳
   ↓
2. 文字提取 (Extract From File)
   ↓
3. 分割處理 (Text Splitter)
   ↓
4. 向量化 (Google Gemini Embeddings)
   ↓
5. 儲存到 PostgreSQL (PGVector Vector Store)
   ↓
6. 持久化到磁碟 (~/.postgresql/data/)
   ↓
7. 隨時可查詢 (Vector Search)
```

---

## 🚀 快速開始

### **前置需求**

- ✅ Mac/Linux/Windows 系統
- ✅ 基本終端機操作能力
- ✅ Homebrew（Mac）或套件管理器
- ✅ n8n 帳號
- ✅ Google Gemini API Key（免費）

### **完整設定步驟**

#### **步驟 1：安裝 PostgreSQL**

**Mac 系統**：
```bash
# 安裝 PostgreSQL
brew install postgresql@17

# 啟動服務
brew services start postgresql@17

# 確認安裝
psql --version
# 應該顯示：psql (PostgreSQL) 17.x
```

**Windows 系統**：
1. 下載：https://www.postgresql.org/download/windows/
2. 執行安裝程式
3. 記住設定的密碼

**Linux 系統**：
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib

# 啟動服務
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### **步驟 2：安裝 PGVector 擴展**

**Mac 系統**：
```bash
# 安裝 PGVector
brew install pgvector

# 連接到 PostgreSQL
psql postgres

# 建立擴展（在 psql 中執行）
CREATE EXTENSION IF NOT EXISTS vector;

# 確認安裝
\dx vector

# 退出
\q
```

**從原始碼安裝**：
```bash
git clone https://github.com/pgvector/pgvector.git
cd pgvector
make
make install

# 重啟 PostgreSQL
brew services restart postgresql@17
```

#### **步驟 3：建立 RAG 資料庫**

```bash
# 連接到 PostgreSQL
psql postgres

# 建立資料庫（在 psql 中執行）
CREATE DATABASE n8n_rag_db;

# 連接到新資料庫
\c n8n_rag_db

# 啟用 Vector 擴展
CREATE EXTENSION IF NOT EXISTS vector;

# 建立文件表
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT,
    metadata JSONB,
    embedding vector(1536)
);

# 建立索引
CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops);

# 確認表已建立
\dt

# 退出
\q
```

#### **步驟 4：在 n8n 設定憑證**

1. 開啟 n8n → **Credentials** → **Add Credential**
2. 選擇 **Postgres**
3. 填入：
   ```
   Host: localhost
   Database: n8n_rag_db
   User: [您的使用者名稱]
   Password: [您的密碼，可能為空]
   Port: 5432
   SSL Mode: disable（本地開發）
   ```
4. 點擊 **Test connection**
5. 看到 ✅ 成功後，儲存

#### **步驟 5：修改工作流程**

**從基礎版升級**：

1. 將所有 **Supabase Vector Store** 節點替換為 **PGVector Vector Store**
2. 設定節點：
   ```
   Operation Mode: Insert Documents / Retrieve Documents
   Postgres Credential: [選擇剛才建立的憑證]
   Table Name: documents
   ```
3. 測試執行

**👉 詳細步驟請參考 [升級到PGVector指南.md](./升級到PGVector指南.md)**

---

## 💡 核心概念

### **1. PostgreSQL vs 雲端資料庫**

| 項目 | PostgreSQL | Supabase/雲端 |
|------|-----------|--------------|
| **資料位置** | `~/.postgresql/data/` | 雲端伺服器 |
| **存取方式** | `localhost:5432` | `xxx.supabase.co:5432` |
| **延遲** | <5ms | 50-100ms |
| **控制權** | 100% | 有限 |
| **成本** | 免費 | 有限額/付費 |

### **2. PGVector 擴展**

```
PGVector 是什麼？
├─ PostgreSQL 的擴展
├─ 增加向量資料類型支援
├─ 提供向量相似度搜尋
├─ 支援多種距離計算方式
└─ 完全免費開源
```

### **3. 向量索引類型**

```sql
-- IVFFlat 索引（省記憶體，速度中等）
CREATE INDEX ON documents 
USING ivfflat (embedding vector_cosine_ops) 
WITH (lists = 100);

-- HNSW 索引（更快，耗記憶體）
CREATE INDEX ON documents 
USING hnsw (embedding vector_cosine_ops);
```

---

## 🛠️ 日常管理

### **查看資料**

```sql
-- 連接到資料庫
psql -d n8n_rag_db

-- 查看文件數量
SELECT COUNT(*) FROM documents;

-- 查看資料庫大小
SELECT pg_size_pretty(pg_database_size('n8n_rag_db'));

-- 查看最近的文件
SELECT id, content, metadata 
FROM documents 
ORDER BY (metadata->>'upload_time')::timestamp DESC 
LIMIT 10;

-- 搜尋特定內容
SELECT content, metadata 
FROM documents 
WHERE content ILIKE '%產品%';
```

### **效能優化**

```sql
-- 分析資料表（優化查詢計畫）
ANALYZE documents;

-- 重建索引（資料量大時）
REINDEX TABLE documents;

-- 清理無用資料
VACUUM FULL documents;
```

### **備份資料**

```bash
# 備份整個資料庫
pg_dump -U [使用者名稱] n8n_rag_db > rag_backup.sql

# 壓縮備份
pg_dump -U [使用者名稱] n8n_rag_db | gzip > rag_backup.sql.gz

# 恢復資料庫
psql -U [使用者名稱] n8n_rag_db < rag_backup.sql
```

### **清空資料**

```sql
-- 清空所有文件
TRUNCATE TABLE documents;

-- 或刪除特定條件的資料
DELETE FROM documents 
WHERE metadata->>'source' = 'local_upload';
```

---

## 📊 效能調教

### **調整 PostgreSQL 設定**

編輯 `postgresql.conf`：

```bash
# 找到設定檔
psql -c "SHOW config_file;"

# 編輯設定檔
# Mac: /opt/homebrew/var/postgresql@17/postgresql.conf
```

**建議設定**（根據您的系統調整）：

```conf
# 記憶體設定
shared_buffers = 256MB          # 25% 系統記憶體
effective_cache_size = 1GB      # 50-75% 系統記憶體
work_mem = 16MB                 # 查詢工作記憶體

# 連線設定
max_connections = 100           # 最大連線數

# 查詢優化
random_page_cost = 1.1          # SSD 硬碟使用
```

**重啟 PostgreSQL**：
```bash
brew services restart postgresql@17
```

### **向量搜尋優化**

```sql
-- 調整 IVFFlat 的 lists 參數
-- 資料量 < 10000：lists = 100
-- 資料量 10000-100000：lists = 1000
-- 資料量 > 100000：lists = sqrt(資料量)

CREATE INDEX ON documents 
USING ivfflat (embedding vector_cosine_ops) 
WITH (lists = 1000);
```

---

## 🔒 安全性設定

### **設定密碼認證**

編輯 `pg_hba.conf`：

```bash
# 找到檔案
psql -c "SHOW hba_file;"

# 編輯（Mac）
# /opt/homebrew/var/postgresql@17/pg_hba.conf
```

**建議設定**：

```conf
# 本地連線使用密碼
local   all   all   md5
host    all   all   127.0.0.1/32   md5
```

### **建立專用使用者**

```sql
-- 建立 n8n 專用使用者
CREATE USER n8n_user WITH PASSWORD 'your_strong_password';

-- 授予權限
GRANT ALL PRIVILEGES ON DATABASE n8n_rag_db TO n8n_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO n8n_user;
```

---

## ❓ 常見問題

### **Q1: PostgreSQL 無法啟動？**

```bash
# 檢查狀態
brew services list | grep postgresql

# 查看日誌
tail -f /opt/homebrew/var/log/postgresql@17.log

# 重啟服務
brew services restart postgresql@17
```

### **Q2: 連線被拒絕？**

```bash
# 確認 PostgreSQL 運行中
psql postgres -c "SELECT version();"

# 檢查埠號
lsof -i :5432
```

### **Q3: PGVector 擴展無法建立？**

```bash
# 重新安裝 PGVector
brew reinstall pgvector

# 手動建立
psql -d n8n_rag_db -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

### **Q4: 查詢速度很慢？**

```sql
-- 檢查索引
SELECT * FROM pg_indexes WHERE tablename = 'documents';

-- 重建索引
REINDEX TABLE documents;

-- 分析資料表
ANALYZE documents;
```

### **Q5: 如何遷移到其他機器？**

```bash
# 在原機器備份
pg_dump -U postgres n8n_rag_db | gzip > backup.sql.gz

# 傳輸到新機器
scp backup.sql.gz user@new-machine:/tmp/

# 在新機器恢復
gunzip -c /tmp/backup.sql.gz | psql -U postgres n8n_rag_db
```

---

## 🎓 學習資源

### **PostgreSQL 學習**
- [PostgreSQL 官方文件](https://www.postgresql.org/docs/)
- [PostgreSQL 教學](https://www.postgresqltutorial.com/)
- [SQL 語法參考](https://www.postgresql.org/docs/current/sql.html)

### **PGVector 學習**
- [PGVector GitHub](https://github.com/pgvector/pgvector)
- [PGVector 文件](https://github.com/pgvector/pgvector#usage)
- [向量搜尋最佳實踐](https://github.com/pgvector/pgvector#best-practices)

### **n8n 整合**
- [n8n PGVector 節點文件](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.vectorstorepgvector/)
- [n8n RAG 指南](https://docs.n8n.io/advanced-ai/rag-in-n8n/)

---

## ✅ 完成檢查清單

### **安裝設定**
- [ ] PostgreSQL 已安裝並運行
- [ ] PGVector 擴展已安裝
- [ ] n8n_rag_db 資料庫已建立
- [ ] documents 表已建立
- [ ] 索引已建立
- [ ] n8n 憑證已設定並測試成功

### **功能測試**
- [ ] 測試上傳文件成功
- [ ] 在 PostgreSQL 中看到資料
- [ ] 測試查詢功能正常
- [ ] 重啟 PostgreSQL 後資料仍存在 ✅
- [ ] 查詢速度符合預期

### **進階設定**
- [ ] PostgreSQL 效能已優化
- [ ] 設定自動備份機制
- [ ] 設定密碼認證
- [ ] 建立專用使用者

---

## 🎉 恭喜完成！

您已經成功建立了：
- ✅ 完全本地化的 RAG 系統
- ✅ 零成本無限制的向量資料庫
- ✅ 企業級的資料控制能力
- ✅ 高效能的查詢系統

### **您現在可以：**

1. **持續優化**：調整效能參數
2. **擴展功能**：增加更多進階功能
3. **部署生產**：用於實際專案
4. **分享經驗**：幫助其他人學習

---

**🎓 您已經掌握了 RAG 的最高階應用！**

**📚 相關指南**：
- [升級到PGVector指南.md](./升級到PGVector指南.md) - 完整的遷移步驟
- [基礎版 Supabase](../02_基礎版_Supabase雲端儲存/README.md) - 如果需要快速原型

---

*最後更新：2025-01-19*  
*版本：v1.0.0*
