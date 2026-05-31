# 🌐 ngrok 各平台（Mac / Windows / Raspberry Pi）設定教學

本教學協助您在不同的作業系統（macOS、Windows、Raspberry Pi）上安裝與設定 ngrok tunnel，將您本地或區域網路內的 n8n 服務（預設埠為 `5678`）對應到您申請的公開固定網址。

這是讓 n8n 接收外部 Webhook（例如 LINE Bot）與設定第三方 OAuth 2.0 授權（例如 Google API）的必要關鍵步驟。

---

## 📋 前置準備

在開始之前，請確認：
1. **Docker 環境**：您的本機或遠端裝置已成功運行 Docker 且 n8n 容器已經啟動（請參考主安裝文件）。
2. **ngrok 帳號與資訊**：您已登入 ngrok 取得：
   - 專屬的 **Authtoken**。
   - 配發或申請的 **固定網址 (Static Domain)**（例如：`xxx.ngrok-free.app` 或 `xxx.ngrok-free.dev`）。

---

## 🚀 步驟 1：開啟終端機並連線

依據您的系統開啟相應的命令行介面：

### 🍎 macOS
- 按住 `Cmd + Space` 開啟 Spotlight，搜尋 `Terminal` 並開啟。

### 🪟 Windows
- 推薦使用 **PowerShell**：按 `Win + X` 鍵後選擇「Windows PowerShell」。
- 或按 `Win + R` 輸入 `cmd` 開啟命令提示字元。

### 🍓 Raspberry Pi (遠端連線)
- 在本機電腦的終端機上透過 SSH 連線至您的 Pi：
  ```bash
  ssh pi@<您的Pi-IP位址>
  ```
  *(提示：在 Pi 本機輸入 `hostname -I` 可查詢其內部 IP)*

---

## 📥 步驟 2：安裝 ngrok

請選擇您目前的作業系統來完成安裝：

