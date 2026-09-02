# 🚀 n8n + Cloudflare Tunnel 容器化整合安裝指南 (生產級方案)

本目錄提供透過 **Docker Compose** 同時運行 **n8n** 與 **Cloudflare Tunnel (`cloudflared`)** 雙容器的一站式解決方案。

透過此方案，只需在 `.env` 設定好您的**專屬自訂網域**與 **Cloudflare Tunnel Token**，即可一鍵啟動具備企業級安全防護、永久固定 HTTPS 網址的 n8n 自動化伺服器，完美支援 LINE Bot、Google / Notion OAuth 2.0 Webhook 回呼！

---

## 🌟 為什麼選擇 n8n + Cloudflare 容器化整合？

| 比較維度 | ngrok 方案 (開發測試推薦) | ☁️ Cloudflare Tunnel 整合方案 (正式生產推薦) 🏆 |
| :--- | :--- | :--- |
| **適用場景** | 開發除錯、本機快速驗證 | **正式營運、長久穩定運作、自動化生產線** |
| **網域型態** | 免費隨機/自訂 ngrok 子網域 | **完全使用您個人的專屬獨立頂級網域**（如 `n8n.yourdomain.com`） |
| **成本與限制** | 免費版流量與連線數有限制 | **免費版無頻寬/連線數嚴格限制**，全球 CDN 加速 |
| **SSL 憑證** | ngrok 提供短期憑證 | **自動享有 Cloudflare 免費 Edge SSL/TLS 憑證** |
| **安全防禦** | 基礎通道加密 | **原生享有 Cloudflare 全球 DDoS 防護與 WAF 安全檢測** |
| **管理便利性** | 單一通道 | 可在同一 Tunnel 下隨意擴充多個子網域與內部服務 |

---

## 🏗️ 運作架構原理

`cloudflared` 與 `n8n` 容器運行在同一個 Docker 內部網路中。`cloudflared` 主動向 Cloudflare 發起安全的加密連線（Outbound），將外部發送至您專屬網域的請求直接轉發給內部 `n8n` 容器：

```
🌐 LINE / Google / 外部使用者 (Internet)
              │
              ▼ HTTPS (https://n8n.你的網域.site)
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃  Cloudflare 全球邊緣網路 (Edge Network + CDN)   ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
              │
              ▼ 安全加密通道 (Outbound Tunnel)
 ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃  本機 / 伺服器 Docker 虛擬網路                   ┃
 ┃                                                ┃
 ┃   ┌──────────────────┐      ┌──────────────┐   ┃
 ┃   │ cloudflared 容器 │ ───▶ │ n8n 容器     │   ┃
 ┃   │ (Cloudflare 通道)│      │ (Port: 5678) │   ┃
 ┃   └──────────────────┘      └──────────────┘   ┃
 ┃                                    ▲           ┃
 ┃                                    │           ┃
 ┃                             持久化儲存 (Volume)  ┃
 ┃                                    │           ┃
 ┃                             ┌──────────────┐   ┃
 ┃                             │   n8n_data   │   ┃
 ┃                             └──────────────┘   ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
              ▲
              │ 本機瀏覽器管理 (http://localhost:5678)
 💻 本機開發者電腦 / 雲端主機
```

---

## 📋 前置作業

在部署前，請確認已完成以下步驟（若尚未完成，請先參考 [Cloudflare Tunnel 圖文設定指南](../cloudflare_tunnel/README.md)）：

1. **已申請個人專屬獨立網域**（例如 `yourdomain.com`），並將 DNS 名稱伺服器託管至 Cloudflare（狀態為「使用中」）。
2. **在 Cloudflare Zero Trust 建立 Tunnel** 並取得 **Tunnel Token**（以 `eyJhIj...` 開頭）。
3. **在 Zero Trust 設定「已發佈應用程式路由」**：
   - 子網域：`n8n`
   - 服務類型：`HTTP`
   - URL：`localhost:5678`（使用 host 網路）或 `n8n:5678`（使用 Docker Compose 內部網路名稱）。

---

## 📁 專案檔案結構一覽

建立一個專屬目錄（例如 `n8n-cloudflare/`），結構如下：

```
n8n-cloudflare/
├── compose.yaml          # Docker Compose 雙容器編排檔
├── .env                  # 環境變數設定檔（填入您的網域與 Token）
├── up.bat (或 up.sh)     # 一鍵啟動腳本
└── down.bat (或 down.sh) # 一鍵停止腳本
```

