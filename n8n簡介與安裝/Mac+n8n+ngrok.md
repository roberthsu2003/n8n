# 🍎 Mac + ngrok 固定網址設定教學

本教學將協助您在 macOS 上設定 ngrok tunnel，讓您的 n8n 伺服器可以透過固定的公開網址訪問。這是使用 LINE Bot、Google OAuth 等外部服務整合的必要步驟。

---

## 📋 前置準備

在開始之前，請確認：

- ✅ macOS 已安裝並運行 Docker Desktop
- ✅ n8n 容器已經啟動（參考主文件的安裝步驟）
- ✅ 已完成 ngrok 帳號註冊並取得：
  - Authtoken（以 `2...` 開頭的長代碼）
  - 固定網址（例如：`poodle-calm-roughly.ngrok-free.app`）

---

## 🚀 設定步驟

### 步驟 1：開啟終端機

使用以下任一方式開啟終端機：

- **方法 1**：按 `Cmd + Space` 開啟 Spotlight，輸入 `Terminal`，按 Enter
- **方法 2**：前往「應用程式」>「工具程式」>「終端機」

---

### 步驟 2：安裝 ngrok

有兩種安裝方式，推薦使用 Homebrew：

#### 方法 A：使用 Homebrew（強烈推薦）

Homebrew 是 macOS 最流行的套件管理工具，可以簡化軟體安裝和更新。

**如果尚未安裝 Homebrew**，先執行：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**安裝 ngrok**：

```bash
brew install ngrok/ngrok/ngrok
```

#### 方法 B：手動下載安裝

