# 部署 n8n 的「免費」資源指南

n8n 提供了強大的**社區版 (Community Edition)**，這意味著軟體本身是開源且免費的，只要您選擇**自託管 (Self-Hosting)**，就能免費使用核心功能。

---

## 🚀 推薦的首選方案 (Best Options)

### 1. 💻 本地端部署 (Localhost targeting Desktop)

最適合：**開發、測試、學習、教學錄影**。

*   **資源**：利用您的桌上型電腦。
*   **部署方式**：
    *   **Docker Desktop (:recommend: 推薦)**：官方支援度最高，一行指令 `docker run` 即可啟動。
    *   **npm**：透過 Node.js 快速安裝 (`npm install -g n8n`)。
*   **✅ 優點**：
    *   **零成本**：無需申請任何帳號或主機。
    *   **極致效能**：現代電腦的處理速度遠勝免費雲端主機。
    *   **隱私安全**：資料完全只存在您的電腦中。
*   **⚠️ 缺點**：
    *   **非 7x24 小時**：電腦關機，自動化流程即停止。
    *   **外部連線限制**：外部服務 (Webhook) 預設無法連入。需搭配 [ngrok](https://ngrok.com) 或 [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/) 進行內網穿透。

### 2. 🏠 家用伺服器 (Home Server targeting Raspberry Pi)

最適合：**長期運用、個人自動化助理、智能家居整合**。

*   **資源**：Raspberry Pi (樹莓派) 系列。
*   **部署方式**：
    *   **Docker (:recommend: 推薦)**：支援 ARM64 架構，部署穩定且易於升級。
*   **✅ 優點**：
    *   **7x24 小時待命**：低功耗，全天候運作您的自動化腳本。
    *   **資料掌控權**：所有數據皆保留在家中，不經過第三方雲端。
*   **⚠️ 缺點與解法**：
    *   **外部連線**：需解決外網連入問題（Public IP）。
        *   *傳統解法*：設定 DDNS (動態域名) + Router Port Forwarding。
        *   *:bulb: 現代解法*：直接使用 **ngrok** 或 **Cloudflare Tunnel**，無需更動路由器設定即可安全連線。
    *   **硬體效能**：受限於板載 RAM/CPU，處理大量並發任務時可能較慢。

---

## ☁️ 雲端「永久免費」方案 (Always Free Cloud Tiers)

如果您需要公開 IP 且不想維護硬體，可考慮雲端方案，但需注意限制。

### 3. ☁️ Oracle Cloud (OCI) - Always Free VM

目前公認**最慷慨**的免費方案。

*   **資源**：Oracle Cloud Infrastructure 提供的 ARM Ampere A1 Compute。
*   **規格**：最高可達 4 OCPU, 24GB RAM (視區域庫存而定)。
*   **✅ 優點**：
    *   **企業級效能**：資源給得非常大方，甚至勝過許多付費 VPS。
    *   **固定公網 IP**：Webhook 設定最直覺方便。
*   **⚠️ 缺點**：
    *   **設定門檻高**：需具備 Linux、SSH key、VCN (虛擬網路)、防火牆設定等知識。
    *   **帳號審核**：註冊時信用卡驗證較嚴格，部分區域資源可能缺貨。

### 4. 🚀 平台即服務 (PaaS) - Render / Hugging Face

最適合：**短期 Demo、輕量級測試、公開展示**。

*   **資源**：Render Free Tier 或 Hugging Face Spaces (Docker)。
*   **✅ 優點**：
    *   **部署簡單**：通常連動 GitHub 即可自動部署。
    *   **SSL 憑證**：自動處理 HTTPS。
*   **⛔️ 致命限制 (Critical Warnings)**：
    *   **休眠機制 (Spin Down)**：閒置 (如 15 分鐘) 後會自動休眠。喚醒需要時間，極易導致 Webhook 請求逾時 (Timeout)。
    *   **❌ 資料遺失 (Data Persistence)**：這是最嚴重的問題。免費容器通常使用 **Ephemeral Filesystem (暫存檔案系統)**。
        *   **後果**：當服務重啟、休眠喚醒或重新部署時，**所有建立的工作流 (Workflows) 和帳號設定都會被清空歸零**。
        *   **解法**：必須自行串接外部資料庫 (如外掛 PostgreSQL)，但這會大幅增加免費部署的複雜度。

---

## 📊 綜合比較表

| 方案 | 適合情境 | 7x24 運作 | 外部連線難易 | 資料保存 |
| :--- | :--- | :--- | :--- | :--- |
| **Desktop (Local)** | 學習、測試 | ❌ (關機即停) | 需穿透 (ngrok) | ✅ 本機硬碟 |
| **Raspberry Pi** | 個人長期使用 | ✅ 穩定 | 需穿透或設定 | ✅ 本機 SD 卡/SSD |
| **Oracle Cloud** | 進階用戶、高效能 | ✅ 穩定 | ⭐ 容易 (Public IP) | ✅ 雲端硬碟 |
| **Render / PaaS** | 臨時 Demo | ❌ 會休眠 | ⚠️ 易逾時 | ❌ **重啟即消失** |

---

## 💡 給您的建議

1.  **初學者 / 課程錄製**：直接使用 **本機電腦 (`docker run`)**。搭配 ngrok 解決偶爾需要的外部連線，這是阻力最小的路徑。
2.  **個人助理 / 自動化**：將 **Raspberry Pi** 架設起來，使用 Docker + Cloudflare Tunnel。這能兼顧免費、隱私與 7x24 小時運作的需求。