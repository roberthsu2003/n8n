# 雲端資料庫整合

歡迎來到 n8n 雲端資料庫整合教學！工作流執行完資料就消失了，想要「記住」報名名單、訂單、借閱紀錄，或讓 AI 讀懂公司文件，就需要資料庫。本章前半段使用 **Supabase（PostgreSQL）** 儲存與統計業務資料，後半段使用 **Pinecone 向量資料庫** 打造會查文件的 AI 助理。

每個範例都是一個生活化的情境，並附上**自動產生的測試資料**（SQL 腳本、CSV、知識文件），不需要自己準備任何資料，匯入就能動手做。

**資料表與欄位都用繁體中文命名**（例如 `SELECT 品名, 單價 FROM 早餐品項`），SQL、Supabase 畫面和 n8n 節點輸出都看得懂，不用再對照英文欄位。

> 💡 **AI 協作時代學習法**：在學習完基礎節點操作並透過 MCP 連線 AI（Gemini、ChatGPT 或 Claude）後，您可以直接複製每個範例下方的 **「AI 賦能延伸實作」** 折疊區塊（`<details>`）內的 Prompt，交由 AI 助理替您在畫布上全自動建構與擴充進階邏輯！

## 🔑 前置準備

本章使用的服務都有免費方案，**不需要綁信用卡**：

1. [🐘 Supabase 註冊與 n8n 連線設定](./Supabase設定/README.md)（範例 01～04、07）
2. [🌲 Pinecone 註冊與 n8n 連線設定](./Pinecone設定/README.md)（範例 05～07）
3. [🤖 Gemini 與 Gmail 憑證設定](./Gemini與Gmail憑證/README.md)（AI 與寄信）

## 📚 範例導覽

本教學提供七個完整的實作範例，從免寫 SQL 的資料表操作、SQL 統計報表、排程提醒，到讓 AI 查資料庫、查文件，最後整合兩種資料庫完成自動客服：

| 範例 | 情境 | 資料庫 | 核心技術 |
| :---: | :--- | :--- | :--- |
| 01 | 社團活動報名系統 | 🐘 Supabase | Supabase 節點 CRUD、View、表單 |
| 02 | 早餐店每日營收日報 | 🐘 Supabase | SQL JOIN／GROUP BY、參數化查詢、HTML 郵件 |
| 03 | 圖書館逾期還書提醒 | 🐘 Supabase | 日期運算、json_agg、狀態回寫防重複 |
| 04 | 網拍小賣家 AI 資料助理 | 🐘 Supabase | AI Agent + Postgres Tool、唯讀帳號 |
| 05 | 公司員工手冊問答機器人 | 🌲 Pinecone | RAG、切塊、Embedding、Namespace |
| 06 | 餐廳菜單智慧推薦 | 🌲 Pinecone | CSV 向量化、Metadata Filter |
| 07 | 維修中心客服信自動回覆 | 🌲 + 🐘 | Gmail Trigger、結構化輸出、草稿審核、Upsert |

---

## 第一部分：Supabase（PostgreSQL）

### 1. [範例：社團活動報名系統](./01_社團活動報名系統/README.md)

學生用表單報名社團活動，系統即時檢查剩餘名額與是否重複報名，有名額才寫入資料庫並寄出確認信。全程使用 Supabase 節點，**不用寫 SQL**。

**學習重點**：
- 使用 Supabase 節點 Create／Get Many／Delete 操作資料表
- 用 Filters 設定查詢條件（Equals、多條件 AND）
- 用資料庫 View 即時計算剩餘名額
- Always Output Data 處理「查無資料」的情況
- n8n Form 的多種結果頁（成功、額滿、重複）

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：額滿時不再直接拒絕，改為加入候補名單；有人取消報名時，自動寄信通知第一順位候補者。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我擴充目前的「01 社團活動報名系統」工作流程，加入候補名單功能：
1. 我會先在 Supabase 建立資料表「社團候補」（欄位：編號, 活動編號, 姓名, 電子郵件, 候補時間），名稱都是中文。
2. 修改報名流程：「還有名額？」IF 節點的 False 分支，不要直接顯示名額已滿，改為：
   - 使用 Supabase 節點（Create）把報名者寫入「社團候補」。
   - 使用 Supabase 節點（Get Many）查詢該活動目前有幾位候補，算出他是第幾順位。
   - Form Ending 顯示「名額已滿，您已列入候補第 N 位，有空位時會寄信通知您」。
