# 第一章：n8n 安裝與備份

![](./images/n8n容器透視圖.png)

## 目錄

- [1.1 n8n 安裝與公開網址設定（ngrok）](#11-n8n-安裝與公開網址設定ngrok)
- [1.2 n8n 備份與還原方式](#12-n8n-備份與還原方式-)
- [1.3 n8n 軟體更新（升級至最新版）](#13-n8n-軟體更新升級至最新版)
- [1.4 忘記登入密碼 / 完整重置系統](#14-忘記登入密碼--完整重置系統-)

---

## 1.1 n8n 安裝與公開網址設定（ngrok）

為了讓 n8n 能夠發揮完整功能（例如：接收 LINE Bot 等外部 Webhook、進行 Google / Notion OAuth 2.0 整合授權、以及使用 n8n MCP 讓 AI 協同控制工作流），**n8n 必須具備一組公開的 HTTPS 網址**。

本教學採用 **ngrok** 建立安全快速的公開通道，無論安裝於本機電腦（macOS / Windows）或遠端裝置（Raspberry Pi / Linux）皆適用。

#### 前置需求
- 已安裝 Docker Desktop 或 Docker Engine
- 需要註冊 ngrok 帳號（免費版即可）

---

#### 第一階段：安裝 ngrok 並啟動通道取得網址

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
  - **Windows**（優先使用 Windows Store / winget，若無法使用才改用 Scoop；**⚠️ 注意：兩者請二選一，切勿同時安裝**）：
    - **方法一（首選：Windows Store / winget）**：
      開啟 PowerShell 執行：
      ```powershell
      winget install ngrok
      ```
      *（或直接開啟 Microsoft Store 應用程式搜尋 `ngrok` 安裝）*
    - **方法二（備選：若 Store / winget 無法安裝，改用 Scoop）**：
      在 PowerShell 執行：
      ```powershell
      # 1. 若尚未安裝 Scoop，先在 PowerShell 執行安裝 Scoop
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
      Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

      # 2. 透過 Scoop 安裝 ngrok
      scoop install ngrok
      ```
  - **Linux / Raspberry Pi**（使用 Apt 安裝）：
    ```bash
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
      sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
      echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
      sudo tee /etc/apt/sources.list.d/ngrok.list && \
      sudo apt update && sudo apt install ngrok
    ```

**步驟 3：綁定專屬 Authtoken (Add your authtoken)**
- 在 **Setup & Installation** 頁面的第 2 步（或左側選單 **Your Authtoken**），直接複製指令並於終端機執行：
  ```bash
  ngrok config add-authtoken <您的Authtoken>
  ```

**步驟 4：啟動 ngrok 並取得專屬公開網址** ⭐️
- 在終端機直接輸入以下指令啟動通道：
  ```bash
  ngrok http 5678
  ```
- 啟動後，終端機會直接顯示所有連線資訊面板（包含帳號、狀態與固定網址）：
  ```text
  Session Status                online
  Account                       your-name@gmail.com (Plan: Free)
  Web Interface                 http://127.0.0.1:4040
  Forwarding                    https://xxxx-xxxx.ngrok-free.dev -> http://localhost:5678
  ```
- **請複製 `Forwarding` 欄位中的 HTTPS 網址**（例如：`https://xxxx-xxxx.ngrok-free.dev`），接下來啟動 n8n 容器時會使用此網址！
- ⚠️ **請保持此終端機視窗開啟**，不要關閉它（關閉則通道中斷）。若需執行後續指令，請另外開啟新的終端機視窗。

---

#### 第二階段：安裝 n8n 並設定

**步驟 1：建立資料卷**

```bash
docker volume create n8n_data
```

**步驟 2：啟動 n8n 容器**

> ⚠️ **指令語法關鍵注意事項（避免語法報錯）**：
> 1. **請勿保留 `<>` 符號**：請直接將範例中的網址替換為您從 ngrok 取得的真實網址（例如 `abcd-1234.ngrok-free.dev`）。
> 2. **`=` 符號左右不可有空格**：例如 `-e N8N_PORT=5678`，寫成 `-e N8N_PORT = 5678` 會導致容器啟動失敗。
> 3. **每行結尾反斜線 `\` 前方需有空格**：換行反斜線 `\` 前請保留一個空格，且 `\` 之後不可有任何空格或字元。
> 4. **網址格式區分**：`N8N_HOST` **不加** `https://`；而 `N8N_EDITOR_BASE_URL` 與 `WEBHOOK_URL` **必須包含** `https://`。

請依據您的作業系統選擇對應的啟動指令：

##### 💻 macOS / Windows（Docker Desktop）
```bash
docker run -d \
  --name n8n \
  --restart always \
  -p 5678:5678 \
  -e N8N_HOST=abcd-1234.ngrok-free.dev \
  -e N8N_PROTOCOL=https \
  -e N8N_PORT=5678 \
  -e N8N_EDITOR_BASE_URL=https://abcd-1234.ngrok-free.dev \
  -e WEBHOOK_URL=https://abcd-1234.ngrok-free.dev \
  -e GENERIC_TIMEZONE=Asia/Taipei \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

##### 🍓 Raspberry Pi / Linux（原生 Docker Engine）
```bash
docker run -d \
  --name n8n \
  --restart always \
  --add-host=host.docker.internal:host-gateway \
  -p 5678:5678 \
  -e N8N_HOST=abcd-1234.ngrok-free.dev \
  -e N8N_PROTOCOL=https \
  -e N8N_PORT=5678 \
  -e N8N_EDITOR_BASE_URL=https://abcd-1234.ngrok-free.dev \
  -e WEBHOOK_URL=https://abcd-1234.ngrok-free.dev \
  -e GENERIC_TIMEZONE=Asia/Taipei \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

> 💡 **為什麼 Raspberry Pi / Linux 需要額外加上 `--add-host`？**
> - **macOS / Windows (Docker Desktop)**：自帶虛擬化網路路由，預設就支援透過 `host.docker.internal` 連線到本機 Host。
> - **Raspberry Pi / Linux (Docker Engine)**：原生 Linux Docker 預設不會解析 `host.docker.internal`。加入 `--add-host=host.docker.internal:host-gateway` 會在容器內部的 hosts 設定中將主機網關（通常為 `172.17.0.1`）指向 `host.docker.internal`，如此一來 n8n 容器內的工作流才能連線到樹莓派本機執行的服務（如 MQTT Broker、資料庫或本地 API）。

![](./images/本機安裝概念圖_ngrok.png)

---

#### 重要說明

- **連接本機服務**：若需要在 n8n 工作流程中連接本機電腦的服務（如本地 API、資料庫、MQTT 等），請使用 `host.docker.internal` 作為主機名稱
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

---

## 1.3 n8n 軟體更新（升級至最新版）🔄

當 n8n 發布新版本時，只需更新 Docker 映像檔並重新建立容器即可完成升級：

> 💡 **資料安全保證**：工作流程、憑證等所有設定均保存在 `n8n_data` 資料卷中，刪除容器與映像檔**不會遺失任何資料**。

**步驟 1：停止並刪除現有容器**
```bash
docker stop n8n
docker rm n8n
```

**步驟 2：刪除舊映像檔並拉取最新版本**
```bash
# 刪除舊的 n8n 映像檔
docker rmi docker.n8n.io/n8nio/n8n

# 下載最新版映像檔
docker pull docker.n8n.io/n8nio/n8n
```

**步驟 3：重新啟動 n8n 容器**
執行您原本使用的 `docker run` 指令（帶入相同的環境變數與 `-v n8n_data:/home/node/.n8n` 資料卷）即可完成升級！

---

## 1.4 忘記登入密碼 / 完整重置系統 ⚠️

若您忘記了 n8n 管理員帳號或密碼，需透過刪除資料卷來重置系統：

> 🚨 **警告**：刪除 `n8n_data` 資料卷會**徹底清空所有現存的工作流程、帳號與 API 憑證**！若有重要資料請確保事先已有備份。

**步驟 1：停止並刪除 n8n 容器**
```bash
docker stop n8n
docker rm n8n
```

**步驟 2：刪除現有的資料卷 (Volume)**
```bash
docker volume rm n8n_data
```

**步驟 3：重新建立資料卷**
```bash
docker volume create n8n_data
```

**步驟 4：重新啟動 n8n 容器**
執行原本的 `docker run` 指令重新啟動容器，啟動後開啟瀏覽器即可看到初始註冊畫面，重新建立全新的帳號與密碼。
