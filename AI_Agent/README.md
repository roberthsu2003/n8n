# 🤖 n8n AI 應用與智慧代理（AI Agent）全方位教學

歡迎來到 **n8n AI 應用與智慧代理（AI Agent）學習專區**！

為了讓學習路徑更加清晰、循序漸進，我們將所有教學內容規劃為 **四大循序漸進階段**：從最純粹穩定的「專用 AI 節點」，過渡到具備自主思考的「AI Agent」，深入探索「企業級 RAG 向量知識庫」，最後落地至「多代理協同與全渠道自動化中樞」。

> 💡 **AI 協作時代學習法**：在學習完基礎節點操作並透過 MCP 連線 AI（Gemini、ChatGPT 或 Claude）後，您可以直接複製每個範例內的 **「AI 賦能延伸實作」** Prompt 提詞，交由 AI 助理替您在畫布上全自動建構與擴充進階邏輯！

---

## 🤖 核心模型主軸與註冊指引

在開始進行 AI 工作流建構前，請先完成以下任一或兩個推薦平台的模型 API 註冊與憑證串接（支援免費額度、標準 OpenAI 相容 API、且符合企業與政府機關資安合規）：

• 🤖 **AI 助手與模型註冊**：[**NVIDIA NIM 微服務模型串接**](../nvidia_nim/README.md) ｜ [**OpenRouter 多模型聚合平台 (資安合規)**](../openrouter/README.md)

---

## 🧭 專用節點 vs AI Agent 快速決策指南

在 n8n 中，請根據任務特性選擇最適合的架構：

| 比較項目 | 🟢 專用基礎 AI 節點 / Chains | 🟡🔴 AI Agent 智慧代理 |
| :--- | :--- | :--- |
| **代表節點** | `Basic LLM Chain`, `Information Extractor`, `Text Classifier`, `Sentiment Analysis`, `Summarization Chain`, `Question & Answer Chain` | `AI Agent` (Tools Agent) |
| **決策邏輯** | **確定性單向流程**（輸入 ➔ 處理 ➔ 輸出） | **自主推理循環**（思考 ➔ 決定工具 ➔ 執行 ➔ 總結） |
| **工具調用** | 無（專注於單一文字處理任務） | 具備（自主決定呼叫 API、計算機、搜尋或子工作流） |
| **速度與成本** | ⚡ 最快、Token 消耗少、結果穩定可控 | 🧠 消耗較多 Token、具備多輪推理能力 |
| **適用情境** | 翻譯、非結構文字轉 JSON、情緒打分、意圖分類、長文摘要、文件檢索問答 | 互動客服機器人、動態多工具調度、多代理團隊協同 |

---

## 📚 四大階段學習導覽（點擊進入各階段專案）

請點擊下方四大階段連結，進入專屬目錄開始學習：

---

### [🟢 階段一：基礎專用 AI 節點（了解基本 AI 的使用）](./階段一_基礎專用AI節點/README.md)

*適合初學者的第一站！掌握確定性單向處理鏈，建立對 Prompt、JSON Schema、情緒與意圖分類的扎實基礎。*

- **包含範例**：
  1. [**Basic LLM Chain**](./階段一_基礎專用AI節點/Basic_LLM_Chain/README.md)：基礎提示詞與多語言文案潤飾
  2. [**Information Extractor**](./階段一_基礎專用AI節點/Information_Extractor/README.md)：自然語言轉強型別 JSON 欄位（取代 Regex）
  3. [**Sentiment Analysis**](./階段一_基礎專用AI節點/Sentiment_Analysis/README.md)：顧客語氣情感分析與負面客訴預警
  4. [**Text Classifier**](./階段一_基礎專用AI節點/Text_Classifier/README.md)：文字意圖分類與多路業務派工路由
  5. [**Summarization Chain**](./階段一_基礎專用AI節點/Summarization_Chain/README.md)：長篇大論、會議記錄與文章智慧濃縮
  6. [**Question & Answer Chain**](./階段一_基礎專用AI節點/Question_and_Answer_Chain/README.md)：基礎文件檢索問答鏈（RAG 入門）

👉 **[進入階段一完整教學 ➔](./階段一_基礎專用AI節點/README.md)**