3. 修改取消報名流程：「有刪除到資料？」為 True 時：
   - 用 Supabase 節點查詢該活動「社團候補」中 候補時間 最早的一筆（Limit 1）。
   - 如果有候補者，用 Gmail 寄信通知他「目前有空位，請在 24 小時內重新報名」。
4. 請幫我在畫布上建立所需節點、設定 Filters 與表達式，並完成連線！
```
</details>

---

### 2. [範例：早餐店每日營收日報](./02_早餐店每日營收日報/README.md)

每天早上 8 點自動統計早餐店昨天的營收、熱銷前五名與各時段營收，整理成 HTML 日報寄給老闆。測試資料用 SQL 自動產生 30 天、約 1,700 筆擬真訂單。

**學習重點**：
- Postgres 節點 Execute Query
- 參數化查詢 `$1` 防止 SQL Injection
- `JOIN` 多表關聯、`GROUP BY` 分組統計、`COUNT(*) FILTER` 條件計數
- Execute Once 避免重複查詢
- Code 節點整合多個查詢結果，用 HTML 製作郵件報表

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：在日報中加入 Gemini 撰寫的「今日營運建議」，讓數字變成老闆看得懂的行動建議。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我升級「02 早餐店每日營收日報」工作流程：
1. 新增一個 Postgres 節點「最近 7 天每日營收」（Execute Once），SQL 查詢 早餐訂單 資料表最近 7 天每天的訂單數與營收（欄位：下單時間、訂單金額）（以報表日期為基準）。
2. 在「組合 HTML 日報」之前，新增 Basic LLM Chain 節點並連接 Google Gemini Chat Model（models/gemini-2.5-flash）。
3. Prompt 內容：提供「營收總覽」「熱銷前五名」「各時段營收」「最近 7 天每日營收」四份資料（用 JSON.stringify 帶入），
   請 AI 以早餐店顧問的角度，用繁體中文寫出 3 點、每點 40 字以內的營運建議（例如備料、人力安排、促銷）。
4. 修改 Code 節點，把 AI 建議放在日報最下方「💡 今日營運建議」區塊。
5. 請幫我建立節點、設定表達式並完成連線！
```
</details>

---

### 3. [範例：圖書館逾期還書提醒](./03_圖書館逾期還書提醒/README.md)

每天早上找出逾期未還的讀者，一人一封信列出所有逾期的書與罰款，依逾期天數自動調整語氣，寄出後回寫提醒日期，同一天不會重複寄。

**學習重點**：
- PostgreSQL 日期運算 `CURRENT_DATE - 應還日期`
- `IS NULL` 判斷空值
- `json_agg` 把多列合併成 JSON 陣列
- Code 節點 Run Once for Each Item
- 寄信後 `UPDATE` 回寫狀態，避免重複通知
- `$('節點').item` 取得配對的資料

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：加入「到期前提醒」與「館員彙整通知」，讓提醒系統更完整。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我擴充「03 圖書館逾期還書提醒」工作流程：
1. 從「設定」節點拉出第二條分支「到期前提醒」：
   - Postgres 節點查詢 借閱紀錄 中 歸還日期 IS NULL 且 應還日期 = CURRENT_DATE + 2 的借閱，JOIN 圖書館讀者 與 館藏書籍（資料表與欄位都是中文）。
   - 用 Gmail 寄出「您借閱的《書名》將於 2 天後到期」的提醒信（收件人用設定節點的 測試信箱）。
