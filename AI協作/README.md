# AI 協作指南 (AI Collaboration with n8n)

本章節介紹如何結合現代 AI 工具（如 Claude、ChatGPT、Gemini、OpenCode 等）與 n8n 進行高效協作，涵蓋**瀏覽器/視覺互動**與 **MCP (Model Context Protocol) 協議整合**兩大維度。

---

## 📑 目錄

- [一、視覺與瀏覽器操作協作（支援任意輸入模式）](#一視覺與瀏覽器操作協作支援任意輸入模式)
  - [方式 1：使用 Chrome 內建「問問 Gemini」方式（唯讀諮詢）](#方式-1使用-chrome-內建問問-gemini-方式唯讀諮詢)
  - [方式 2：使用 Claude in Chrome 方式](#方式-2使用-claude-in-chrome-方式)
  - [方式 3：使用 ChatGPT in Chrome 方式（瀏覽器套件）](#方式-3使用-chatgpt-in-chrome-方式瀏覽器套件)
- [二、n8n MCP 連結方式（工具呼叫與自動化執行）](#二n8n-mcp-連結方式工具呼叫與自動化執行)
  - [⚠️ 核心先決條件 (MCP 存取要求)](#️-核心先決條件-mcp-存取要求)
  - [⚙️ n8n 後台設定位置與介面](#️-n8n-後台設定位置與介面)
  - [🔌 連線方式（依客戶端類型）](#-連線方式依客戶端類型)
    - [模式 A：OAuth 授權連線（Claude Connector）](#模式-aoauth-授權連線適用於-claudeai--claude-desktop)
    - [模式 B：Token / 遠端端點連線（OpenCode / Cursor / Claude Code）](#模式-btoken--遠端端點連線適用於-opencodecursorclaude-code)
- [實戰範例](#實戰範例)

---

## 一、視覺與瀏覽器操作協作（支援任意輸入模式）

此模式下，n8n 工作流的觸發節點可以是**任何輸入模式**（例如手動點擊 Manual Trigger、排程 Schedule、表單 Form 等），由 AI 透過畫面解析或瀏覽器控制來輔助建立與偵錯。

### 方式 1：使用 Chrome 內建「問問 Gemini」方式（唯讀諮詢）

* **運作機制**：利用 Chrome 瀏覽器側邊欄內建的「問問 Gemini (Ask Gemini in Chrome)」，自動抓取當前 n8n 網頁分頁的畫面與文字內容進行即時分析。
* **特點與限制**：
  * 💡 **只可給意見 / 諮詢建議**：能快速分析當前畫面上的節點拓撲、解讀執行失敗的錯誤原因、或給予 Code 節點語法與正則表達式撰寫建議。
  * 🔒 **無法直接修改**：屬於唯讀的對話諮詢輔助模式，AI **無法直接替您點擊、新增或修改 n8n 畫布上的節點**，需由使用者手動調整。

### 方式 2：使用 Claude in Chrome 方式

* **運作機制**：利用 Claude 瀏覽器外掛直接讀取當前 n8n Web 編輯器畫面的 DOM 與內容。
* **適用情境**：
  * 在瀏覽器中直接與 AI 對話，讓 AI 根據當前畫布上的節點配置給出修改建議。
  * 複製/貼上 JSON 工作流或自動填入複雜表達式（Expressions）。

### 方式 3：使用 ChatGPT in Chrome 方式（瀏覽器套件）

* **運作機制**：在 Chrome 安裝 ChatGPT 官方或相容的瀏覽器擴充套件，讓 ChatGPT 能夠直接讀取並操作當前 n8n Web 編輯器畫面。
* **適用情境**：
  * 側邊欄即時協作：直接在 n8n 分頁側邊欄呼叫 ChatGPT 分析當前畫布配置。
  * 輔助設定與參數填寫：讓 AI 讀取頁面結構後協助產生表達式、Code 節點程式碼與設定值。
  * 錯誤即時診斷：當節點執行報錯時，直接讀取畫面錯誤訊息提供即時排錯建議。

---

## 二、n8n MCP 連結方式（工具呼叫與自動化執行）

透過 **Model Context Protocol (MCP)**，AI 助理能直接將 n8n 作為外部工具箱，執行搜尋、建立工作流或直接觸發指定任務。

### ⚠️ 核心先決條件 (MCP 存取要求)

當使用 MCP 讓 AI 存取、呼叫並執行 n8n 工作流程時，該 Workflow 必須符合以下要件：

1. **工作流程必須已發布/啟動 (Published / Active)**：
   * 只有處於已發布 (Published) 且啟用狀態的 Workflow 才能開放給 MCP 存取與執行。
2. **支援的觸發節點類型 (Trigger Nodes)**：
   * Workflow 的觸發起點**必須是以下四種節點之一**：
     * 🌐 **Webhook**（HTTP 外部請求觸發）
     * 📝 **Form**（n8n 表單輸入觸發）
     * ⏰ **Schedule**（排程定時觸發）
     * 💬 **Chat Trigger**（AI 對話介面觸發）
3. **公開 HTTPS 網址**：
   * 本機端 (Self-hosted) 的 n8n 實例需透過 ngrok 或反向代理暴露為 HTTPS 網址，以供 MCP Client / OAuth 正常連線。

---

### ⚙️ n8n 後台設定位置與介面 (適用於 Version 2.34.6 最新版)

> 📘 **完整圖文指南**：所有按鈕功能、Expose 與權限差異及各大客戶端連線教學，請參閱 **[n8n Instance-level MCP 連線設定與介面指南 (v2.34.6)](./n8n_mcp_setup_guide.md)**。

從 n8n **v2.34.6** 最新介面中，MCP 服務由 **Instance-level MCP (Preview)** 統一管理，介面主要分為三大區塊與按鈕功能：

1. **進入路徑**：
   * 點選左下角 **Settings（設定）** ➔ 左側選單選擇 **Instance-level MCP (Preview)**。
2. **Connection details（連線設定區）**：
   * **`MCP status` 下拉選單 (`● Enabled ˇ`)**：全域切換 MCP 服務啟用狀態（綠色代表啟用中）。
   * **`Connect your client` 按鈕 (`[ 🔌 Connect ]`)**：開啟引導精靈，挑選目標 AI 工具（Claude、Cursor、OpenCode、ChatGPT 等）並獲取專屬設定步驟與端點。
3. **Access（存取控制區）**：
   * **`Workflows exposed` 按鈕 (`1 workflow >`)**：管理開放給 AI 當作 MCP Tool 呼叫的工作流程（僅支援已發布且為 Webhook/Form/Schedule/Chat Trigger 觸發的流程）。
   * **`Allowed callback URLs` 安全設定 (`All >`)**：設定 OAuth 登入重定向的受信任白名單網址。
4. **Connected clients（已連線客戶端管理區）**：
   * **`All connected clients` 列表 (`View all >`)**：檢視與管理所有目前已獲授權連線的 AI 客戶端（例如顯示 `2 clients have access`），可隨時撤銷 (Revoke) 存取權限。

---

### 🔌 連線方式（依客戶端類型）

根據不同的 AI 工具，支援以下兩種連線整合方式：

#### 模式 A：OAuth 授權連線（適用於 Claude.ai / Claude Desktop）

利用 n8n GmbH 官方提供的 **Claude Connector**，透過圖形化 OAuth 流程快速連線：

* **詳細步驟說明**：請參閱 [Claude Connector 完整設定手冊](./README1.md)
* **快速步驟**：
  1. 在 n8n **Connection details > OAuth** 記下 `Server URL`（需為 ngrok 等公開 HTTPS 網址）。
  2. 在 Claude 的 **Connectors** 搜尋並新增官方 `n8n`。
  3. 貼上 Server URL 點擊 Connect，完成瀏覽器跳轉授權即可。

#### 模式 B：Token / 遠端端點連線（適用於 OpenCode、Cursor、Claude Code）

透過遠端 MCP 端點 (HTTP / SSE) 或 Access Token 配置文件直接連線：

* **詳細設定說明**：請參閱 [n8n MCP Server 設定與連結指南](../mcp連結/README.md)

---

### 方式 4：使用 OpenCode Desktop / CLI 方式

在開發者導向的 **OpenCode** 環境中，透過遠端 MCP 端點直接整合 n8n。OpenCode 設定支援**全域等級 (Global)** 與 **專案等級 (Project)** 兩種配置層級：

* **詳細設定說明**：請參閱 [n8n MCP Server 設定與連結指南](../mcp連結/README.md) 與 [完整指南](./n8n_mcp_setup_guide.md#1-opencode-設定檔與常用指令)
* **指令操作**：
  ```bash
  # 新增 n8n MCP 服務
  opencode mcp add n8n
  
  # 檢查 MCP 連線狀態
  opencode mcp list
  ```

#### 🌐 全域等級設定 (Global Level)
* **設定檔位置**：`~/.config/opencode/opencode.json`
* **適用情境**：在任何目錄下啟動 OpenCode，所有專案皆共用同一組 n8n 連線設定。

#### 📁 專案等級設定 (Project Level)
* **設定檔位置**：專案根目錄下的 `opencode.json`（例如 `<專案根目錄>/opencode.json`）
* **適用情境**：僅針對特定專案生效，適合各專案使用獨立的 n8n 實例、不同端點或客製化標頭。

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "n8n": {
      "type": "remote",
      "url": "https://<your-ngrok-domain>.ngrok-free.app/mcp-server/http",
      "enabled": true,
      "headers": {
        "Accept-Encoding": "identity"
      }
    }
  }
}
```

---

## 🚲 實戰範例

* **[台北市 YouBike 低車輛站點自動記錄](./台北市的youbike/README.md)**
  * 即時抓取開放資料、條件篩選並寫入 Google Sheets。
  * 內附完整 **給 AI 的 Prompt 範本**，可直接提供給 Claude / OpenCode 自動建置整個 Workflow。