### 🍎 macOS 安裝方式
推薦使用 Homebrew 安裝。若未安裝 Homebrew，可先至 [brew.sh](https://brew.sh/) 安裝。
```bash
brew install ngrok/ngrok/ngrok
```
*（手動下載：下載官方 Mac ZIP 檔，解壓後將 `ngrok` 移至 `/usr/local/bin/` 並執行 `chmod +x` 給予權限。）*

### 🪟 Windows 安裝方式
- **方式 A (推薦，適合開發者)**：如果您有安裝 Chocolatey，可執行：
  ```powershell
  choco install ngrok
  ```
- **方式 B (手動安裝)**：
  1. 前往 [ngrok 下載頁面](https://ngrok.com/download) 下載 Windows (64-bit) 壓縮檔。
  2. 解壓縮後將 `ngrok.exe` 放於方便的資料夾（如 `C:\Tools\ngrok\`）。
  3. 在該資料夾內按住 `Shift` + 滑鼠右鍵，選擇「在此處開啟 PowerShell 視窗」。

### 🍓 Raspberry Pi 安裝方式
在 Pi 的 SSH 終端機中執行以下一鍵安裝指令：
```bash
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && \
  sudo apt install ngrok
```

**🔍 驗證安裝**：安裝完後，在各系統終端機執行 `ngrok version` 應能成功顯示版本號。

---

## 🔑 步驟 3：綁定 ngrok 帳號 (Authtoken)

將您在 ngrok Dashboard 取得的帳號專屬 Token 綁定至本地環境（此指令跨平台通用，Windows 下為 `ngrok.exe` 或 `./ngrok`）：

```bash
ngrok config add-authtoken <您的Authtoken>
```
> ⚠️ **請將 `<您的Authtoken>` 替換為您網頁上實際的 Token**（例如以 `2...` 或 `3...` 開頭的長字串）。

---

## ⚡ 步驟 4：啟動 ngrok Tunnel

將本地 `5678` Port (n8n 預設埠) 的流量透過 ngrok 轉發到您的固定網址：

### 🍎 macOS 與 🪟 Windows (前景執行)
```bash
ngrok http 5678 --domain=<您的固定網址>
```
> ⚠️ **注意**：
> - 請將 `<您的固定網址>` 替換為實際網址（不含 `https://`，例如：`xxx.ngrok-free.dev`）。
> - 前景執行會顯示即時狀態面板。**請勿關閉此終端機視窗**，否則通道會中斷。若需執行其他指令，請另開新視窗/分頁。

### 🍓 Raspberry Pi (背景執行)
為了避免 SSH 斷線導致 ngrok 關閉，建議在背景運行：
```bash
ngrok http 5678 --domain=<您的固定網址> > /dev/null &
```

---

## 🧪 步驟 5：驗收與測試

### 1. 驗證網址訪問
保持 ngrok 啟動狀態，在網頁瀏覽器中輸入：
```text
https://<您的固定網址>
```
- **成功**：將會直接看到 n8n 的登入或註冊畫面。
- **502 Bad Gateway**：表示 ngrok 已成功連通，但您本地的 n8n Docker 容器尚未啟動或仍在初始化中。

### 2. 檢查 Webhook URL 設定
登入 n8n 後，隨便點擊建立一個新的 Workflow 並新增 **Webhook 節點**。
檢查該節點提供的 Webhook URL：
- ✅ **正確**：顯示為 `https://<您的固定網址>/webhook/...`
- ❌ **錯誤**：顯示為 `http://localhost:5678/webhook/...`（此時表示您啟動 n8n Docker 容器時，未設定 `WEBHOOK_URL` 環境變數，請參考下方故障排除處理）。

---

## 🔧 故障排除 (Troubleshooting)

### 問題 1：提示 `command not found: ngrok` 或 `'ngrok' is not recognized...`
- **Mac / Linux**：表示 ngrok 未安裝或未加入環境變數，請確認是否執行了 `/usr/local/bin` 移動步驟或 `brew install`。
- **Windows**：如果手動安裝，請在 `ngrok.exe` 的目錄下執行，或輸入完整路徑：`.\ngrok.exe http 5678 ...`

### 問題 2：顯示 `The tunnel ... is already bound to another session`
- 說明該網址已在另一個 ngrok 程序中被佔用。
- **解決方法**：
  - **Mac / Linux**：執行 `pkill ngrok` 關閉所有舊的 ngrok，稍等 3 秒後重新啟動。
  - **Windows**：開啟工作管理員 (`Ctrl + Shift + Esc`)，在處理程序中找到 `ngrok.exe` 並點擊「結束工作」。

### 問題 3：n8n 的 Webhook URL 仍顯示為 localhost
- 這是因為 Docker 啟動時沒有傳入 `WEBHOOK_URL` 所導致。
- **解決方法**：
  1. 停止並刪除舊容器：`docker stop n8n && docker rm n8n`
  2. 帶入環境變數重新啟動容器（請替換 `<您的固定網址>`）：
     - **Mac / Linux**：
       ```bash
       docker run -d --name n8n --restart always -p 5678:5678 -e WEBHOOK_URL="https://<您的固定網址>" -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
       ```
     - **Windows (PowerShell)**：
       ```powershell
       docker run -d --name n8n --restart always -p 5678:5678 -e WEBHOOK_URL="https://<您的固定網址>" -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
       ```

---

## 💡 進階實用技巧

### 1. 開機與自動啟動設定

#### 🍎 macOS (使用 LaunchAgent)
1. 建立設定檔：`nano ~/Library/LaunchAgents/com.ngrok.tunnel.plist`
2. 貼上以下內容（注意替換 `<您的固定網址>`）：
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.ngrok.tunnel</string>
       <key>ProgramArguments</key>
       <array>
           <string>/usr/local/bin/ngrok</string>
           <string>http</string>
           <string>5678</string>
           <string>--domain=<您的固定網址></string>
       </array>
       <key>RunAtLoad</key>
       <true/>
       <key>KeepAlive</key>
       <true/>
   </dict>
   </plist>
   ```
3. 載入並啟動服務：
   ```bash
   launchctl load ~/Library/LaunchAgents/com.ngrok.tunnel.plist
   launchctl start com.ngrok.tunnel
   ```

#### 🍓 Raspberry Pi (使用 systemd)
1. 建立服務：`sudo nano /etc/systemd/system/ngrok.service`
2. 貼上以下內容：
   ```ini
   [Unit]
   Description=ngrok tunnel
   After=network.target

   [Service]
   Type=simple
   User=pi
   ExecStart=/usr/local/bin/ngrok http 5678 --domain=<您的固定網址>
   Restart=on-failure

   [Install]
   WantedBy=multi-user.target
   ```
3. 啟用服務：
   ```bash
   sudo systemctl enable ngrok && sudo systemctl start ngrok
   ```

### 2. 即時連線監控
ngrok 啟動後會在本地開啟一個 Web 介面。打開瀏覽器進入：
```text
http://127.0.0.1:4040
```
在這裡，您可以即時監看所有進入 n8n 的 HTTP 請求、Webhook 回應及資料主體，是整合測試時的極佳工具！