2. 在原本「更新提醒紀錄」之後，新增彙整通知：
   - 使用 Aggregate 節點（或 Code 節點）把今天所有被提醒、且 最多逾期天數 >= 30 的讀者整理成一份清單。
   - 若清單不是空的，用 Gmail 寄一封「嚴重逾期讀者清單」給館員，以 HTML 表格列出姓名、電話、逾期書名與天數。
3. 請幫我建立節點、撰寫 SQL 並完成連線！
```
</details>

---

### 4. [範例：網拍小賣家 AI 資料助理](./04_網拍小賣家AI資料助理/README.md)

不會 SQL 也能查資料庫！用聊天的方式問「上個月哪個商品賣最好？」「哪些快沒庫存？」，AI Agent 自己寫 SQL 查 Supabase 並用表格回答。AI 使用唯讀帳號，就算寫錯也改不到資料。

**學習重點**：
- AI Agent 搭配 Postgres Tool，讓 AI 自己寫 SQL
- `$fromAI()` 讓 AI 填入工具參數
- System Prompt 中描述資料表結構與商業規則
- 認識 Supabase MCP：讓 AI 自己探索資料庫，並比較兩種做法的權限差異
- 建立唯讀資料庫角色，在資料庫層級保護資料
- 用 View 簡化資料結構，提高 AI 查詢正確率

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：讓 AI 資料助理能把查詢結果畫成圖表，並把助理搬到 Telegram 上隨時使用。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我升級「04 網拍小賣家 AI 資料助理」工作流程：
1. 新增一個 HTTP Request Tool 節點，命名為 make_chart，連接到 AI Agent 的 Tool：
   - 呼叫 https://quickchart.io/chart，以 GET 方式帶入參數 c（Chart.js 設定 JSON）。
   - c 的值使用 $fromAI('chart_config', 'Chart.js 的設定 JSON 字串，包含 type、data.labels、data.datasets', 'string')。
   - 工具描述：「把數據畫成圖表，回傳圖片網址」。
2. 在 AI Agent 的 System Message 最後加上規則：「使用者要求看趨勢、比較或比例時，先查詢資料，再呼叫 make_chart 產生圖表，並在回答中附上圖片網址。」
3. 測試問題：「畫出最近 6 個月每月營收的長條圖」。
請幫我建立節點、設定參數並完成連線！
```
</details>

---

## 第二部分：Pinecone 向量資料庫

### 5. [範例：公司員工手冊問答機器人](./05_公司員工手冊問答機器人/README.md)

把員工手冊放進 Pinecone，新人用自己的話問「年假有幾天？」「出差住宿可以報多少？」，AI 從手冊找到相關段落後回答，並註明依據的章節。

