# 天氣和新聞查詢（使用 Ollama）

## 工作流名稱:天氣和新聞查詢_使用Ollama

## 重要技巧：[**$fromAI()**](#fromAI說明)

## 📚 學習目標

在掌握基本對話功能後，學習如何讓 AI Agent 具備**工具使用能力**。透過 Ollama 本地模型，建立一個能夠查詢天氣和新聞的智能助理，無需雲端 API 金鑰即可實作。

## 🎯 難度等級

**難度**: ⭐⭐☆ (初級到中級)  
**學習時間**: 45-60 分鐘  
**階段**: 階段一：基礎入門（進階）

## 📌 學習前提

建議先完成 [**智能客服聊天機器人**](../智能客服聊天機器人/README.md) 範例，理解 AI Agent 的基本對話功能後，再學習本範例的工具使用能力。

## 工作流架構

![天氣和新聞查詢_使用Ollama](./images/天氣和新聞查詢_使用Ollama.png)

## 工作流下載

[天氣和新聞查詢工作流下載](./天氣和新聞查詢_使用Ollama.json)

## 📋 工作流程說明

這是**第二個 AI Agent 範例**，在基本對話功能的基礎上，加入了**工具使用能力**。這個範例展示如何使用 Ollama 本地 LLM 模型建立一個功能完整的 AI 代理，能夠：
- 接收並理解用戶的對話訊息
- **自主選擇合適的工具來回答問題**（核心新功能）
- **獲取即時天氣資訊**（使用 HTTP Request Tool）
- **檢索最新新聞內容**（使用 RSS Feed Read Tool）
- 保持對話記憶與脈絡
- 提供即時且有用的答案

## 💡 為什麼這個範例很重要？

**學習重點**：
- ✅ **工具使用能力**：學習如何讓 AI 自主選擇和使用工具
- ✅ **實用功能**：天氣查詢和新聞檢索是實際常見的需求
- ✅ **零成本學習**：使用 Ollama 本地模型，無需 API 費用
- ✅ **漸進式學習**：從純對話進階到工具整合

**與前一個範例的差異**：
- 第一個範例（智能客服）：只有純對話功能
- 本範例：加入了**工具選擇**和**外部資料獲取**能力

**適用場景**：
- 需要即時資訊的智能助理
- 學習 Tool-Using Agent 的概念
- 建立多功能的 AI 系統
- 工具擴展的實驗平台

## 🔧 使用節點

- **Chat Trigger**（聊天觸發器）- 對話入口，接收用戶訊息
- **AI Agent**（AI 代理核心）- 決策中心，選擇適當工具
- **Ollama Chat Model**（本地語言模型）- 使用 Ollama 運行 LLM
- **Conversation Memory**（對話記憶）- 保持對話上下文
- **Get Weather Tool**（天氣工具）- 獲取天氣預報資訊
- **Get News Tool**（新聞工具）- 讀取 RSS 新聞動態

## 🎓 教學重點

### 1. AI Agent 的工作流程

你的 AI 代理運作分為三個步驟：

1. **接收（Receive）**：
   - 從聊天介面接收用戶訊息
   - 理解用戶的意圖和需求

2. **選擇（Choose）**：
   - 分析問題類型
   - 決定使用哪個工具或直接回答
   - 例如：天氣問題 → Get Weather Tool
   - 例如：新聞問題 → Get News Tool

3. **回應（Respond）**：
   - 執行選定的工具
   - 整合工具返回的資料
   - 生成自然語言回應

### 2. System Message（系統訊息）的設計

System Message 定義了 AI 代理的：
- **角色定位**：你是什麼身份？
- **核心能力**：你能做什麼？
- **行為規範**：你應該如何回應？
- **工具使用**：如何選擇和使用工具？

**本範例的 System Message 重點**：
```
<role>
你是 n8n Demo AI Agent，一個友善且樂於助人的助理，
專門展示 n8n 自動化平台中 AI 代理的強大功能。
</role>

<instructions>
- 透過智能使用可用工具來回答用戶問題
- 保持對話式且鼓勵性的語氣
- 主動建議用戶可以嘗試的問題範例
</instructions>
```

### 3. 對話記憶（Conversation Memory）

**Window Buffer Memory** 的運作方式：
- 保存最近 30 則訊息（可調整）
- 自動管理記憶體使用
- 提供對話上下文給 AI
- 讓 AI 能理解前後關聯

**範例場景**：
```
用戶: "巴黎的天氣如何？"
AI: "巴黎今天溫度 15°C，多雲..."

用戶: "那明天呢？"  ← AI 能理解「那」指的是巴黎
AI: "巴黎明天溫度 17°C，晴天..."
```

