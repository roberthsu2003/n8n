# 台北市 youbike 站點資訊查詢

## 工作流名稱

台北市youbike站點資訊查詢

## 📚 學習目標

在具備基本對話概念後，學習如何讓 AI Agent 使用**單一工具**查詢台北市 YouBike 即時站點資訊。本工作流預設使用 **Google Gemini**（`gemini-3-flash-preview`），並保留 **Ollama Chat Model** 節點可改接本地模型；聊天介面為台北市交通局 YouBike 服務中心，助理名稱為「帥氣的小犬」。

## 🎯 難度等級

**難度**: ⭐☆☆ (初級)

## 📋 工作流程說明

本工作流實作一個**政府交通局 YouBike 客服**情境的 AI 助理，能夠：

- 從聊天介面接收使用者問題（台北市交通局／youbike服務中心）
- 依系統提示扮演友善、專業的 youbike 客服人員
- 在需要站點即時資料時，呼叫 **台北市youbike即時資訊**（HTTP Request Tool）取得台北市 YouBike API 資料
- 使用 Simple Memory 維持對話脈絡
- 回覆簡潔、以繁體中文為主，並可於無法處理時引導至機關聯絡人

**與純對話範例的差異**：本範例引入**一個工具**（台北市 YouBike 即時 API），讓 AI 能根據使用者問題主動呼叫並解讀即時資料後回答。

## 🔧 使用節點

- **When chat message received**（Chat Trigger）— 對話入口；標題「台北市交通局」、副標「youbike服務中心」、助理「帥氣的小犬」、歡迎訊息「您好:\n這是台北市youbike服務中心」
- **AI Agent** — 依 System Message 扮演 youbike 客服，決定是否呼叫工具
- **Google Gemini Chat Model** — 預設連接的 LLM（`gemini-3-flash-preview`）
- **Ollama Chat Model** — 選用，可改接本地模型（如 `gpt-oss:20b-cloud`）
- **Simple Memory** — 對話記憶（contextWindowLength 可調）
- **台北市youbike即時資訊**（HTTP Request Tool）— 呼叫台北市 YouBike 即時 API：`https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json`，工具描述為「專門取得台北市youbike即時資訊的API」

## 📥 工作流下載

[台北市youbike站點資訊查詢](./台北市youbike站點資訊查詢.json)

## ⚙️ 設定與使用要點

1. **語言模型**：目前由 **Google Gemini Chat Model** 連到 AI Agent；若改為本地，將 AI Agent 的語言模型改接 **Ollama Chat Model** 並設定 Ollama 憑證與模型。
2. **工具**：僅使用一個 HTTP Request Tool，固定讀取台北市 YouBike 即時 JSON，無需額外參數；AI 會依對話決定是否呼叫並解讀回傳內容。
3. **System Message**：已定義 youbike 客服角色、個性、可使用的工具、職責、對話原則與輸出格式，以及無法處理時的機關聯絡人資訊（李彥安、02-27208889#6907、pn9607@gov.taipei）。
4. **Chat Trigger**：可依需求調整標題、副標、助理名稱、歡迎訊息與是否公開。

## 📌 建議先修

建議先完成 [智能客服聊天機器人](../智能客服聊天機器人/README.md)，理解 AI Agent 基本對話與 System Prompt 後，再學習本範例的「單一工具」整合。