**學習重點**：
- RAG（檢索增強生成）的運作原理
- 文件切塊（Chunk Size、Overlap、Markdown 切分）
- Gemini Embedding 與 Pinecone Index 維度必須一致（3072）
- Namespace 區隔不同知識庫，Clear Namespace 避免重複資料
- Pinecone 檢索工具搭配 AI Agent，工具節點需用英文命名

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：HR 只要更新 Google Drive 裡的手冊，知識庫就自動重建，不用再手動上傳。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我修改「05 公司員工手冊問答機器人」的流程 A（建立知識庫）：
1. 新增 Google Drive Trigger 節點，監控「HR 文件」資料夾，事件為 File Updated 與 File Created，每 5 分鐘檢查一次。
2. 串接 Google Drive 節點（Download file），下載觸發的檔案；若是 Google 文件，轉換為純文字（text/plain）格式下載。
3. 將下載的檔案接到原本的「寫入 Pinecone」節點（namespace: handbook，Clear Namespace 開啟），沿用原本的 Data Loader、Text Splitter 與 Gemini Embeddings。
4. 寫入完成後，用 Gmail 寄一封通知給 HR：「員工手冊知識庫已更新：檔名、更新時間、寫入段落數」。
5. 保留原本的表單上傳流程作為備用。請幫我建立節點並完成連線！
```
</details>

---

### 6. [範例：餐廳菜單智慧推薦](./06_餐廳菜單智慧推薦/README.md)

40 道菜的菜單 CSV 一鍵上架到 Pinecone，每道菜帶有價格、辣度、素食、過敏原標籤。客人說「不吃辣、吃素、預算 250」，AI 就能精準推薦並算好總價。

**學習重點**：
- 把表格資料（CSV）的每一列轉成一筆向量
- Default Data Loader 自訂文字內容與 Metadata
- Metadata Filter：先精確篩選、再語意搜尋
- 一個 AI Agent 搭配多個檢索工具
- 在 System Prompt 中處理飲食限制與預算計算

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：新增「不吃辣」專用工具，並把客人最後決定的點餐內容記錄到 Supabase。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我擴充「06 餐廳菜單智慧推薦」工作流程：
1. 複製「search_vegetarian_menu」節點，命名為 search_mild_menu：
   - Metadata Filter 改為 辣度 = 0。
   - 工具描述：「只搜尋完全不辣的菜色，客人說不吃辣、怕辣、帶小孩時使用」。
   - 連接同一個 Gemini Embeddings 與 AI Agent。
2. 新增一個 Postgres Tool 節點，命名為 save_order，讓 AI 在客人說「就點這些」時呼叫：
   - 執行 INSERT INTO 點餐紀錄 (點了哪些菜, 總金額, 備註) VALUES ($1, $2, $3)，參數由 $fromAI 提供。
   - 我會先在 Supabase 建立「點餐紀錄」資料表（編號, 點了哪些菜 text, 總金額 int, 備註 text, 建立時間），名稱都是中文。
3. 更新 AI Agent 的 System Message，說明兩個新工具的使用時機。
請幫我建立節點、設定參數並完成連線！
```
</details>

---

### 7. [範例：維修中心客服信自動回覆](./07_維修中心客服信自動回覆/README.md)

本章總結範例。Gmail 收到客服信後，AI 查 Pinecone 的維修 FAQ 寫好回覆並存成草稿，同時在 Supabase 建立客服工單。Pinecone 負責「找答案」，Supabase 負責「記錄與統計」。

**學習重點**：
- Gmail Trigger 自動讀信、Gmail 建立草稿與標記已讀
- Structured Output Parser 讓 AI 回傳固定格式 JSON
- 讓 AI 同時做分類、判斷緊急程度、撰寫回覆
- Human-in-the-loop：只建草稿、由真人審核
- Postgres Insert or Update（Upsert）避免重複工單
- 向量資料庫與關聯式資料庫的分工

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：依分類自動加上 Gmail 標籤，緊急件即時通知店長，並每天寄出待處理工單清單。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我擴充「07 維修中心客服信自動回覆」工作流程：
1. 在「標記為已讀」之後新增 Gmail 節點（Message ➔ Add Label），依 $('AI 客服').item.json.output.問題分類 加上對應標籤（例如「維修/費用」「維修/保固」），標籤我會先在 Gmail 建立好。
2. 新增 IF 節點判斷 緊急程度 是否為「緊急」，若是則用 Gmail 寄一封通知給店長，主旨「🚨 緊急維修件：{{問題摘要}}」，內容包含客人 Email 與原信內容。
3. 另外建立一條排程分支（每天 18:00）：
   - Postgres 查詢 維修工單 中今天建立、處理狀態 為「需人工處理」或「草稿待審」的工單。
   - 用 HTML 表格整理後，以 Gmail 寄給客服主管。
請幫我建立所需節點、設定表達式並完成連線！
```
</details>

---

## 📁 其他資料夾

- [共用知識庫文件](./共用知識庫文件/)：更多可以拿來練習 RAG 的文件（家電手冊、健保指南、租屋契約等），可替換範例 05 的員工手冊做練習。
- [舊版範例](./舊版範例/README.md)：改版前的範例，僅供參考。

**🎓 完成這些範例後，您將能夠用資料庫保存與分析業務資料，並打造會查文件、會查資料庫的 AI 助理！**