---

## 🛠️ 快速配置與部署

### 1. 建立 `.env` 環境設定檔

在專案目錄下新增 `.env` 檔案，填入您的網域與 Cloudflare Tunnel Token：

```env
# 您的 n8n 完整公開自訂網域名稱（不加 https:// 與結尾斜線，請替換為您的實際網域）
DOMAIN=n8n.yourdomain.com

# Cloudflare Zero Trust 取得的 Tunnel Token
CLOUDFLARE_TUNNEL_TOKEN=eyJhIjoi...請替換為您的完整Token...

# ⚠️ 若使用備份 Volume (n8n_data) 還原，請務必填入備份環境的加密金鑰：
N8N_ENCRYPTION_KEY=11FpZn6tsYW+C+Ui+CKF6nc2iOcEtYBT
```

---

### 2. 建立 `compose.yaml` 編排檔

在同目錄下新增 `compose.yaml`：

```yaml
services:
  n8n:
    image: docker.n8n.io/n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=${DOMAIN}
      - N8N_PROTOCOL=https
      - N8N_PORT=5678
      - N8N_EDITOR_BASE_URL=https://${DOMAIN}
      - WEBHOOK_URL=https://${DOMAIN}
      - GENERIC_TIMEZONE=Asia/Taipei
      - TZ=Asia/Taipei
      - N8N_RUNNERS_ENABLED=true
      - N8N_DEFAULT_BINARY_DATA_MODE=filesystem
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY:-}
    volumes:
      - n8n_data:/home/node/.n8n

  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: cloudflared
    restart: unless-stopped
    command: tunnel --no-autoupdate run --token ${CLOUDFLARE_TUNNEL_TOKEN}
    network_mode: host
    depends_on:
      - n8n

volumes:
  n8n_data:
    name: n8n_data
```

> 💡 **關鍵說明**：
> - `volumes` 中的 `name: n8n_data` 確保**所有專案皆共用同一個名為 `n8n_data` 的 Volume**，無論日後切換至 ngrok 或單獨 `docker run`，您的 n8n 工作流程與憑證資料都能無縫保留！
> - `cloudflared` 容器使用 `network_mode: host`，可直接連通主機上的 `localhost:5678`，與 Cloudflare 後台設定的 `HTTP://localhost:5678` 完全相符。

---

### 3. 一鍵啟動腳本

#### 🪟 Windows 使用者 (`up.bat` 與 `down.bat`)
- **啟動腳本 `up.bat`**：
  ```bat
  @echo off
  echo 正在啟動 n8n 與 Cloudflare Tunnel 服務...
  docker compose up -d
  echo 啟動完成！請開啟瀏覽器存取 n8n 服務。
  pause
  ```
- **停止腳本 `down.bat`**：
  ```bat
  @echo off
  echo 正在停止服務...
  docker compose down
  echo 服務已安全停止。
  pause
  ```

#### 🍎 macOS / Linux 使用者 (`up.sh` 與 `down.sh`)
- **啟動腳本 `up.sh`**：
  ```bash
  #!/bin/bash
  echo "🚀 正在啟動 n8n 與 Cloudflare Tunnel 服務..."
  docker compose up -d
  echo "✅ 啟動完成！"
  ```
- **停止腳本 `down.sh`**：
  ```bash
  #!/bin/bash
  echo "🛑 正在停止服務..."
  docker compose down
  echo "✅ 服務已停止。"
  ```
  *(記得執行 `chmod +x up.sh down.sh` 給予執行權限)*

---

## 🌐 測試與驗證

1. 執行啟動腳本或終端機執行 `docker compose up -d`。
2. 打開瀏覽器輸入 `https://n8n.你的網域`（例如 `https://n8n.yourdomain.com`）。
3. 確認能順利開啟 n8n 介面，並顯示安全的 **HTTPS 鎖頭** 標誌。
4. 恭喜！您已擁有企業級的個人 n8n 自動化伺服器！

---

## 🔗 相關設定與進階教學
- ☁️ **Cloudflare 詳細圖文指引**：[Cloudflare Tunnel 逐步設定教學](../cloudflare_tunnel/README.md)
- 🔌 **ngrok 整合方案**：[n8n + ngrok 容器化整合指南](../n8n_ngrok/README.md)
- 🔑 **雲端服務授權**：[Google Cloud Platform 設定](../google_cloud設定/README.md) ｜ [LINE Messaging API 設定](../line設定/README.md)
