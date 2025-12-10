# n8n MCP 設定與功能說明

本文件說明如何設定 n8n 的 MCP (Model Context Protocol) 伺服器，以及 AI 透過此介面可以執行的操作。

## n8n MCP 設定方式

要讓 AI 透過 MCP 連接到您的 n8n 實例，通常需要設定 `n8n-mcp` 伺服器並提供必要的連線資訊。

### 1. 取得 n8n API 金鑰 (API Key)
1. 開啟您的 n8n 儀表板。
2. 進入 **Settings** (設定) > **API**。
3. 點擊 **Create API Key** (建立 API 金鑰)。
4. 複製產生的 API Key。

### 2. 確認 n8n API URL
您的 n8n API URL 通常格式為：
- 本地端：`http://localhost:5678/api/v1`
- 伺服器端：`https://<您的域名>/api/v1`

### 3. 設定環境變數
在設定 MCP Server 時 (例如在 Claude Desktop 或其他 MCP Client)，您需要提供以下環境變數：
- `N8N_API_KEY`: 剛才取得的 API 金鑰。
- `N8N_API_URL`: 您的 n8n API 網址。

> **注意**：如果您使用的是 n8n 內建的 "MCP Server Trigger" 節點，則設定方式會有所不同（由節點直接提供連接 URL），但上述方式是讓 AI 全面存取 n8n API 的通用標準做法。

## AI 可以透過 MCP 做什麼

透過 n8n MCP 整合，AI 助手可以直接與您的自動化流程互動。根據目前的 MCP 工具支援 (`n8n-mcp`)，主要功能包括：

### 1. 搜尋 Workflow (Search Workflows)
- **功能**：AI 可以根據名稱或描述關鍵字搜尋您現有的 workflows。
- **用途**：讓 AI 能快速找到適合處理使用者請求的自動化流程。

### 2. 獲取 Workflow 詳情 (Get Workflow Details)
- **功能**：AI 可以查看特定 workflow 的詳細資訊，包括其 ID、名稱、以及觸發節點的結構。
- **用途**：這非常重要，因為它讓 AI 知道該如何正確地呼叫 workflow，以及需要準備哪些輸入參數 (Inputs)。

### 3. 執行 Workflow (Execute Workflow)
- **功能**：AI 可以直接觸發並執行指定的 workflow。
- **用途**：AI 會根據 workflow 的需求填入參數，實現自動化任務的調用。
    - 例如：請 AI "幫我新增一筆客戶資料到 Notion"，AI 可以搜尋到對應的 n8n workflow，並執行它來完成工作。

透過這些功能，您可以將 n8n 作為 AI 的 "工具箱"，讓 AI 不僅能回答問題，還能實際執行複雜的系統整合與操作。
