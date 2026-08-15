# n8n MCP Server 設定與連結指南

本指南說明如何將 n8n 的 MCP (Model Context Protocol) Server 連結至各種 AI 工具與 CLI 客戶端（如 Claude.ai / Claude Desktop、OpenCode CLI 等）。

> 📘 **最新版後台介面與按鈕說明**：請參閱 **[n8n Instance-level MCP 連線設定與介面指南 (v2.34.6)](../AI協作/n8n_mcp_setup_guide.md)**。

---

## 📋 概覽 (Overview)

- **MCP 端點 URL**: `https://superinnocent-hillary-unwholesome.ngrok-free.dev/mcp-server/http`
- **服務類型**: Remote MCP Server (HTTP / SSE)

---

## 1. Claude.ai / Claude Desktop (OAuth Connector 模式)

在 Claude 中透過官方 Connector 快速完成 OAuth 授權連線：

1. 開啟 **Claude.ai**（網頁版或桌面版應用程式）。
2. 在左側選單進入 **Customize** ➔ **Connectors**（或 **Settings > Connectors**）。
3. 在清單中搜尋 **n8n**（Type: `Web`），或點擊右上角 **`Add ˇ`** ➔ **`Browse connectors`** 選擇由 **n8n GmbH** 發布的官方連接器。
4. 點選 **`Connect`**，輸入 ngrok 產生的公開 HTTPS Server URL（例如 `https://<你的ngrok網域>.ngrok-free.app`）。
5. 瀏覽器完成 n8n OAuth 授權登入後，Claude Connectors 清單中的狀態即會顯示為 **`✓` (已連線)**。

* 📖 **詳細教學請參閱**：[Claude Connector 完整設定手冊](../AI協作/README1.md)

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
 
 ### OpenCode 設定檔層級 (全域 vs 專案等級)
 
 OpenCode 支援全域與專案兩種設定層級：
 
 1. 🌐 **全域等級 (Global Level)**：
    * **路徑**：`~/.config/opencode/opencode.json`
    * **說明**：跨專案通用，所有工作目錄皆可共用此 n8n MCP 設定。
    * 可透過指令檢視：`cat ~/.config/opencode/opencode.json`
 
 2. 📁 **專案等級 (Project Level)**：
    * **路徑**：`<專案根目錄>/opencode.json`
    * **說明**：僅在當前專案目錄下啟動 OpenCode 時生效，適合特定專案連接專屬的 n8n 實例或客製化 headers。
 
 ### 設定檔範例 (`opencode.json`)：
 
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