---

### [🟡 階段二：AI Agent 核心與工具調用](./階段二_AI_Agent核心與工具調用/README.md)

*邁入自主代理領域！學習具備「記憶模組」與「外部工具調用能力」的 AI Agent 架構。*

- **包含範例**：
  1. [**智能客服聊天機器人**](./階段二_AI_Agent核心與工具調用/智能客服聊天機器人/README.md)：Chat Trigger、System Prompt 與連續對話記憶
  2. [**臺北市 YouBike 2.0 即時查詢**](./階段二_AI_Agent核心與工具調用/台北市youbike站點資訊查詢/README.md)：單一 HTTP Request API 工具掛載與資料轉譯
  3. [**即時天氣與新聞助理**](./階段二_AI_Agent核心與工具調用/天氣和新聞查詢_使用Ollama/README.md)：多工具並存決策與 `$fromAI()` 動態參數注入

👉 **[進入階段二完整教學 ➔](./階段二_AI_Agent核心與工具調用/README.md)**

---

### [🟠 階段三：企業級 RAG 向量知識庫](./階段三_企業級RAG向量知識庫/README.md)

*徹底杜絕 AI 幻覺！建構企業級私有文件檢索增強生成（RAG）架構與向量資料庫。*

- **包含範例**：
  1. [**入門版：記憶體儲存 RAG**](./階段三_企業級RAG向量知識庫/01_記憶體儲存入門/README.md)：In-Memory Vector Store、上傳即問答
  2. [**基礎版：Supabase 雲端儲存 RAG**](./階段三_企業級RAG向量知識庫/02_Supabase雲端向量庫/README.md)：索引與查詢分離、雲端資料庫建置
  3. [**基礎版：RAG 檢索策略與來源過濾**](./階段三_企業級RAG向量知識庫/03_檢索策略與來源過濾/README.md)：意圖分析、動態 Metadata Filter 注入、Postgres 記憶
  4. [**進階版：本地 PostgreSQL + PGVector**](./階段三_企業級RAG向量知識庫/04_本地PostgreSQL向量庫/README.md)：完全私有化控管
  5. [**進階版：雲端專用 Pinecone 向量庫**](./階段三_企業級RAG向量知識庫/05_Pinecone雲端向量庫/README.md)：百萬級向量即時檢索與 Google Drive 串接

👉 **[進入階段三完整教學 ➔](./階段三_企業級RAG向量知識庫/README.md)**

---

### [🔴 階段四：企業級進階實戰與多代理](./階段四_企業級進階實戰與多代理/README.md)

*落地真實企業場景！跨系統子流程調度、多代理團隊協同作業與全渠道客服中樞。*

- **包含範例**：
  1. [**萬能工作流助理**](./階段四_企業級進階實戰與多代理/具備工具使用能力的助理/README.md)：Call n8n Workflow Tool 調用獨立子工作流程
  2. [**Gmail 客服郵件分類歸檔**](./階段四_企業級進階實戰與多代理/郵件智能分類系統/README.md)：結構化 JSON 輸出與 Google Sheets 工單自動化閉環
  3. [**多代理人協作團隊**](./階段四_企業級進階實戰與多代理/多代理協作系統/README.md)：Supervisor 主管 Agent 調度「研究員」與「文案師」
  4. [**全渠道客戶服務自動化平台**](./階段四_企業級進階實戰與多代理/客戶服務自動化平台/README.md)：統一 Webhook、意圖分流、人機轉接與工單追蹤

👉 **[進入階段四完整教學 ➔](./階段四_企業級進階實戰與多代理/README.md)**

---

## 🎯 建議學習順序

```
【第一步：基礎紮根】階段一：基礎專用 AI 節點 ➔ 掌握 6 大核心 Chain 節點
       ↓
【第二步：升級代理】階段二：AI Agent 核心與工具調用 ➔ 掌握自主決策與 API 工具
       ↓
【第三步：私有知識】階段三：企業級 RAG 向量知識庫 ➔ 掌握文件切塊、向量儲存與語意檢索
       ↓
【第四步：多代理落地】階段四：企業級進階實戰與多代理 ➔ 打造多代理團隊與全渠道中樞
```
