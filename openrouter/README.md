# OpenRouter 整合與設定指南 🌐

**OpenRouter** 是一個全球領先的多模型聚合平台（AI Model Aggregator），提供單一相容於 **OpenAI API** 的統一端點，讓使用者能一鍵調用來自全球頂尖 AI 實驗室（如 Meta、Google、Anthropic、OpenAI、Mistral AI 等）的數百種模型。透過 OpenRouter，公務機關與企業無須在各大平台個別申請帳號與儲值，即可在 n8n 中靈活切換不同場景所需的最佳模型。

---

## 🏛️ 政府機關資通安全合規與選型原則

> [!IMPORTANT]
> **落實公務機關資安合規規範（非陸資模型原則）**  
> 依據我國資通安全法規及行政院「各機關使用生成式 AI 參考指引」，公務機關執行各項公務與內部自動化流程時，**嚴禁採用大陸廠牌、陸資背景或伺服器位於受限區域之模型**（例如 DeepSeek、Qwen 通義千問、Yi 零一萬物、ChatGLM、Moonshot Kimi、MiniMax、Baichuan 等）。

### OpenRouter 提供的資安防護與隱私功能：
1. **零數據留存政策（Zero Data Retention, ZDR）**：OpenRouter 支援勾選 ZDR 端點，保證傳輸內容不會被用於模型二次訓練，亦不會持久保存。
2. **完全透明的模型供應商來源**：每個模型均清楚標註發布者、部署伺服器位置（如 Google Cloud、AWS 美國節點、Together AI、Fireworks 等）。
3. **靈活的自訂白名單**：機構可嚴格限定僅允許連線至美國與歐洲之模型供應商。

---

## 📋 目錄

