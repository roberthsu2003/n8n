# LINE 整合實作
## 範例 1：LINE 訊息觸發 n8n 工作流程

### 📚 工作流程說明

這個 n8n 工作流程示範如何透過 **LINE Webhook** 接收使用者傳送至 LINE 官方帳號的訊息，並在 n8n 中自動解析出關鍵欄位（例如：使用者 ID、訊息文字、ReplyToken、群組 ID 與事件類型），為後續的資料庫儲存、商業邏輯分流或 AI 智慧對話奠定基礎。

---

### 🔗 Webhook URL 綁定設定

在 n8n 匯入工作流程後，請依序完成工作流程發布（Publish）與 Webhook 網址綁定：

> [!IMPORTANT]
> **必須先將工作流程設為 Published（正式啟用）！**
> LINE Developers 的 Webhook 驗證（Verify）與真實訊息接收，**必須使用 Production URL（正式發布網址）** 且工作流程處於 **Published / Active** 狀態下才能成功回應 200 OK。

1. **發布工作流程（Publish）**：
   - 點擊 n8n 畫布右上角的 **Publish**（或將 Active 開關切換為啟用狀態）。
2. **複製 Production Webhook URL**：
   - 點開「LINE Webhook 觸發器」節點，切換至 **Production URL** 分頁並複製網址（格式為：`https://<你的網域>/webhook/line-webhook`）。
