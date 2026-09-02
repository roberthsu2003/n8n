# 🚀 n8n + ngrok 容器化整合安裝指南 (最推薦方案)

本目錄提供透過 **Docker Compose** 同時運行 **n8n** 與 **ngrok** 雙容器的一站式解決方案。只需設定好環境變數並執行啟動腳本，即可快速取得固定的外部 HTTPS 網址，無痛接收 LINE Bot、Google/Notion OAuth 等外部 Webhook 請求。

---

## 🌟 為什麼強烈推薦此方案？

| 比較維度 | 傳統方式 (本機安裝 ngrok + 獨立 n8n 容器) | 容器化整合方案 (Docker Compose) 🏆 |
| :--- | :--- | :--- |
| **Windows 防毒相容性** | ❌ **極易被誤判**：Windows Defender 常將本機 `ngrok.exe` 誤判定為木馬或病毒而遭隔離/攔截。 | ✅ **完美避開誤判**：ngrok 運行在 Docker 隔離環境中，完全不觸發 Windows 安全性攔截。 |
| **環境乾淨度** | ❌ 電腦需安裝多種命令列套件與管理工具 (winget/scoop/brew)。 | ✅ 電腦僅需安裝 Docker Desktop，其餘全在容器內部管理，乾淨好維護。 |
| **啟動與停止** | ❌ 需分別開兩個終端機視窗，分開啟動與關閉 n8n 與 ngrok。 | ✅ 雙擊執行 `up.bat` / `./up.sh` 一鍵雙啟；`down.bat` / `./down.sh` 一鍵關閉。 |
| **網域與變數綁定** | ❌ 每次重啟若忘記指定網域，Webhook 網址變動需至後台全部重新設定。 | ✅ 透過 `.env` 綁定靜態固定網域 (Static Domain)，開機永不失效。 |

---

## 🏗️ 運作架構原理

ngrok 容器與 n8n 容器處於同一個 Docker 內部虛擬網路中，外部請求由 ngrok 安全穿透後直接轉發至 n8n：

```
🌐 LINE / Google / Notion (外部雲端)
              │
              ▼ HTTPS
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃  ngrok 官方雲端伺服器 (https://你的網域.ngrok-free.dev) ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
              │
              ▼ 安全通道 (Secure Tunnel)
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃  本機 Docker 虛擬網路                             ┃
 ┃                                                ┃
 ┃   ┌──────────────┐          ┌──────────────┐   ┃
 ┃   │ ngrok 容器   │ ──(內部)──▶ │ n8n 容器     │   ┃
 ┃   │ (Port 穿透)  │          │ (Port: 5678) │   ┃
 ┃   └──────────────┘          └──────────────┘   ┃
 ┃                                    ▲           ┃
 ┃                                    │           ┃
 ┃                             持久化儲存 (Volume)  ┃
 ┃                                    │           ┃
 ┃                             ┌──────────────┐   ┃
 ┃                             │   n8n_data   │   ┃
 ┃                             └──────────────┘   ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
              ▲
              │ 瀏覽器管理介面 (http://localhost:5678)
 💻 本機開發者電腦 (Windows / macOS)
```

---

## 📑 選擇您的作業系統進行安裝

請依據您的電腦作業系統點選下方對應的完整圖文教學：

- 🪟 **[Windows 安裝教學與腳本配置](./n8n-ngrok-windows.md)**  
  *(包含 Docker Desktop 檢查、`.env`、`compose.yaml`、`up.bat`、`down.bat` 一鍵批次檔設定與常見問題排除)*

- 🍎 **[macOS 安裝教學與腳本配置](./n8n-ngrok-mac.md)**  
  *(包含 Apple Silicon / Intel 辨識、`.env`、`compose.yaml`、`up.sh`、`down.sh` 終端腳本權限與開機管理)*

---

## 📁 專案檔案結構一覽

依照教學建立完成後，您的專案資料夾結構將如下：

```
n8n-ngrok/
├── compose.yaml          # Docker Compose 核心編排設定檔
├── .env                  # 環境變數設定檔（放置 Authtoken 與固定網域）
├── up.bat (或 up.sh)     # 一鍵啟動腳本
└── down.bat (或 down.sh) # 一鍵安全停止腳本
```

---

## ⚠️ 重要備註：使用備份 Volume 還原時必加環境變數

如果您是匯入或使用已備份的 `n8n_data` Volume（例如從 Docker Desktop 匯入的備份檔），請務必在 `.env` 中加入 **`N8N_ENCRYPTION_KEY`**：

```env
# 若使用備份 Volume 還原，請務必填入與備份環境完全相同的加密金鑰：
N8N_ENCRYPTION_KEY=11FpZn6tsYW+C+Ui+CKF6nc2iOcEtYBT
```
> 💡 **為什麼需要？** n8n 資料庫中所有已儲存的 API Key、Token 與連線密碼都是透過此金鑰加密，若未設定或金鑰不符，還原後所有憑證將無法解密使用。詳細說明請見 [n8n的備份方式](../n8n的備份方式/README.md)。

---

## 🔗 相關章節與後續設定
- 🐳 **若尚未安裝 Docker**：[Docker 安裝指南](../docker安裝/README.md)
- 💾 **資料備份與還原**：[n8n 資料備份與還原指南](../n8n的備份方式/README.md)
- 🔑 **外部服務整合**：[LINE Messaging API 設定](../line設定/README.md) ｜ [Google Cloud Platform 設定](../google_cloud設定/README.md)
- 🤖 **AI Agent 協作**：[n8n MCP 協議設定指南](../n8n_mcp/README.md)