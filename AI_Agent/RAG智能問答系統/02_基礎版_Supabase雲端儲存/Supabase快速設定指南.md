# ⚡ Supabase 向量儲存 - 快速設定指南

本指南將協助您快速完成從 Simple Vector Store 到 Supabase 的升級。

---

## 🎯 **為什麼選擇 Supabase？**

| 優勢 | 說明 |
|------|------|
| ⚡ **超快速** | 快速完成設定 |
| 🎨 **視覺化介面** | 不需要終端機操作 |
| 🆓 **免費額度** | 500MB 資料庫（約 40,000 份文件） |
| 🔄 **自動備份** | 資料不會遺失 |
| 🌐 **隨處存取** | 不受本地網路限制 |
| 🛡️ **企業級安全** | 自動加密、防火牆 |

---

## 🚀 **步驟 1：建立 Supabase 帳號**

### **1.1 註冊帳號**

1. 前往 [https://supabase.com](https://supabase.com)
2. 點擊右上角 **Start your project**
3. 選擇快速註冊方式：
   - ✅ **使用 GitHub 登入**（推薦，最快）
   - ✅ 使用 Google 登入
   - 使用 Email 註冊

<img width="600" alt="Supabase 註冊" src="https://supabase.com/docs/img/supabase-signup.png">

### **1.2 建立組織（可選）**

- 如果是第一次使用，系統會要求建立組織
- 輸入組織名稱（可以用個人名字）
- 點擊 **Create organization**

---

## 📦 **步驟 2：建立新專案**

### **2.1 填寫專案資訊**

1. 點擊 **New Project**
2. 填寫以下資訊：

```
專案名稱: n8n-rag-system
資料庫密碼: [設定一個強密碼並記下來]
地區: Northeast Asia (Tokyo) [選擇離您最近的]
定價方案: Free [選擇免費方案]
```

3. 點擊 **Create new project**
4. ⏳ 等待片刻（Supabase 自動建立資料庫）

### **2.2 專案建立完成**

看到專案儀表板，代表成功！✅

<img width="600" alt="Supabase Dashboard" src="https://supabase.com/docs/img/supabase-dashboard.png">

---

## 🔧 **步驟 3：啟用 Vector 擴展**

### **3.1 開啟 SQL Editor**

1. 點擊左側選單的 **SQL Editor**
2. 點擊 **New query**

### **3.2 執行 SQL 指令**

貼上以下 SQL 並點擊 **Run**：

```sql
-- 啟用 Vector 擴展
CREATE EXTENSION IF NOT EXISTS vector;

-- 建立文件儲存表
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT,
    metadata JSONB,
    embedding vector(1536)
);

-- 建立索引以加速搜尋
CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
```

### **3.3 確認成功**

看到綠色的 **Success** 訊息即可！✅

---

## 🔑 **步驟 4：取得連線資訊**

### **4.1 找到連線字串**

1. 點擊左側選單的 **Settings** (齒輪圖示)
2. 點擊 **Database**
3. 捲動到 **Connection string** 區域
4. 選擇 **URI** 格式

### **4.2 複製連線資訊**

您會看到類似這樣的連線字串：

```
postgresql://postgres:[YOUR-PASSWORD]@db.xxxxxxxxxxxxx.supabase.co:5432/postgres
```

**重要**：
- ⚠️ 將 `[YOUR-PASSWORD]` 替換為您在步驟 2.1 設定的密碼
- 📋 複製完整的連線字串

**範例**：
```
原始: postgresql://postgres:[YOUR-PASSWORD]@db.abc123.supabase.co:5432/postgres
替換後: postgresql://postgres:MyStr0ngP@ssw0rd@db.abc123.supabase.co:5432/postgres
```

---

## 🎨 **步驟 5：在 n8n 中設定憑證**

### **5.1 開啟 n8n 憑證設定**

1. 開啟 n8n
2. 點擊左側選單的 **Credentials**
3. 點擊右上角 **Add Credential**
4. 搜尋並選擇 **Postgres**

### **5.2 填寫連線資訊**

#### **方法 A：使用連線字串（最簡單）**

1. 選擇 **Connection Type**: `URI`
2. 貼上剛才複製的完整連線字串
3. 點擊 **Test connection**
4. 看到 ✅ **Connection successful** 即可
5. 點擊 **Save**

#### **方法 B：手動輸入（如果方法 A 不行）**

從連線字串解析資訊：
```
postgresql://postgres:密碼@主機:埠/資料庫
```

填入：
```
Host: db.xxxxxxxxxxxxx.supabase.co
Database: postgres
User: postgres
Password: [您的密碼]
Port: 5432
SSL Mode: require [重要！Supabase 需要 SSL]
```

### **5.3 儲存憑證**

給憑證一個好記的名字：
```
名稱: Supabase RAG Database
```

點擊 **Save** 儲存。

---

## 🔄 **步驟 6：修改工作流程**

### **6.1 修改索引流程（Workflow 1A/1B）**

#### **找到並替換節點**：

1. 開啟 `01_RAG文件索引_本機上傳` 工作流程
2. 刪除 **Simple Vector Store** 節點
3. 新增 **Supabase Vector Store** 節點
   - 點擊左上角 **+** 
   - 搜尋 `Supabase Vector Store`
   - 拖曳到畫布

#### **設定 Supabase Vector Store 節點**：

```
Mode: Insert Documents

Postgres Credential: [選擇剛才建立的憑證]

Table Name: documents

Options:
├─ Clear Store: 關閉（避免每次都清空資料）
└─ Metadata: [可選] 額外的元資料欄位
```

#### **連接節點**：

- 將 `✂️ 遞迴字元分割器` 的輸出連接到 `Supabase Vector Store`
- 將 `🧠 Embeddings` 連接到 `Supabase Vector Store` 的 **Embeddings** 輸入

### **6.2 修改查詢流程（Workflow 2A/2B）**

#### **替換節點**：

1. 開啟 `03_RAG智能問答_基礎版` 工作流程
2. 刪除 **Simple Vector Store** 節點
3. 新增 **Supabase Vector Store** 節點

#### **設定節點**：

```
Mode: Retrieve Documents (As Vector Store for Chain/Tool)

Postgres Credential: [選擇相同的憑證]

Table Name: documents

Options:
└─ Top K: 4 (檢索數量)
```

#### **連接節點**：

保持原本的連接結構，只是將節點替換即可。

---

## ✅ **步驟 7：測試系統**

### **7.1 測試上傳**

1. 執行 **Workflow 1A**
2. 開啟表單網址
3. 上傳一個測試文件
4. 確認執行成功 ✅

### **7.2 在 Supabase 查看資料**

1. 回到 Supabase 儀表板
2. 點擊左側 **Table Editor**
3. 選擇 `documents` 表
4. 您應該可以看到剛才上傳的文件！✅

<img width="600" alt="Supabase Table Editor" src="https://supabase.com/docs/img/table-editor.png">

### **7.3 測試查詢**

1. 執行 **Workflow 2A**
2. 開啟對話介面
3. 提出問題測試
4. 確認 AI 可以正確回答 ✅

### **7.4 測試持久性**

1. 重啟 n8n
2. 再次開啟對話介面
3. 提出相同問題
4. ✅ 確認資料沒有消失（因為儲存在雲端）

---

## 🎨 **進階功能：使用 Supabase 管理介面**

### **查看所有文件**

1. Table Editor → documents
2. 可以看到所有儲存的向量資料

### **執行 SQL 查詢**

```sql
-- 查看文件數量
SELECT COUNT(*) FROM documents;

-- 查看最近的文件
SELECT id, content, metadata, created_at 
FROM documents 
ORDER BY created_at DESC 
LIMIT 10;

-- 搜尋特定內容
SELECT content, metadata 
FROM documents 
WHERE content ILIKE '%產品%';
```

### **匯出資料**

1. Table Editor → documents
2. 點擊右上角 **Export**
3. 選擇格式（CSV / JSON）
4. 下載備份

---

## 📊 **免費額度說明**

### **Supabase Free Plan 包含**：

| 資源 | 免費額度 | 說明 |
|------|---------|------|
| 📦 **資料庫空間** | 500MB | 約可儲存 40,000 份文件 |
| 🔄 **API 請求** | 無限 | 沒有請求數量限制 |
| 📥 **資料傳輸** | 2GB/月 | 足夠一般使用 |
| 🕐 **備份保留** | 7 天 | 自動每日備份 |
| 👥 **專案數量** | 2 個 | 可建立 2 個專案 |

### **什麼時候會超過免費額度？**

```
❌ 不太可能超過：
- 每天上傳 10-50 份文件
- 每天執行 100-500 次查詢
- 小型團隊（<10 人）使用

⚠️ 可能會超過：
- 儲存超過 40,000 份文件
- 大量圖片或影片檔案
- 每天數千次 API 請求
```

### **如果超過額度會怎樣？**

1. Supabase 會發送電子郵件通知
2. 您可以：
   - 升級到付費方案（$25/月起）
   - 刪除舊資料釋放空間
   - 優化資料儲存方式

---

## 🔒 **安全性設定（可選但推薦）**

### **設定 Row Level Security (RLS)**

```sql
-- 啟用 RLS
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- 建立政策：允許所有讀取
CREATE POLICY "Allow public read access"
ON documents FOR SELECT
TO public
USING (true);

-- 建立政策：允許所有寫入
CREATE POLICY "Allow public write access"
ON documents FOR INSERT
TO public
WITH CHECK (true);
```

### **設定 API Key 權限**

1. Settings → API
2. 查看 **Project API keys**
3. 使用 **service_role** key（完整權限，僅用於 n8n）

---

## 🆚 **Supabase vs 本地 PostgreSQL 對比**

| 項目 | Supabase | 本地 PostgreSQL |
|------|----------|----------------|
| **設定複雜度** | 🟢 簡單 | 🟡 中等 |
| **技術門檻** | 🟢 零門檻 | 🟡 需要終端機 |
| **管理介面** | ✅ 視覺化 | ❌ 只有終端機 |
| **備份** | ✅ 自動 | ❌ 需手動 |
| **成本** | 🆓 免費額度<br>💰 超過需付費 | 🆓 完全免費 |
| **隱私** | ⚠️ 資料在雲端 | ✅ 100% 本地 |
| **維護** | ✅ 自動更新 | ❌ 需自己維護 |

---

## ❓ **常見問題**

### **Q1: Supabase 安全嗎？我的資料會被看到嗎？**

**A**: 非常安全！
- ✅ 企業級加密（資料傳輸 + 儲存都加密）
- ✅ ISO 27001 認證
- ✅ SOC 2 Type II 認證
- ✅ 符合 GDPR
- ❌ Supabase 員工無法看到您的資料

### **Q2: 如果我超過免費額度會怎樣？**

**A**: 
1. 您會收到電子郵件通知
2. 專案不會立即停止運作
3. 您可以：
   - 升級到 Pro ($25/月)
   - 刪除舊資料
   - 匯出並遷移到本地

### **Q3: 可以從 Supabase 遷移到本地 PostgreSQL 嗎？**

**A**: 可以！非常簡單：
```bash
# 匯出資料
pg_dump [Supabase 連線字串] > backup.sql

# 匯入到本地
psql -U postgres n8n_rag_db < backup.sql
```

### **Q4: Supabase 速度會比本地慢嗎？**

**A**: 輕微影響，但可以忽略：
- 🌐 網路延遲：約 50-100ms（取決於地區）
- 💻 本地查詢：約 5-10ms
- 📊 對 RAG 應用影響：**幾乎感覺不到**

### **Q5: 可以用在商業專案嗎？**

**A**: 可以！
- ✅ Free Plan 可用於商業
- ✅ 需遵守服務條款
- ✅ 建議商業專案升級 Pro（更穩定）

---

## 🎉 **完成檢查清單**

- [ ] Supabase 帳號已註冊
- [ ] 專案已建立
- [ ] Vector 擴展已啟用
- [ ] documents 表已建立
- [ ] n8n 憑證已設定並測試成功
- [ ] Workflow 1A/1B 已修改
- [ ] Workflow 2A/2B 已修改
- [ ] 測試上傳成功
- [ ] 在 Supabase 看到資料
- [ ] 測試查詢功能正常
- [ ] 重啟 n8n 後資料仍存在 ✅

---

## 📚 **下一步學習**

完成基礎設定後，您可以：

1. **學習 Supabase 更多功能**：
   - [Supabase 官方文件](https://supabase.com/docs)
   - [PostgreSQL 函數](https://supabase.com/docs/guides/database/functions)
   - [即時訂閱](https://supabase.com/docs/guides/realtime)

2. **優化 RAG 系統**：
   - 調整 embedding 維度
   - 實作混合搜尋
   - 新增文件分類

3. **準備遷移到本地**（如果需要）：
   - 學習 PostgreSQL 管理
   - 設定自動備份
   - 效能優化

---

## 🎓 **總結**

✅ **您已經成功完成**：
- ⚡ 快速設定完成
- 🆓 使用免費的雲端向量資料庫
- 💾 資料永久儲存（不會消失）
- 🎨 擁有視覺化管理介面
- 🔄 自動備份機制

**恭喜！您現在擁有一個生產級別的 RAG 系統！** 🎉

---

## 📞 **需要幫助？**

如果遇到任何問題：

1. **Supabase 支援**：
   - [Discord 社群](https://discord.supabase.com)
   - [GitHub Issues](https://github.com/supabase/supabase/issues)
   - [官方文件](https://supabase.com/docs)

2. **n8n 支援**：
   - [n8n 社群論壇](https://community.n8n.io)
   - [官方文件](https://docs.n8n.io)

3. **隨時問我**：
   - 我可以協助您解決設定問題
   - 提供優化建議
   - 協助除錯
