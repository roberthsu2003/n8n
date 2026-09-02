# 基礎範例 6：Question and Answer Chain（RAG 規章知識庫問答）

## 📚 工作流程說明

在自動化客服與企業問答中，通用大語言模型（如 GPT、Llama、Claude）常常會產生「幻覺（Hallucination）」或回答過時的資訊。

**Question and Answer Chain（檢索問答鏈）** 是建構 **RAG（Retrieval-Augmented Generation，檢索增強生成）** 的標準專用 AI 節點。透過將企業內部的「售後規章、產品手冊、保固條款」載入向量資料庫，當使用者提問時，系統會先**精準檢索出相關的規章段落**，再交由 AI **嚴格根據該段落作答**，徹底消除胡言亂語！

> 🤖 **模型註冊與串接指南（推薦資安合規主軸）**：
> - [**NVIDIA NIM 微服務模型串接**](../../nvidia_nim/README.md)（推薦 `meta/llama-3.3-70b-instruct`）
> - [**OpenRouter 多模型聚合平台**](../../openrouter/README.md)（推薦 `meta-llama/llama-3.3-70b-instruct`）

---

## 🧭 工作流程架構（RAG 6 大節點層級串接鏈）

在 n8n 中，Question and Answer Chain 的底層 LangChain 架構具有**嚴格的型別插槽相依性**：

```mermaid
flowchart TD
    Trigger["👆 Manual Trigger"] --> Question["💬 模擬顧客提問<br/>(進水是否保固？退貨多久？)"]
    Question --> QAChain["❓ Question and Answer Chain<br/>(RAG 檢索問答核心)"]
    QAChain --> Answer["🎯 整理與輸出政策解答<br/>(依規章確認：進水不保固/退款3天)"]
    
    Model["🧠 Chat Model<br/>(NVIDIA NIM / OpenRouter)"] -.->|1. ai_languageModel| QAChain
    
    subgraph RAG_Stack ["🗄️ 知識庫檢索完整階層鏈條"]
        RetrieverNode["🔍 Vector Store Retriever<br/>(檢索適配器)"]
        VectorStore["🗄️ In-Memory Vector Store<br/>(向量儲存庫)"]
        Embeddings["🔤 Embeddings Model<br/>(text-embedding-3-small)"]
        DocLoader["📄 預載售後政策規章<br/>(Default Data Loader)"]
        Splitter["✂️ Recursive Character Text Splitter<br/>(文本切片器)"]
        
        RetrieverNode -.->|2. ai_retriever (必接)| QAChain
        VectorStore -.->|3. ai_vectorStore (必接)| RetrieverNode
        Embeddings -.->|4. ai_embedding (必接)| VectorStore
        DocLoader -.->|5. ai_document (必接)| VectorStore
        Splitter -.->|6. ai_textSplitter (必接)| DocLoader
    end
```

---

## 📥 工作流程與資料檔案下載

- [下載修復與完整連線範例流程：Question_and_Answer_Chain.json](./Question_and_Answer_Chain.json)
- [查看/下載售後規章偽資料文本：售後服務與保固政策規章.txt](./售後服務與保固政策規章.txt)

---

## 🛠️ 常見錯誤排查：為什麼原本的畫布會亮紅燈？

### 🔴 致命錯誤 1：`In-Memory Vector Store` 無法直接連到 `QA Chain`
- **原因剖析**：
  - `Question and Answer Chain` 底部插槽要求的型別是 **`Retriever *`（`ai_retriever`）**。
  - `In-Memory Vector Store` 節點輸出的型別是 **`Vector Store`（`ai_vectorStore`）**。
  - 兩者型別不相容，因此 Vector Store 無法直接連入 QA Chain，導致 Vector Store 孤立飄在畫布上，QA Chain 的 Retriever 插槽呈現空白並亮紅燈！
- **解決方案**：
  - 在兩者之間必須加入一個 **`Vector Store Retriever`** 節點作為「檢索適配器」！

---

### 🔴 致命錯誤 2：`Default Data Loader` 缺少 `Text Splitter *`
- **原因剖析**：
  - 在 n8n 中，`Default Data Loader` 節點負責載入長篇文章，但它需要知道「如何切片」，因此底部標有紅星的 **`Text Splitter *`** 插槽為必連項目。
- **解決方案**：
  - 在下方連接一個 **`Recursive Character Text Splitter`** 節點（Chunk Size 1000, Chunk Overlap 200）。

---

