# 初階範例

歡迎來到 n8n 初階範例教學！這裡提供了一系列適合初學者的實作範例，幫助您從零開始學習 n8n 的基本操作和核心概念。

> 💡 **AI 協作時代學習法**：在學習完基礎節點操作並透過 MCP 連線 AI（Gemini、ChatGPT 或 Claude）後，您可以直接複製每個範例下方的 **「AI 賦能延伸實作」** 折疊區塊（`<details>`）內的 Prompt，交由 AI 助理替您在畫布上全自動建構與擴充進階邏輯！

## 📚 範例導覽

本教學提供六個完整的實作範例，從最基礎的資料處理、API 串接到檔案格式轉換與內建資料表，幫助您循序漸進掌握 n8n：

---

### 1. [範例：初體驗](./初體驗/README.md)
**難度**: 初級 | **學習時間**: 15-20 分鐘

第一個 n8n 工作流！學習基本的觸發與資料傳遞。

**學習重點**：
- 手動觸發工作流程 (Manual Trigger)
- 從資料來源獲取資料 (Customer Datastore)
- 使用 Set (Edit Fields) 節點整理資料欄位
- 理解 n8n 的資料流向與訊息發送

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 為客戶名單加入在地化問候語判斷，並自動產生客製化郵件通知內容。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在目前的 n8n 畫布上，延伸「初體驗」工作流程：
1. 讀取 Customer Datastore 取得的客戶名單。
2. 透過 Edit Fields (Set) 節點增加一個欄位 greetingMessage。
3. 規則：若 country 為 "TW" 則開頭加上「親愛的 {{ $json.name }} 您好！」，若是其他國家則加上「Dear {{ $json.name }}, Welcome!」。
4. 將組合好的個人化訊息傳遞給 Customer Messenger 節點輸出。
請幫我規劃並配置好節點連線與表達式。
```
</details>

---

### 2. [範例：透過互動式逐步教程學習 JSON 基礎](./json基礎/README.md)
**難度**: 初級 | **學習時間**: 20-25 分鐘

JSON 是自動化流程的資料核心。透過這個互動式實作範例，您將學會如何建立和操作 JSON 格式。

**學習重點**：
- JSON 語法基礎（鍵值對、資料型態）
- 六種基本 JSON 資料型態（字串、數字、布林值、陣列、物件、Null）
- n8n 表達式 `{{ ... }}` 的使用
- 資料結構化與引用

<details>
<summary>🤖 <strong>AI 賦能延伸實作（建立全新工作流 Prompt）</strong></summary>

> 💡 **從無到有建立全新工作流**：
> 透過 MCP 連線，AI 不僅能修改既有流程，更具備**「從零自動建立全新工作流」**的能力！只要以自然語言描述需求，AI 就能在 n8n 畫布上自動新增工作流、建立所有節點、填入測試資料、設定欄位表達式並完成串接。

**可直接複製給 AI 的 Prompt 提詞（建立全新工作流）**：
```text
請在 n8n 替我從無到有建立一個全新的「進階 JSON 巢狀資料處理」工作流程：
1. 建立一個全新的空白工作流，命名為「進階 JSON 巢狀資料實戰」。
2. 起點使用 Manual Trigger 節點。
3. 串接一個 Code 節點或 Set 節點，生成一組包含會員與訂單資訊的巢狀 JSON 物件（例如：customer_name: "王小明"、is_vip: true、items 陣列：包含多筆商品名稱、單價與數量）。
4. 接續新增一個 Set (Edit Fields) 節點，使用 n8n 表達式提取出：
   - 購買總品項數量 (items.length)
   - 第一個購買的商品名稱 (items[0].name)
   - 判斷是否為 VIP 並回傳折扣文字（如「享 VIP 9 折優惠」）
5. 請直接幫我在畫布上建立所有節點、配置好表達式語法並完成連線！
```
</details>

---

### 3. [範例：透過網站取得隨機引言](./透過網站取得隨機引言/README.md)
**難度**: 初級 | **學習時間**: 15-20 分鐘

學習如何使用 **HTTP Request** 節點發送請求並抓取外部 API 資料。

**學習重點**：
- HTTP 請求的基本概念 (GET 方法)
- 使用 HTTP Request 節點呼叫外部 API (`https://zenquotes.io/api/random`)
- 資料處理與欄位重新命名
- n8n 表達式的實際應用

<details>
<summary>🤖 <strong>AI 賦能延伸實作（串接本地 Ollama 模型 Prompt）</strong></summary>

> 💡 **任務目標**：抓取英文名言後，由本地 **Ollama** 模型（`gemma4:31b-cloud`）自動翻譯為繁體中文，並生成 30 字的今日行動啟發建議。

