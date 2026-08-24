# 🛠️ 環境建置與基礎設定總覽

本章節彙整了運行 n8n 自動化系統所需的各項**基礎設施建置、外部網路穿透、身份驗證、AI 模型串接以及系統維運備份**指南。無論您是在 Windows、macOS 或是 Raspberry Pi (Linux) 環境下開發，都能依照以下分類指引逐步完成設定。

---

## 🗺️ 環境架構與設定地圖


## 📚 基礎設定模組導覽

### 📦 一、容器化基礎與核心系統

#### 🐳 1. [Docker 安裝指南](../docker安裝/README.md)
**適用對象**：Windows / macOS / Raspberry Pi (Linux)  
- 完整跨平台 Docker Desktop / Docker Engine 安裝流程
- 終端機常用 Docker 指令與環境驗證方式
- Linux 非 root 使用者權限設定與開機自啟動配置

#### 🚀 2. [n8n 簡介與容器安裝](../n8n簡介與安裝/README.md)
**重點內容**：
- n8n 核心架構與概念介紹
- 透過 Docker 快速啟動 n8n 容器實體
- 資料持久化儲存磁區 (`n8n_data`) 設定
- 容器版本更新、升級與環境重置流程

---

### 🌐 二、外網通道與安全連線

#### 🌐 3. [生產級 Tunnel 安全通道方案](../tunnel/README.md)
**重點內容**：
- 為何正式生產環境需搭配專屬網域名稱與固定 HTTPS
- **Cloudflare Tunnel (cloudflared)** 免開放路由器連接埠之高安全部署
- 自訂網域、SSL/TLS 憑證自動管理與 Webhook 穩定接收

#### 🔌 4. [ngrok 安裝與設定 (開發測試用)](../ngrok安裝/README.md)
**重點內容**：
- 快速建立臨時 HTTPS 安全通道
- 本地開發時即時接收外部 Webhook 與 OAuth 回調
- ngrok 帳號綁定與 AuthToken 配置

---

### 🔐 三、身份驗證與通訊/雲端服務授權

#### 🔑 5. [關於 OAuth 2.0 開放授權的概念](../OAuth/README.md)
**重點內容**：
- OAuth 2.0 運作機制與授權流程圖解
- Client ID、Client Secret、Access Token 與 Refresh Token 角色解析
- 解決第三方服務（Google、LINE 等）連線授權的核心觀念

#### ☁️ 6. [Google Cloud Platform 設定指南](../google_cloud設定/README.md)
**重點內容**：
- Google Cloud Console (Google Auth Platform) 專案建立
- 啟用 Google Drive、Gmail、Google Sheets 等 API 服務
- 配置 OAuth 2.0 同意畫面與取得用戶端憑證
- 在 n8n 中完成 Google 憑證授權綁定與常見連線排錯

#### 💬 7. [LINE Messaging API 設定指南](../line設定/README.md)
**重點內容**：
- LINE Developers Console 建立 Provider 與 Messaging API Channel
- 取得 Channel Secret 與 Channel Access Token (long-lived)
- 設定 HTTPS Webhook URL 接收訊息事件
- LINE Official Account Manager 回應模式與自動回應設定
- 在 n8n 建立 LINE 憑證與測試驗證流程

---

### 🤖 四、AI 智慧代理與本機/雲端模型

#### ⚙️ 8. [n8n MCP (Model Context Protocol) 設定指南](../n8n_mcp/README.md)
**重點內容**：
- 將 n8n 工作流轉變為 AI 助手的全功能工具箱（Tools）
- **Claude.ai 官方 Connector**：免寫程式碼、瀏覽器 OAuth 一鍵授權直連
- **OpenCode 橋樑連線**：支援 ChatGPT / OpenAI 帳號登入與全域 CLI 管理
- **Google Antigravity 專案協作**：Gemini 智慧代理深度整合與 Bearer Token 設定

#### 🦙 9. [Ollama 安裝與 Gemma 4 雲端模型整合](../ollama安裝/README.md)
**重點內容**：
- Windows、macOS 與 **Raspberry Pi (Linux 一行指令 systemd override)** 安裝指南
- 登入 Ollama 帳號並建立 API Key
- 使用 **`gemma4:cloud`** 雲端模型（免顯卡、不佔本地記憶體）
- Docker 容器內部連線與 n8n Ollama Chat Model 憑證設定

---

### 🛡️ 五、系統維運、備份與正式部署

#### 💾 10. [n8n 的備份方式](../n8n的備份方式/README.md)
**重點內容**：
- Docker Volume 手動備份與匯出工作流 JSON
- 透過 n8n 內建排程工作流實現全自動定時備份
- 資料庫與憑證之異地備份與災害復原流程

#### 🚢 11. [n8n 的生產環境部署](../n8n的部署/README.md)
**重點內容**：
- Docker Compose 多容器編排設定（搭配 PostgreSQL 資料庫）
- 反向代理（Reverse Proxy）、環境變數與安全金鑰管理
- 正式上線維運最佳實踐與高可用性架構