### 🔴 致命錯誤 3：`Embeddings Model` 缺少憑證
- **解決方案**：
  - 確保已選取有效 OpenAI / OpenRouter 憑證，並選用 `text-embedding-3-small`。

---

---

## 📄 預載售後政策規章（Default Data Loader 偽資料文本）

在 `Default Data Loader` 節點中，我們預先載入了一份結構完整、條款明確的企業售後規章偽資料，供向量檢索器進行語意比對：

```text
【TechCorp 數位智能 產品售後服務與保固政策總規章（2026年版）】

一、 原廠保固範圍與期限
1. 凡購買本公司全系列正品，憑購買發票、電子訂單憑證或產品保固卡，享有自簽收日起算「1 年（12 個月）原廠有限保固服務」。
2. 保固期內，若屬非人為因素引起之硬體功能故障、晶片瑕疵或零組件異常，本公司提供免費檢測與免費維修更換服務。

二、 人為損壞與除外條款（非免費保固項目）
以下情況均不在免費保固範圍內，本公司將依檢測情況酌收零件工本費與檢測服務費（基本檢測費 500 元）：
1. 液體滲入損壞：產品因進水、受潮、浸泡液體、飲料潑灑或汗水侵蝕導致之機板短路與零件鏽蝕。
2. 物理外力撞擊：因重摔、擠壓、撞擊導致外殼破裂、螢幕碎裂或內部結構損毀。
3. 非原廠拆修：未經原廠授權私自拆解、改裝、更換副廠零件或刷除非官方韌體者。
4. 天災不可抗力：因雷擊、水災、火災、地震等天然災害造成之損壞。

三、 7 天猶豫期與退貨規範
1. 猶豫期計算：依照消費者保護法規定，線上通路訂購之商品享有自收件次日起算「7 天猶豫期（鑑賞期）」。
2. 猶豫期非試用期：辦理退貨之商品必須保持全新未拆封狀態，包含主機、配件、原廠包裝盒、說明書、發票及贈品皆需完整無缺。
3. 退貨運費負擔：在 7 天猶豫期內提出合規退貨申請，由本公司委派物流免費到府取件。

四、 退款時程與作業天數
1. 驗收時效：本公司售後中心於收到退回包裹後，將於 1 個工作天內完成商品完整性驗收。
2. 款項返還：
   - 信用卡付款：確認驗收無誤後，將於「3 個工作天內」完成信用卡線上刷退。
   - ATM / 貨到付款：將於「5 個工作天內」將款項全額匯入買方指定之銀行帳戶。

五、 新品不良（DOA）換貨規範
1. 若商品於收件後「15 天內」發生非人為之功能性故障，本公司將免費提供原箱換新機服務。

六、 客服諮詢專線
- 客服專線：0800-888-999（週一至週五 09:00 - 18:00）
- 線上報修：https://service.techcorp.com
```

---

## 🎯 學習重點

- **嚴格型別插槽架構**：理解 n8n LangChain 節點中 Chain ➔ Retriever ➔ Vector Store ➔ Embeddings / Document ➔ Splitter 的 6 級依賴關係。
- **零幻覺保證**：限制模型只能依據檢索到的政策回答，絕不胡亂捏造。
- **完全告別孤立節點**：掌握適配器概念，徹底消除所有紅色未連線警告。

---

## 💡 實際應用場景

- **內部企業 HR 規章查詢機器人**：員工詢問請假、報帳、差旅補助辦法。
- **電商客服售後 FAQ 機器人**：精準解答退貨條件、保固範圍、物流時效。
- **產品操作手冊技術支援**：依據說明書解答特定錯誤代碼與障礙排除步驟。

---

## 🤖 AI 賦能延伸實作（附 Prompt 提詞）

<details>
<summary>👉 點擊展開可直接複製給 AI 助理的 Prompt 提詞</summary>

> 💡 **任務目標**：透過 AI 助理將 Question and Answer Chain 連接 Webhook 與通訊軟體，打造即時客服問答機器人。

```text
請幫我在目前的「Question and Answer Chain」工作流程中升級為線上客服機器人：
1. 起點改為接收 Webhook（或 Chat Trigger）傳入的顧客問題 {{ $json.chatInput }}。
2. 透過 Question and Answer Chain 連接知識庫進行檢索回答。
3. 串接 LINE Notify（或 Telegram / Slack）節點，將問題與 AI 依據規章回答的內容發送給顧客。
請幫我配置好連線與變數對應！
```
</details>
