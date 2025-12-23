# 📁 RAG 基礎版 - Supabase 雲端儲存

## 📖 **學習重點**

- 學會如何用 **Supabase 向量資料庫** 快速部署 RAG（檢索增強生成）AI 系統，適合零技術門檻新手。
- 瞭解 **n8n** 自動化平台與 Supabase、PostgreSQL 的整合方式，實現對話紀錄儲存與知識檢索的功能。
- 學會設定與測試 n8n 節點與向量儲存服務，讓 AI 能高效從文件資料中搜尋與產生回應。
- 完成帳號註冊、專案建立、資料管理與系統測試的全流程實作，建立穩定可擴充的 RAG 雲端架構。

### **註冊和連線注意事項**
- 節點`Postgres Chat Memory`必需設定的方式
   - supabase的註冊方式(必需使用GitHub登入)一開始的建立專案，會自動建立一個postgresql資料庫，所以不需要再另外建立postgresql資料庫。
   - postgresql要自已設定密碼
   - postgresql的設定,例如:`密碼和連線池`,必需先進入`project settings`，然後再進入`database`，才可以重設密碼和連線池。`請看下方專有名詞解釋`
   - postgresql的連線字串必需先進入專案的`connect`
      - type必需使用psql,而不是使用URI
      - Source必需使用:`Primary Database`
      - Method必需使用:`Transaction pooler`

   ```psql
   psql -h db.bwfxafdmgjtmdmvjkpsj.supabase.co -p 5432 -d postgres -U postgres
   -h: 主機名稱
   -p: 埠號
   -d: 資料庫名稱
   -U: 使用者名稱
   ```

   - 如何在n8n中加入`Postgres Chat Memory`節點(小心是當作Memory使用,所以不需先設定table)設定postgresql的憑證,並測試連線是否成功。


### **有關於postgresql的專有名詞解釋**


**什麼是連線池(Connection Pool)**
「Connection pooling configuration」指的是資料庫「連線池」的設定，也就是你要怎麼管理一批可重用的資料庫連線，以便讓很多客戶端同時存取時維持效能與穩定。

**連線池是什麼**

- 連線池會預先建立一組到 Postgres 的連線，之後每個 API / 後端請求來時，就向池子借一條連線，用完再還回去，而不是每次新建與關閉連線。
- 這樣可以減少建立連線的開銷，避免太多連線直接打爆資料庫，提升整體吞吐量與穩定性。

**Supabase 這裡的配置在管什麼**

- 「Pool Size」是每個 user+db 組合可以用的最大到 Postgres cluster 的連線數，例如預設 15 條，是依你的 compute 等級（Nano）決定的上限。
- 「Max Client Connections」是允許同時接到連線池的客戶端連線數上限（這裡是 200），超過的客戶端可能會排隊或被拒絕，以保護後端資料庫不被壓垮。

**什麼時候需要調整**

- 當請求量變大、看到連線不夠用或有 timeout 時，才會考慮調整 Pool Size（但在你現在的 Nano 計畫中，上限是預設的）。
- 一般情況下維持預設設定即可，如果要處理高併發，就需要升級 compute 等級，讓可用的 pool 與 client 連線上限變大。

---

**使麼是PostgreSQL URI連線字串**

- `URI` 會以標準 Postgres URL 的形式給你連線字串，例如：

    `postgresql://postgres:7G42K2Zx58@aws-1-ap-south-1.pooler.supabase.com:6543/postgres`

> 這種格式通常給程式庫或 ORM 用，例如 Node、Python、SQLAlchemy 之類，直接塞一條 URL 就可以建立連線。

**什麼是PostgreSQL psql連線字串**

- `PSQL` 指的是給 `psql` CLI 工具使用的命令格式，通常長得像：

   `psql -h aws-1-ap-south-1.pooler.supabase.com -p 6543 -d postgres -U postgres`

- 這種格式適合你在終端機裡手動連線測試，或寫在 shell script 裡執行資料庫操作。

**什麼是Postgres的連線方法(Method)**
- Direct connection(直接連線)

