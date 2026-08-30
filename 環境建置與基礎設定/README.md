# 🛠️ 環境建置與基礎設定總覽

本章節彙整了運行 n8n 自動化系統所需的各項**基礎設施建置、外部網路穿透、身份驗證、AI 模型串接以及系統維運備份**指南。無論您是在 Windows、macOS 或是 Raspberry Pi (Linux) 環境下開發，都能依照以下分類指引逐步完成設定。

---

## 🗺️ 環境架構與設定地圖


## 📚 基礎設定模組導覽

### 📦 一、容器化基礎與核心系統

#### ⭐ 1. [n8n + ngrok 容器化整合安裝 (開發測試推薦)](../n8n_ngrok/README.md)
**適用對象**：Windows / macOS  
- **解決 Windows 防毒誤判**：ngrok 運行於容器內，徹底避開 Windows Defender 將 `ngrok.exe` 誤判為病毒的問題
- **Docker Compose 一鍵管理**：透過腳本雙擊啟動/關閉，免去手動開多個終端機
- **自動綁定固定網域**：透過 `.env` 配置靜態網域，重開機 Webhook 網址不遺失

#### ☁️ 2. [n8n + Cloudflare Tunnel 容器化整合安裝 (生產級自訂網域方案)](../n8n_cloudflare/README.md)
**適用對象**：具備自訂網域的使用者 / 正式生產營運環境
- **免開路由器 Port**：利用 Cloudflare Tunnel 穿透技術，無公網 IP 亦能安全對外發佈
- **雙容器一鍵部署**：透過 Docker Compose 自動啟動 n8n 與 `cloudflared`
- **免費 Enterprise 級防護**：自動享有 Cloudflare 全球 CDN 快取、DDoS 防護與自動 Edge SSL 憑證

#### 🐳 3. [Docker 安裝指南](../docker安裝/README.md)
**適用對象**：Windows / macOS / Raspberry Pi (Linux)  
- 完整跨平台 Docker Desktop / Docker Engine 安裝流程
- 終端機常用 Docker 指令與環境驗證方式
- Linux 非 root 使用者權限設定與開機自啟動配置

#### 🚀 4. [n8n 獨立容器安裝與啟動](../n8n簡介與安裝/README.md)
**重點內容**：
- n8n 核心架構與概念介紹
- 透過 `docker run` 單獨啟動 n8n 容器實體
- 資料持久化儲存磁區 (`n8n_data`) 設定
- 容器版本更新、升級與環境重置流程

---

### 🌐 二、外網通道與安全連線

#### 🌐 5. [生產級 Tunnel 安全通道方案 (Cloudflare Tunnel)](../cloudflare_tunnel/README.md)
**重點內容**：
- 為何正式生產環境需搭配專屬網域名稱與固定 HTTPS
- **Cloudflare Tunnel (cloudflared)** 免開放路由器連接埠之高安全部署
- 自訂網域、SSL/TLS 憑證自動管理與 Webhook 穩定接收

#### 🔌 6. [ngrok 本機安裝與設定 (傳統方式/測試用)](../ngrok安裝/README.md)
**重點內容**：
- 快速建立臨時 HTTPS 安全通道
- 本地開發時即時接收外部 Webhook 與 OAuth 回調
- ngrok 帳號綁定與 AuthToken 配置

---

### 🔐 三、身份驗證與通訊/雲端服務授權

#### 🔑 7. [關於 OAuth 2.0 開放授權的概念](../OAuth/README.md)
**重點內容**：
- OAuth 2.0 運作機制與授權流程圖解
- Client ID、Client Secret、Access Token 與 Refresh Token 角色解析
- 解決第三方服務（Google、LINE 等）連線授權的核心觀念

#### ☁️ 8. [Google Cloud Platform 設定指南](../google_cloud設定/README.md)
**重點內容**：
- Google Cloud Console (Google Auth Platform) 專案建立
- 啟用 Google Drive、Gmail、Google Sheets 等 API 服務
- 配置 OAuth 2.0 同意畫面與取得用戶端憑證
- 在 n8n 中完成 Google 憑證授權綁定與常見連線排錯

#### 💬 9. [LINE Messaging API 設定指南](../line設定/README.md)
**重點內容**：
- LINE Developers Console 建立 Provider 與 Messaging API Channel
- 取得 Channel Secret 與 Channel Access Token (long-lived)
- 設定 HTTPS Webhook URL 接收訊息事件
- LINE Official Account Manager 回應模式與自動回應設定
- 在 n8n 建立 LINE 憑證與測試驗證流程

#### ✈️ 10. [Telegram Bot 申請與前置設定指南](../通訊軟體整合/Telegram/README.md#️-前置設定指南)
**重點內容**：
- 向官方 `@BotFather` 發送 `/newbot` 取得專屬 Bot Token
- 設定 `/setprivacy` (Disable) 確保機器人在群組能正常接收訊息
- 取得管理員個人與群組 `chatId` 用於警報推播
- 在 n8n 建立 Telegram 憑證與測試連線

---

### 🗄️ 四、雲端資料庫與向量資料庫平台註冊

#### 🐘 11. [Supabase 雲端資料庫註冊與連線指南 (免信用卡)](../雲端資料庫整合/Supabase/README.md)
**重點內容**：
- Supabase 官方帳號註冊（完全免信用卡）
- 建立免費 PostgreSQL 專案與設定資料庫密碼
- 取得 Session Pooler IPv4 連線主機與 Port 6543
- 在 n8n 中配置 Postgres / Supabase 憑證與 SSL 連線

#### 🌲 12. [Pinecone 向量資料庫註冊與索引設定 (免信用卡)](../雲端資料庫整合/06_Pinecone雲端向量資料庫與AI檢索/README.md#免費建立-pinecone不用花錢步驟指南)
**重點內容**：
- Pinecone 官方免費帳號註冊（Serverless Starter Plan，免信用卡）
- 取得 API Key 與環境主機位置
- 建立維度為 1536（支援 OpenAI `text-embedding-3-small`）的 Serverless 向量索引
- 在 n8n 中串接 Pinecone Vector Store 節點進行 AI 語意檢索

---

### 🤖 五、AI 智慧代理與本機/雲端模型

#### ⚙️ 13. [n8n MCP (Model Context Protocol) 設定指南](../n8n_mcp/README.md)
**重點內容**：
- 將 n8n 工作流轉變為 AI 助手的全功能工具箱（Tools）
- **Claude.ai 官方 Connector**：免寫程式碼、瀏覽器 OAuth 一鍵授權直連
- **OpenCode 橋樑連線**：支援 ChatGPT / OpenAI 帳號登入與全域 CLI 管理
- **Google Antigravity 專案協作**：Gemini 智慧代理深度整合與 Bearer Token 設定

#### 🦙 14. [Ollama 安裝與 Gemma 4 雲端模型整合](../ollama安裝/README.md)
**重點內容**：
- Windows、macOS 與 Linux 安裝指南
- 登入 Ollama 帳號並建立 API Key
- 使用 **`gemma4:cloud`** 雲端模型（免顯卡、不佔本地記憶體）
- Docker 容器內部連線與 n8n Ollama Chat Model 憑證設定

---

### 🛡️ 六、系統維運與備份

#### 💾 15. [n8n 的備份方式](../n8n的備份方式/README.md)
**重點內容**：
- Docker Volume 手動備份與匯出工作流 JSON
- 透過 n8n 內建排程工作流實現全自動定時備份
- 資料庫與憑證之異地備份與災害復原流程
