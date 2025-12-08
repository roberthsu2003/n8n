# Raspberry Pi + n8n + ngrok 固定網址架設指南

這份指南將協助你在 Raspberry Pi 上架設 n8n 自動化伺服器，並透過 ngrok 取得一個「永久固定」的對外網址。這對於連接 LINE Bot 或 Google OAuth 是必要的步驟。

## 📝 準備工作 (筆記區)

在開始之前，請確保你已經準備好以下資訊。請在操作過程中將你的專屬資訊填寫在此處：

- **我的 ngrok 帳號 (Email):** `__________________________`
- **我的 ngrok Authtoken:** `__________________________`
- **我的固定網址 (Static Domain):** `__________________________` *(例如: poodle-calm-roughly.ngrok-free.app)*

## 第一階段：申請固定網址 (電腦操作)

請在你的 Mac 或 Windows 電腦瀏覽器上操作。

1. **註冊/登入 ngrok**
    - 前往 [dashboard.ngrok.com/signup](https://dashboard.ngrok.com/signup)
    - 建議直接使用 **Google 帳號登入**。
1. **領取免費固定網址** ⭐️ (重要步驟)
    - 登入後，點選左側選單的 **Universal Gateway** (通用網關) > **Domains**。
    - 點擊畫面中間的 **「+ Create Domain」** 按鈕。
    - 系統會自動配發一個網址給你。
    - **請將這個網址抄寫到上方的筆記區。**
1. **取得身分驗證碼 (Authtoken)**
    - 點選左側選單的 **Getting Started** > **Your Authtoken**。
    - 複製那串以 `2...` 開頭的長代碼。
    - **請將 Token 抄寫或暫存起來。**

## 第二階段：安裝與設定 (Raspberry Pi 操作)

請開啟終端機 (Terminal)，透過 SSH 連線進入你的 Raspberry Pi。

### 步驟 1：安裝 ngrok

複製並執行以下指令 (這會自動下載並安裝 ngrok)：

```other
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
```

### 步驟 2：綁定帳號

將你的 Authtoken 告訴 Raspberry Pi： *(請將 `<你的_TOKEN>` 換成筆記區那一長串代碼)*

```other
ngrok config add-authtoken <你的_TOKEN>
```

### 步驟 3：啟動固定網址隧道

這會讓 ngrok 在背景執行，並將流量導向 Port 5678。 *(請將 `<你的網址>` 換成筆記區的網址，**不需要**加 http://)*

> 範例：`ngrok http 5678 --domain=poodle-calm.ngrok-free.app > /dev/null &`

```other
ngrok http 5678 --domain=<你的網址> > /dev/null &
```

**如何檢查是否成功？** 在你的電腦瀏覽器輸入 `https://<你的網址>`。如果出現 "502 Bad Gateway" 或 n8n 畫面，代表隧道已經打通了！(502 是正常的，因為我們還沒開 n8n)。

## 第三階段：啟動 n8n Docker (最後一步)

現在我們要啟動 n8n，並明確告訴它我們的對外網址是剛剛申請的那個。

### 步驟 1：移除舊容器 (如果有)

```other
docker rm -f n8n
```

### 步驟 2：啟動新容器

請務必修改下方指令中的 `<你的網址>`。

```other
docker run -d \
  --name n8n \
  --restart always \
  -p 5678:5678 \
  -e WEBHOOK_URL="https://<你的網址>" \
  -v n8n_data:/home/node/.n8n \
  n8nio/n8n
```

## ✅ 驗收與測試

1. **打開瀏覽器**：輸入 `https://<你的網址>`。
2. **確認畫面**：你應該會看到 n8n 的設定畫面或登入畫面。
3. **檢查 Webhook**：
    - 進入 n8n 建立一個 Workflow。
    - 新增一個 **Webhook 節點**。
    - 打開節點設定，檢查 **Webhook URL** 是否顯示為 `https://<你的網址>/...` 而不是 `localhost`。

**恭喜！你的 n8n 伺服器已經準備好接收 LINE Bot 與 Google OAuth 的連線了。**

## 💡 常見問題排除 (Troubleshooting)

- **錯誤：`The tunnel ... is already bound to another session`**
    - **原因**：你可能重複執行了 ngrok 指令。
    - **解法**：執行 `pkill ngrok` 關閉所有程序，然後再執行一次步驟 3。
- **錯誤：n8n 裡的網址還是 localhost**
    - **原因**：Docker 啟動指令中的 `WEBHOOK_URL` 沒設定好。
    - **解法**：請檢查 Docker 指令網址是否有加 `https://`，並重新執行第三階段。

## 📘 附錄：Markdown 筆記語法速查

如果您要在筆記軟體中編輯此文件，這些是常用的語法：

- **標題**：使用 `#` (大標題), `##` (次標題)
- **粗體**：使用 `**文字**`
- **程式碼區塊**：使用三個反引號 ````` 包裹程式碼
- **清單**：使用 `*` 或 `1.` 開頭
- **引用/備註**：使用 `>` 開頭