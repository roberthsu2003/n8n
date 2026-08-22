# ngrok 安裝與公開網址設定 🌐

為了讓本機或私有網路中的 n8n 能夠接收外部服務的請求（例如：LINE Bot Webhook、Google / Notion OAuth 2.0 整合授權、以及遠端 AI MCP 控制），**n8n 必須具備一組公開且安全的 HTTPS 網址**。

> ⚠️ **重要環境區分與定位說明**：
> - **⚡ 開發與測試階段（本教學）**：採用 **ngrok** 建立快速臨時通道，優點是免自備網域、幾秒鐘即可完成映射除錯。但因免費方案**只能同時建立 1 個 Tunnel** 且重開後網址可能變動，僅建議於開發階段使用。
> - **🚀 正式生產環境（Production）**：若需 7x24 小時常駐運行、綁定自有固定網域且無通道數量限制，請參考專門的正式方案 👉 **[生產級安全通道與穿透方案 (Cloudflare Tunnel)](../tunnel/README.md)**。

本教學採用 **ngrok** 建立安全通道（Tunnel），將本機的 `5678` 連接埠映射至公開的網際網路網址。無論是使用 **macOS**、**Windows** 或 **Raspberry Pi (Linux)** 皆能輕鬆設定。

---

## 目錄

- [步驟 1：註冊 / 登入 ngrok 帳號](#步驟-1註冊--登入-ngrok-帳號)
- [步驟 2：安裝 ngrok 應用程式](#步驟-2安裝-ngrok-應用程式)
  - [💻 Windows 安裝方式](#-windows-安裝方式)
  - [🍎 macOS 安裝方式](#-macos-安裝方式)
  - [🍓 Raspberry Pi / Linux 安裝方式](#-raspberry-pi--linux-安裝方式)
- [步驟 3：綁定專屬 Authtoken](#步驟-3綁定專屬-authtoken)
- [步驟 4：啟動通道取得公開 HTTPS 網址](#步驟-4啟動通道取得公開-https-網址)
- [重要注意事項](#重要注意事項)

---

## 步驟 1：註冊 / 登入 ngrok 帳號

1. 前往 [dashboard.ngrok.com](https://dashboard.ngrok.com/)。
2. 點選 **「Continue with Google」** 或輸入 Email 進行註冊與登入（免費方案即可滿足需求）。

---

## 步驟 2：安裝 ngrok 應用程式

登入後，可至左側選單 **Getting Started** > **Setup & Installation** 查看官方引導，或依您的作業系統選擇以下指令：

### 💻 Windows 安裝方式
請以系統管理員身分開啟 PowerShell，選擇以下其中一種方式（**⚠️ 注意：兩者請二選一，切勿重複安裝**）：

- **方法一（首選：Windows Store / winget）**：
  ```powershell
  winget install ngrok
  ```
  *(或直接開啟 Microsoft Store 應用程式搜尋 `ngrok` 點擊安裝)*

- **方法二（備選：若 winget 無法安裝，改用 Scoop）**：
  ```powershell
  # 1. 若尚未安裝 Scoop，先在 PowerShell 執行安裝
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

  # 2. 透過 Scoop 安裝 ngrok
  scoop install ngrok
  ```

---

### 🍎 macOS 安裝方式
推薦使用 Homebrew 套件管理工具，開啟終端機執行：
```bash
brew install ngrok
```

---

### 🍓 Raspberry Pi / Linux 安裝方式
在終端機執行以下指令，透過 Apt 套件庫安裝：
```bash
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && sudo apt install ngrok
```

---

## 步驟 3：綁定專屬 Authtoken

1. 在 ngrok 儀表板左側點選 **Your Authtoken** 複製您的專屬 Token。
2. 開啟終端機執行指令進行綁定：
   ```bash
   ngrok config add-authtoken <您的Authtoken>
   ```

---

## 步驟 4：啟動通道取得公開 HTTPS 網址 ⭐️

在終端機直接輸入以下指令，將本機 `5678` 埠（n8n 預設埠）對外公開：

```bash
ngrok http 5678
```

啟動後，終端機會呈現連線狀態面板：

```text
Session Status                online
Account                       your-name@gmail.com (Plan: Free)
Web Interface                 http://127.0.0.1:4040
Forwarding                    https://xxxx-xxxx.ngrok-free.dev -> http://localhost:5678
```

**請複製 `Forwarding` 欄位中的 HTTPS 網址**（例如：`https://xxxx-xxxx.ngrok-free.dev`），後續啟動 n8n 容器時會作為公開網址使用。

---

## 重要注意事項

1. ⚠️ **請保持此終端機視窗開啟**：關閉終端機即會中斷 ngrok 通道。若要執行後續的 Docker 指令，請另外開啟新的終端機視窗。
2. 💡 **Web 監控介面**：在瀏覽器開啟 `http://127.0.0.1:4040` 可以即時查看所有經過 ngrok 通道的 HTTP 請求與回應內容，除錯 Webhook 時非常方便。
3. 👉 下一步：取得公開網址後，請前往 [**n8n簡介與安裝**](../n8n簡介與安裝/README.md) 啟動 n8n 容器。