### 4. 工具使用（Tool Usage）

**Get Weather Tool** - HTTP Request Tool：
- 使用 Open-Meteo API 獲取天氣資料
- AI 會自動推斷地理座標
- 支援當前、每小時、每日天氣預報
- 無需 API 金鑰，免費使用

**Get News Tool** - RSS Feed Read Tool：
- 讀取各種 RSS 新聞源
- 支援 BBC、CNN、TechCrunch、n8n Blog 等
- 獲取最新文章標題和摘要
- AI 會根據主題選擇合適的 RSS 源

### 5. Ollama 模型設定

**使用的模型**：`gpt-oss:20b`
- 20 億參數的開源模型
- 適合一般對話和工具使用
- 運行需要約 12GB 記憶體

**其他可選模型**：
- `llama2:7b` - 較小、較快
- `mistral:7b` - 效能均衡
- `llama2:13b` - 更好的理解能力
- `codellama:7b` - 適合程式相關

## ⚙️ 設定步驟

### 前置準備：安裝 Ollama

**macOS**：
```bash
brew install ollama
```

**Linux**：
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

**Windows**：
從 [Ollama 官網](https://ollama.ai) 下載安裝程式

### 步驟一：下載 LLM 模型

啟動 Ollama 並下載模型：
```bash
ollama pull gpt-oss:20b
```

驗證模型是否可用：
```bash
ollama list
```

### 步驟二：設定 Ollama 連接

1. 在 n8n 中加入 **Ollama Chat Model** 節點
2. 設定 Ollama API 憑證：
   - Base URL: `http://localhost:11434`（預設）
   - 如果 Ollama 在遠端伺服器，修改為對應 IP
3. 選擇模型：`gpt-oss:20b`

### 步驟三：匯入工作流程

1. 下載 `天氣和新聞查詢_使用Ollama.json`
2. 在 n8n 中點擊「Import from File」
3. 選擇下載的 JSON 檔案
4. 工作流程會自動匯入

### 步驟四：設定 Chat Trigger

1. **Chat Trigger** 節點已預先設定
2. 可自訂：
   - **Title**：聊天視窗標題
   - **Subtitle**：聊天視窗副標題
   - **Initial Messages**：歡迎訊息
   - **Public**：是否公開聊天連結

### 步驟五：設定 AI Agent

1. 開啟 **Your First AI Agent** 節點
2. 檢查 System Message（已預設好）
3. 確認已連接：
   - Ollama Chat Model（語言模型）
   - Conversation Memory（記憶）
   - Get Weather Tool（天氣工具）
   - Get News Tool（新聞工具）

### 步驟六：測試工作流程

1. 點擊「Save」儲存工作流程
2. 點擊「Activate」啟動工作流程
3. 點擊「🗨 Open Chat」開啟聊天視窗
4. 嘗試以下測試問題：

**測試問題範例**：
```
✅ "巴黎的天氣如何？"
✅ "給我最新的科技新聞。"
✅ "n8n 是什麼？"
✅ "台北明天會下雨嗎？"
✅ "給我一些 AI Agent 的應用想法。"
```

## 💡 實際應用場景

### 個人助理
- 查詢天氣、新聞、日程
- 回答一般知識問題
- 協助日常任務規劃

### 學習工具
- 練習 AI Agent 開發
- 理解 Prompt Engineering
- 實驗不同的工具組合

### 內部工具
- 公司內部問答系統
- 技術支援助手
- 流程自動化介面

### 原型開發
- 快速驗證 AI 應用想法
- 測試工具整合
- 概念驗證（POC）

## 🔧 進階功能擴展

### 練習 1：新增更多工具

**加入 Calculator Tool**：
```
1. 點擊 AI Agent 的 Tools 區域
2. 選擇「Add Tool」→「Calculator」
3. 測試數學計算問題
```

**加入 Wikipedia Tool**：
```
1. 安裝 Wikipedia 節點
2. 設定為 Tool
3. 讓 AI 能查詢維基百科
```

**加入 Gmail Tool**：
```
1. 連接 Gmail 帳戶
2. 設定發送郵件工具
3. 讓 AI 能代發郵件
```

### 練習 2：自訂 System Prompt

**改變 AI 性格**：
```
專業顧問型：
你是一位專業的商業顧問，擅長提供策略建議...

技術專家型：
你是一位資深工程師，專注於技術問題的深入解答...

輕鬆幽默型：
你是一位風趣的助手，喜歡用輕鬆的方式幫助用戶...
```

### 練習 3：優化對話記憶

調整 **Conversation Memory** 參數：
- **Context Window Length**：30 → 50（保存更多歷史）
- 觀察記憶對對話品質的影響
- 找到效能與品質的平衡點

### 練習 4：切換不同模型

嘗試不同的 Ollama 模型：
```bash
# 下載其他模型
ollama pull llama2:7b
ollama pull mistral:7b
ollama pull codellama:7b

# 在 Ollama Chat Model 節點中切換模型
# 比較不同模型的回應品質和速度
```

### 練習 5：建立多語言支援

修改 System Message 加入多語言：
```
你能使用以下語言進行對話：
- 繁體中文（預設）
- English
- 日本語
- 한국어

請根據用戶使用的語言自動切換。
```

### 練習 6：加入自訂工具

**建立「搜尋本地檔案」工具**：
```
1. 使用 Execute Command 節點
2. 設定為 Tool
3. 執行 grep 或 find 命令
4. 讓 AI 能搜尋伺服器上的檔案
```

## 📌 常見問題

### Q: Ollama 無法連接怎麼辦？

**A**: 
1. 確認 Ollama 服務是否正在運行：
   ```bash
   ollama serve
   ```
2. 檢查 Base URL 是否正確（預設：`http://localhost:11434`）
3. 如果使用 Docker，確認 port mapping 正確
4. 檢查防火牆設定

### Q: AI 回應速度很慢？

**A**: 
- **切換到較小的模型**：`llama2:7b` 比 `gpt-oss:20b` 快
- **檢查硬體資源**：確保有足夠的 RAM 和 CPU
- **使用 GPU 加速**：如果有 NVIDIA GPU，啟用 CUDA
- **關閉其他應用**：釋放更多記憶體

### Q: 如何讓 AI 回答更準確？

**A**: 
- **優化 System Prompt**：提供更明確的指示
- **增加上下文**：調整 Conversation Memory 長度
- **使用更大的模型**：例如 `llama2:13b`
- **提供範例**：在 System Prompt 中加入範例對話

### Q: 工具呼叫失敗怎麼辦？

**A**: 
- **檢查工具描述**：確保描述清楚易懂
- **測試工具節點**：單獨測試工具是否正常運作
- **查看執行日誌**：檢查錯誤訊息
- **簡化工具參數**：減少必填參數的數量

### Q: 如何部署給其他人使用？

**A**: 
1. **啟動工作流程**：點擊「Activate」
2. **設定 Public Chat**：在 Chat Trigger 中啟用 Public
3. **分享連結**：複製聊天 URL 分享給使用者
4. **設定 ngrok**：如果在本地運行，使用 ngrok 建立外部連結

### Q: Ollama 和 OpenAI 有什麼差異？

**A**: 

| 特性 | Ollama | OpenAI |
|------|--------|--------|
| 部署方式 | 本地運行 | 雲端 API |
| 成本 | 免費 | 按使用量付費 |
| 隱私 | 完全私密 | 資料傳送到外部 |
| 模型品質 | 中等 | 頂尖（GPT-4） |
| 回應速度 | 取決於硬體 | 穩定快速 |
| 適用場景 | 學習、開發、私有資料 | 生產環境、高品質需求 |

## 🚀 從 Ollama 進階到雲端 API

當你熟悉了 Ollama 後，可以輕鬆切換到雲端模型：

### 切換到 OpenAI
```
1. 將 Ollama Chat Model 替換為 OpenAI Chat Model
2. 設定 OpenAI API Key
3. 選擇模型（gpt-3.5-turbo 或 gpt-4）
4. 其他設定保持不變
```

### 切換到 Google Gemini
```
1. 將 Ollama Chat Model 替換為 Google Gemini Chat Model
2. 設定 Google API Key
3. 選擇模型（gemini-pro）
4. 其他設定保持不變
```

### 混合使用策略
```
開發/測試：使用 Ollama（節省成本）
生產環境：使用 OpenAI/Gemini（更好品質）
敏感資料：使用 Ollama（隱私保護）
一般應用：使用雲端 API（穩定可靠）
```

## 📚 延伸學習

### 前置範例
建議先完成：
- [範例一：智能客服聊天機器人](../智能客服聊天機器人/README.md) - 學習基本對話功能

### 後續範例建議
完成此範例後，建議繼續學習：

1. [範例三：文件智能問答系統](../文件智能問答系統/README.md)
   - 學習 RAG 技術和向量資料庫
   
2. [範例四：具備工具使用能力的助理](../具備工具使用能力的助理/README.md)
   - 學習更多進階工具整合技巧（使用雲端 API）

<a name='fromAI說明'></a>
## 💡 有關於$fromAI()的說明書

下面是一份**專門給 n8n 使用者 / 教學用**的

👉 **`$fromAI()` 語法說明書（白話＋技術版）**

---

## 一、`$fromAI()` 是什麼？

`$fromAI()` 是 **n8n AI 節點（特別是 Tool / AI Agent）專用的表達式函式**，
用途是：

> **把「某個參數的值」交給 AI 決定，而不是寫死在 workflow 裡**

簡單一句話：

> 🔮 **讓 AI 幫你填欄位值**

在你的例子中，就是讓 AI **自動選擇最適合的 RSS Feed URL**。

---

## 二、基本語法結構

```js
$fromAI(name, description, type, defaultValue)
```

### 1️⃣ `name`（參數名稱）

```js
'URL'
```

* 這是 **AI 要產生的欄位名稱**
* 會顯示在 AI 的「工具參數 schema」中
* 建議用**有意義的名稱**

👉 教學建議：

* URL
* city
* keyword
* rssFeed

---

### 2️⃣ `description`（給 AI 看的說明）

```js
'Select the most appropriate RSS feed URL based on the user query. Available options are listed in the tool description.'
```

⚠️ **這一段非常重要**

* 這是 **給 AI 看、不是給使用者看**
* AI 會依這段文字來「判斷要怎麼選值」
* 寫得越清楚，AI 越聰明

👉 教學重點：

* 這裡其實就是 **prompt engineering**
* 很適合拿來教學生「AI 怎麼被引導」

---

### 3️⃣ `type`（資料型別）

```js
'string'
```

目前常見的型別：

| 型別        | 說明           |
| --------- | ------------ |
| `string`  | 文字（最常用）      |
| `number`  | 數字           |
| `boolean` | true / false |
| `array`   | 陣列（進階）       |
| `object`  | 物件（進階）       |

👉 RSS URL 一定是字串，所以用 `string`

---

### 4️⃣ `defaultValue`（預設值）

```js
'https://feeds.bbci.co.uk/news/world/rss.xml'
```

用途有三個：

1. AI 不確定時的 **保底值**
2. Workflow 第一次測試時不會壞
3. 提供 AI 一個「參考答案」

👉 很重要的教學觀念：

> **default ≠ 固定值，而是 fallback**

---

## 三、把你的範例拆解成一句人話

```js
{{ 
  $fromAI(
    'URL',
    'Select the most appropriate RSS feed URL based on the user query. Available options are listed in the tool description.',
    'string',
    'https://feeds.bbci.co.uk/news/world/rss.xml'
  ) 
}}
```

等同於對 AI 說：

> 「嘿 AI，
> 現在我需要一個叫做 **URL** 的參數，
> 它是 **字串**，
> 請你根據使用者問的內容，
> 從我前面列出的 RSS 清單中，
> 選一個**最適合的 RSS Feed URL**。
> 如果你真的不知道，就先用 BBC World。」

---

## 四、執行時實際發生什麼事（重要）

### 🧠 AI 的流程是這樣：

1. 使用者輸入問題

   > 「今天台灣有什麼新聞？」

2. AI 看到 Tool description 裡的 RSS 清單

   * Liberty Times
   * CNA
   * BBC
   * TechCrunch …

3. AI 根據「台灣」這個關鍵字判斷

4. 自動回傳：

```json
{
  "URL": "https://news.ltn.com.tw/rss/all.xml"
}
```

5. n8n 把這個值塞進 RSS Read Tool

👉 **整個流程不用 if / switch / code**

---

## 五、教學時一定要強調的 3 個重點

### ⭐ 1. `$fromAI()` 是「AI 決策入口」

不是 JavaScript 函式思維，而是：

> **把控制權交給 LLM**

---

### ⭐ 2. description 就是 prompt

學生常犯錯：

❌ description 寫得很隨便
✅ description 寫得像在「教 AI 做事」

---

### ⭐ 3. Tool + $fromAI = Agent 行為

當你搭配：

* AI Agent
* Tool
* `$fromAI()`

你教的已經不是 n8n，
而是：

> 🤖 **Agentic Workflow（代理式流程）**

---

## 六、給你一個「教學用標準模板」

```js
{{ 
  $fromAI(
    'parameter_name',
    'Clearly describe how the AI should decide this value, including constraints or available options.',
    'string',
    'default_value'
  ) 
}}
```


---


