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

## 🛠️ [環境建置與基礎設定](./環境建置與基礎設定/README.md)

提供從容器引擎、安全通道、n8n 部署到 AI / MCP / Cloud 授權的完整基礎建設教學，詳見 **[👉 進入環境建置與基礎設定總覽](./環境建置與基礎設定/README.md)**。

**包含主題**：
- ⭐ **極速推薦**：[n8n + ngrok 容器化整合安裝 (解決 Windows 防毒誤判)](./n8n_ngrok/README.md)
- 🐳 **容器基礎**：[Docker 安裝指南](./docker安裝/README.md) ｜ [n8n 獨立容器安裝與啟動](./n8n簡介與安裝/README.md)
- 🌐 **外網通道**：[生產級 cloudeflare Tunnel 安全方案](./tunnel/README.md) ｜ [ngrok 本機安裝與設定](./ngrok安裝/README.md)
- 🔐 **授權與雲端**：[OAuth 2.0 概念解析](./OAuth/README.md) ｜ [Google Cloud Platform 設定](./google_cloud設定/README.md) ｜ [LINE Messaging API 設定](./line設定/README.md)
- 🤖 **AI 助手與模型**：[n8n MCP 協議設定指南](./n8n_mcp/README.md) ｜ [Ollama 雲端模型整合](./ollama安裝/README.md)
- 🛡️ **維運與部署**：[n8n 資料備份與還原](./n8n的備份方式/README.md) ｜ [n8n 生產環境部署架構](./n8n的部署/README.md)

---

## 🎯 [初階範例](./初階範例/README.md)

> ⚠️ **環境需求**：開始實作前，必須先完成 **Docker 安裝**、**建立 n8n 容器** 並 **啟動 ngrok** 外網通道才可正常執行（可參考 [n8n + ngrok 容器化整合安裝](./n8n_ngrok/README.md)）。

適合初學者的 6 大核心實作範例，循序漸進掌握節點操作、資料處理與內建功能：

- **初體驗**：手動觸發與基本資料傳遞
- **JSON 基礎**：資料結構解析與表達式應用
- **透過網站取得引言**：HTTP Request API 整合與 AI 延伸
- **CSV 轉換為 Excel**：二進位檔案解析與格式轉換
- **DataTable 簡單操作**：內建資料表、成績統計排名與 IF 條件判斷
- **n8n 內建表單節點**：Form Trigger 表單設計與資料自動寫入

---

## 🔗 [整合 Webhook 的實作](./webhook實作/README.md)

學習如何使用 Webhook 建立 API 端點，讓外部應用程式能夠透過 HTTP 請求觸發 n8n 工作流程。

**包含範例**：
- 自動化問候系統：學習 Webhook 觸發器、條件判斷與 JSON 回應
- 即時訂單接收與計算：電商購物車資料處理、折扣與運費運算
- 檔案上傳與自動處理：Multipart Form-Data 檔案上傳與 CSV 自動解析
- 多事件分流與安全驗證：Header 金鑰驗證與 Switch 多路分流

## 🔗 [整合 Google 服務](./Google_Cloud_api服務/README.md)

提供 Google Drive、Gmail、Google Sheets、Google Docs 與 Google 表單等服務的整合實作範例。

**包含範例**：
- 儲存檔案至 Google Drive：學習 Google Drive API 整合與檔案上傳
- 自動寄送 Gmail：掌握排程觸發與郵件發送
- 寄送一則笑話：進階的多 API 串接技巧
- 學生體驗回饋問卷範本：完整的表單處理自動化流程
- 訂便當系統：表單觸發器與 Google Sheets 資料寫入
- 取得台北市 YouBike 資料：動態檔案搜尋、條件分支與進階 Sheets 歸檔
- **動態文件生成與 PDF 自動化**：使用 Google Docs `{{placeholder}}` 佔位符範本替換、自動轉存 PDF 並透過 Gmail 寄出附件

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