> ⚠️ **執行前準備（重要）**：
> 1. 本機需先安裝 [Ollama](https://ollama.com/)。
> 2. 請先在終端機執行指令以預先下載並啟動模型：
>    ```bash
>    ollama run gemma4:31b-cloud
>    ```
> 3. 確保本機 Ollama 服務處於運行狀態（預設埠號為 `11434`），這樣 n8n 才能順利連線調用該模型。

**可直接複製給 AI 的 Prompt 提詞**：
```text
我想將「取得隨機引言」工作流程升級為「每日 AI 哲理金句機器人」：
1. 保留原本的 HTTP Request 節點（向 https://zenquotes.io/api/random 抓取引言）。
2. 在後面串接 Basic LLM Chain（或 AI Agent）節點，並連接「Ollama Chat Model」模型節點。
3. Ollama 模型請指定使用 `gemma4:31b-cloud`（Base URL 請依環境設定為 http://localhost:11434 或 http://host.docker.internal:11434）。
4. 設定 AI Prompt 提詞：將抓到的英文名言（{{ $json.q }}）與作者（{{ $json.a }}）翻譯為優美的繁體中文，並自動生成一句 30 字以內的「今日行動建議與啟發」。
5. 最後將英文原文、中文翻譯與行動啟發整理為結構化的 JSON 輸出。
請直接幫我在工作流中新增、設定好這些節點並完成連線！
```
</details>

---

### 4. [範例：CSV轉換為Excel](./csv轉換為Excel/README.md)
**難度**: 中級 | **學習時間**: 25-30 分鐘

學習如何下載政府開放資料 CSV 檔案，並將其轉換為 Excel (.xlsx) 格式。

**學習重點**：
- HTTP 請求下載二進位檔案
- 處理二進位資料 (Binary Data)
- 使用 Extract from File 節點解析 CSV
- 使用 Convert to File 節點轉換為 Excel

**練習資源**：
- [財務報表 PDF 範例](https://www.sample-videos.com/pdf/Sample-pdf-5-mb.pdf)
- [發票報表範例](https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dense/invoice.pdf)

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：由 AI 在 CSV 轉換過程中插入篩選器，只篩選「高薪且特定地區」的職缺再匯出為 Excel。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我擴充目前的「CSV 轉換為 Excel」工作流程：
1. 在 Extract from File 解析出 CSV 的 JSON 資料後，插入一個 Filter 或 Code 節點。
2. 篩選條件：只保留職缺薪資（月薪）大於 40,000 元，且工作地點在「臺北市」的職缺。
3. 整理欄位為：公司名稱、職缺名稱、薪資待遇、工作地點。
4. 將篩選後的資料再接進 Convert to File 節點轉換為 Excel (.xlsx) 檔案。
請幫我調整節點順序並完成條件設定！
```
</details>

---

### 5. [範例：DataTable 簡單操作](./DataTable/)
**難度**: 初級 | **學習時間**: 20 分鐘

學習如何使用 n8n 內建 DataTable 功能進行永久性資料存儲與查詢。

**學習重點**：
- n8n 內建 DataTable 基本概念
- 透過手動或 CSV 匯入建立「學生成績單」
- 使用 DataTable 節點進行資料讀取、新增與過濾

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 AI 自動計算 DataTable 中學生的平均成績、總分排名，並列出待加強名單。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我建立一個操作 DataTable「學生成績單」的智慧分析工作流程：
1. 使用 DataTable 節點讀取「學生成績單」中的所有學生成績（name, chinese, english, math）。
2. 撰寫一個 Code 節點計算：
   - 全班國文、英文、數學的各科平均分數
   - 總分最高的前 3 名學生姓名與總分
   - 任何一科不及格（< 60 分）的待加強學生清單
3. 將計算結果彙整成乾淨的總結報告 JSON 輸出。
請幫我生成完整的節點配置與 JavaScript 運算邏輯！
```
</details>

---

### 6. [範例：n8n 內建表單節點](./表單節點/)
**難度**: 中級 | **學習時間**: 25-30 分鐘

學習如何使用 Form Trigger 快速建立網頁輸入表單，提交後自動寫入 DataTable。

**學習重點**：
- n8n 內建 Form Trigger 節點欄位設計
- 表單驗證與資料提交
- 自動將表單資料寫入 DataTable

**影音參考**：
- [YouTube 內建表單參考影片 1](https://youtu.be/yGm0X6YtME4?si=HGcvQFlu4LdA2B8o)
- [YouTube 內建表單參考影片 2](https://youtu.be/HPIfP_IN95o?si=81ag2Cuw9u-DKqUR)

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：學生填寫成績表單後，AI 自動生成「個人化學習診斷評語」，並即時顯示於表單完成頁面。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我升級「學生成績輸入表單」工作流程：
1. 當使用者透過 Form Trigger 提交學生姓名與各科成績後，先將資料寫入 DataTable「學生成績單」。
2. 接著串接一個 AI 生成節點（或智慧評語邏輯），根據學生的成績表現產生一段 100 字左右的「個人化學習診斷評語」（例如：數學優秀請保持、英文基礎需加強）。
3. 最後在表單提交後的回應頁面（Respond to Webhook / Form Response），動態顯示「提交成功！AI 導師給 [姓名] 的評語：[評語內容]」。
請幫我規劃並配置此自動化流程！
```
</details>

---

## 📚 相關資源

- [n8n 官方文件](https://docs.n8n.io/)
- [n8n 官方教學範例](https://blog.n8n.io/tag/tutorial/)
- [n8n 簡介與安裝](../n8n簡介與安裝/README.md)
- [AI 協作指南與 MCP 連線教學](../AI協作/README.md)

---

**🎓 完成這些範例後，您將具備基礎的 n8n 操作能力，可以開始探索更進階的 AI Agent 與多服務整合功能！**
