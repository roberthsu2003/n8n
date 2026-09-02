![](./images/n8n實戰教學講義.png)

# 🚀 n8n 全方位實戰教學講義 (從入門到企業級 AI Agent 與自動化架構)

> 💡 **這是一套專為零基礎學習者、自動化工程師與企業團隊設計的端到端實戰教材。**  
> 全面涵蓋 **No-Code / Low-Code 自動化**、**前後端 WebAPI 串接**、**Google Workspace 辦公自動化**、**LINE / Telegram 雙向通訊**、**雲端資料庫 / RAG 向量知識庫** 以及 **企業級 Multi-Agent AI 系統**！

---

## 📘 關於 n8n 與核心架構

**n8n** 起初名稱為 **nodemation**（節點自動化，Node-based Automation），後簡稱 **n8n**。n8n 的核心哲學是**「透過視覺化工作流連結所有具備 API 的雲端服務與內部系統」**，具備高度開源、資料完全自託管（Self-hosted）、無 vendor lock-in 且可靈活擴充 JavaScript / Python 程式碼的強大優勢。

### 🧩 n8n 自動化工作流的五大核心要素

1. **⚡ 觸發 (Trigger)**：工作流的起點，支援定時排程 (Schedule)、外部事件推播 (Webhook)、表單提交 (Form) 或收到郵件等事件。
2. **🔗 連接 (Connect)**：透過 OAuth 2.0 授權、API Key 或資料庫連線，安全連結各項雲端服務與內部系統。
3. **⚙️ 資料運算 (Transform)**：解析 JSON 結構、格式轉換、資料過濾、條件分流，或呼叫 AI Agent 進行智慧語意運算。
4. **🧪 測試與驗證 (Test)**：在畫布上逐步執行單節點 (Test Step)、模擬測試資料並即時排查錯誤。
5. **🚀 上線啟動 (Activate)**：切換為 Active 啟用狀態，由 n8n 引擎 7x24 常駐監聽並全自動執行任務。

---

## 🗺️ 推薦學習路徑地圖 (Learning Path)

本教材規劃了循序漸進的階梯式學習地圖，讓學生與團隊成員都能輕鬆找到適合的切入點：

- **第 1 階段：環境建置與基礎設定** ➔ Docker 安裝、ngrok 外網通道建立與 API 憑證申請。
- **第 2 階段：核心基礎與初階範例** ➔ 手動觸發、JSON 資料流、DataTable 內建表格與表單操作。
- **第 3 階段：Webhook 與前後端 WebAPI** ➔ GET/POST 即時反饋、玻璃擬態測試台與檔案上傳統計。
- **第 4 階段：Google 服務與辦公自動化** ➔ 訂便當系統、Gmail HTML 晨報與 Docs 證書自動轉存 PDF。
- **第 5 階段：通訊軟體整合 (LINE & Telegram)** ➔ LINE Reply 免費回覆、Flex 圖文卡片與 Telegram 機器人。
- **第 6 階段：Code 節點與資料庫架構** ➔ JavaScript 髒資料清洗、Postgres CRUD 與多表統計分組。
- **第 7 階段：AI Agent 與 RAG 向量知識庫** ➔ Ollama / Gemini、Supabase pgvector 與 Multi-Agent 多代理協同。
- **第 8 階段：零預算雲端永久部署** ➔ Hugging Face、Koyeb、Render 與 OCI 永久免費雲端上線。

---

## 📚 課程目錄與實作模組導覽

---

