# 整合 Webhook 的實作

Webhook 是現代自動化系統的核心技術之一，它允許外部應用程式透過 HTTP 請求來即時觸發 n8n 工作流程。透過 Webhook，您可以將 n8n 當作自訂的 API 伺服器，接收表單提交、金流付款通知、IoT 感測器訊號或第三方系統事件。

> 💡 **AI 協作時代學習法**：在學習完基礎節點操作並透過 MCP 連線 AI（Gemini、ChatGPT 或 Claude）後，您可以直接複製每個範例下方的 **「AI 賦能延伸實作」** 折疊區塊（`<details>`）內的 Prompt，交由 AI 助理替您在畫布上全自動建構與擴充進階邏輯！

---

## 📚 什麼是 Webhook？

Webhook 是一種「反向 API (Reverse API)」或「事件驅動推播」的概念：
- **傳統 API 輪詢（Pull）**：您的應用程式必須每隔幾秒主動發送請求「拉取」是否有新資料，耗費網路頻寬且有延遲。
- **Webhook 推播（Push）**：當外部事件發生時（如使用者提交表單、收到訊息、完成結帳），外部服務會自動發送 HTTP 請求「推送」資料到您的 n8n 端點，實現真正的零延遲即時自動化。

---

## 📚 實作範例導覽

本教學提供四個循序漸進的實作範例，從基礎的 POST 請求解析、電商訂單計算，到二進位檔案上傳與生產級安全分流驗證：

---

### 1. [範例一：自動化問候系統](./自動化問候系統/README.md)
**難度**: 初級 | **學習時間**: 30-40 分鐘

透過 Webhook 接收外部 POST 請求，驗證使用者資料並回傳個人化問候訊息。

**學習重點**：
- Webhook 觸發器的基礎設定與 HTTP Method (POST)
- 理解 Webhook 接收的資料結構（`$json.body`）
- IF 節點的條件判斷（檢查姓名是否存在）
- Set 節點的資料處理與欄位整理
- Respond to Webhook 節點的 JSON 回應

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 擴充自動化問候系統，自動依據時間（早安/午安/晚安）與性別動態生成富有溫度的客製化問候語。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在目前的「自動化問候系統」工作流程中進行延伸升級：
1. 保持原本的 Webhook 觸發器（POST /greeting）。
2. 在「檢查姓名」後，加入 Code 節點判斷當前伺服器時間：
   - 早上 (05:00 - 11:59)：早安
   - 下午 (12:00 - 17:59)：午安
   - 晚上 (18:00 - 04:59)：晚安
3. 若輸入資料包含 gender: "male" 或 "female"，問候語分別加上「先生」或「小姐」。
4. 整理輸出為：greeting（問候語）、client_ip（來自 headers 的 IP）、timestamp。
5. 最後透過 Respond to Webhook 回傳 200 JSON 結果。
請幫我建立相關節點與運算邏輯！
```
</details>

---

### 2. [範例二：即時訂單接收與計算](./即時訂單接收與計算/README.md)
**難度**: 初中級 | **學習時間**: 35-45 分鐘

模擬購物車結帳事件，接收包含多筆商品的 JSON 訂單，由 Code 節點自動計算金額、VIP 折扣與免運門檻並回傳電子收據。

**學習重點**：
- 接收巢狀 JSON 結構（含品項清單陣列 `items`）
- 使用 JavaScript Code 節點進行商業運算（單項小計、全單總計、折扣、運費）
- 動態產生自訂訂單編號與時間戳記
- 即時回傳標準 JSON 訂單確認收據

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 在訂單成立後自動過濾大額訂單，發送警示通知並記錄至 Google Sheets / DataTable。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在目前的「即時訂單接收與計算」工作流程中進行延伸升級：
1. 在「運算金額與折扣」節點之後，新增一個條件判斷（IF 節點）。
2. 若 final_amount >= 2000，將該筆大額訂單標記為 priority: "high"，並呼叫通知節點（或發送電子郵件至主管信箱）。
3. 同時將訂單編號、顧客姓名、實付金額與下單時間追加記錄到 Google Sheets 或 DataTable 中。
4. 最後確保「回傳訂單確認」節點依然能順利回傳 200 JSON 收據給前端。
請幫我建立相關節點並完成連線配置！
```
</details>