3. **貼至 LINE Developers 並驗證**：
   - 登入 [LINE Developers Console](https://developers.line.biz/console/)，進入您建立的 Channel ➔ **Messaging API** 分頁。
   - 在 **Webhook URL** 欄位貼上剛複製的 **Production URL**。
   - 將 **Use webhook** 切換為 **啟用（Enabled/On）**。
   - 點擊 **Verify** 按鈕，確認出現 **`Success`** 綠色成功提示！

> 📌 完整的 LINE Channel 建立與前置設定請參閱 **[📱 LINE Messaging API 設定指南](../../../line設定/README.md)**。

---

### 流程架構圖

```mermaid
flowchart LR
    A["📱 LINE 用戶發送訊息"] --> B["⚡ LINE Webhook 觸發器"]
    B --> C["⚡ 即時回傳 200 OK"]
    B --> D["⚙️ 解析 LINE 訊息 (Code 節點)"]
    D --> E{"是否為文字訊息？"}
    E -->|是| F["📋 整理輸出日誌 (Set 節點)"]
    E -->|否| G["⏹️ 忽略或分流其他事件"]
```

---

### 預覽圖

![LINE 訊息觸發工作流程預覽](./images/pic1.png)

---

### 工作流程樣版下載

- [📥 LINE 訊息觸發工作流程樣版 (line_webhook_trigger.json)](./line_webhook_trigger.json)

---

#### 📋 節點詳細說明

1. **📝 流程說明（Sticky Note）**
   - **功能**：畫布上的備忘說明，標示各階段處理重點。

2. **⚡ LINE Webhook 觸發器（Webhook Node）**
   - **功能**：工作流程的起點，監聽 LINE 伺服器推播的 HTTP POST 請求。
   - **設定要點**：
     - **HTTP Method**：`POST`
     - **Path**：`line-webhook`
     - **Response Mode**：`Using 'Respond to Webhook' Node`（非同步即時回應模式）

3. **⚡ 即時回傳 200 OK（Respond to Webhook Node）**
   - **功能**：立即向 LINE 伺服器回覆 HTTP 200 `{"status": "ok"}`。
   - **重要性**：LINE 伺服器若在 1 秒內未收到 200 回應，會判定傳輸失敗並持續重發 Webhook，造成流程重複執行。

4. **⚙️ 解析 LINE 訊息（Code Node）**
   - **功能**：從 LINE Webhook 傳入的 `events` 陣列中提取關鍵參數：
     - `userId`：發送訊息的使用者專屬識別碼（格式為 `U` 開頭的 33 碼字串）。
     - `userMessage`：使用者輸入的文字內容。
     - `replyToken`：用於免費被動回覆此則訊息的權杖（有效時效約 1 分鐘）。
     - `messageType`：訊息類型（如 `text`、`image`、`sticker` 等）。
     - `eventType`：事件類型（如 `message`、`follow`、`unfollow` 等）。

   <details>
   <summary>🔍 <b>查看 Code 節點完整程式碼與逐行解析</b></summary>

   ```javascript
   // 解析 LINE Webhook Payload
   const body = $input.first().json.body || {};
   const events = body.events || [];

   if (events.length === 0) {
     return [{
       json: {
         status: 'no_events',
         note: '這通常是 LINE Webhook URL 驗證請求或無訊息事件',
         rawBody: body,
         receivedAt: new Date().toISOString()
       }
     }];
   }

   const event = events[0];
   const messageType = event.message?.type || '';
   const userMessage = event.message?.text || '';
   const replyToken = event.replyToken || '';
   const userId = event.source?.userId || '';
   const groupId = event.source?.groupId || '';
   const eventType = event.type || '';

   return [{
     json: {
       status: 'ok',
       eventType,
       messageType,
       userMessage,
       replyToken,
       userId,
       groupId,
       timestamp: event.timestamp,
       receivedAt: new Date().toISOString()
     }
   }];
   ```

   #### 逐段解析說明：
   1. **取得 Webhook Payload 與 Events 陣列**：
      - `$input.first().json.body || {}`：從 Webhook 節點取得傳入的請求 Body，預設為 `{}` 避免未定義錯誤。
      - `body.events || []`：LINE 發送的所有事件（訊息、加好友等）皆包裝在 `events` 陣列中。
   2. **防呆與邊界情況處理（Verify 驗證請求）**：
      - 當在 LINE Developers Console 點擊 **Verify** 測試連線時，LINE 只會送出空陣列 `events: []`。
      - 透過 `if (events.length === 0)` 攔截並回傳 `status: 'no_events'`，避免後續存取空資料時拋出錯誤導致流程中斷。
   3. **安全提取關鍵欄位（使用 Optional Chaining `?.`）**：
      - `event.message?.text`：安全取得使用者傳送的文字內容。
      - `event.replyToken`：提取用於回覆訊息的單次有效權杖。
      - `event.source?.userId` / `groupId`：取得使用者個人 ID 或群組 ID，方便後續識別用戶或推播。
      - `event.message?.type` 與 `event.type`：用於判斷訊息型態（文字、圖片、貼圖等）與事件型態（訊息、加好友、退群等）。
   4. **回傳標準化輸出（Structured Output）**：
      - 將扁平化、結構化的乾淨欄位包裝在 `return [{ json: { ... } }];`，供後續節點（如 IF 節點、AI Agent、HTTP Request）直接透過 `$json.userMessage` 或 `$json.replyToken` 便捷引用。

   </details>

5. **🔀 是否為文字訊息？（IF Node）**
   - **功能**：判斷 `$json.messageType` 是否等於 `text`，確保只有文字訊息進入主處理管線，避免圖片或貼圖造成後續字串處理錯誤。

6. **📋 整理輸出日誌（Edit Fields / Set Node）**
   - **功能**：將解析出的使用者與訊息內容整理為結構化的輸出物件，方便後續工作流程調用或寫入日誌。

---

#### 🎯 學習重點

- **Webhook 接收機制**：理解 LINE 如何以 JSON Payload 即時推送事件給 n8n。
- **即時回應 200 原理**：掌握使用 `Respond to Webhook` 節點避免伺服器重試風暴的最佳實踐。
- **LINE 關鍵參數辨識**：熟悉 `userId`（用戶標識）與 `replyToken`（免費回覆憑據）的用途。
- **條件分流**：使用 IF 節點依照訊息型態進行分流處理。

---

#### 💡 實際應用場景

- **LINE 官方帳號客服監聽**：即時接收客戶提問並轉發至團隊 Telegram 或 Slack。
- **客戶資料自動建檔**：擷取用戶傳送的姓名、電話或預約資訊，寫入 Google Sheets 或 Supabase。
- **AI 智能客服入口**：作為對話機器人的接收起點，將 `userMessage` 送入 AI Agent 生成回覆。

---

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標 1：透過 MCP 從零建立此工作流程**
> 只要複製下方 Prompt，AI 即可在您的 n8n 畫布上全自動建構出此工作流程。

**可直接複製給 AI 的 Prompt 提詞（建立工作流）**：
```text
請在我的 n8n 畫布上從無到有建立一個「LINE 訊息接收與解析」工作流程：
1. 新增 Webhook 觸發節點：
   - HTTP Method 設為 POST。
   - Path 設為 line-webhook。
   - Response Mode 設為 Using 'Respond to Webhook' Node。
2. 連接 Respond to Webhook 節點，立即回傳 JSON {"status": "ok"}。
3. 同時連接 Code 節點，JavaScript 邏輯需解析 $input.first().json.body.events[0]，提取出 eventType, messageType, userMessage, replyToken, userId。
4. 連接 IF 節點，判斷 messageType 是否等於 "text"。
5. 在 True 分支連接 Edit Fields (Set) 節點，輸出包含 status: "處理成功" 與 logSummary: "收到來自 {{ $json.userId }} 的訊息：{{ $json.userMessage }}"。
請幫我建立所有節點並完成連線！
```

---

> 💡 **任務目標 2：升級為 AI 智慧問答機器人（串接 LLM 與 Reply API）**
> 結合大型語言模型（OpenAI / Gemini / Ollama），將用戶輸入即時交給 AI 回覆，並透過 LINE Reply API 免費送回給使用者。

**可直接複製給 AI 的 Prompt 提詞（串接 AI 智慧回覆）**：
```text
請幫我在目前的「LINE 訊息接收工作流程」後面升級加入 AI Agent 智慧問答與自動回覆：
1. 接在「是否為文字訊息」的 True 分支後面。
2. 新增 AI Agent（或 Basic LLM Chain）節點：
   - 串接 Chat Model（例如 Gemini Chat Model 或 OpenAI Chat Model）。
   - System Prompt 設定為：「你是一個親切專業的 LINE 智能助手，請使用繁體中文，以簡潔且有條理的語氣回覆使用者的提問。」
   - 將使用者的 {{ $json.userMessage }} 作為 Prompt 輸入。
3. 在 AI 節點後接續新增一個 HTTP Request 節點（呼叫 LINE Reply API）：
   - Method: POST
   - URL: https://api.line.me/v2/bot/message/reply
   - Authentication: 選擇 Header Auth（使用已建立的 Authorization: Bearer <Channel Access Token> 憑證）。
   - Body (JSON):
     {
       "replyToken": "={{ $('解析 LINE 訊息').item.json.replyToken }}",
       "messages": [
         {
           "type": "text",
           "text": "={{ $json.text || $json.output }}"
         }
       ]
     }
請直接幫我在畫布上建立並完成串接！
```
</details>