### 🛠️ 1. [環境建置與第三方網站註冊設定](./環境建置與基礎設定/README.md)
實作所有章節必備的雲端服務、API 金鑰憑證與基礎設施設定：
* 🐳 **容器與本機安裝**：[Docker 安裝指南](./docker安裝/README.md) ｜ [n8n 獨立容器安裝與啟動](./n8n簡介與安裝/README.md)
* 🌐 **外網通道平台註冊**：[ngrok 帳號註冊與 AuthToken 設定](./ngrok安裝/README.md) ｜ [Cloudflare 帳號註冊與 Tunnel 安全通道](./cloudflare_tunnel/README.md)
* ⭐ **一鍵容器化整合推薦**：[n8n + ngrok 雙容器方案 (快速開發測試)](./n8n_ngrok/README.md) ｜ [n8n + Cloudflare 雙容器方案 (自訂網域生產級)](./n8n_cloudflare/README.md)
* 💬 **通訊軟體開發者註冊**：[LINE Developers 註冊與 Messaging API 設定](./line設定/README.md) ｜ [Telegram BotFather 機器人申請與憑證設定](./通訊軟體整合/Telegram/README.md#️-前置設定指南)
* ☁️ **Google 雲端平台註冊**：[Google Cloud Platform (GCP) 專案建立與 API 啟用](./google_cloud設定/README.md) ｜ [OAuth 2.0 開放授權概念解析](./OAuth/README.md)
* 🗄️ **雲端資料庫平台註冊**：[Supabase 雲端資料庫註冊與連線設定 (免信用卡)](./雲端資料庫整合/Supabase/README.md) ｜ [Pinecone 向量資料庫註冊與索引設定 (免信用卡)](./雲端資料庫整合/06_Pinecone雲端向量資料庫與AI檢索/README.md#免費建立-pinecone不用花錢步驟指南)
* 🤖 **AI 助手與模型註冊**：[NVIDIA NIM 微服務模型串接](./nvidia_nim/README.md) ｜ [OpenRouter 多模型聚合平台 (資安合規)](./openrouter/README.md) ｜ [n8n Chat Hub 企業級對話中心](./chat_hub/README.md) ｜ [n8n MCP 協議設定 (Claude / OpenAI / Gemini)](./n8n_mcp/README.md) ｜ [Ollama 本機模型整合](./ollama安裝/README.md)
* 🛡️ **資料維運與備份**：[n8n 資料備份與還原指南](./n8n的備份方式/README.md)

---

### 🎯 2. [初階範例：核心入門 6 大關卡](./初階範例/README.md)
專為初學者設計的友善起點，建立正確的節點資料流與視覺化除錯思維：
1. **初體驗**：手動觸發（Manual Trigger）與節點資料流動
2. **JSON 基礎**：解析巢狀 JSON、動態表達式 `{{ }}` 變數參照
3. **網站引言串接**：呼叫 HTTP Request 取得公開 API 資料
4. **CSV 轉換為 Excel**：二進位檔案解析與 Excel XLSX 格式轉換
5. **DataTable 簡單操作**：內建資料表讀寫、成績統計排名與條件分支
6. **n8n 內建表單節點**：Form Trigger 網頁表單設計與問卷資料收集

---

### 🔗 3. [Webhook 實作：打造專屬 API 伺服器](./webhook實作/README.md)
深入理解 Webhook 事件驅動推播，將 n8n 作為高可用 API Gateway 與微服務：
1. **GET 請求與即時瀏覽器問候**：零門檻！免裝工具，網址列打參數直接回傳個人化歡迎 JSON。
2. **互動式網頁表單與個人化問候系統**：附帶**現代暗黑玻璃擬態（Glassmorphism）測試台**，支援即時延遲（ms）測量、200/400 狀態碼徽章與雙分頁檢視！
3. **電商購物車即時結帳與計算**：接收商品陣列，自動運算 VIP 9 折、滿千免運並產出電子收據。
4. **檔案上傳與自動資料統計**：接收 Multipart 二進位 CSV 成績單，自動計算國英數平均分報表。
5. **API 金鑰驗證與多事件分流**：Header API Key 401 阻斷防護與 Switch 多路業務路由器。
6. **Webhook 整合 AI 文字分析微服務**：傳入顧客評論，AI 自動評估情緒、滿意度並產出客服建議回信。

---

### ☁️ 4. [Google 服務整合：Google Workspace 自動化](./Google_Cloud_api服務/README.md)
深度串接日常辦公最核心的 Google 雲端生態系（Drive, Gmail, Sheets, Docs, Forms）：
1. **開放資料轉存 Excel 至 Google Drive**：下載政府即時 CSV，封裝 Excel 並自動備份至指定資料夾。
2. **每日早晨 AI 晨報與 Gmail 自動發信**：定時排程抓取金句，渲染精緻 **HTML 早安卡片郵件** 發送至團隊信箱。
3. **多來源 API 整合與幽默笑話電子報**：跨節點聚合名言與程式笑話，自動寄送雙色卡片放鬆特刊。
4. **線上訂便當與自動統計通知系統**：手機填表點餐（含加購紅茶運算），自動登記 Google 試算表並**秒發 HTML 訂購確認信**！
5. **學生體驗回饋問卷與滿意度告警**：監聽表單回覆，$\le 3$ 分客訴即時告警、優質建議自動轉寄產品團隊。
6. **YouBike 站點監控與動態試算表歸檔**：過濾無車低站點，智慧搜尋硬碟並自動建立當日試算表分頁。
7. **Google Docs 範本替換與 PDF 結業證書自動寄送**：Docs 佔位符替換，自動轉存 PDF 證書並以 Gmail 夾帶附件寄出。
8. **Google 試算表整合 AI 智慧客服**：試算表收到諮詢，AI Agent 自動撰寫專業回信寄出並回填狀態。

---

### 🤖 5. [AI Agent 與 LLM 模型整合：打造智慧多代理團隊](./AI_Agent/README.md)
結合大型語言模型（NVIDIA NIM、OpenRouter、Gemini、OpenAI）與 RAG 私有向量知識庫：
* **[🟢 階段一：基礎專用 AI 節點](./AI_Agent/階段一_基礎專用AI節點/README.md)**：Basic LLM Chain、Information Extractor、Sentiment Analysis、Text Classifier、Summarization Chain 與 Q&A Chain 確定性單向處理鏈。
* **[🟡 階段二：AI Agent 核心與工具調用](./AI_Agent/階段二_AI_Agent核心與工具調用/README.md)**：智能客服聊天機器人（Memory 記憶）、臺北市 YouBike 2.0 即時查詢（API Tool）、即時天氣與新聞助理（多工具自主決策）。
* **[🟠 階段三：企業級 RAG 向量知識庫](./AI_Agent/階段三_企業級RAG向量知識庫/README.md)**：入門記憶體儲存、Supabase 雲端向量庫、本地 PostgreSQL (PGVector)、Pinecone 百萬級向量庫與語意檢索策略。
* **[🔴 階段四：企業級進階實戰與多代理](./AI_Agent/階段四_企業級進階實戰與多代理/README.md)**：萬能工作流助理（Call Workflow Tool）、Gmail 客服郵件分類與工單閉環、Multi-Agent Supervisor 多代理人協同團隊、端到端全渠道客服中樞。

---

### 💬 6. [通訊軟體整合：LINE & Telegram 雙向通訊](./通訊軟體整合/README.md)
串接主流即時通訊軟體，實現事件觸發、主動告警與 AI 智慧對話機器人：
* **[📱 LINE 整合實作（5 大範例）](./通訊軟體整合/LINE/README.md)**：
  - LINE Webhook 接收 ➔ 主動推播日報 ➔ `replyToken` **免費雙向回覆**（不扣推播額度） ➔ **Flex Message 互動圖文卡片** ➔ 整合 AI Agent 智慧客服助理。
* **[✈️ Telegram 整合實作（5 大範例）](./通訊軟體整合/Telegram/README.md)**：
  - Telegram Trigger 監聽 ➔ Markdown 富文本與按鈕推播 ➔ Switch 指令應答 ➔ 圖片/報表文件檔案發送 ➔ 整合 AI 多用戶 Session 獨立記憶。

---

### 🗄️ 7. [雲端資料庫與向量知識庫：PostgreSQL, Supabase & Pinecone](./雲端資料庫整合/README.md)
關聯式資料庫與專用向量資料庫實戰，提供**完全免綁信用卡方案**：
1. **Postgres 基礎 CRUD**：參數化查詢防 SQL 注入與 `RETURNING *` 技巧
2. **Supabase Low-Code 表格存取**：免寫 SQL，透過視覺化介面讀寫資料表
3. **電商訂單 Upsert 與關聯統計**：`ON CONFLICT` 防重複下單與跨表 JOIN 分組報表
4. **資料庫變更即時偵測與推播**：定時排程監控 pending 訂單，Telegram 發送即時告警
5. **Supabase pgvector 向量知識庫**：關聯式資料庫與 RAG 向量一體化檢索
6. **Pinecone 雲端向量資料庫 RAG**：Serverless 專用向量庫毫秒級高併發語意搜尋

---

### 💻 8. [Code Node (JavaScript) 節點進階應用](<./code_node(javascript)節點/README.md>)
突破 Low-Code 限制，處理企業級複雜商業邏輯與大數據清洗：
1. **Code Node 互動式入門教學**：6 關卡實作、逐筆 vs 整批模式、`this.helpers.httpRequest` 呼叫 API
2. **字串清理與日期標準化**：正規表達式 `.replace()`、ISO 8601 轉換與繁中在地化
3. **多條件分類與動態標籤**：單一 JS 節點取代多個 IF 節點，動態計算 RFM 會員分級
4. **陣列操作與銷售報表重組**：Group By 跨店分組、不可變陣列排序與 `.reduce()` 營收聚合
5. **進階資料去重與二進位生成**：JavaScript `Map` 高速 $O(N)$ 去重與二進位 CSV 檔案動態生成

---

### 📜 9. [Google Apps Script (GAS) 整合實作](./GAS整合/README.md)
結合 Google Docs 範本排版能力與 n8n 工作流，無代碼產出企業級精緻文件：
1. **GAS 基礎文字佔位符替換**：Google Docs `{{姓名}}`、`{{日期}}` 佔位符動態替換
2. **公司專屬 Logo 與品牌套版**：動態下載企業 Logo 並內嵌至公文文件
3. **動態多列報價單與收據生成**：依品項陣列動態插入表格列，自動計算小計與 5% 稅額
4. **企業合約轉存 PDF 與雲端歸檔**：Docs 自動轉為唯讀 PDF、儲存 Google Drive 並清理暫存檔
5. **表單提交 ➔ 自動產出 PDF ➔ Gmail 寄送**：表單送出即時產出公司專屬 PDF 並夾帶附件寄出

---

### 🌐 10. [前端網頁與 WebAPI 整合 (n8n 作為後端網站)](./前端網頁與WebAPI整合/README.md)
將 n8n 當作無伺服器後端（Backend-as-a-Service, BaaS），前端透過 `fetch()` 即時串接：
1. **即時會員註冊與驗證 API**：現代玻璃擬態註冊介面、Token 簽發與狀態碼回傳
2. **商品型錄分頁與即時搜尋 API**：前端輸入防抖（Debounce）與伺服器端分頁過濾
3. **電商購物車結帳與折扣碼計算 API**：後端防篡改強制定價與優惠碼狀態機驗證
4. **檔案上傳與自動雲端託管 API**：拖曳上傳圖片 (Multipart)，解析二進位數據並回傳雲端連結
5. **AI 智慧客服對話視窗 API**：網頁右下角懸浮 AI Chat Widget，支援訪客 Session 連續對話

---

### 🌍 11. [n8n 零預算「永久免費」雲端部署指南](./n8n的部署/README.md)
專為學生量身打造的 0 元雲端部署方案，支援 7x24 雲端永久在線：
* **Hugging Face Spaces (學生首選)**：免信用卡、2 vCPU + 16GB RAM、自帶 HTTPS 網址與 Docker 部署
* **Koyeb Serverless 容器**：免信用卡、免休眠 PaaS、一鍵拉取官方映像檔與全球 CDN
* **Render 免費 Web 服務**：主流 PaaS 快速部署，搭配 UptimeRobot 防止閒置休眠
* **Oracle Cloud (OCI) 永久免費主機**：怪物級 4 核心 ARM CPU、24GB RAM、獨立公網 IP
* **資料庫持久化架構**：連線免費 Supabase PostgreSQL，實現運算與儲存分離，工作流程永不遺失

---

### 🏢 12. [企業專案實戰](./企業專案/README.md)

---

