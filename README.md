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

## 🛠️ [環境建置與第三方網站註冊設定](./環境建置與基礎設定/README.md)

本課程各章節實作所需之**雲端服務、第三方平台註冊、API 憑證與基礎設施**完整前置設定指南（詳見 **[👉 進入環境建置與基礎設定總覽](./環境建置與基礎設定/README.md)**）：

- 🐳 **容器與本機安裝**：[Docker 安裝指南](./docker安裝/README.md) ｜ [n8n 獨立容器安裝與啟動](./n8n簡介與安裝/README.md)
- 🌐 **外網通道平台註冊**：[ngrok 帳號註冊與 AuthToken 設定](./ngrok安裝/README.md) ｜ [Cloudflare 帳號註冊與 Tunnel 安全通道](./cloudflare_tunnel/README.md)
- ⭐ **一鍵容器化整合推薦**：[n8n + ngrok 雙容器方案 (開發測試/解決防毒誤判)](./n8n_ngrok/README.md) ｜ [n8n + Cloudflare 雙容器方案 (自訂網域生產級)](./n8n_cloudflare/README.md)
- 💬 **通訊軟體開發者註冊**：[LINE Developers 註冊與 Messaging API 設定](./line設定/README.md) ｜ [Telegram BotFather 機器人申請與憑證設定](./通訊軟體整合/Telegram/README.md#️-前置設定指南)
- ☁️ **Google 雲端平台註冊**：[Google Cloud Platform (GCP) 專案建立與 API 啟用](./google_cloud設定/README.md) ｜ [OAuth 2.0 開放授權概念解析](./OAuth/README.md)
- 🗄️ **雲端資料庫平台註冊**：[Supabase 雲端資料庫註冊與連線設定 (免信用卡)](./雲端資料庫整合/Supabase/README.md) ｜ [Pinecone 向量資料庫註冊與索引設定 (免信用卡)](./雲端資料庫整合/06_Pinecone雲端向量資料庫與AI檢索/README.md#免費建立-pinecone不用花錢步驟指南)
- 🤖 **AI 助手與模型註冊**： [NVIDIA NIM 微服務模型串接](./nvidia_nim/README.md) ｜ [OpenRouter 多模型聚合平台 (資安合規)](./openrouter/README.md) [n8n MCP 協議設定 (Claude / OpenAI / Gemini)](./n8n_mcp/README.md) ｜ [Ollama 官方雲端模型整合](./ollama安裝/README.md) 
- 🛡️ **資料維運與備份**：[n8n 資料備份與還原指南](./n8n的備份方式/README.md)

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

學習如何使用 Webhook 將 n8n 打造為專屬的 API 伺服器與微服務，提供由淺至深 6 大實作範例：

- **GET 請求與瀏覽器即時問候**：零門檻入門，瀏覽器網址列直接傳參測試與 JSON 即時回應
- **互動式網頁表單問候系統**：接收 POST 表單請求，搭配 HTML5/CSS3 前端介面體驗動態反饋
- **電商購物車即時結帳與計算**：接收商品清單陣列，運算 VIP 9 折與滿千免運並產出電子收據
- **檔案上傳與自動解析處理**：接收 Multipart 二進位 CSV 檔案，自動解析資料並產出統計分析報表
- **API 金鑰安全驗證與多事件分流**：Header API Key 401 阻斷防護與 Switch 多路業務路由
- **Webhook 整合 AI 文字分析微服務**：外部傳入顧客留言，AI 自動評估情緒、產出摘要與客服回信建議

---

## 🔗 [整合 Google 服務（Google Workspace 自動化）](./Google_Cloud_api服務/README.md)

深度整合 Google Drive、Gmail、Google Sheets、Google Docs 與 Google 表單，提供由淺至深 8 大實作範例：

- **自動備份檔案至 Google Drive**：下載開放資料 CSV，轉換 Excel 並自動上傳至雲端硬碟備份
- **每日早晨 AI 晨報與 Gmail 自動發信**：排程觸發取得每日金句，排版 HTML 晨報並透過 Gmail 發送
- **多來源 API 整合與幽默笑話電子報**：並行請求名言與笑話 API，合併資料並寄送雙語電子報
- **辦公室線上訂便當與 Google Sheets 自動歸檔**：線上網頁表單訂餐，自動計算金額並逐筆追加寫入試算表
- **學生體驗回饋問卷與滿意度自動告警通知**：監聽 Google 表單回覆，低分客訴即時告警、高分寄送感謝信
- **臺北市 YouBike 2.0 站點監控與動態試算表歸檔**：空車警戒過濾，智慧搜尋雲端硬碟並動態建立分頁
- **Google Docs 範本動態替換與 PDF 結業證書自動發信**：Docs 範本 `{{placeholder}}` 批次文字替換，匯出 PDF 附件自動寄出
- **Google 試算表整合 AI 智慧客服與自動郵件回覆**：試算表登記新諮詢，AI 自動撰寫專業回信並寄出，回填處理狀態

---


## 🤖 [整合 LLM 模型的 AI Agent](./AI_Agent/README.md)

學習如何將 Ollama（本地零成本）、Google Gemini、OpenAI GPT、Claude 等大型語言模型與 **RAG 向量知識庫** 整合到 n8n 中，提供由淺至深 8 大實作範例：

- **階段一：基礎對話與工具呼叫**
  1. **智能客服聊天機器人**：純對話、System Prompt、Window Buffer Memory 對話記憶
  2. **臺北市 YouBike 2.0 即時查詢**：單一工具調用，串接台北市政府開放資料 API
  3. **多工具天氣與新聞助理**：多工具自主選擇，使用 `$fromAI()` 動態生成查詢參數
- **階段二：RAG 知識庫與工作流自動化**
  4. **企業私有知識庫 RAG 問答系統**：向量資料庫檢索（In-Memory / Supabase），杜絕模型幻覺
  5. **具備工作流呼叫能力的 AI 萬能助理**：掛載 Calculator Tool 與 Call n8n Workflow Tool
  6. **Gmail 客服郵件智慧分類與歸檔**：結構化 JSON 輸出、高急迫告警分流與 Google Sheets 記錄
- **階段三：多代理協同與企業級平台**
  7. **多代理人協作團隊 (Multi-Agent)**：Supervisor 主管代理拆解任務，指揮「調研」與「文案」專家
  8. **端到端客戶服務自動化平台**：全渠道 Webhook 接入、RAG 檢索、意圖判斷與真人客服升級

---

## 💬 [通訊軟體整合 (LINE & Telegram)](./通訊軟體整合/README.md)

學習如何將 n8n 與主流即時通訊軟體（LINE 與 Telegram）進行雙向串接，實現事件觸發與智慧助理自動化：

- **[📱 LINE 整合實作](./通訊軟體整合/LINE/README.md)**（另附 **[📱 圖文前置與憑證設定指南](./line設定/README.md)**）：
  - 提供由淺至深 5 大實作範例（支援免費 Reply API 與 Flex 圖文卡片）：
    1. **LINE 訊息接收與 Webhook 觸發**：設定 Webhook 接收用戶傳送事件，即時回傳 200 OK 並解析關鍵欄位。
    2. **主動推播與排程通知**：透過 HTTP Request 節點調用 LINE Push API，發送定時營運日報。
    3. **雙向通訊與關鍵字自動回覆**：使用 `replyToken` 在 1 分鐘內免費即時回覆訊息（完全不扣推播額度）。
    4. **Flex Message 互動圖文卡片**：使用 JSON 結構打造具備封面圖、價格與導購按鈕的高質感 Bubble 卡片。
    5. **整合 AI 智慧客服助理**：串接 `AI Agent` 與 LLM 模型，以 `userId` 隔離對話記憶並免費回傳。
  - 支援範例工作流：[`line_webhook_trigger.json`](./通訊軟體整合/LINE/LINE訊息觸發工作流/line_webhook_trigger.json)、[`line_push_message.json`](./通訊軟體整合/LINE/n8n呼叫LINE發送訊息/line_push_message.json)、[`line_bot_workflow.json`](./通訊軟體整合/LINE/LINE雙向通訊與自動回覆/line_bot_workflow.json)、[`line_flex_message.json`](./通訊軟體整合/LINE/LINEFlexMessage圖文卡片/line_flex_message.json)、[`line_ai_agent.json`](./通訊軟體整合/LINE/LINE整合AI智慧助理/line_ai_agent.json)。
- **[✈️ Telegram 整合實作](./通訊軟體整合/Telegram/README.md)**（另附 **[✈️ 前置與憑證設定指南](./通訊軟體整合/Telegram/README.md#️-前置設定指南)**）：
  - 提供由淺至深的 5 大實作範例（完全免費無推播則數上限）：
    1. **Telegram 訊息觸發**：使用 `Telegram Trigger` 監聽指令與訊息，解析 `chatId` 與發訊者資訊。
    2. **主動推播與警報通知**：使用 `Telegram` 節點發送 Markdown 富文本排版與 Inline Keyboard 按鈕。
    3. **雙向通訊與自動回覆**：使用 `Switch` 節點實現 `/start`、`/help`、`/info` 指令分流應答。
    4. **多媒體與文件檔案推播**：發送圖片 (`Send Photo`) 與報表檔案 (`Send Document`) 附加 Caption。
    5. **整合 AI 智慧助理**：串接 `AI Agent` 與 LLM 模型，以 `chatId` 實現多用戶 Session 獨立對話記憶。
  - 支援範例工作流：[`telegram_trigger_workflow.json`](./通訊軟體整合/Telegram/Telegram訊息觸發工作流/telegram_trigger_workflow.json)、[`telegram_send_message.json`](./通訊軟體整合/Telegram/n8n呼叫Telegram發送訊息/telegram_send_message.json)、[`telegram_bot_interactive.json`](./通訊軟體整合/Telegram/Telegram雙向通訊與自動回覆/telegram_bot_interactive.json)、[`telegram_send_media.json`](./通訊軟體整合/Telegram/Telegram發送多媒體與文件/telegram_send_media.json)、[`telegram_ai_agent.json`](./通訊軟體整合/Telegram/Telegram整合AI智慧助理/telegram_ai_agent.json)。

---

## 🗄️ [雲端資料庫與向量資料庫整合 (PostgreSQL, Supabase & Pinecone)](./雲端資料庫整合/README.md)（另附 **[🐘 Supabase 設定指南](./雲端資料庫整合/Supabase/README.md)**）

學習如何將 n8n 與關聯式資料庫 **PostgreSQL**、全端平台 **Supabase** 及專用無伺服器向量資料庫 **Pinecone** 整合，提供由淺至深 6 大實作範例（皆支援**完全免費、免綁信用卡**方案）：

- **Postgres 基礎 CRUD 與資料讀寫**：原生 SQL 語法、參數化查詢防 SQL 注入與 `RETURNING *` 技巧
- **Supabase Low-Code 節點與資料表存取**：免寫 SQL，透過 REST API 進行 Low-Code 視覺化表格讀寫與條件過濾
- **電商訂單 Upsert 與跨表關聯統計報表**：使用 `ON CONFLICT` 防重複寫入，並執行 `LEFT JOIN ... GROUP BY` 產出消費排行榜
- **資料庫變更即時偵測與即時推播**：定時排程監控 `pending` 新訂單，自動發送 Telegram / LINE 推播並更新狀態閉環
- **Supabase pgvector 向量知識庫與 AI 語意搜尋**：啟用 `pgvector` 擴充套件，打造關聯式資料庫與 RAG 向量一體化檢索
- **Pinecone 雲端向量資料庫與 AI 檢索**：免費建立 Serverless Index，體驗專用向量資料庫毫秒級高併發 RAG 檢索

---


## 💻 [Code Node (JavaScript) 節點進階應用](./code_node%28javascript%29節點/README.md)（另附 **[📖 執行機制與全域變數詳解](./code_node%28javascript%29節點/n8n執行機制與全域變數詳解.md)**）

掌握 JavaScript Code 節點，突破 Low Code 的限制，處理複雜商業邏輯與大數據清洗，提供由淺至深 5 大實作範例：

- **Code Node 互動式入門教學**：6 關卡實作、逐筆 vs 整批執行模式、`this.helpers.httpRequest` 呼叫 API 與 CSV 生成
- **字串清理與日期格式標準化**：正規表達式 `.replace()`、ISO 8601 標準日期轉換、文字修剪與繁體中文語系化輸出
- **多條件分類與動態標籤**：單一節點取代十幾個 IF 節點、多維度邏輯運算、動態陣列標籤與防除以零安全設計
- **陣列操作與銷售報表重組**：動態 Object Map Group By 分組、不可變陣列排序、`.reduce()` 營收聚合與多維度日報產出
- **進階資料去重與二進位檔案生成**：JavaScript `Map` 高速 $O(N)$ 去重、合併來源管道、UTF-8 BOM 防 Excel 亂碼與二進位 CSV 封裝

---

## 📜 [Google Apps Script (GAS) 整合實作](./GAS整合/README.md)

結合 Google Apps Script (GAS) 的深度排版能力與 n8n 工作流程，使用 **Placeholder（佔位符）範本** 打造完全符合企業專屬格式的公文、報價單、合約與 PDF，提供由淺至深 5 大實作範例：

- **GAS 基礎文字佔位符替換**：Google Docs 範本文字替換、正則表達式跳脫與公版複製
- **公司專屬 Logo 與品牌套版**：動態下載企業 Logo 圖檔並內嵌、自訂統編、Slogan 與 CI/VI 規範
- **動態多列報價單與收據生成**：支援不固定品項數量，動態新增表格列、計算小計、5% 營業稅與總計
- **企業合約與證書生成 PDF 與雲端歸檔**：自動轉換為唯讀 PDF 檔案、儲存至指定 Google Drive 資料夾並自動清理暫存檔
- **Google 表單提交 ➔ 自動生成客製 PDF ➔ Gmail 寄送**：雙向自動化閉環，表單提交即時產出公司專屬 PDF 並自動夾帶附件寄出

---

## 🌐 [前端網頁與 WebAPI 整合（n8n 作為後端網站）](./前端網頁與WebAPI整合/README.md)

前端網頁透過 `fetch()` 呼叫 n8n Webhook，將 n8n 作為無伺服器後端網站（Backend WebAPI / BaaS），提供由淺至深 5 大實作範例：

- **即時會員註冊與驗證 API**：玻璃擬態註冊/登入介面、Email 格式檢查、Session Token 簽發與狀態碼回傳
- **商品型錄分頁與即時搜尋 API**：RESTful GET 請求、前端輸入防抖（Debounce）、商品分類篩選與伺服器端分頁運算
- **電商購物車結帳與折扣碼計算 API**：後端防篡改強制定價、優惠代碼狀態機驗證、5% 稅額計算與訂單序號生成
- **檔案上傳與自動雲端託管 API**：拖曳上傳 (Multipart FormData)、二進位數據解析、自動儲存至 Google Drive 與公開連結回傳
- **AI 智慧客服對話視窗 API**：網站右下角浮動 AI Chat Widget、依 `sessionId` 隔離訪客對話記憶與 AI Agent 即時應答

---

## 🌍 [n8n 零預算「永久免費」雲端部署全指南](./n8n的部署/README.md)

專為學生量身打造的 0 元雲端部署方案（完全排除實體硬體購買，支援 7x24 雲端永久在線）：

- **Hugging Face Spaces (學生首選)**：免信用卡、2 vCPU + 16GB RAM、自帶 HTTPS 網址與 Docker 容器部署
- **Koyeb Serverless 容器**：免信用卡、免休眠 PaaS、一鍵拉取官方映像檔與全球 CDN 邊緣加速
- **Render 免費 Web 服務**：主流 PaaS 快速部署，搭配 UptimeRobot 免費排程防止閒置休眠
- **Oracle Cloud (OCI) 永久免費主機**：怪物級 4 核心 ARM CPU、24GB RAM、獨立公網 IP 與 Docker 生產環境
- **資料庫持久化架構**：連線免費 Supabase PostgreSQL，實現運算與儲存分離，工作流程永不遺失

---

[**企業專案**](./企業專案/工研院產業/README.md)


