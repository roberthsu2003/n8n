# n8n Instance-level MCP 連線設定與介面功能指南 (v2.34.6 最新版)

> **適用版本**：`n8n Version 2.34.6` 或更高版本  
> **功能定位**：Instance-level MCP (Preview)  
> **核心目標**：讓外部 AI 助理與 IDE（如 OpenCode、Claude、Cursor 等）透過 **Model Context Protocol (MCP)** 協議安全連線至 n8n 實例，並精細控制開放的工作流程與權限。  
> 💡 **客戶端現況說明**：目前 **Claude.ai** 與 **OpenCode / Cursor** 已完整支援 MCP 直連；**ChatGPT 網頁與桌面版** 目前尚未支援原生 MCP Connector 連線（ChatGPT 需透過瀏覽器擴充套件或自訂 Actions 進行協作）。

---

## 📑 目錄

1. [架構概念與連線流程](#architecture)
2. [n8n 後台介面與所有按鈕功能詳解 (v2.34.6)](#n8n-ui-features)
   - [Connection details（連線設定區）](#connection-details)
   - [Access（存取控制區）](#access-control)
   - [Connected clients（已連線客戶端管理區）](#connected-clients)
3. [Expose（開放）與連線權限的關鍵差異](#expose-vs-permissions)
4. [各 AI 客戶端連線設定教學](#client-setups)
   - [Claude Connector (OAuth 模式)](#claude-connector)
   - [OpenCode 設定檔與常用指令](#opencode-mcp)
   - [Google Antigravity 專案等級 MCP 設定](#antigravity-mcp)
5. [安全規範與推薦操作流程](#security-and-workflow)
6. [課堂實戰範例（附 AI Prompt 提詞）](#practical-examples)

---

<a id="architecture"></a>
## 一、架構概念與連線流程

```text
┌─────────────────────────────────────────────────────────────┐
│             外部 AI 客戶端 / IDE / CLI 工具                  │
│       (OpenCode / Claude Desktop / Cursor / ChatGPT)        │
└──────────────────────────────┬──────────────────────────────┘
                               │ MCP over HTTP / SSE / OAuth
                               ▼ (需公開 HTTPS，如 ngrok)
┌─────────────────────────────────────────────────────────────┐
│                 n8n Instance-level MCP Server               │
│                  (n8n Version 2.34.6)                       │
├──────────────────────────────┬──────────────────────────────┤
│  存取權限控制 (Access Control) │  已開放工作流 (Exposed Workflows)│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│              n8n 核心工作流、節點與自動化執行引擎             │
└─────────────────────────────────────────────────────────────┘
```

* AI 客戶端**不是直接存取 n8n 的底層資料庫**，而是透過 n8n 內建的 MCP Server API 操作工作流程。
* 若 n8n 部署於本機 (Self-hosted)，必須透過 ngrok、Cloudflare Tunnel 或反向代理提供**公開 HTTPS 網址**。

---

<a id="n8n-ui-features"></a>
## 二、n8n 後台介面與所有按鈕功能詳解 (v2.34.6)

### 進入路徑
點擊 n8n 左下角 **Settings（設定）** ➔ 左側選單選擇 **Instance-level MCP**。

---

<a id="connection-details"></a>
### 1. Connection details（連線設定區）

| 介面項目 | 類型 / 狀態標示 | 功能說明與操作指引 |
| :--- | :--- | :--- |
| **MCP status** | 狀態下拉選單<br>`● Enabled ˇ` / `Disabled` | **控制全域 MCP 伺服器的啟用狀態**。<br>• 設為 **Enabled（綠色）** 時，外部 AI（Claude、Cursor、ChatGPT、OpenCode）才能與本 n8n 實例建立 MCP 連線。<br>• 若暫時不希望任何外部 AI 連線，可切換為 **Disabled** 進行快速阻斷。 |
| **Connect your client** | 動作按鈕<br>`[ 🔌 Connect ]` | **開啟用戶端連線引導精靈 (Setup Wizard)**。<br>點擊後會彈出視窗，讓您挑選目標 AI 工具（如 Claude、Cursor、OpenCode、ChatGPT、VS Code），並自動產生專屬的設定步驟、連線資訊：<br>• **OAuth Server URL**（供 Claude 等支援 OAuth 的工具）<br>• **Access Token / HTTP Endpoint**（通常為 `https://<網域>/mcp-server/http`）。 |

---

<a id="access-control"></a>
### 2. Access（存取控制區）

| 介面項目 | 類型 / 狀態標示 | 功能說明與操作指引 |
| :--- | :--- | :--- |
| **Workflows exposed** | 導航按鈕<br>`1 workflow >` (依數量顯示) | **管理開放給 MCP 工具呼叫的工作流程清單**。<br>• 點擊進入工作流程選擇頁面，可直接勾選要開放給 AI 的 Workflow。<br>• **Description**：強烈建議為每個開放的工作流填寫清晰的描述，AI 會依據這段描述在對話中智能判斷何時呼叫該工具。 |
| **Allowed callback URLs** | 安全設定按鈕<br>`All >` / `Custom >` | **限制 OAuth 登入授權的回調（Redirect）網址白名單**。<br>• **All（預設）**：允許所有客戶端重定向網址，方便快速測試，但安全性較寬鬆。<br>• **自訂白名單**：可限定只有特定的客戶端 callback 網址（如 Claude 官方回調網址）才能完成授權，避免未經授權的應用程式發起 OAuth 劫持。 |

---

<a id="connected-clients"></a>
### 3. Connected clients（已連線客戶端管理區）

| 介面項目 | 類型 / 狀態標示 | 功能說明與操作指引 |
| :--- | :--- | :--- |
| **All connected clients** | 列表導航按鈕<br>`View all >`<br>*(顯示目前例如: 2 clients have access)* | **檢視並管理所有已成功連線並取得授權的外部 AI 客戶端**。<br>• 點擊進入可檢視目前有存取權限的應用程式列表（如 OpenCode CLI、Claude Desktop 等）。<br>• 可在此查看個別連線的授權時間，並在需要時執行 **Revoke（撤銷連線）**，立即中止特定客戶端的存取權。 |

---

<a id="expose-vs-permissions"></a>
## 三、Expose（開放）與連線權限的關鍵差異

在 n8n MCP 協作中，這是最核心且容易混淆的概念：

### 1. Expose（工作流程開放）
* 工作流程是否被標記為可作為獨立 MCP Tool 供 AI 執行，在內部資料中通常標記為：
  ```text
  availableInMCP: true
  ```
* 例如後台顯示 **`1 workflow exposed`**，代表明確開放給 AI 呼叫的封裝工具數量為 1 個。

### 2. n8n 連線帳號管理權限 (Management Permissions)
* 當 OpenCode 或 Claude 透過 MCP Token / OAuth 連線時，連線本身如果具有 n8n 實例的管理權限，AI 仍然可以透過管理 API 執行查詢工作流列表、讀取工作流 JSON 結構、修改節點等動作。
* **重點結論**：
  * **「已 Expose」** ＝ AI 可將該工作流當作獨立功能工具直接帶參數觸發。
  * **「管理權限」** ＝ AI 可檢視與維護 n8n 畫布上的工作流程。
  * 兩者層次不同，因此即使只 Expose 1 個工作流，AI 仍可能列出後台全部的 7 個工作流程。

---

<a id="client-setups"></a>
## 四、各 AI 客戶端連線設定教學

<a id="claude-connector"></a>
### 1. Claude.ai Connector (OAuth 模式)

適用於 **Claude.ai** 網頁版或 **Claude Desktop** 應用程式：

1. **取得公開 HTTPS 網址**：
   確保本機已啟動 ngrok 並轉發 n8n 埠號（預設 5678）：
   ```bash
   ngrok http 5678
   ```
2. **開啟 Claude Connectors 介面**：
   * 在 Claude.ai 側邊欄點選 **Customize** ➔ **Connectors**（或 **Settings > Connectors**）。
3. **新增與連線 n8n**：
   * **搜尋連線**：在 Connectors 列表中找到 **n8n**（Type 為 `Web`），或點擊右上角 **`Add ˇ`** ➔ 選擇 **`Browse connectors`** 搜尋 official `n8n` (by n8n GmbH)。
   * 點選 **`Connect`** 按鈕。
   * 輸入 ngrok 產生的 Server URL（例如 `https://<你的ngrok網域>.ngrok-free.app`）。
4. **瀏覽器 OAuth 授權**：
   * 系統會自動開啟 n8n 登入/授權畫面，點擊確認允許連線。
5. **確認連線狀態**：
   * 授權完成後，Claude Connectors 列表中的 n8n 狀態會變更為 **`✓` (已連線)**。
   * 同步可在 n8n 後台 **Settings > Instance-level MCP > Connected clients** 查看到 Claude 已連線。

---

<a id="opencode-mcp"></a>
### 2. OpenCode 設定檔與常用指令

> [!TIP]
> **強烈推薦使用「全域設定 (Global)」（特別是使用 OpenCode Desktop 桌面版時）**：
> - **OpenCode Desktop 用戶**：桌面版在不同工作區或開啟不同資料夾時，會預設讀取全域設定。將 n8n MCP 設在全域可確保在任何專案介面中都能無縫調用。
> - **一次配置、到處可用**：只需設定一次（或執行一次 `opencode mcp add`），免去每個專案重複配置或更新 ngrok 網址的繁瑣步驟，最為省時且不易出錯！

OpenCode 支援 **全域等級 (Global Level)** 與 **專案等級 (Project Level)** 兩種設定方式，配置結構完全相同：

#### A. 設定檔層級說明
* 🌐 **全域等級 (Global Level，⭐ 強烈推薦)**：
  * **設定檔位置**：`~/.config/opencode/opencode.json`
  * **優勢**：一次設定，終生受用。**OpenCode Desktop 桌面版**與 CLI 在任何專案或目錄啟動時，皆自動共用這組 n8n MCP 連線。
* 📁 **專案等級 (Project Level)**：
  * **設定檔位置**：`<專案根目錄>/opencode.json`
  * **適用情境**：只對當前專案生效。若特定專案需要連線至不同 n8n 實例或需個別客製化 headers，才在專案根目錄建立。

#### B. 設定檔內容範例 (`opencode.json`)

> ⚠️ **OAuth 與 Access Token 模式說明**：
> OpenCode 支援 **OAuth 自動授權** 功能（連線時由 CLI 引導開啟瀏覽器授權）。但因 OAuth 屬於較新功能，在特定環境下有時可能無法自動完成授權。
> **若遇到 OAuth 無法授權的情形，請改用傳統穩定的 Access Token 方式**（在 `headers` 帶入 `Authorization: "Bearer <TOKEN>"`）；若使用 OAuth 模式則可省略 `Authorization` 欄位。

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "n8n": {
      "type": "remote",
      "url": "https://<你的ngrok公開網域>/mcp-server/http",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer <你的_n8n_ACCESS_TOKEN>",
        "Accept-Encoding": "identity"
      }
    }
  }
}
```

> **欄位說明**：
> - `mcp.n8n`：MCP 服務識別名稱（可自訂）。
> - `type`：`remote`（遠端端點）。
> - `url`：n8n MCP 端點，路徑通常為 `/mcp-server/http`。
> - `headers.Accept-Encoding`：設定為 `identity`，可避免網關 Gzip 壓縮破壞 SSE/流式傳輸連線。
> - `headers.Authorization`：填入 Access Token（Bearer Token 格式）。當 OAuth 自動授權失敗時，以此方式可直接通過驗證。

#### C. 常用管理指令（全域 / Global 設定）

> 💡 **全域說明**：以下所有 `opencode` CLI 指令均預設針對**全域環境**（設定檔儲存於 `~/.config/opencode/opencode.json`，認證憑證儲存於 `~/.local/share/opencode/`），設定完成後在任何專案目錄皆可生效。

```bash
# 1. 登入 OpenAI / ChatGPT 帳號提供者（全域登入，供 ChatGPT 用戶使用）
opencode auth login

# 2. 全域新增 n8n MCP 服務（預設寫入 ~/.config/opencode/opencode.json）
opencode mcp add n8n --url https://<你的ngrok公開網域>/mcp-server/http

# 3. 手動觸發 / 重新進行全域 OAuth 網頁授權
opencode mcp auth n8n

# 4. 查看全域所有已註冊的 MCP 連線狀態
opencode mcp list

# 5. 診斷與測試全域 n8n 連線狀態
opencode mcp debug n8n

# 6. 登出或移除全域 n8n 連線憑證
opencode mcp logout n8n
```

> 📌 **模式與授權說明**：
> - **OAuth 模式**：執行 `opencode mcp add n8n --url ...` 後，首次連線時會自動喚起瀏覽器進行 n8n 登入授權（或執行 `opencode mcp auth n8n` 手動喚起），Token 會由 OpenCode 自動保存至本地全域憑證。
> - **Access Token 模式**：直接在 `opencode.json` 中配置 `"Authorization": "Bearer <TOKEN>"`，連線時直接通過驗證，無需透過瀏覽器進行 OAuth 跳轉。
> - **專案專屬範圍**：若希望將 MCP 設定僅限制在特定專案（非全域），請直接手動在該專案根目錄建立 `opencode.json` 進行配置。

> 💡 **ChatGPT 用戶專屬優勢**：若您擁有 ChatGPT / OpenAI 帳號，可在 OpenCode 透過 `opencode auth login` 登入 OpenAI 帳號，即可直接使用 ChatGPT 的模型（如 GPT-4o、o1 等）藉由 MCP 自動化操控 n8n 工作流程！

---

<a id="antigravity-mcp"></a>
### 3. Google Antigravity 專案等級 MCP 設定

Google Antigravity 支援**專案等級（Workspace-level）**與**全域等級（Global-level）**設定：

* 🌐 **全域設定（Global）**：位於 `~/.gemini/config/`，適用於本機所有專案。
* 📁 **專案等級設定（Workspace）**：位於專案根目錄下的 `.agents/` 資料夾，只對當前專案生效，可隨 Git 版本庫一同提交分享。

#### A. 專案目錄結構
```text
專案根目錄/
├── .agents/
│   ├── mcp_config.json                 # 專案層級 MCP 設定
│   └── plugins/
│       └── n8n/
│           ├── plugin.json             # Plugin 宣告檔
│           └── mcp_config.json         # Plugin 內部的 MCP 設定
└── ...
```

#### B. 設定檔案內容
1. **Plugin 宣告檔 (`.agents/plugins/n8n/plugin.json`)**：
   ```json
   {
     "name": "n8n"
   }
   ```
2. **MCP 設定檔 (`.agents/mcp_config.json` 或 `.agents/plugins/n8n/mcp_config.json`)**：
   > 💡 **認證注意**：Antigravity 不支援瀏覽器 OAuth 授權流程，若啟用認證需在 `headers` 帶入 `"Authorization": "Bearer <YOUR_ACCESS_TOKEN>"`。

   ```json
   {
     "mcpServers": {
       "n8n": {
         "serverUrl": "https://<你的ngrok公開網址>/mcp-server/http",
         "headers": {
           "Authorization": "Bearer <你的_n8n_ACCESS_TOKEN>",
           "Accept-Encoding": "identity"
         }
       }
     }
   }
   ```

> 📘 **詳細指南與除錯範例**：請參閱專題講義 **[Antigravity 專案等級 n8n MCP 設定教學](./antigravity_mcp_setup_guide.md)**。

---



<a id="security-and-workflow"></a>
## 五、安全規範與推薦操作流程

### 🔒 安全重點
1. **切勿提交金鑰至公開 Git**：包含 API Key、Webhook URL、Access Token。
2. **ngrok 網址監控**：免費版 ngrok 重新啟動後網址會變更，需同步更新 `opencode.json`（或各客戶端設定檔）。
3. **最小權限原則**：不隨意開放 `workflow:update`、`workflow:publish` 等寫入與發布權限。
4. **測試完成後關閉**：開發或教學結束後，請關閉 ngrok 隧道或將 n8n 的 MCP status 暫時切為 **Disabled**。

---

### 📋 推薦操作流程

```text
┌──────────────────────────────────────────────┐
│ 1. 確認工作流名稱與 ID                         │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│ 2. 讀取工作流配置與輸入格式 (Get Details)       │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│ 3. 向 AI 說明預計執行或修改的節點 (Planning)   │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│ 4. 使用測試模式驗證 (Test Execution)           │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│ 5. 檢查執行紀錄與 Error Log                    │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│ 6. 確認無誤後才發布或正式啟用 (Publish)         │
└──────────────────────────────────────────────┘
```

> **核心準則**：**先讀取、再確認、後執行；先測試、再發佈。**

---

<a id="practical-examples"></a>
## 🚲 課堂實戰範例（附 AI Prompt 提詞）

選好你的 AI 工具後，立即跟著實戰範例動手練習：

* 🚲 **[台北市 YouBike 低車輛站點自動記錄](./台北市的youbike/README.md)**
  * **任務目標**：定時抓取政府即時開放資料，篩選車輛不足 3 輛的站點並自動寫入 Google Sheets。
  * **課堂提詞**：內附完整的 **「AI Prompt 範本」**，直接貼給 Gemini、ChatGPT 或 Claude，讓 AI 替你全自動打造完整工作流程！
