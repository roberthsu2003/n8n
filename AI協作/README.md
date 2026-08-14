# AI 協作指南 (AI Collaboration with n8n)

本章節介紹如何結合現代 AI 工具（如 Claude、OpenCode、多模態視覺模型等）與 n8n 進行高效協作，涵蓋**瀏覽器/視覺互動**與 **MCP (Model Context Protocol) 協議整合**兩大維度。

---

## 📑 目錄

- [一、視覺與瀏覽器操作協作（支援任意輸入模式）](#一視覺與瀏覽器操作協作支援任意輸入模式)
  - [方式 1：使用 Chrome 內建「問問 Gemini」方式（唯讀諮詢）](#方式-1使用-chrome-內建問問-gemini-方式唯讀諮詢)
  - [方式 2：使用 Claude in Chrome 方式](#方式-2使用-claude-in-chrome-方式)
  - [方式 3：使用 Codex / 多模態 Computer Vision 方式](#方式-3使用-codex--多模態-computer-vision-方式)
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

### 方式 3：使用 Codex / 多模態 Computer Vision 方式

* **運作機制**：透過多模態 AI 的電腦視覺（Computer Vision）能力，直接截圖分析 n8n 畫布流程、節點連線狀態或執行報錯資訊。
* **適用情境**：
  * 流程拓撲結構與邏輯檢查（檢查分流是否漏掉條件）。
  * 節點執行失敗時，截圖 Error Log 給 AI 進行即時診斷與修復建議。

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

### ⚙️ n8n 後台設定位置與介面

從 n8n **v2.23+** 開始，MCP 服務由內建的 **Instance-level MCP** 管理：

1. **功能位置**：
   * 點選左下角 **Settings（設定）** ➔ 左側選單選擇 **Instance-level MCP (Preview)**。
2. **啟用服務**：
   * 將右上角的開關切換為 **Enabled（綠色）**。
3. **連線資訊 (Connection details)**：
   * 點選右上角的 **Connection details** 按鈕，彈出視窗提供兩種連線憑證：
     * 🔑 **OAuth**：提供 `Server URL`（例如 ngrok 的公開 HTTPS 網址），供支援 OAuth 流程的客戶端（如 **Claude Connector**）使用。
     * 🎫 **Access token**：提供專屬 API Token，供使用 Token 驗證的開發者工具（如 **Claude Code**、**Cursor**、**OpenCode**）使用。
4. **工作流程授權 (Workflows 頁籤)**：
   * 點選 **Enable workflows** 按鈕，勾選要開放給 AI 呼叫的已發布 Workflow。
   * **Description（說明）**：為每個開放的 Workflow 填寫清楚的描述，AI 會依據這段說明判斷何時呼叫該工具。
5. **已連線客戶端管理 (Connected clients 頁籤)**：
   * 查看目前已成功連線並取得授權的外部 AI 客戶端列表。

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

在開發者導向的 **OpenCode** 環境中，透過遠端 MCP 端點直接整合 n8n。

* **詳細設定說明**：請參閱 [n8n MCP Server 設定與連結指南](../mcp連結/README.md)
* **指令操作**：
  ```bash
  # 新增 n8n MCP 服務
  opencode mcp add n8n
  
  # 檢查 MCP 連線狀態
  opencode mcp list
  ```
* **配置文件範例 (`~/.config/opencode/opencode.json`)**：
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