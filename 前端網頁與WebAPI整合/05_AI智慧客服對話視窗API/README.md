# 🌐 前端網頁與 WebAPI 整合
## 範例 5：AI 智慧客服浮動對話視窗 API（即時語意對話與 RAG 串接）

### 📚 工作流程說明

想要為企業官方網站快速加入像 Intercom 或 Zendesk 的**智能客服浮動對話視窗（Chat Widget）**嗎？

本範例展示：
1. **極致美觀的浮動對話視窗**：提供純 HTML/CSS/JS 打造的現代化右下角客服 Widget，具備展開/收合平滑動畫、快捷問題膠囊標籤（Chips）、打字中指示器與自動捲動效果。
2. **n8n 後端 AI Agent 大腦**：Webhook 接收前端傳來的 `sessionId` 與使用者問題，透過 **AI Agent** 與語言模型（OpenAI `gpt-4o-mini` / Gemini）進行多輪上下文對話。
3. **即時雙向應答**：透過 **Respond to Webhook 節點** 即時回傳 AI 生成的繁體中文解答，為網站訪客提供 7x24 小時不間斷的智慧諮詢服務。

---

### 流程架構圖

```mermaid
flowchart LR
    A["💬 訪客點擊網站右下角客服 Widget (website/index.html)"] -->|1. POST /ai-chat-api { sessionId, message }| B["⚡ Webhook 節點 (POST)"]
    
    subgraph n8n_Backend_API["n8n AI 客服核心"]
        C["🧠 語言模型 (OpenAI / Gemini)"] --> D["🤖 網站 AI 客服代理 (AI Agent)"]
        E["💾 Window Buffer Memory (依 sessionId 記住對話)"] --> D
        D --> F["📤 Respond to Webhook 節點"]
    end
    
    B --> D
    F -->|2. 回傳 { success, reply, sessionId }| G["📱 前端對話視窗即時渲染 AI 回答"]
```

---

### 工作流程與前端檔案下載

- [📥 n8n WebAPI 工作流程樣版 (05_ai_chat_widget_api_workflow.json)](./05_ai_chat_widget_api_workflow.json)
- [💻 前端浮動 AI 客服網頁原始碼 (website/index.html)](./website/index.html)

---

#### 📋 節點詳細說明

1. **📝 流程說明（Sticky Note）**
   - **功能**：介紹前端 Widget 如何透過 UUID/SessionId 與 n8n 後端維持獨立對話狀態。

2. **⚡ 接收前端 AI 對話請求 (POST)（Webhook Node）**
   - **HTTP Method**：`POST`
   - **Path**：`ai-chat-api`
   - **Response Mode**：`Using 'Respond to Webhook' Node`

3. **🤖 網站 AI 客服代理（AI Agent Node）**
   - **Prompt**：`={{ $json.body.message }}`
   - **System Message**：定義客服人設（繁體中文、親切專業）。

4. **💾 Window Buffer Memory 節點**
   - **Session Key**：`={{ $('接收前端 AI 對話請求 (POST)').item.json.body.sessionId }}`（依瀏覽器訪客隔離對話記憶）。

5. **📤 即時回傳 AI 回答給前端（Respond to Webhook Node）**
   - **Response Body**：`{ "success": true, "reply": $json.output, "sessionId": ... }`

---

#### 🧪 測試與驗證方法

1. **瀏覽器介面測試**：
   - 開啟 `website/index.html`。
   - 點擊右下角的紫色 💬 按鈕打開對話框。
   - 點選快捷膠囊按鈕「💼 服務項目」或自行輸入「請問你們有什麼服務？」。
   - 觀察打字中動畫與 AI 即時回覆！
   - 接著詢問：「那要怎麼聯絡你們？」，測試 AI 是否記得前一句對話。

2. **curl 命令行測試**：
   ```bash
   curl -X POST http://localhost:5678/webhook/ai-chat-api \
     -H "Content-Type: application/json" \
     -d '{
       "sessionId": "test_user_001",
       "message": "你好，我想了解 n8n 自動化課程"
     }'
   ```

---

#### 🎯 學習重點

- **Session 隔離機制**：前端在網頁載入時生成唯一 `sessionId`，傳入 n8n 作為 Memory 的 Session Key，實現不同瀏覽器訪客對話歷史完全獨立。
- **低成本全功能客服**：無須每月支付高昂的 SaaS 客服月費，直接在企業官網嵌入自建的 AI 客服系統。

---

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 為客服代理掛載 Supabase / Pinecone 向量知識庫工具，回答私有產品文件。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在「網站 AI 客服 WebAPI」流程中掛載向量知識庫檢索工具：
1. 新增 Vector Store Tool 節點，連接 Supabase / Pinecone 向量資料庫。
2. 串接 OpenAI Embeddings 模型。
3. 將工具連接至 AI Agent 的 Tools 輸入端。
4. 更新 System Message 要求 AI 優先查閱知識庫內容回覆。
請幫我配置好節點與連線！
```
</details>
