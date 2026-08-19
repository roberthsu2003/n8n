# 第一章：n8n 安裝與備份

![](./images/n8n容器透視圖.png)

## 目錄

- [1.1 安裝方式](#11-安裝方式)
- [1.2 n8n 備份與還原方式](#12-n8n-備份與還原方式)

---

## 1.1 安裝方式

根據您的使用需求，我們提供三種不同的安裝方式。請先參考下方的**使用情境選擇指南**，選擇最適合您的安裝方式。

### 📋 使用情境選擇指南

選擇適合您的安裝方式：

| 情境 | 適用安裝方式 | 說明 |
|------|------------|------|
| **只在本機使用**<br>不需要外部服務連接 | [方式一](#方式一本機安裝-localhost) | 最簡單的安裝方式，適合測試和學習 |
| **跨電腦訪問**<br>例如：Mac 訪問 Raspberry Pi 上的 n8n | [方式二](#方式二ssh-tunnel-安裝) | 透過 SSH Tunnel 安全連接，不需公開網址 |
| **需要外部服務整合**<br>例如：LINE Bot、Google OAuth、Webhook | [方式三](#方式三ngrok-公開網址安裝) | 使用 ngrok 建立公開網址，支援完整功能 |

---

### 方式一：本機安裝 (localhost)

#### 🎯 適用情境
- 只在同一台電腦上使用 n8n
- 不需要接收外部 Webhook
- 適合學習和測試

#### 前置需求
- 已安裝 Docker Desktop 或 Docker Engine
- 確保 Docker 服務正在運行

#### 安裝步驟

**步驟 1：建立資料卷**（用於持久化儲存 n8n 的設定和資料）

```bash
docker volume create n8n_data
```

**步驟 2：啟動 n8n 容器**

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e GENERIC_TIMEZONE="Asia/Taipei" \
  docker.n8n.io/n8nio/n8n
```

**步驟 3：訪問 n8n**

在瀏覽器中開啟：`http://localhost:5678`

![](./images/本機安裝概念圖.png)

---

### 方式二：SSH Tunnel 安裝

#### 🎯 適用情境
- n8n 安裝在另一台電腦上（例如：Raspberry Pi）
- 需要從本機電腦（Mac/Windows）訪問遠端的 n8n
- 不需要公開網址，只需內網訪問
- 需要使用 Google OAuth 等服務（因為這些服務要求 localhost 或 HTTPS）

#### 前置需求
- 遠端電腦已安裝 Docker
- 本機電腦可透過 SSH 連接遠端電腦
- 知道遠端電腦的 IP 位址

#### 安裝步驟

**步驟 1：在遠端電腦上建立資料卷**

```bash
docker volume create n8n_data
```

**步驟 2：在遠端電腦上啟動 n8n 容器**

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e GENERIC_TIMEZONE="Asia/Taipei" \
  -e N8N_SECURE_COOKIE=false \
  docker.n8n.io/n8nio/n8n
```

**步驟 3：在本機電腦建立 SSH Tunnel**

> ⚠️ **為什麼需要 SSH Tunnel？**
> 
> Google API 等服務通常不允許 `http://` 開頭的內部 IP 位址（如 `http://192.168.x.x:5678`）作為「已授權的重新導向 URI」，除非是 `localhost`。
> 
> 透過 SSH Tunnel，我們可以將本機的 `localhost:5678` 映射到遠端電腦的 n8n 服務，這樣就能以 `http://localhost:5678` 的形式訪問，滿足 OAuth 的要求。

在本機電腦執行以下指令：

```bash
# 語法：ssh -L <本地Port>:localhost:<遠端Port> <使用者>@<遠端IP>
ssh -L 5678:localhost:5678 pi@192.168.1.100
```

**步驟 4：訪問 n8n**

保持 SSH 連線不中斷，在本機瀏覽器中開啟：`http://localhost:5678`

---

### 方式三：ngrok 公開網址安裝

#### 🎯 適用情境
- 需要接收外部服務的 Webhook（例如：LINE Bot、GitHub Webhook）
- 需要使用 OAuth 2.0 整合第三方服務（例如：Google、Notion）
- 想要使用 **n8n MCP** 的功能 (讓 AI 能夠搜尋、執行、檢查您的工作流程)
- 需要在任何地方訪問你的 n8n
- n8n 可安裝在本機或遠端電腦（Raspberry Pi）

#### 前置需求
- 已安裝 Docker Desktop 或 Docker Engine
- 需要註冊 ngrok 帳號（免費版即可）

---

#### 第一階段：安裝 ngrok 與申請固定網址

##### 📝 準備工作（筆記區）

請在操作過程中將您的專屬資訊填寫在此處：

- **我的 ngrok 帳號 (Email):** `__________________________`
- **我的 ngrok Authtoken:** `__________________________`
- **我的固定網址 (Static Domain):** `__________________________` *(例如: xxx.ngrok-free.app 或 xxx.ngrok-free.dev)*

##### 操作步驟

ngrok 登入後的 **Setup & Installation** 提供了完整的引導流程，請依序完成以下 4 個步驟：

**步驟 1：註冊 / 登入 ngrok**
- 前往 [dashboard.ngrok.com](https://dashboard.ngrok.com/)。
- 推薦直接點選 **「Continue with Google」/ Google 帳號快速登入**。

**步驟 2：安裝 ngrok 應用程式 (Install the ngrok agent)**
- 登入後，點選左側選單 **Getting Started** > **Setup & Installation**。
- 系統會自動偵測您的作業系統，並提供安裝指令：
  - **macOS**（推薦使用 Homebrew 安裝）：
    ```bash
    brew install ngrok
    ```
  - **Windows**（推薦使用 PowerShell 透過 Scoop 安裝）：
    ```powershell
    # 1. 若尚未安裝 Scoop，先在 PowerShell 執行安裝 Scoop
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

    # 2. 透過 Scoop 安裝 ngrok
    scoop install ngrok
    ```
  - **Raspberry Pi / 其他方式**：請參考 [👉 各平台詳細安裝教學](./ngrok各平台設定教學.md)。

**步驟 3：綁定專屬 Authtoken (Add your authtoken)**
- 在 **Setup & Installation** 頁面的第 2 步（或左側選單 **Your Authtoken**），可直接一鍵複製已包含您專屬 Token 的指令並於終端機執行：
  ```bash
  ngrok config add-authtoken <您的Authtoken>
  ```

**步驟 4：取得免費固定網址 (Your dev domain) 並啟動** ⭐️
- 在頁面的第 3 & 4 步，會看到系統為您配發的專屬開發固定網址（例如：`https://xxx.ngrok-free.dev`）。
- **請將這個網址抄寫到上方的筆記區。**
- ⚠️ **關鍵注意（必改 Port 5678）**：
  ngrok 官方預設範例為連接 80 埠號，但因為 **n8n 的預設服務埠號 (Port) 是 5678**，所以在啟動通道時，您**必須將 port 改為 5678**：
  ```bash
  ngrok http 5678 --domain=<您的固定網址>
  # 或最新格式：
  # ngrok http --url=<您的固定網址> 5678
  ```

---

#### 第二階段：安裝 n8n 並設定

**步驟 1：建立資料卷**

```bash
docker volume create n8n_data
```

**步驟 2：啟動 n8n 容器**

⚠️ **請務必將 `<你的網址>` 替換為您在 ngrok 申請的固定網址**

```bash
docker run -d \
  --name n8n \
  --restart always \
  -p 5678:5678 \
  -e N8N_HOST=<abcd-1234.ngrok-free.app> \
  -e N8N_PROTOCOL=https \
  -e N8N_PORT=5678 \
  -e N8N_EDITOR_BASE_URL=<https://abcd-1234.ngrok-free.app> \
  -e WEBHOOK_URL=<https://abcd-1234.ngrok-free.app> \
  -e GENERIC_TIMEZONE=Asia/Taipei \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

**步驟 3：設定 ngrok tunnel**

請參考專屬的跨平台教學，在您的系統上完成安裝、帳號綁定並啟動通道：

👉 [**ngrok 各平台（Mac / Windows / Raspberry Pi）設定教學**](./ngrok各平台設定教學.md)

![](./images/本機安裝概念圖_ngrok.png)

---

<details>
<summary>📂 <b>方式四：GoDaddy 申請正式網域與 Cloudflare Tunnel (暫停使用 - 點擊展開)</b></summary>

##### 申請流程
1. 登入 Godaddy 申請正式網址（建議申請 1 年最便宜的，每年重新申請）。
2. 登入 Cloudflare 註冊免費帳號，將申請的正式網址加入 Cloudflare。
3. 取得 Cloudflare 的 2 組 Name Servers。
4. 登入 Godaddy 帳戶，進入網域設定將原有的 Name Servers 改為 Cloudflare 的 2 組 Name Servers。

##### 驗證方式
1. 登入 Godaddy 帳戶查看 Name Servers 是否已成功替換。
2. 登入 Cloudflare 帳戶查看該網域狀態是否為使用中。

##### 終端機指令驗證方式
- 查詢 DNS Server 狀態：
  ```bash
  dig ns <你的網域> @8.8.8.8
  dig ns <你的網域> @1.1.1.1
  ```

##### 設定 Cloudflare Tunnel
1. 進入 [one.dash.cloudflare.com](https://one.dash.cloudflare.com/)
2. 點選 **Access** > **Tunnels** > **Create a tunnel**

##### 本機安裝與啟動 Tunnel 連接器
- 安裝連接器：
  ```bash
  brew install cloudflared
  ```
- 啟動 Tunnel：
  ```bash
  cloudflared tunnel run --token <你的token>
  ```
- 驗證 Tunnel 狀態：
  ```bash
  cloudflared tunnel list
  ```

</details>

#### 重要說明

- **連接本機服務**：若需要在 n8n 工作流程中連接本機電腦的服務（如本地 API、資料庫等），請使用 `host.docker.internal` 作為主機名稱
  - 例如：`http://host.docker.internal:8080/api`
- **時區設定**：已設定為 `Asia/Taipei`，確保工作流程的時間戳記正確
- **資料持久化**：使用 `n8n_data` 卷儲存所有設定，即使容器重新啟動也不會遺失資料

#### 驗證安裝

執行以下命令檢查容器是否正常運行：

```bash
docker ps | grep n8n
```

應該會看到 n8n 容器在運行中。

---

## 1.2 n8n 備份與還原方式 💾

當您完成 n8n 安裝與設定後，為了確保資料安全，請務必了解如何定期備份您的工作流與資料庫。

👉 請前往參考專屬教學章節：[**n8n的備份方式**](../n8n的備份方式/README.md)
