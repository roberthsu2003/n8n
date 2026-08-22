![](./images/n8n實戰教學講義.png)

# n8n 實戰教學講義

## 📘 關於 n8n

**n8n** 起初的名稱為 **nodemation**（節點自動化），後簡化為 **n8n**（這種縮寫法來自 internationalization → i18n）。n8n 的核心理念是**整合所有帶有 API 的應用程式和服務**，並強調其**無程式碼 (No Code)** 或**低程式碼 (Low Code)** 的特性，讓非技術背景的使用者也能輕鬆建立自動化工作流。

## 🧩 n8n 工作流的五個核心邏輯要素

1. **觸發 (Trigger)** - 啟動工作流的起點
2. **連接 (Connect)** - 連結不同的服務和應用程式
3. **資料處理 (Transform)** - 轉換和處理資料
4. **測試 (Test)** - 驗證工作流是否正常運作
5. **啟動 (Activate)** - 執行自動化任務

---

## 🛠️ 環境建置與基礎設定

### 🐳 [docker安裝](./docker安裝/README.md)
完整說明 Windows、macOS 與 Raspberry Pi (Linux) 的 Docker 安裝步驟、環境設定與驗證方式。

### 🌐 [ngrok安裝](./ngrok安裝/README.md)
學習如何安裝與設定 ngrok 建立安全通道，取得公開 HTTPS 網址以接收外部 Webhook 與 OAuth 回調。

### 🚀 [n8n 簡介與安裝](./n8n簡介與安裝/README.md)
學習 n8n 的核心概念、透過 Docker 啟動 n8n 容器、備份還原、版本升級與重置方式。


### 🔐 [關於 OAuth (開放授權) 的概念](./OAuth/README.md)
了解 OAuth 2.0 的運作原理，這是連接 Google、LINE 等第三方服務的關鍵技術。

### ⚙️ [n8n MCP 設定指南](./n8n_mcp/README.md)
透過 Model Context Protocol (MCP)，將 n8n 工作流轉變為 AI 助手的強大工具：
1. **Claude.ai 官方 Connector**：免寫程式碼、瀏覽器 OAuth 一鍵授權直連。
2. **OpenCode 橋樑連線**：支援 ChatGPT / OpenAI 帳號登入與全域 CLI 管理指令（免手寫設定檔）。
3. **Google Antigravity 專案協作**：Gemini 智慧代理深度連體整合與 Bearer Token 配置。

### 🦙 [Ollama 安裝](./ollama安裝/README.md)
學習如何在 Windows、macOS 與 Raspberry Pi 安裝 Ollama、登入帳號建立 API Key、使用 `:cloud` 雲端模型（如 `gemma4:cloud`），以及與 n8n 容器的連線配置。

### ☁️ [Google Cloud 設定](./google_cloud設定/README.md)
詳細說明如何在 Google Cloud Console (Google Auth Platform) 建立專案、啟用 Google 服務 API、配置 OAuth 2.0 同意畫面、取得用戶端 ID 與密碼，並於 n8n 中完成授權綁定。

---

## 🎯 [初體驗範例](./初階範例/README.md)

適合初學者的完整教學範例，從基礎的資料處理到檔案格式轉換，幫助您建立 n8n 的核心操作能力。

**包含範例**：
- 初體驗：學習基本的觸發與資料傳遞
- JSON 基礎：掌握自動化流程的資料核心
- 透過網站取得引言：學習 HTTP Request 與 API 整合
- CSV轉換為Excel：進階檔案處理技巧

---

## 🔗 [整合 Webhook 的實作](./webhook實作/README.md)

學習如何使用 Webhook 建立 API 端點，讓外部應用程式能夠透過 HTTP 請求觸發 n8n 工作流程。

**包含範例**：
- 自動化問候系統：學習 Webhook 觸發器、條件判斷與 JSON 回應
- 即時訂單接收與計算：電商購物車資料處理、折扣與運費運算
- 檔案上傳與自動處理：Multipart Form-Data 檔案上傳與 CSV 自動解析
- 多事件分流與安全驗證：Header 金鑰驗證與 Switch 多路分流

## 🔗 [整合 Google 服務](./Google_Cloud_api服務/README.md)

提供 Google Drive、Gmail、Google Sheets 與 Google 表單等服務的整合實作範例。

**包含範例**：
- 儲存檔案至Google Drive：學習 Google Drive API 整合
- 自動寄送 Gmail：掌握排程觸發與郵件發送
- 寄送一則笑話：進階的多 API 串接技巧
- 學生體驗回饋問卷範本：完整的表單處理自動化流程

---


## 🤖 整合 LLM 模型的 AI Agent

學習如何將 Ollama、OpenAI、Claude、Gemini 等大型語言模型與 **RAG（檢索增強生成）** 整合到 n8n 工作流中，建立由淺至深的智能化自動化系統。

- **主入口**：[整合 LLM 的 AI Agent](./AI_Agent/README.md)
- **RAG 實作**（本章節內）：[整合 RAG 的實作](./AI_Agent/RAG智能問答系統/README.md) — 依文件問答、向量儲存由淺至深，含範例大綱與預留項目。

