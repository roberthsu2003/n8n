# 基礎範例 3：Sentiment Analysis（文字情緒與滿意度分析）

## 📚 工作流程說明

即時掌握顧客情緒與社群輿情是提升客戶滿意度的關鍵！

**Sentiment Analysis** 節點利用大語言模型強大的語意理解能力，精準分析文字背後的情感傾向（例如：Positive 正面、Neutral 中立、Negative 負面），並輸出信心評分（Confidence Score）。透過與 IF 條件節點結合，可以第一時間過濾出極度不滿的客訴，自動發送 Telegram / LINE 警報給主管介入處理。

> 🤖 **模型註冊與串接指南（推薦資安合規主軸）**：
> - [**NVIDIA NIM 微服務模型串接**](../../nvidia_nim/README.md)（推薦 `meta/llama-3.3-70b-instruct`）
> - [**OpenRouter 多模型聚合平台**](../../openrouter/README.md)（推薦 `meta-llama/llama-3.3-70b-instruct`）

---

## 🧭 工作流程架構

```mermaid
flowchart LR
    Trigger["👆 Manual Trigger"] --> Review["💬 模擬顧客評論/留言<br/>(含強烈負面客訴)"]
    Review --> Sentiment["😊 Sentiment Analysis<br/>(分析情感與信心指數)"]
    Model["🧠 NVIDIA NIM / OpenRouter<br/>(OpenAI Chat Model)"] -.->|語意判定| Sentiment
    Sentiment --> Check{"判斷是否為負面<br/>(sentiment == negative)"}
    Check -->|True 是| Alert["🚨 發送緊急主管通報<br/>(Telegram / Slack)"]
    Check -->|False 否| Log["📝 存入一般常規評論日誌"]
```

---

## 📥 工作流程圖下載

- [下載範例流程：Sentiment_Analysis.json](./Sentiment_Analysis.json)

---

## 📋 節點詳細說明

1. **📝 Sticky Note（便利貼）**
   - 標記教學重點與情緒分流機制。

2. **🔄 模擬顧客評論與客訴 (Edit Fields)**
   - 包含訂單編號 `order_id` 與一段表達延誤與客服失聯的強烈不滿文字。

3. **😊 Sentiment Analysis（情緒分析節點）**
   - **Text**：傳入文字 `{{ $json.review_text }}`。
   - **輸出屬性**：
     - `sentiment`：判定之情緒（positive, neutral, negative 或自訂標籤）。
     - `confidence_score`：模型判定之信心評分（0~1）。

4. **🔀 是否為負面客訴？(IF 節點)**
   - 條件規則：`{{ $json.sentiment }} == "negative"`。
   - **True 分支**：串接緊急通報，附帶訂單編號與評論原文。
   - **False 分支**：記錄至一般資料表。

5. **🧠 OpenAI Chat Model（連接 NVIDIA NIM / OpenRouter）**
   - 透過標準 OpenAI 相容介面提供高效的情感分析推理。

---

## ⚙️ 節點設定指南與參數詳解

在 n8n 中配置 `Sentiment Analysis` 節點時，需注意以下核心設定：

### 1. 必填參數：Text to Analyze（待分析文字）
- **欄位作用**：告訴 AI 模型哪一段文字需要進行情感與情緒傾向分析。
- **填寫方式**：點擊輸入框右側的 **Expression（表達式）** 模式，引用前置節點帶入的變數，例如：
  ```text
  {{ $json.review_text }}
  ```
  *(若上游欄位名稱為 `message` 或 `content`，則填 `{{ $json.message }}` 或 `{{ $json.content }}`)*
- ⚠️ **注意事項**：此欄位為必填項（有紅色驚嘆號），若未填入文字或表達式，節點將無法執行。

### 2. 底部模型插槽：Model *（語言模型）
- 節點底部標有紅星的 `Model *` 插槽為**必要連接**。
- 必須從畫布下方拉線連接一個語言模型節點（如 `OpenAI Chat Model`、`NVIDIA NIM`、`OpenRouter` 或 `Ollama Chat Model`），以提供語意判斷能力。

### 3. Options 進階選項（點擊 Add Option）
- **Sentiment Property**：自訂輸出情緒結果的欄位名稱（預設為 `sentiment`）。
- **Score Property**：自訂信心分數欄位名稱（預設為 `confidence_score`，數值介於 0 ~ 1）。
- **自訂情緒分類（Custom Sentiments）**：除預設的 `positive` / `neutral` / `negative` 之外，可自訂細部標籤（如 `urgent_complaint`、`praise`、`refund_request` 等）。

### 4. 節點輸出資料結構範例
執行後，節點會在原 JSON 物件中自動附加情緒分析結果：
```json
{
  "order_id": "ORD-20260901-889",
  "review_text": "已經等了超過一個星期都沒有收到商品，客服完全沒人理，要求全額退款！",
  "sentiment": "negative",
  "confidence_score": 0.98
}
```

---

## 🎯 學習重點

- **情感傾向判定**：理解 LLM 如何解讀文字語意並標記情緒。
- **信心指標運用**：透過信心評分可過濾模糊不清的評論。
- **自動化危機預警**：學習「AI 分析 ➔ 條件判斷 ➔ 即時警報」的經典自動化模式。

---

## 💡 實際應用場景

- Google 商家、App Store / Google Play 用戶評論每日自動情緒評級。
- 客服信箱進線時，自動將負面嚴重情緒的郵件標記為高優先級（High Priority）。
- 社群品牌風向即時監控（公關危機預警）。

---

## 🤖 AI 賦能延伸實作（附 Prompt 提詞）

<details>
<summary>👉 點擊展開可直接複製給 AI 助理的 Prompt 提詞</summary>

> 💡 **任務目標**：透過 AI 自訂五星級滿意度標籤，並根據情緒自動擬定不同語氣的回覆草稿。

```text
請幫我在目前的「Sentiment Analysis」流程中進行升級：
1. 將 Sentiment Analysis 的情緒標籤自訂為 5 等級：5_star_praise, 4_star_satisfied, 3_star_neutral, 2_star_minor_issue, 1_star_furious。
2. 串接一個 Basic LLM Chain 節點：根據判定出的等級自動生成適當語氣的繁中公關回覆（例如 5 星表達感謝並給予折扣碼；1 星表達誠摯歉意並主動提供客服專線）。
請幫我配置好節點與提示詞！
```
</details>
