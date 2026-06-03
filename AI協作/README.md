# AI協作 — 使用 Claude Connector 連接 n8n

## 範例 Workflow

### 🚲 [台北市的 YouBike 低車輛站點自動記錄](./台北市的youbike/README.md)
從台北市政府開放資料即時抓取 YouBike 2.0 所有站點資訊，自動篩選可借或可還車輛不足 3 輛的低車輛站點，並依日期寫入 Google Sheets，方便追蹤各站點供車狀況。本範例同時附有**給 AI 的 Prompt 範本**，可直接貼給 Claude 重新建出此 workflow。

---

## 什麼是 Claude n8n Connector？

**Claude Connector** 是 Claude 內建的整合功能，由 **n8n GmbH** 官方開發。透過 Connector，Claude 可以直接與您的 n8n 實例溝通，無需手動設定 MCP Server 或 ngrok。

連線後 Claude 可以：
- 建立、搜尋、執行 Workflow
- 管理 Data Tables、專案與資料夾
- 查詢執行紀錄與節點定義

> 共提供 **27 個工具**，涵蓋 `search_workflows`、`execute_workflow`、`get_workflow_details`、`publish_workflow` 等完整操作。

---

## 設定步驟

### 1. 在 n8n 開啟 Instance-level MCP

1. 進入 n8n 的 **Settings（設定）**。
2. 點選左側選單的 **Instance-level MCP**（標示 Preview）。
3. 確認右上角 **Enabled** 開關已打開（綠色）。
4. 點選 **Connection details**，選擇 **OAuth** 頁籤，記下 **Server URL**。

### 2. 啟動 ngrok 取得 HTTPS 網址

OAuth 授權流程要求 n8n 必須透過 **HTTPS** 對外提供服務，因此需先用 ngrok 將本機 n8n 暴露為公開 HTTPS 網址。

```bash
ngrok http 5678
```

啟動後複製 ngrok 產生的 HTTPS 網址，例如：

```
https://superinnocent-hillary-unwholesome.ngrok-free.app
```

> **提示**：新版 ngrok 大部分情況會提供固定網址，重新啟動後網址不變，無需重新設定 Claude Connector。

### 3. 在 Claude 新增 n8n Connector

1. 開啟 Claude 桌面版，點選左側 **Connectors**。
2. 點選右上角 **+** 搜尋 `n8n`。
3. 選擇由 **n8n GmbH** 開發的官方 Connector。
4. 點選 **Connect**，輸入上一步取得的 **ngrok HTTPS 網址** 作為 Server URL。
5. 完成 **OAuth 授權**，瀏覽器會跳出 n8n 登入/授權頁面，確認後即完成連線。

### 3. 授權 Workflow（開放給 Claude 使用）

回到 n8n **Settings > Instance-level MCP > Workflows** 頁籤：

1. 點選右上角 **Enable workflows** 按鈕。
2. 選擇要開放給 Claude 的 Workflow。

| 欄位 | 說明 |
|------|------|
| Name | Workflow 名稱 |
| Location | 所在專案 / 資料夾 |
| Description | Claude 識別此工具的說明（建議填寫，避免 ⚠️ No description）|

> **提示**：Description 是 Claude 判斷何時呼叫此 Workflow 的依據，請盡量填寫清楚。

### 4. 確認連線狀態

- 在 n8n **Settings > Instance-level MCP > Connected clients** 頁籤可看到 Claude 已連線。
- 在 Claude **Connectors** 清單中，n8n 顯示於 **Web** 區塊且狀態為已連線。

---

## Tool 權限說明

Claude Connector 提供兩類工具，可在 Claude 的 Connector 設定中調整權限：

| 類型 | 說明 | 預設 |
|------|------|------|
| Read-only tools（14個）| 查詢類，如 Get Execution、Search Workflows | 自動允許 |
| Write tools | 建立、執行、發布類操作 | 需手動確認 |