---

### 3. [範例三：檔案上傳與自動處理](./檔案上傳與自動處理/README.md)
**難度**: 中級 | **學習時間**: 40-50 分鐘

學習如何透過 Webhook 接收外部上傳的實體二進位檔案（`multipart/form-data`），並自動解析檔案內容。

**學習重點**：
- Webhook 接收二進位檔案資料 (Binary Property `data`)
- 使用 Extract from File 節點自動將上傳的 CSV 轉為 JSON
- 統計資料筆數與生成資料預覽摘要
- 使用 curl 命令列工具進行檔案上傳測試

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 為上傳的 CSV 資料自動寫入 DataTable，若發現異常資料自動發送警示。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我擴充目前的「檔案上傳與自動處理」工作流程：
1. 在 Extract from File 解析出 CSV 的每筆資料後，新增一個 DataTable 節點，將所有資料批次寫入「學生成績單」表格中。
2. 加入資料檢查邏輯：若任何學生成績欄位為空或非數字，收集這些異常名單。
3. 在 Respond to Webhook 回應中，額外回傳匯入成功筆數 (success_count) 與異常資料清單 (invalid_records)。
請直接幫我規劃並配置這些節點！
```
</details>

---

### 4. [範例四：多事件分流與安全驗證](./多事件分流與安全驗證/README.md)
**難度**: 中高級 | **學習時間**: 45-60 分鐘

建立具備生產級安全認證與多事件路由的 Webhook API，支援 Header Token 檢查與 Switch 分流。

**學習重點**：
- 檢查 HTTP Header 自訂金鑰 (`x-api-key`)
- 驗證失敗時直接回傳 `401 Unauthorized` 狀態碼阻斷
- 使用 Switch 節點根據 `event_type` 進行多路事件分流（新會員註冊、訂單付款、未知事件）
- 多分支處理後匯流至統一的 Respond to Webhook

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 增加退款申請事件分支，並依金額自動判斷是否由系統直接核准。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在「多事件分流與安全驗證」工作流程中加入進階功能：
1. 擴充 Switch 節點，增加第 3 個事件分支：refund_requested（退款申請事件）。
2. 在 refund_requested 分支中，新增一個 Code 節點，檢查退款金額是否小於 1000 元（若是則自動批准並設定 status: "auto_approved"；若否則標記需人工審核 status: "manual_review"）。
3. 同樣匯流至「回傳處理結果」節點回傳給調用端。
請直接幫我更新 Switch 規則並新增處理節點與連線！
```
</details>

---

## 🔧 Webhook 核心觀念與設定重點

### 1. Test URL vs Production URL
* **Test URL (`/webhook-test/...`)**：當在 n8n 點擊「Listen for test event」時專用，只會接收單次請求，適合開發除錯。
* **Production URL (`/webhook/...`)**：必須將右上角切換為 **Active（已啟用）** 才會 7x24 常駐監聽外部請求。

### 2. 資料存取路徑差異
* **POST / PUT Body 資料**：資料會包裝在 `body` 物件內，表達式需寫為 `{{ $json.body.欄位名稱 }}`。
* **GET 查詢參數**：參數會包裝在 `query` 物件內，表達式需寫為 `{{ $json.query.參數名稱 }}`。
* **Headers 請求標頭**：標頭存在於 `headers` 物件內，例如 `{{ $json.headers['x-api-key'] }}`。

### 3. Response Mode（回應模式）
* **On received (預設)**：接收到請求立刻回傳 200 OK，後續節點非同步執行（適合耗時較長的背景任務）。
* **Using 'Respond to Webhook' Node**：等待流程處理完畢後，由 Respond to Webhook 節點回傳運算結果與指定狀態碼（適合即時查詢與 API 回應）。

---

## 📚 相關資源

- [n8n 官方 Webhook 節點文件](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)
- [n8n 簡介與安裝](../n8n簡介與安裝/README.md)（含 ngrok 固定網址設定）
- [AI 協作指南與 MCP 連線教學](../AI協作/README.md)
- [HTTP 請求方法與狀態碼 (MDN)](https://developer.mozilla.org/zh-TW/docs/Web/HTTP/Methods)

---

**🎓 完成這些範例後，您將具備建立企業級 API 與事件驅動自動化系統的核心能力！**
