# n8n Instance-level MCP 連線設定與介面功能指南 (v2.34.6 最新版)

> **適用版本**：`n8n Version 2.34.6` 或更高版本  
> **功能定位**：Instance-level MCP (Preview)  
> **核心目標**：讓外部 AI 助理與 IDE（如 OpenCode、Claude、Cursor、ChatGPT 等）透過 **Model Context Protocol (MCP)** 協議安全連線至 n8n 實例，並精細控制開放的工作流程與權限。

---

## 📑 目錄

1. [架構概念與連線流程](#一架構概念與連線流程)
2. [n8n 後台介面與所有按鈕功能詳解 (v2.34.6)](#二n8n-後台介面與所有按鈕功能詳解-v2346)
   - [進入路徑](#進入路徑)
   - [Connection details（連線設定區）](#1-connection-details連線設定區)
   - [Access（存取控制區）](#2-access存取控制區)
   - [Connected clients（已連線客戶端管理區）](#3-connected-clients已連線客戶端管理區)
3. [Expose（開放）與連線權限的關鍵差異](#三expose開放與連線權限的關鍵差異)
4. [各 AI 客戶端連線設定教學](#四各-ai-客戶端連線設定教學)
   - [OpenCode 設定檔與常用指令](#1-opencode-設定檔與常用指令)
   - [Claude Connector (OAuth 模式)](#2-claude-connector-oauth-模式)
   - [Cursor / 遠端 Token 模式](#3-cursor--遠端-token-模式)
5. [安全規範與推薦操作流程](#五安全規範與推薦操作流程)
6. [常見問題與排查 (Troubleshooting)](#六常見問題與排查-troubleshooting)

---

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

## 二、n8n 後台介面與所有按鈕功能詳解 (v2.34.6)

### 進入路徑
點擊 n8n 左下角 **Settings（設定）** ➔ 左側選單選擇 **Instance-level MCP**。

---

### 1. Connection details（連線設定區）

| 介面項目 | 類型 / 狀態標示 | 功能說明與操作指引 |
| :--- | :--- | :--- |
| **MCP status** | 狀態下拉選單<br>`● Enabled ˇ` / `Disabled` | **控制全域 MCP 伺服器的啟用狀態**。<br>• 設為 **Enabled（綠色）** 時，外部 AI（Claude、Cursor、ChatGPT、OpenCode）才能與本 n8n 實例建立 MCP 連線。<br>• 若暫時不希望任何外部 AI 連線，可切換為 **Disabled** 進行快速阻斷。 |
| **Connect your client** | 動作按鈕<br>`[ 🔌 Connect ]` | **開啟用戶端連線引導精靈 (Setup Wizard)**。<br>點擊後會彈出視窗，讓您挑選目標 AI 工具（如 Claude、Cursor、OpenCode、ChatGPT、VS Code），並自動產生專屬的設定步驟、連線資訊：<br>• **OAuth Server URL**（供 Claude 等支援 OAuth 的工具）<br>• **Access Token / HTTP Endpoint**（通常為 `https://<網域>/mcp-server/http`）。 |

---

### 2. Access（存取控制區）

| 介面項目 | 類型 / 狀態標示 | 功能說明與操作指引 |
| :--- | :--- | :--- |
| **Workflows exposed** | 導航按鈕<br>`1 workflow >` (依數量顯示) | **管理開放給 MCP 工具呼叫的工作流程清單**。<br>• 點擊進入工作流程選擇頁面，可直接勾選要開放給 AI 的 Workflow。<br>• **Description**：強烈建議為每個開放的工作流填寫清晰的描述，AI 會依據這段描述在對話中智能判斷何時呼叫該工具。 |
| **Allowed callback URLs** | 安全設定按鈕<br>`All >` / `Custom >` | **限制 OAuth 登入授權的回調（Redirect）網址白名單**。<br>• **All（預設）**：允許所有客戶端重定向網址，方便快速測試，但安全性較寬鬆。<br>• **自訂白名單**：可限定只有特定的客戶端 callback 網址（如 Claude 官方回調網址）才能完成授權，避免未經授權的應用程式發起 OAuth 劫持。 |

---

### 3. Connected clients（已連線客戶端管理區）

| 介面項目 | 類型 / 狀態標示 | 功能說明與操作指引 |
| :--- | :--- | :--- |
| **All connected clients** | 列表導航按鈕<br>`View all >`<br>*(顯示目前例如: 2 clients have access)* | **檢視並管理所有已成功連線並取得授權的外部 AI 客戶端**。<br>• 點擊進入可檢視目前有存取權限的應用程式列表（如 OpenCode CLI、Claude Desktop 等）。<br>• 可在此查看個別連線的授權時間，並在需要時執行 **Revoke（撤銷連線）**，立即中止特定客戶端的存取權。 |

---

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

## 四、各 AI 客戶端連線設定教學

### 1. OpenCode 設定檔與常用指令

OpenCode 支援 **全域等級 (Global Level)** 與 **專案等級 (Project Level)** 兩種設定方式，配置結構完全相同：

#### A. 設定檔層級說明
* 🌐 **全域等級 (Global Level)**：
  * **設定檔位置**：`~/.config/opencode/opencode.json`
  * **適用情境**：電腦上的所有專案在啟動 OpenCode 時，皆自動共用這組 n8n MCP 連線設定。
* 📁 **專案等級 (Project Level)**：
  * **設定檔位置**：`<專案根目錄>/opencode.json`
  * **適用情境**：只對當前專案生效。若特定專案需要連線至不同實例、專屬 ngrok 網域或需客製化 headers，可直接在專案根目錄建立。

#### B. 設定檔內容範例 (`opencode.json`)
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "n8n": {
      "type": "remote",
      "url": "https://<你的ngrok公開網域>/mcp-server/http",
      "enabled": true,
      "headers": {
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

#### C. 常用管理指令
```bash
# 新增 n8n MCP 服務
opencode mcp add n8n

# 查看所有 MCP 連線狀態
opencode mcp list

# 診斷與測試連線
opencode mcp debug n8n

# 登出或移除連線
opencode mcp logout n8n
```

---

### 2. Claude Connector (OAuth 模式)

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

### 3. Cursor / 遠端 Token 模式

在 Cursor 的 `mcp.json` 中配置：

```json
{
  "mcpServers": {
    "n8n": {
      "url": "https://<你的ngrok公開網域>/mcp-server/http",
      "headers": {
        "Accept-Encoding": "identity"
      }
    }
  }
}
```

---

## 五、安全規範與推薦操作流程

### 🔒 安全重點
1. **切勿提交金鑰至公開 Git**：包含 API Key、Webhook URL、Access Token。
2. **ngrok 網址監控**：免費版 ngrok 重新啟動後網址會變更，需同步更新 `opencode.json`。
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

## 六、常見問題與排查 (Troubleshooting)

### Q1: OpenCode 顯示找不到 n8n 或連線逾時
- [ ] 檢查 n8n 本地實例是否正常運行。
- [ ] 檢查 ngrok 或反向代理是否在線，且網址使用的是 `https://`。
- [ ] 確認 endpoint 路徑結尾是否包含 `/mcp-server/http`。
- [ ] 重新啟動 OpenCode 讓設定重新載入。

### Q2: 連線成功但 AI 看不到任何可執行的工作流
- [ ] 檢查該 Workflow 是否已點擊 **Publish / Active**（未發布啟用的工作流無法由 MCP 觸發）。
- [ ] 前往 **Settings > Instance-level MCP > Workflows exposed**，確認該工作流程已勾選開放 (Expose)。
- [ ] 確認該工作流有填寫清楚的 **Description**，以便 AI 能夠辨識。

### Q3: 執行工作流時失敗或報錯
- [ ] 檢查工作流節點中引用的 OAuth / API 憑證是否過期。
- [ ] 先以測試資料模式手動觸發，檢查 n8n 的 **Executions** 頁籤定位失敗的具體節點。
