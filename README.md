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

## 📚 課程章節

### 🐳 [Docker容器化基礎與n8n部署準備](./Docker容器化基礎與n8n部署準備/README.md)
學習 Docker 容器化基礎與 n8n 部署準備，包括 Docker 核心概念、安裝與 Hello World、基礎指令實戰、網路與與資料持久化、進階管理與 Docker Compose、專題實戰 - 模擬 n8n 部署環境。

### 🚀 [第一章：n8n 簡介與安裝](./n8n簡介與安裝/README.md)
學習 n8n 的核心概念、支援的安裝方式（Docker、npm），以及如何建立固定網址（ngrok）以接收外部 Webhook。

### 🔐 [關於 OAuth (開放授權) 的概念](./OAuth/README.md)
了解 OAuth 2.0 的運作原理，這是連接 Google、LINE 等第三方服務的關鍵技術。

### ☁️ [Google Cloud 的 API 服務設定重點](./Google_Cloud_api服務/README.md)
學習如何在 Google Cloud Platform 建立專案、啟用 API，以及設定 OAuth 憑證。

---

## 🎯 [初體驗範例](./初階範例/README.md)

適合初學者的完整教學範例，從基礎的資料處理到檔案格式轉換，幫助您建立 n8n 的核心操作能力。

**包含範例**：
- 初體驗：學習基本的觸發與資料傳遞
- JSON 基礎：掌握自動化流程的資料核心
- 透過網站取得引言：學習 HTTP Request 與 API 整合
- CSV轉換為Excel：進階檔案處理技巧

---


## 🔗 [整合 Google 服務](./Google_Cloud_api服務/README.md)

學習如何整合 Google Cloud API 服務，包含完整的 OAuth 2.0 設定指南與實作範例。

**包含範例**：
- 儲存檔案至Google Drive：學習 Google Drive API 整合
- 自動寄送 Gmail：掌握排程觸發與郵件發送
- 寄送一則笑話：進階的多 API 串接技巧
- 學生體驗回饋問卷範本：完整的表單處理自動化流程

---

## 🔗 [整合 Webhook 的實作](./webhook實作/README.md)

學習如何使用 Webhook 建立 API 端點，讓外部應用程式能夠透過 HTTP 請求觸發 n8n 工作流程。

**包含範例**：
- 自動化問候系統：學習 Webhook 觸發器、條件判斷與 JSON 回應

---

## 🤖 整合 LLM 模型的 AI Agent

學習如何將 Ollama、OpenAI、Claude、Gemini 等大型語言模型與 **RAG（檢索增強生成）** 整合到 n8n 工作流中，建立由淺至深的智能化自動化系統。

- **主入口**：[整合 LLM 的 AI Agent](./AI_Agent/README.md)
- **RAG 實作**（本章節內）：[整合 RAG 的實作](./AI_Agent/RAG/README.md) — 依文件問答、向量儲存由淺至深，含範例大綱與預留項目。

**由淺至深學習路徑**（不另標階段，建議依序進行）：

1. **智能客服聊天機器人** — 純對話、System Prompt、對話記憶
2. **天氣和新聞查詢（使用 Ollama）** — 工具使用、HTTP / RSS、$fromAI()
3. **RAG 入門體驗** — 記憶體儲存、精簡版文件問答；完整路徑見 [整合 RAG 的實作](./AI_Agent/RAG/README.md)
4. **具備工具使用能力的助理** — 進階工具、雲端 API
5. **郵件智能分類系統** — 業務自動化、分類與流程
6. **多代理協作系統** — 多代理、任務分工
7. **客戶服務自動化平台** — 端到端、知識庫與多渠道
8. **AI Agent 監控與優化** — 監控、評估、安全與優化

---



## 🔌 [n8n MCP Server 整合](./mcp/README.md)
透過 Model Context Protocol (MCP)，將 n8n 工作流轉變為 AI 助手的強大工具，讓 AI 能夠搜尋、檢查並直接執行自動化任務。

---

## 💻 [Code Node (JavaScript) 進階應用](./code_node(javascript)節點/README.md)

掌握 Node.js Code 節點，突破 Low Code 的限制。學習如何處理複雜的資料轉換、多重條件判斷與陣列重組，讓您的工作流程更靈活高效。

---

## 🗄️ [Supabase 整合](./supabase整合/README.md)
使用開源的 Firebase 替代方案 Supabase，學習即時資料庫、檔案儲存和身份驗證的整合。

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


