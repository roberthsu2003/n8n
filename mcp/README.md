# n8n MCP 設定與功能說明

本文件說明如何設定 n8n 的 **原生 MCP (Model Context Protocol) 存取功能**。此功能允許您將 n8n Workflow 直接作為 AI 工具 (Tools) 暴露給 Claude Desktop 或其他 MCP Client 使用。

> **注意**：此說明適用於 n8n v1.122.5 或更高版本，並使用原生的 "MCP Access" 設定面板。

## 設定步驟

### 1. 啟用 n8n MCP 功能 (全域設定)
1. 進入 n8n 的 **Settings** (設定)。
2. 點選左側選單的 **MCP Access**。
3. 將右上角的 **Enable MCP** 開關打開。

### 2. 開放 Workflow 權限 (個別設定)
**這是最關鍵的一步！** 只有被明確授權的 Workflow 才會變成 AI 可用的工具。

您可以透過兩種方式開啟權限：

**方法 A：從 Workflow 列表 (最快)**
1. 在 n8n 的 **Workflows** 列表頁面。
2. 點擊該 Workflow 右側的三個點選單 `⋮`。
3. 選擇 **Grant MCP access** (如果已開啟則會顯示 Remove MCP access)。

**方法 B：從 Workflow 編輯器**
1. 進入該 Workflow 的編輯畫面。
2. 開啟 **Settings**。
3. 啟用 **MCP Access** 選項。

> **提示**：開啟後，您可以回到 **Settings > MCP Access** 頁面，下方會列出 **Available Workflows**，確認 AI 目前可以看到哪些工具。

### 3. 設定 MCP Client (以 Claude Desktop 為例)
在您的 Claude Desktop 設定檔 (`claude_desktop_config.json`) 中，加入以下設定。這會使用 `supergateway` 來連接 n8n 的 HTTP Endpoint。

請將 `<YOUR_SERVER_URL>` 和 `<YOUR_ACCESS_TOKEN>` 替換為 **Settings > MCP Access** 頁面上顯示的實際數值。

```json
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "supergateway",
        "--streamableHttp",
        "<YOUR_SERVER_URL>", 
        "--header",
        "authorization:Bearer <YOUR_ACCESS_TOKEN>"
      ]
    }
  }
}
```

- **Server URL**: 在 MCP Access 頁面的 "Server URL" 欄位複製 (結尾通常是 `/mcp-server/http`)。
- **Access Token**: 在 MCP Access 頁面的 "Access Token" 欄位複製。

## AI 可以透過這個 MCP 做什麼

一旦設定完成，每個被授權的 Workflow 都會變成 AI 的一個 **"工具" (Tool)**。

- **自動化執行**：
    AI 不再是"操作 n8n"，而是**直接使用您定義好的功能**。
    - *場景*：您有一個 "新增 Notion 筆記" 的 Workflow。
    - *AI 的視角*：它會看到一個名為 `create_notion_note` 的工具，並知道需要填入 `title` 和 `content`。
    - *使用者指令*：當您對 AI 說「幫我把今天的會議記錄記下來」，AI 就會自動呼叫這個工具。

- **彈性整合**：
    您可以在 n8n 中使用任何節點 (HTTP Request, Slack, Google Sheets 等) 建立複雜邏輯，然後將其包裝成一個簡單的工具給 AI 使用。
