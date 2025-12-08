# Windows Desktop + n8n + ngrok 固定網址架設指南

這份指南將協助你在 Windows 桌上型電腦上架設 n8n 自動化伺服器，並透過 ngrok 取得一個「永久固定」的對外網址。這對於連接 LINE Bot 或 Google OAuth 是必要的步驟。

## 📝 準備工作 (筆記區)

在開始之前，請確保你已經準備好以下資訊。

- **我的 ngrok 帳號 (Email):** `__________________________`
- **我的 ngrok Authtoken:** `__________________________`
- **我的固定網址 (Static Domain):** `__________________________` *(例如: poodle-calm-roughly.ngrok-free.app)*

## 第一階段：申請固定網址 (網頁操作)

1. **註冊/登入 ngrok**
    - 前往 [dashboard.ngrok.com/signup](https://dashboard.ngrok.com/signup)
    - 建議直接使用 **Google 帳號登入**。
2. **領取免費固定網址** ⭐️ (重要步驟)
    - 登入後，點選左側選單的 **Universal Gateway** (通用網關) > **Domains**。
    - 點擊畫面中間的 **「+ Create Domain」** 按鈕。
    - 系統會自動配發一個網址給你。
    - **請將這個網址抄寫到上方的筆記區。**
3. **取得身分驗證碼 (Authtoken)**
    - 點選左側選單的 **Getting Started** > **Your Authtoken**。
    - 複製那串以 `2...` 開頭的長代碼。
    - **請將 Token 抄寫或暫存起來。**

## 第二階段：安裝與設定 (Windows 操作)

請使用 **PowerShell** 或 **命令提示字元 (CMD)** 進行操作。

### 步驟 1：安裝 ngrok

建議使用 **Chocolatey** 套件管理器安裝 (如果有的話)，或是直接下載官方安裝檔。

**方法 A：使用 Chocolatey (推薦工程師使用)**
```powershell
choco install ngrok
```

**方法 B：手動下載**
1. 前往 [ngrok 下載頁面](https://ngrok.com/download) 下載 Windows 版本。
2. 解壓縮 zip 檔，將 `ngrok.exe` 放在你方便執行的路徑 (例如桌面或專案資料夾)。
3. 在該資料夾點擊右鍵選「在終端機中開啟」。

### 步驟 2：綁定帳號

將你的 Authtoken 告訴 ngrok： *(請將 `<你的_TOKEN>` 換成筆記區那一長串代碼)*

```powershell
ngrok config add-authtoken <你的_TOKEN>
```

### 步驟 3：啟動固定網址隧道

這會讓 ngrok 在背景執行，並將流量導向 Port 5678。 *(請將 `<你的網址>` 換成筆記區的網址，**不需要**加 http://)*

```powershell
ngrok http 5678 --domain=<你的網址>
```

> **注意：** 在 Windows 上執行此指令後，終端機視窗會變成 ngrok 的監控畫面。**請不要關閉這個視窗**，否則連線會中斷。

**如何檢查是否成功？** 在瀏覽器輸入 `https://<你的網址>`。如果出現 "502 Bad Gateway" 或 n8n 畫面，代表隧道已經打通了！(502 是正常的，因為我們還沒開 n8n)。

## 第三階段：啟動 n8n Docker

開啟**另一個** PowerShell 視窗來執行 Docker 指令。

### 步驟 1：移除舊容器 (如果有)

```powershell
docker rm -f n8n
```

### 步驟 2：啟動新容器

請務必修改下方指令中的 `<你的網址>`。

> 提示：PowerShell 的換行符號是倒引號 (`)，與 Linux 的反斜線 (\) 不同。

```powershell
docker run -d `
  --name n8n `
  --restart always `
  -p 5678:5678 `
  -e WEBHOOK_URL="https://<你的網址>" `
  -v n8n_data:/home/node/.n8n `
  docker.n8n.io/n8nio/n8n
```

## ✅ 驗收與測試

1. **打開瀏覽器**：輸入 `https://<你的網址>`。
2. **確認畫面**：你應該會看到 n8n 的設定畫面或登入畫面。
3. **檢查 Webhook**：
    - 進入 n8n 建立一個 Workflow。
    - 新增一個 **Webhook 節點**。
    - 打開節點設定，檢查 **Webhook URL** 是否顯示為 `https://<你的網址>/...` 而不是 `localhost`。

**恭喜！你的 Windows n8n 伺服器已經準備好接收 LINE Bot 與 Google OAuth 的連線了。**