- [1. 適合政府機關之非中國推薦模型清單](#1-適合政府機關之非中國推薦模型清單)
- [2. 註冊 OpenRouter 帳號與取得 API Key](#2-註冊-openrouter-帳號與取得-api-key)
- [3. 在 n8n 中串接 OpenRouter](#3-在-n8n-中串接-openrouter)
  - [步驟一：建立 OpenAI Credential 憑證](#步驟一建立-openai-credential-憑證)
  - [步驟二：在工作流中配置 OpenAI Chat Model 節點](#步驟二在工作流中配置-openai-chat-model-節點)
- [4. API 終端機連線驗證 (cURL)](#4-api-終端機連線驗證-curl)
- [5. 常見問題與排錯指南 (FAQ)](#5-常見問題與排錯指南-faq)

---

## 1. 適合政府機關之非中國推薦模型清單

以下為公務機關推薦之**歐美頂級、安全合規且具備高度繁體中文與 Agent 能力**的精選模型清單：

| 模型名稱 (Model ID) | 發布團隊 / 國別 | 類型與價格等級 | 核心優勢與適用公務場景 |
| :--- | :--- | :--- | :--- |
| **`meta-llama/llama-3.3-70b-instruct`** *(首選推薦)* | Meta（美國） | 開源旗艦 / 極低成本（提供 `:free` 免費版） | **公文撰寫、公務諮詢、工作流 Agent**<br>開源最強 70B 模型，繁中語意理解優秀，Tool Calling 穩定。 |
| **`google/gemini-2.0-flash-001`** | Google（美國） | 商業商用 / 超低成本 | **百萬 Token 超長公文分析、高速反應、多模態**<br>推論延遲極低、支援大量法規文件對比與圖表解析。 |
| **`mistralai/mistral-large-2411`** | Mistral AI（法國） | 歐洲旗艦 / 中等成本 | **跨國公文翻譯、進階推理、高難度邏輯審查**<br>歐盟頂尖模型，嚴格遵循歐盟 GDPR 隱私標準。 |
| **`mistralai/codestral-2501`** | Mistral AI（法國） | 歐洲開源 / 低成本 | **JavaScript / Python 自動化腳本生成與 Debug**<br>專為 Code 邏輯最佳化，適合 n8n Code Node 程式碼輔助。 |
| **`anthropic/claude-3.5-sonnet`** | Anthropic（美國） | 商業旗艦 / 高品質 | **深度公文報告撰寫、複雜 Agentic 任務規劃**<br>全球公認邏輯最強、文筆細膩且指令遵循度最高之模型。 |
| **`openai/gpt-4o-mini`** | OpenAI（美國） | 商業商用 / 極低成本 | **即時智能客服機器人、一般性資料分類與摘要**<br>兼顧 OpenAI 生態系相容性與極致性價比。 |

> [!TIP]
> OpenRouter 針對部分開源模型（如 `meta-llama/llama-3.3-70b-instruct:free`、`google/gemini-2.0-flash-thinking-exp:free`）提供免費調用端點，非常適合教學、展示與概念驗證（PoC）。

---

## 2. 註冊 OpenRouter 帳號與取得 API Key

1. **前往官網**：打開瀏覽器造訪 [OpenRouter 官方網站 (openrouter.ai)](https://openrouter.ai/)。
2. **註冊 / 登入**：點擊右上角 **Sign In**，支援 Google、GitHub 或 Email 登入。
3. **建立 API Key**：
   - 點擊右上角個人頭像 ➔ 選擇 **Keys**（或直接進入 [openrouter.ai/keys](https://openrouter.ai/keys)）。
   - 點擊 **Create Key**。
   - 輸入 Key Name（例如 `n8n-gov-workflow`）。
   - 可選填信用額度上限（Credit limit），點擊 **Create**。
   - 複製生成的 API Key（格式為 `sk-or-v1-...`），請妥善保存。
4. **（選用）帳戶儲值**：若需使用付費模型，進入 **Credits** 頁面進行儲值（支援信用卡與各大主流支付，低至 $5 美元即可開始）。

---

## 3. 在 n8n 中串接 OpenRouter

OpenRouter 完全相容於 OpenAI 規範，在 n8n 中只需透過內建的 **OpenAI Chat Model** 節點並設定自訂 Base URL 即可直接連線。

### 步驟一：建立 OpenAI Credential 憑證

1. 開啟 n8n 管理後台，點選左側 **Credentials** ➔ **Add Credential**。
2. 搜尋並選取 **OpenAI API**。
3. 填入設定：
   - **Credential Name**：`OpenRouter API`
   - **API Key**：貼上以 `sk-or-v1-...` 開頭的 OpenRouter API Key。
4. 點擊 **Save** 完成儲存。

---

### 步驟二：在工作流中配置 OpenAI Chat Model 節點

1. 在工作流中新增 **AI Agent**、**AI Chat** 或 **Basic LLM Chain** 節點。
2. 在 Model 輸入點點擊 `+` 號，新增 **OpenAI Chat Model** 節點。
3. 節點參數配置如下：
   - **Credential for OpenAI**：選擇剛剛建立的 `OpenRouter API`。
   - **Model**：選擇 `Custom Model Name`，輸入完整的 Model ID（例如 `meta-llama/llama-3.3-70b-instruct` 或 `google/gemini-2.0-flash-001`）。
   - **Base URL (關鍵設定)**：展開下方 **Options** ➔ 勾選 **Base URL**，輸入：
     ```text
     https://openrouter.ai/api/v1
     ```
   - **Temperature**：公務分析與法規諮詢建議設為 `0.2`；一般問答建議設為 `0.7`。

### 🚀 一鍵複製測試工作流 (Workflow JSON)

學員可直接點擊下載 **[👉 下載 OpenRouter_測試工作流.json](./OpenRouter_測試工作流.json)**，或**展開複製下方 JSON 程式碼**，回到 n8n 畫布空白處按下 `Ctrl + V` (Windows) 或 `Cmd + V` (Mac) 即可一鍵貼上完整測試工作流！

<details>
<summary><b>點此展開 / 複製完整工作流程 JSON 程式碼 📋</b></summary>

```json
{
  "name": "OpenRouter 測試工作流",
  "nodes": [
    {
      "parameters": {
        "content": "## 🌐 OpenRouter 快速測試指南\n\n**如何測試：**\n1. 點擊下方 **OpenAI Chat Model** 節點\n2. 選擇你的 **OpenRouter API** 憑證（填入 `sk-or-v1-...`）\n3. 點擊 **Chat Trigger (聊天觸發)** 節點上的 **「Chat」** 按鈕發送訊息測試！\n\n> 💡 **模型推薦**：預設採用開源旗艦 `meta-llama/llama-3.3-70b-instruct`。",
        "height": 260,
        "width": 380,
        "color": 7
      },
      "id": "openrouter-guide-note",
      "name": "📋 使用說明",
      "type": "n8n-nodes-base.stickyNote",
      "position": [
        -200,
        -100
      ],
      "typeVersion": 1
    },
    {
      "parameters": {
        "options": {}
      },
      "id": "openrouter-chat-trigger",
      "name": "When chat message received",
      "type": "@n8n/n8n-nodes-langchain.chatTrigger",
      "position": [
        -200,
        200
      ],
      "typeVersion": 1.1
    },
    {
      "parameters": {
        "options": {
          "systemMessage": "你是一個專業的公務智慧助理，請以繁體中文親切、專業、結構化地回答使用者的問題。"
        }
      },
      "id": "openrouter-ai-agent",
      "name": "AI Agent",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "position": [
        60,
        200
      ],
      "typeVersion": 1.7
    },
    {
      "parameters": {
        "model": "meta-llama/llama-3.3-70b-instruct",
        "options": {
          "baseURL": "https://openrouter.ai/api/v1",
          "temperature": 0.5,
          "maxTokens": 1024
        }
      },
      "id": "openrouter-openai-model",
      "name": "OpenAI Chat Model (OpenRouter)",
      "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
      "position": [
        60,
        420
      ],
      "typeVersion": 1.2
    }
  ],
  "connections": {
    "When chat message received": {
      "main": [
        [
          {
            "node": "AI Agent",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "OpenAI Chat Model (OpenRouter)": {
      "ai_languageModel": [
        [
          {
            "node": "AI Agent",
            "type": "ai_languageModel",
            "index": 0
          }
        ]
      ]
    }
  },
  "settings": {
    "executionOrder": "v1"
  }
}
```

</details>

---

## 4. API 終端機連線驗證 (cURL)

在終端機中執行以下指令，快速測試 OpenRouter 連線與模型回覆（請替換 `YOUR_OPENROUTER_API_KEY`）：

```bash
curl -X POST "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer YOUR_OPENROUTER_API_KEY" \
  -H "HTTP-Referer: https://n8n.io" \
  -H "X-Title: n8n Workflow" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/llama-3.3-70b-instruct",
    "messages": [
      {
        "role": "user",
        "content": "請以繁體中文說明公務機關導入自動化工作流的三大效益。"
      }
    ],
    "temperature": 0.3
  }'
```

---

## 5. 常見問題與排錯指南 (FAQ)

### Q1：調用模型時回傳 `402 Payment Required`？
- **原因**：帳戶餘額不足，或者所選模型非免費版。
- **解決方式**：若為測試目的，可使用帶有 `:free` 標籤的模型（例如 `meta-llama/llama-3.3-70b-instruct:free`），或至 OpenRouter 後台儲值點數。

### Q2：如何確保公務資料不被特定供應商用於訓練？
- **解決方式**：前往 OpenRouter 官方設定頁面 [openrouter.ai/settings/privacy](https://openrouter.ai/settings/privacy)，開啟 **Zero Data Retention** 選項，即可自動過濾掉不支援 ZDR 的端點。

### Q3：模型名稱格式如何確認？
- **解決方式**：請直接至 [OpenRouter Models 瀏覽頁面](https://openrouter.ai/models) 搜尋模型，點擊右上角複製正確的完整 Model ID（例如 `mistralai/mistral-large-2411`，包含團隊前綴斜線）。
