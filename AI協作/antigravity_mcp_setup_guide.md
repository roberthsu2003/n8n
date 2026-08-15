# Antigravity 專案等級 n8n MCP 設定教學

本講義介紹如何在 **Antigravity** 環境中，為單一專案（Workspace-level）設定 **n8n MCP（Model Context Protocol）** 連線，讓 AI 代理能夠直接操作與查詢 n8n 工作流。

> [!IMPORTANT]
> **認證重要須知**：
> **Google Antigravity 目前不支援互動式 OAuth 授權流程**。若 n8n 服務端啟用了 MCP 認證，**必須使用 Access Token（Bearer Token）**，透過設定檔的 `headers` 帶入 `"Authorization": "Bearer <YOUR_ACCESS_TOKEN>"` 進行連線授權。

## 📑 目錄

1. [架構與觀念](#architecture)
2. [專案目錄結構](#directory-structure)
3. [設定檔案內容](#config-files)
4. [欄位詳細說明](#field-descriptions)
5. [OpenCode 與 Antigravity 設定對照](#opencode-vs-antigravity)
6. [連線驗證步驟](#verification-steps)
7. [常用操作與提問範例](#example-prompts)
8. [常見問題排查 (Troubleshooting)](#troubleshooting)

---

<a id="architecture"></a>
## 一、架構與觀念

### 1. 什麼是專案等級（Project-level / Workspace-level）設定？
- **全域設定（Global）**：位於 `~/.gemini/config/`，適用於本機所有的專案與對話。
- **專案等級設定（Workspace）**：位於專案根目錄下的 `.agents/` 資料夾，只對當前專案生效，且可隨 Git 版本庫一同提交分享給團隊成員。

### 2. 連線與認證架構
```text
Antigravity Agent (發送請求帶有 Authorization: Bearer <TOKEN>)
       │
       │ (SSE / HTTP 遠端協定)
       ▼
   ngrok / 反向代理
       │
       ▼
  n8n MCP Server (/mcp-server/http)
       │  ✔ 驗證 Bearer Token
       ▼
 n8n 工作流、節點與執行紀錄
```

---

<a id="directory-structure"></a>
## 二、專案目錄結構

在專案根目錄下建立 `.agents` 目錄，結構如下：

```text
專案根目錄/
├── .agents/
│   ├── mcp_config.json                 # 專案層級 MCP 設定
│   └── plugins/
│       └── n8n/
│           ├── plugin.json             # Plugin 宣告檔
│           └── mcp_config.json         # Plugin 內部的 MCP 設定
├── opencode.json                       # (可選) OpenCode 的設定檔
└── ... (其他專案程式碼)
```

---

<a id="config-files"></a>
## 三、設定檔案內容

### 步驟 1：建立 Plugin 宣告檔 (`.agents/plugins/n8n/plugin.json`)
宣告此目錄為一個名為 `n8n` 的 Antigravity 擴充套件：

```json
{
  "name": "n8n"
}
```

---

### 步驟 2：建立 Plugin MCP 設定檔 (`.agents/plugins/n8n/mcp_config.json`)
設定遠端 n8n MCP Server 的 endpoint 與認證 Header：

```json
{
  "mcpServers": {
    "n8n": {
      "serverUrl": "https://<你的ngrok或公開網址>/mcp-server/http",
      "headers": {
        "Authorization": "Bearer <你的_n8n_ACCESS_TOKEN>",
        "Accept-Encoding": "identity"
      }
    }
  }
}
```

---

### 步驟 3：建立專案通用 MCP 設定檔 (`.agents/mcp_config.json`)
此檔案可確保 Antigravity 各種載入途徑都能辨識：

```json
{
  "mcpServers": {
    "n8n": {
      "serverUrl": "https://<你的ngrok或公開網址>/mcp-server/http",
      "headers": {
        "Authorization": "Bearer <你的_n8n_ACCESS_TOKEN>",
        "Accept-Encoding": "identity"
      }
    }
  }
}
```

---

<a id="field-descriptions"></a>
## 四、欄位詳細說明

| 欄位 | 型別 | 必填 | 說明 |
| :--- | :--- | :---: | :--- |
| `mcpServers.n8n` | 物件 | 是 | MCP Server 的名稱識別碼（此處命名為 `n8n`）。 |
| `serverUrl` | 字串 | 是 | 遠端 n8n MCP Server 的 HTTP/SSE Endpoint 完整網址。 |
| `headers` | 物件 | 是 | 傳送給 MCP Server 的 HTTP 標頭。 |
| `headers.Authorization` | 字串 | 是* | **存取認證**：格式為 `Bearer <TOKEN>`（n8n 啟用認證時必填）。 |
| `headers.Accept-Encoding` | 字串 | 建議 | 傳輸編碼：設為 `"identity"`，避免壓縮編碼影響通訊解析。 |

---

<a id="opencode-vs-antigravity"></a>
## 五、OpenCode 與 Antigravity 設定對照

若先前使用 `opencode.json`，兩者的對應關係如下：

| 設定項目 | OpenCode (`opencode.json`) | Antigravity (`.agents/mcp_config.json`) |
| :--- | :--- | :--- |
| **檔案位置** | `./opencode.json` | `./.agents/mcp_config.json` 或 `.agents/plugins/n8n/mcp_config.json` |
| **頂層欄位** | `"mcp": { ... }` | `"mcpServers": { ... }` |
| **網址欄位** | `"url": "https://..."` | `"serverUrl": "https://..."` |
| **連線類型** | `"type": "remote"` | 自動依 `serverUrl` 判定為遠端連線 |
| **標頭設定** | `"headers": { ... }` | `"headers": { ... }` |

---

<a id="verification-steps"></a>
## 六、連線驗證步驟

1. **確認 n8n 服務**：
   - n8n Server 已啟動並啟用 MCP Server 功能。
   - 反向代理（如 ngrok）已啟動，確認公開 HTTPS 網址有效。
2. **填寫最新網址與 Token**：
   - 將最新的 ngrok 網址與 Bearer Token 填入上述的 `mcp_config.json` 檔案中。
3. **重新載入對話**：
   - 在 Antigravity 中開啟**新對話（New Chat）**，讓 Agent 重新讀取專案的 MCP 設定與載入工具。
4. **發送測試指令**：
   - 向 Agent 輸入：`「請列出目前 n8n 上的所有工作流」`，驗證是否能正常取得回應。

---

<a id="example-prompts"></a>
## 七、常用操作與提問範例

### 1. 查詢工作流清單
```text
請列出目前 n8n 中的所有工作流，並標示哪些已啟用、哪些已 expose 給 MCP。
```

### 2. 檢視工作流結構
```text
請讀取「下載新北市youbike及時資料」工作流，分析它的觸發節點與資料處理邏輯。
```

### 3. 測試執行工作流
```text
請以測試模式（Test Mode）執行「下載新北市youbike及時資料」工作流，並回報執行結果。
```

### 4. 除錯與執行紀錄
```text
查詢「某工作流」最近一次的執行紀錄，看是否有失敗節點與錯誤原因。
```

---

<a id="troubleshooting"></a>
## 八、常見問題排查（Troubleshooting）

1. **看到 `401 Unauthorized` 錯誤**：
   - 原因：未設定 `headers.Authorization`、Token 缺少 `Bearer ` 前綴、Token 過期，或是誤以為 Antigravity 會自動開啟瀏覽器 OAuth（Antigravity 不支援互動式 OAuth，需手動設定 Bearer Token）。
2. **Agent 回應找不到 n8n 工具**：
   - 原因：MCP 設定檔剛建立或修改，目前對話尚未載入。
   - 解決方法：開啟新對話（New Chat）即可自動載入工具。
3. **連線失敗（Connection Refused / Timeout）**：
   - 檢查 ngrok 是否仍在執行，每次重新執行 ngrok 網址會改變，需更新 `mcp_config.json`。
   - 確認網址結尾是否包含 `/mcp-server/http`。
4. **權限不足或找不到特定工作流**：
   - 確認工作流是否已在 n8n 中設定 `availableInMCP: true`。
   - 檢查連線的 n8n 帳號權限。
