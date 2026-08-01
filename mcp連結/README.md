# n8n MCP Server 設定與連結指南

本指南說明如何將 n8n 的 MCP (Model Context Protocol) Server 連結至各種 AI 工具與 CLI 客戶端（如 Claude.ai / Claude Desktop、OpenCode CLI 等）。

---

## 📋 概覽 (Overview)

- **MCP 端點 URL**: `https://superinnocent-hillary-unwholesome.ngrok-free.dev/mcp-server/http`
- **服務類型**: Remote MCP Server (HTTP / SSE)

---

## 1. Claude.ai / Claude Desktop

在 Claude 中可透過 Connector 功能直接新增並連結 n8n MCP 服務：

1. 開啟 Claude.ai 或 Claude Desktop 設定。
2. 前往 **Connectors / Integrations** 頁面。
3. 新增自訂 MCP Connector，輸入服務名稱（如 `n8n`）與遠端端點 URL：
   `https://superinnocent-hillary-unwholesome.ngrok-free.dev/mcp-server/http`
4. 儲存設定並啟用連結。

---

## 2. OpenCode CLI

### 常用管理指令

* **新增 n8n MCP 服務**：
  ```bash
  opencode mcp add n8n
  ```

* **列出目前所有 MCP 服務與狀態**：
  ```bash
  opencode mcp list
  ```

* **檢視與偵錯 n8n MCP 連線狀況**：
  ```bash
  opencode mcp debug n8n
  ```

* **登出或移除 n8n MCP 服務**：
  ```bash
  opencode mcp logout n8n
  ```

### OpenCode 專有配置文件 (OpenCode Specific Config)

這是 **OpenCode 專有** 的 MCP 配置文件，您可以透過以下指令檢視設定內容：

```bash
cat ~/.config/opencode/opencode.json
```

配置文件範例 (`~/.config/opencode/opencode.json`)：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "n8n": {
      "type": "remote",
      "url": "https://superinnocent-hillary-unwholesome.ngrok-free.dev/mcp-server/http",
      "enabled": true,
      "headers": {
        "Accept-Encoding": "identity"
      }
    }
  }
}
```

---

## 💡 注意事項與維護

1. **ngrok 轉發位址**：如果使用 ngrok 免費版服務進行網址轉發，請確保隧道持續開啟；若 ngrok 重新啟動且 URL 變更，需同步更新配置文件中的 `url`。
2. **Accept-Encoding 標頭**：在配置中加入 `"Accept-Encoding": "identity"` 可防止部分網關進行 Gzip 壓縮時導致 SSE 流式傳輸中斷。