> - `Direct connection` 是直接連到你的 Postgres 資料庫，例如用 5432 port 的連線字串，應用程式和資料庫是一對一長連線關係。​ 
> - 很適合跑在 VM、長壽命 container 的後端服務，連線會長時間保持開啟，延遲最低，但需要資料庫支援較多同時連線數。

-Transaction pooler(交易池)

> - `Transaction pooler` 是經過 Supabase 的連線池（例如 Supavisor / PgBouncer 類型）再轉接到資料庫，一條真正的 DB 連線會在「一個 transaction」期間借給某個 client，用完就立刻回到池子重用給其他 client。​
> - 非常適合 serverless function、edge function 或大量短生命週期連線的情境，可以用較少的實際 DB 連線，承受更多併發請求，但某些功能（例如 prepared statements、依賴 session 狀態的操作）會受限制或需要額外設定。

這個版本包含 **4 個獨立工作流程**：
- 📤 **Workflow 1A**：本機檔案上傳索引
- ☁️ **Workflow 1B**：Google Drive 自動同步
- 💬 **Workflow 2A**：基礎版智能問答
- 🎯 **Workflow 2B**：進階版問答（來源過濾）

## ✨ 為什麼選擇 Supabase？

| 特點 | 說明 | 優勢 |
|------|------|------|
| ⚡ **超快設定** | 快速完成 | 不需要安裝任何軟體 |
| 🎨 **視覺化管理** | 提供管理介面 | 不需要使用終端機 |
| 🆓 **免費額度** | 500MB 空間 | 約可儲存 40,000 份文件 |
| 🔄 **自動備份** | 資料每日備份 | 不用擔心資料遺失 |
| 🌐 **隨處存取** | 雲端儲存 | 不受本地網路限制 |
| 🛡️ **企業級安全** | 自動加密 | ISO 27001 認證 |

## 🆚 與其他版本的差異

| 特性 | 入門版 | 基礎版（Supabase） | 進階版（PostgreSQL） |
|------|--------|-------------------|-------------------|
| **儲存方式** | 記憶體 | Supabase 雲端 | PostgreSQL 本地 |
| **設定複雜度** | 🟢 零設定 | **🟢 簡單** | 🟡 中等 |
| **技術門檻** | 🟢 零門檻 | **🟢 零門檻** | 🟡 需要終端機 |
| **資料持久性** | ❌ | ✅ | ✅ |
| **管理介面** | ❌ | **✅ 視覺化** | ❌ 終端機 |
| **資料控制** | 本地 | ⚠️ 雲端 | ✅ 100% 本地 |
| **成本** | 免費 | **免費額度** | 完全免費 |
| **適用規模** | <50 文件 | **<1000 文件** | 無限制 |

## 🎯 核心優勢

### **1. 最快速的設定體驗**

```
傳統方式：
├─ 安裝 PostgreSQL
├─ 安裝 PGVector
├─ 設定資料庫
└─ 總計：較複雜 + 可能遇到問題

Supabase 方式：
├─ 註冊帳號
├─ 建立專案
├─ 複製連線資訊
├─ 設定 n8n
└─ 總計：快速完成 ✅
```

### **2. 零技術門檻**

不需要：
- ❌ 終端機操作
- ❌ SQL 知識
- ❌ 資料庫管理經驗
- ❌ 除錯技能

只需要：
- ✅ 點擊幾個按鈕
- ✅ 複製貼上
- ✅ 完成！

### **3. 視覺化管理介面**

Supabase 提供完整的管理介面：
- 📊 查看所有儲存的文件
- 🔍 SQL 查詢編輯器
- 📈 使用量統計
- 🔄 自動備份管理
- 📝 資料表瀏覽器

### **4. 免費額度充足**

```
免費方案包含：
✅ 500MB 資料庫空間（約 40,000 份文件）
✅ 無限 API 請求
✅ 每月 2GB 資料傳輸
✅ 7 天自動備份
✅ 2 個專案
```

---

## 📦 包含的檔案

### **工作流程檔案**