**由淺至深學習路徑**：

1. **智能客服聊天機器人** — 純對話、System Prompt、對話記憶
2. **天氣和新聞查詢（使用 Ollama）** — 工具使用、HTTP / RSS、$fromAI()
3. **RAG 入門體驗** — 記憶體儲存、精簡版文件問答；完整路徑見 [整合 RAG 的實作](./AI_Agent/RAG智能問答系統/README.md)
4. **具備工具使用能力的助理** — 進階工具、雲端 API
5. **郵件智能分類系統** — 業務自動化、分類與流程
6. **多代理協作系統** — 多代理、任務分工
7. **客戶服務自動化平台** — 端到端、知識庫與多渠道
8. **AI Agent 監控與優化** — 監控、評估、安全與優化

---

## 💬 [通訊軟體整合 (LINE & Telegram)](./通訊軟體整合/README.md)

學習如何將 n8n 與主流即時通訊軟體（LINE 與 Telegram）進行雙向串接，實現事件觸發與智慧助理自動化：

- **[📱 LINE 整合實作](./通訊軟體整合/LINE/README.md)**：
  - **LINE 訊息觸發 n8n 工作流**：設定 Webhook 接收用戶傳送的文字、圖片或加入好友事件，即時啟動自動化流程。
  - **n8n 節點呼叫 LINE Message 服務**：透過 HTTP Request 節點調用 LINE Messaging API，實現免費即時回覆 (`Reply Message`) 與主動推播通知 (`Push Message`)。
  - 支援範例工作流：[`line_bot_workflow.json`](./通訊軟體整合/LINE/line_bot_workflow.json)。
- **[✈️ Telegram 整合實作](./通訊軟體整合/Telegram/README.md)**：
  - 使用 `@BotFather` 快速建立機器人並綁定 n8n Telegram API 憑證。
  - 使用 `Telegram Trigger` 節點即時監聽指令與聊天室訊息。
  - 使用 `Telegram` 節點發送富文本通知、圖片與系統警報。
  - 支援範例工作流：[`telegram_bot_workflow.json`](./通訊軟體整合/Telegram/telegram_bot_workflow.json)。

---

## 🗄️ [雲端資料庫整合 (PostgreSQL / Supabase)](./雲端資料庫整合/README.md)

學習如何將 n8n 與業界標準關聯式資料庫 **PostgreSQL** 及最熱門的開源雲端平台 **Supabase** 整合，打造具備資料持久化與 AI 向量搜尋能力的系統：

- **[🐘 Supabase (PostgreSQL) 實作指南](./雲端資料庫整合/Supabase/README.md)**：
  - **資料表結構設計**：提供開箱即用的 SQL 腳本 [`schema.sql`](./雲端資料庫整合/Supabase/schema.sql)，建立客戶表、訂單表與向量表。
  - **Postgres 節點實戰**：透過原生 SQL 執行 CRUD、防注入參數化查詢、Upsert（避免重複寫入）與跨表統計。
  - **Supabase 節點應用**：透過 REST API 進行無程式碼 (Low-Code) 的資料庫讀寫。
  - **pgvector 向量知識庫**：整合 n8n 的 Supabase Vector Store 實現 RAG 語意搜尋。
  - 支援範例工作流：[`supabase_crud_workflow.json`](./雲端資料庫整合/Supabase/supabase_crud_workflow.json)。

---


## 💻 [Code Node (JavaScript) 進階應用](./code_node(javascript)節點/README.md)

掌握 Node.js Code 節點，突破 Low Code 的限制。學習如何處理複雜的資料轉換、多重條件判斷與陣列重組，讓您的工作流程更靈活高效。

---

## 📜 [Google Apps Script (GAS) 整合](./GAS整合/README.md)
結合 Google Apps Script 的自訂函數與 n8n 工作流，打造更強大的 Google 工作區自動化。

## ⚡ [FastAPI 整合](./FastAPI整合/)
建立自訂 Python API 服務，讓 n8n 能夠呼叫您自己的資料處理邏輯和機器學習模型。

## 🌍 [n8n 的免費部署方案](./n8n的部署/README.md)
了解如何將 n8n 部署到本機、Raspberry Pi、Oracle Cloud 等免費平台，打造 7x24 小時運行的自動化伺服器。

---


## 📚 [關於n8n的更多學習資源]

[n8n 官方文件](https://docs.n8n.io/)

[n8n 官方教學範例](https://blog.n8n.io/tag/tutorial/)

[n8n 官方證照](https://learn.n8n.io/?fbclid=IwVERDUAS3xtZleHRuA2FlbQIxMQBzcnRjBmFwcF9pZAo2NjI4NTY4Mzc5AAEe1J1uU6OplbGvEmVNwKO60GdrEHioGpxe-lFKyOSpxv0sVb3Dc1J12KbI6tk_aem_T4_qC0VlprGI5qRMTNy4VQ)

---

[**企業專案**](./企業專案/工研院產業/README.md)