1. 前往 [ngrok 下載頁面](https://ngrok.com/download)
2. 選擇對應版本：
   - **Apple Silicon (M1/M2/M3)**：下載 ARM64 版本
   - **Intel Mac**：下載 AMD64 版本
3. 解壓縮 ZIP 檔案
4. 將 `ngrok` 執行檔移動到系統路徑：
   ```bash
   sudo mv ngrok /usr/local/bin/
   ```

**驗證安裝**：

```bash
ngrok version
```

應該會顯示版本號，例如：`ngrok version 3.x.x`

---

### 步驟 3：綁定 ngrok 帳號

將您在 ngrok 網站取得的 Authtoken 綁定到本機：

```bash
ngrok config add-authtoken <你的_TOKEN>
```

⚠️ **請將 `<你的_TOKEN>` 替換為您的實際 Authtoken**

範例：
```bash
ngrok config add-authtoken 2abcDEF123xyz...
```

---

### 步驟 4：啟動 ngrok Tunnel

執行以下指令啟動 ngrok，將本地的 5678 port 對應到您的固定網址：

```bash
ngrok http 5678 --domain=<你的網址>
```

⚠️ **請將 `<你的網址>` 替換為您的固定網址（不需要加 `https://`）**

範例：
```bash
ngrok http 5678 --domain=poodle-calm-roughly.ngrok-free.app
```

執行後，您會看到類似以下的畫面：

```
ngrok

Session Status                online
Account                       your-email@example.com
Version                       3.x.x
Region                        Asia Pacific (ap)
Latency                       12ms
Web Interface                 http://127.0.0.1:4040
Forwarding                    https://poodle-calm-roughly.ngrok-free.app -> http://localhost:5678

Connections                   ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

> ⚠️ **重要提醒**：
> - 此終端機視窗會變成 ngrok 的監控畫面
> - **請勿關閉此視窗**，否則連線會中斷
> - 如果需要執行其他指令，請按 `Cmd + T` 開啟新的終端機分頁

---

### 步驟 5：驗證 Tunnel 是否成功

保持 ngrok 終端機視窗開啟，在瀏覽器中開啟：

```
https://<你的網址>
```

**可能出現的狀況**：

1. ✅ **看到 n8n 登入畫面**：完美！設定成功。
2. ✅ **看到 "502 Bad Gateway"**：正常！表示 ngrok tunnel 已建立，只是 n8n 還沒啟動或正在啟動中。
3. ❌ **無法連線或錯誤訊息**：請參考下方的故障排除章節。

---

## ✅ 完整驗收測試

完成上述設定後，請依照以下步驟驗證：

### 1. 確認網站可以訪問

在瀏覽器中開啟您的固定網址：`https://<你的網址>`

應該看到 n8n 的登入或設定畫面。

### 2. 檢查 Webhook URL

驗證 Webhook 是否使用公開網址：

1. 登入 n8n
2. 建立一個新的 Workflow
3. 新增一個 **Webhook** 節點
4. 查看節點設定中的 **Webhook URL**

✅ **正確**：`https://<你的網址>/webhook/...`  
❌ **錯誤**：`http://localhost:5678/webhook/...`

如果顯示 localhost，請檢查您 Docker 啟動時的 `WEBHOOK_URL` 環境變數設定。

---

## 🔧 故障排除

### 問題 1：找不到 ngrok 指令

**錯誤訊息**：`command not found: ngrok`

**原因**：ngrok 未安裝或未加入系統 PATH。

**解決方法**：

1. 檢查是否已安裝：
   ```bash
   which ngrok
   ```

2. 如果沒有輸出，請重新安裝（使用步驟 2 的方法）

3. 如果手動下載安裝，確認檔案權限：
   ```bash
   chmod +x /usr/local/bin/ngrok
   ```

---

### 問題 2：`The tunnel ... is already bound to another session`

**原因**：ngrok 已經在另一個終端機視窗運行中。

**解決方法**：

```bash
# 關閉所有 ngrok 程序
pkill ngrok

# 稍等 2-3 秒後，重新執行步驟 4
ngrok http 5678 --domain=<你的網址>
```

---

### 問題 3：n8n Webhook 仍顯示 localhost

**原因**：Docker 容器啟動時未正確設定 `WEBHOOK_URL` 環境變數。

**解決方法**：

1. 停止並移除現有容器：
```bash
docker stop n8n
docker rm n8n
```

2. 使用正確的環境變數重新啟動（請替換 `<你的網址>`）：
```bash
docker run -d \
  --name n8n \
  --restart always \
  -p 5678:5678 \
  -e WEBHOOK_URL="https://<你的網址>" \
  -e GENERIC_TIMEZONE="Asia/Taipei" \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

---

### 問題 4：無法透過網址訪問 n8n

**檢查清單**：

1. ✅ ngrok 終端機視窗是否仍在運行？
   - 檢查視窗是否顯示 "Session Status: online"

2. ✅ Docker Desktop 是否正在運行？
   - 檢查選單列是否有 Docker 鯨魚圖示

3. ✅ n8n 容器是否正在運行？
   ```bash
   docker ps | grep n8n
   ```
   應該看到 n8n 容器的狀態為 `Up`。

4. ✅ 本地 5678 port 是否可以訪問？
   ```bash
   curl http://localhost:5678
   ```
   應該會回傳 HTML 內容。

---

## 💡 實用技巧

### 讓 ngrok 在背景執行

如果不想讓 ngrok 佔用一個終端機視窗，可以在背景執行：

```bash
ngrok http 5678 --domain=<你的網址> > /dev/null &
```

**說明**：
- `> /dev/null`：將輸出導向空，不顯示訊息
- `&`：在背景執行

**停止背景執行的 ngrok**：

```bash
pkill ngrok
```

---

### 開機自動啟動 ngrok（進階）

使用 macOS 的 LaunchAgent 讓 ngrok 開機自動執行：

1. 建立 plist 檔案：
```bash
nano ~/Library/LaunchAgents/com.ngrok.tunnel.plist
```

2. 貼上以下內容（請替換 `<你的網址>`）：
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
        <string>--domain=<你的網址></string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
```

3. 載入服務：
```bash
launchctl load ~/Library/LaunchAgents/com.ngrok.tunnel.plist
```

4. 啟動服務：
```bash
launchctl start com.ngrok.tunnel
```

**取消自動啟動**：
```bash
launchctl unload ~/Library/LaunchAgents/com.ngrok.tunnel.plist
```

---

### 監控 ngrok 連線狀況

ngrok 提供了一個本地 Web 介面，可以查看即時的請求資訊：

```
http://127.0.0.1:4040
```

在瀏覽器開啟此網址，可以看到：
- 所有通過 ngrok 的 HTTP 請求記錄
- 請求和回應的詳細內容
- 連線統計資訊

這對於除錯 Webhook 和 OAuth 整合非常有幫助！

---

**🎉 恭喜！您的 Mac n8n 伺服器已成功設定 ngrok，可以接收外部 Webhook 和使用 OAuth 整合了！**

