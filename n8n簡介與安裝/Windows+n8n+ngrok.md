# 🪟 Windows + ngrok 固定網址設定教學

本教學將協助您在 Windows 電腦上設定 ngrok tunnel，讓您的 n8n 伺服器可以透過固定的公開網址訪問。這是使用 LINE Bot、Google OAuth 等外部服務整合的必要步驟。

---

## 📋 前置準備

在開始之前，請確認：

- ✅ Windows 系統已安裝並運行 Docker Desktop
- ✅ n8n 容器已經啟動（參考主文件的安裝步驟）
- ✅ 已完成 ngrok 帳號註冊並取得：
  - Authtoken（以 `2...` 開頭的長代碼）
  - 固定網址（例如：`poodle-calm-roughly.ngrok-free.app`）

---

## 🚀 設定步驟

### 步驟 1：開啟終端機

請使用以下任一方式開啟終端機：

- **PowerShell**（推薦）：按 `Win + X`，選擇「Windows PowerShell」
- **命令提示字元 (CMD)**：按 `Win + R`，輸入 `cmd`，按 Enter

---

### 步驟 2：安裝 ngrok

有兩種安裝方式，請選擇其中一種：

#### 方法 A：使用 Chocolatey（推薦，適合開發者）

如果您已安裝 [Chocolatey](https://chocolatey.org/) 套件管理器：

```powershell
choco install ngrok
```

#### 方法 B：手動下載安裝（適合一般使用者）

1. 前往 [ngrok 下載頁面](https://ngrok.com/download)
2. 下載 **Windows (64-bit)** 版本
3. 解壓縮 ZIP 檔案
4. 將 `ngrok.exe` 放到方便的位置（例如：`C:\Tools\ngrok\` 或桌面）
5. 在該資料夾按住 `Shift` + 右鍵，選擇「在此處開啟 PowerShell 視窗」

**驗證安裝**：

```powershell
ngrok version
```

應該會顯示版本號，例如：`ngrok version 3.x.x`

---

### 步驟 3：綁定 ngrok 帳號

將您在 ngrok 網站取得的 Authtoken 綁定到本機：

```powershell
ngrok config add-authtoken <你的_TOKEN>
```

⚠️ **請將 `<你的_TOKEN>` 替換為您的實際 Authtoken**

範例：
```powershell
ngrok config add-authtoken 2abcDEF123xyz...
```

---

### 步驟 4：啟動 ngrok Tunnel

執行以下指令啟動 ngrok，將本地的 5678 port 對應到您的固定網址：

```powershell
ngrok http 5678 --domain=<你的網址>
```

⚠️ **請將 `<你的網址>` 替換為您的固定網址（不需要加 `https://`）**

範例：
```powershell
ngrok http 5678 --domain=poodle-calm-roughly.ngrok-free.app
```

執行後，您會看到類似以下的畫面：

```
ngrok

Session Status                online
Account                       your-email@example.com
Version                       3.x.x
Region                        Asia Pacific (ap)
Latency                       -
Web Interface                 http://127.0.0.1:4040
Forwarding                    https://poodle-calm-roughly.ngrok-free.app -> http://localhost:5678

Connections                   ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

> ⚠️ **重要提醒**：
> - 此終端機視窗會變成 ngrok 的監控畫面
> - **請勿關閉此視窗**，否則連線會中斷
> - 如果需要執行其他指令，請另開一個終端機視窗

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

**錯誤訊息**：`'ngrok' is not recognized as an internal or external command`

**原因**：ngrok 未安裝或未加入系統 PATH。

**解決方法**：

1. 確認 ngrok.exe 的位置
2. 使用完整路徑執行，例如：
   ```powershell
   C:\Tools\ngrok\ngrok.exe http 5678 --domain=<你的網址>
   ```
3. 或將 ngrok 加入系統 PATH（進階使用者）

---

### 問題 2：`The tunnel ... is already bound to another session`

**原因**：ngrok 已經在另一個視窗運行中。

**解決方法**：

1. 找到並關閉正在運行 ngrok 的終端機視窗
2. 或在工作管理員中結束 ngrok.exe 程序：
   - 按 `Ctrl + Shift + Esc` 開啟工作管理員
   - 找到 `ngrok.exe`，點擊「結束工作」
3. 重新執行步驟 4

---

### 問題 3：n8n Webhook 仍顯示 localhost

**原因**：Docker 容器啟動時未正確設定 `WEBHOOK_URL` 環境變數。

**解決方法**：

1. 在 PowerShell 中停止並移除現有容器：
```powershell
docker stop n8n
docker rm n8n
```

2. 使用正確的環境變數重新啟動（請替換 `<你的網址>`）：
```powershell
docker run -d `
  --name n8n `
  --restart always `
  -p 5678:5678 `
  -e WEBHOOK_URL="https://<你的網址>" `
  -e GENERIC_TIMEZONE="Asia/Taipei" `
  -v n8n_data:/home/node/.n8n `
  docker.n8n.io/n8nio/n8n
```

> 💡 **注意**：PowerShell 使用 `` ` `` （backtick）作為換行符號，而非 `\`。

---

### 問題 4：無法透過網址訪問 n8n

**檢查清單**：

1. ✅ ngrok 視窗是否仍在運行？
   - 檢查終端機視窗是否顯示 "Session Status: online"

2. ✅ Docker Desktop 是否正在運行？
   - 檢查系統匣是否有 Docker 圖示

3. ✅ n8n 容器是否正在運行？
   ```powershell
   docker ps
   ```
   應該看到 n8n 容器的狀態為 `Up`。

4. ✅ 本地 5678 port 是否可以訪問？
   - 在瀏覽器開啟：`http://localhost:5678`
   - 應該可以看到 n8n 畫面

---

## 💡 實用技巧

### 讓 ngrok 在背景執行（進階）

如果不想讓 ngrok 視窗一直開著，可以使用以下方式：

#### 選項 1：使用 Windows 服務（推薦）

參考 [ngrok 官方文件](https://ngrok.com/docs/using-ngrok-with/windows/) 設定為 Windows 服務。

#### 選項 2：使用啟動資料夾

將啟動 ngrok 的批次檔加入 Windows 啟動資料夾，讓電腦開機時自動執行。

### 監控 ngrok 連線狀況

ngrok 提供了一個本地 Web 介面，可以查看即時的請求資訊：

```
http://127.0.0.1:4040
```

在瀏覽器開啟此網址，可以看到所有通過 ngrok 的 HTTP 請求記錄。

---

**🎉 恭喜！您的 Windows n8n 伺服器已成功設定 ngrok，可以接收外部 Webhook 和使用 OAuth 整合了！**