1. **01_RAG文件索引_本機上傳.json**
   - 提供網頁表單上傳文件
   - 支援 PDF、Word、TXT 格式
   - 自動建立向量索引並儲存到 Supabase

2. **02_RAG文件索引_Google_Drive同步.json**
   - 從 Google Drive 資料夾同步文件
   - 支援排程自動執行
   - 保留完整檔案元資料

3. **03_RAG智能問答_基礎版.json**
   - 簡單易用的對話介面
   - 搜尋全部文件
   - 適合快速部署

4. **04_RAG智能問答_進階版_來源過濾.json**
   - 支援來源過濾功能
   - 智能識別查詢意圖
   - 更詳細的系統提示

### **設定指南檔案**

- **Supabase快速設定指南.md**：5 分鐘設定步驟（重點！）
- **升級到PGVector指南.md**：如果未來想遷移到本地
- **README.md**（本檔案）：概覽和說明
- **完整使用指南.md**：詳細的使用說明

### **測試資料檔案**

- `產品資訊.md` / `產品資訊.pdf`：測試用產品資料
- `說明書.txt`：測試用說明文件
- `快速參考卡.md`：快速參考資料

---

## 🚀 快速開始

### **前置需求**

- ✅ n8n 帳號（本地安裝或雲端版）
- ✅ Google Gemini API Key（[免費申請](https://aistudio.google.com/app/apikey)）
- ✅ 電子郵件帳號（用於註冊 Supabase）

### **步驟 1：建立 Supabase 帳號**

1. 前往 [https://supabase.com](https://supabase.com)
2. 點擊 **Start your project**
3. 使用 GitHub/Google 快速登入

### **步驟 2：建立專案**

1. 點擊 **New Project**
2. 填寫：
   - 專案名稱：`n8n-rag-system`
   - 資料庫密碼：[設定一個強密碼]
   - 地區：`Northeast Asia (Tokyo)`
3. 點擊 **Create new project**
4. 等待 30 秒

### 重要設定參考影片

[**youtube設定影片**](https://youtu.be/JjBofKJnYIU?si=j-I9HAjcPOkt5vAc)

這份指南包含：
- ✅ 詳細的設定步驟
- ✅ 常見問題解答
- ✅ 免費額度詳細說明
- ✅ 視覺化管理介面使用
- ✅ 疑難排解

---

## 🎯 使用場景

### **最適合 Supabase 的情況**

✅ **快速原型開發**
```
情境：老闆下週要看 Demo
解決：快速建立，馬上展示
```

✅ **小型團隊專案**
```
情境：3-5 人團隊，不想管理伺服器
解決：雲端自動管理，專注開發
```

✅ **學習和實驗**
```
情境：學習 RAG 技術
解決：免費額度充足，隨時實驗
```

✅ **預算有限**
```
情境：初創公司，控制成本
解決：免費開始，成長後付費
```

### **不太適合 Supabase 的情況**

⚠️ **資料不能外流**
```
問題：企業規定資料必須留在內部
建議：改用進階版（本地 PostgreSQL）
```

⚠️ **超大規模**
```
問題：需要儲存 >10,000 份文件
建議：考慮付費方案或本地部署
```

⚠️ **需要離線運作**
```
問題：需要在沒有網路的環境運作
建議：改用進階版（本地 PostgreSQL）
```

---

## 💰 成本管理

### **免費額度詳情**

| 資源 | 免費額度 | 實際可用量 |
|------|---------|----------|
| 📦 資料庫空間 | 500MB | 約 40,000 份文件 |
| 🔄 API 請求 | 無限 | 沒有限制 |
| 📥 資料傳輸 | 2GB/月 | 每月約 200,000 次查詢 |
| 💾 備份保留 | 7 天 | 自動每日備份 |

### **計算方式**

```
每份文件平均大小：
- 1-2 頁 PDF = 約 10-20KB
- 500MB = 25,000-50,000 份文件

每次查詢平均資料傳輸：
- 1 次查詢 = 約 10KB
- 2GB = 約 200,000 次查詢/月
```

### **超過免費額度會怎樣？**

1. Supabase 會發送電子郵件通知
2. 不會立即停止服務
3. 您可以選擇：
   - 升級到 Pro ($25/月)
   - 刪除舊資料
   - 匯出並遷移到本地

---

## 🔄 從 Supabase 遷移到本地

### **何時考慮遷移？**

- ✅ 資料量超過免費額度
- ✅ 需要完全控制資料
- ✅ 對成本有更嚴格的控制
- ✅ 需要客製化資料庫設定

### **如何遷移？**

**步驟 1：匯出資料**
```bash
pg_dump [Supabase 連線字串] > backup.sql
```

**步驟 2：設定本地 PostgreSQL**
```bash
# 安裝 PostgreSQL
brew install postgresql@17

# 建立資料庫
createdb n8n_rag_db
```

**步驟 3：匯入資料**
```bash
psql -d n8n_rag_db < backup.sql
```

**步驟 4：更新 n8n 憑證**
- 將連線資訊改為本地

**👉 完整步驟請參考 [升級到PGVector指南.md](./升級到PGVector指南.md)**

---

## 🎓 學習路徑

### **完成這個版本後，您已經學會：**

✅ 雲端向量資料庫的使用  
✅ 快速部署 RAG 系統的方法  
✅ 視覺化管理介面的使用  
✅ 成本控制和額度管理  
✅ 分離式架構的設計

### **下一步學習建議：**

1. **繼續使用 Supabase**
   - 優化查詢效能
   - 實作更多進階功能
   - 學習 SQL 查詢

2. **升級到本地 PostgreSQL**（[進階版](../03_進階版_本地PostgreSQL/README.md)）
   - 完全掌控資料
   - 零成本無限制
   - 學習資料庫管理

---

## ❓ 常見問題

### **Q1: Supabase 安全嗎？**

**非常安全！**
- ✅ 企業級加密
- ✅ ISO 27001 認證
- ✅ SOC 2 Type II 認證
- ✅ 符合 GDPR

### **Q2: 免費額度夠用嗎？**

**對大多數情況夠用：**
- ✅ 學習和實驗：完全夠用
- ✅ 小型專案（<1000 文件）：夠用
- ⚠️ 大型專案：可能需要付費

### **Q3: 資料會被 Supabase 看到嗎？**

**不會！**
- ✅ 資料加密儲存
- ✅ Supabase 員工無法存取
- ✅ 您完全擁有資料

### **Q4: 可以隨時停用或刪除嗎？**

**可以！**
- ✅ 隨時刪除專案
- ✅ 資料可以匯出
- ✅ 不會被鎖定

### **Q5: 與本地 PostgreSQL 速度差多少？**

**輕微差異：**
- 🌐 Supabase：50-100ms（網路延遲）
- 💻 本地：5-10ms
- 📊 對 RAG 應用：幾乎感覺不到

---

## 🎉 完成檢查清單

### **基礎設定**
- [ ] Supabase 帳號已註冊
- [ ] 專案已建立
- [ ] Vector 擴展已啟用
- [ ] n8n 憑證已設定並測試成功

### **工作流程**
- [ ] 4 個工作流程已匯入
- [ ] Google Gemini 憑證已設定
- [ ] （選用）Google Drive 憑證已設定

### **功能測試**
- [ ] Workflow 1A 上傳功能正常
- [ ] 在 Supabase 看到資料
- [ ] Workflow 2A 問答功能正常
- [ ] 重啟 n8n 後資料仍存在 ✅

---

## 📚 相關資源

- [Supabase 官方文件](https://supabase.com/docs)
- [n8n Vector Store 文件](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.vectorstoresupabase/)
- [PostgreSQL 文件](https://www.postgresql.org/docs/)

---

**🎓 恭喜完成 RAG 基礎版！您已經掌握了最快速的 RAG 部署方式！**

**💡 下一步**：
- 👉 繼續優化當前系統
- 👉 或挑戰 [進階版](../03_進階版_本地PostgreSQL/README.md)，學習本地 PostgreSQL！

---

*最後更新：2025-01-19*  
*版本：v2.0.0*
