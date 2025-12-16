# 範例一：智能客服聊天機器人

> 💡 **教學友善版本**  
> 本範例使用 **OpenRouter** 和 **Google Gemini** 的免費 API，無需信用卡即可開始學習！  
> 非常適合初學者、教學使用、以及預算有限的專案。

## 📚 學習目標

理解 AI Agent 基本架構，學習如何建立一個能夠進行對話的智能客服系統。

## 🎯 難度等級

**難度**: ⭐☆☆ (初級)  
**學習時間**: 30-45 分鐘  
**階段**: 階段一：基礎入門  
**成本**: 💰 完全免費（使用免費 API）

## 📋 工作流程說明

這個範例展示如何建立一個基本的 AI 聊天機器人，能夠：
- 接收用戶訊息
- 使用 AI 模型進行對話
- 保持對話記憶與脈絡
- 提供個人化的客服回應

## 📋 工作流程視覺化

![智能客服聊天機器人視覺化](./images/智能客服聊天機器人視覺化.png)

## 📋 工作流程下載

[📥 下載 Workflow JSON 檔案](./智能客服聊天機器人.json)

## 🔧 使用節點

- **Chat Trigger**（觸發器）- 接收用戶訊息
- **AI Agent**（核心）- AI 處理中心
- **OpenRouter Chat Model**（主要語言模型）- 使用免費模型生成回應
- **Google Gemini Chat Model**（備選語言模型）- Google 免費 API
- **Buffer Window Memory**（記憶功能）- 保持對話脈絡

### 💡 為什麼選擇這些模型？

本範例使用 **OpenRouter** 和 **Google Gemini**，而非 OpenAI：

| 模型 | 優點 | 適用情境 |
|------|------|---------|
| **OpenRouter** | ✅ 提供多種免費模型<br>✅ 支援多家 AI 廠商<br>✅ API 格式統一 | 教學、實驗、低預算專案 |
| **Google Gemini** | ✅ 完全免費使用<br>✅ 回應品質優秀<br>✅ 無需信用卡 | 教學、個人專案、初學者 |
| OpenAI | ❌ 必須付費<br>❌ 需要信用卡 | 商業專案、高品質需求 |

**本範例預設使用 OpenRouter 的免費模型：`meta-llama/llama-3.3-70b-instruct:free`**

## 🎓 教學重點

### 1. 如何設定 System Prompt（系統提示詞）

System Prompt 決定了 AI Agent 的角色和行為。範例：

```
你是一個友善且專業的客服助理。你的任務是：
1. 親切地回應客戶問題
2. 提供準確的產品資訊
3. 協助解決客戶問題
4. 在無法解決時，禮貌地引導客戶聯繫人工客服
```

### 2. 對話記憶的重要性

- **Simple Memory** 節點會自動儲存對話歷史
- 讓 AI 能夠理解上下文，提供連貫的回應
- 記憶會隨著對話進行而更新

### 3. Chat Model 的選擇與設定

**OpenRouter Chat Model**（本範例使用）：
- 🎯 支援多家 AI 廠商的模型（OpenAI、Anthropic、Meta、Google 等）
- 💰 提供多種免費模型選擇
- 🔧 統一的 API 格式，易於切換模型
- 📚 非常適合教學與實驗
- 🚀 本範例使用：`meta-llama/llama-3.3-70b-instruct:free` 免費模型

**取得 OpenRouter API Key**：
1. 前往 [OpenRouter 官網](https://openrouter.ai/)
2. 註冊帳號（完全免費）
3. 前往 [API Keys 頁面](https://openrouter.ai/keys)
4. 建立新的 API Key
5. 複製並儲存（免費額度足夠教學使用）

**Google Gemini Chat Model**（備選方案）：
- 🎯 Google 官方提供的 AI 模型
- 💰 完全免費使用（每日有使用量限制）
- 🌟 回應品質優秀，支援繁體中文
- 📚 適合初學者和個人專案

**取得 Google Gemini API Key**：
1. 前往 [Google AI Studio](https://makersuite.google.com/app/apikey)
2. 使用 Google 帳號登入
3. 點擊「Get API Key」
4. 建立新的 API Key
5. 複製並儲存（無需信用卡）

## ⚙️ 設定步驟

### 方式一：直接導入 Workflow（推薦 ⭐）

**最快速的方式** - 3 分鐘完成設定！

1. **下載並導入 Workflow**
   - 下載 `智能客服聊天機器人.json`
   - 在 n8n 介面點擊 `⋮` → `Import from File`
   - 選擇下載的 JSON 檔案

2. **設定 OpenRouter API Key**
   - 前往 [OpenRouter](https://openrouter.ai/keys) 取得免費 API Key
   - 點擊「OpenRouter Chat Model」節點
   - Credentials → 選擇或建立新憑證
   - 輸入 API Key 並儲存

3. **啟動並測試**
   - 點擊右上角「啟動」按鈕
   - 點擊「客服聊天」節點查看聊天介面
   - 開始對話測試

### 方式二：從零開始建立（學習用）

適合想要深入了解每個步驟的學習者。

#### 步驟一：建立觸發器
1. 在工作流程中加入 **Chat Trigger** 節點
2. 設定觸發器名稱（例如：`客服聊天`）
3. 啟用「Public」選項，讓使用者可以訪問

#### 步驟二：設定 AI Agent
1. 加入 **AI Agent** 節點
2. 連接 **Chat Trigger** 到 **AI Agent**
3. Agent 類型保持預設

#### 步驟三：設定語言模型（OpenRouter）
1. 加入 **OpenRouter Chat Model** 節點
2. 連接到 **AI Agent** 的「Language Model」輸入端
3. 設定 OpenRouter API 憑證：
   - 前往 [OpenRouter Keys](https://openrouter.ai/keys)
   - 建立新的 API Key（免費）
   - 在節點中新增憑證並貼上 API Key
4. 選擇模型：`meta-llama/llama-3.3-70b-instruct:free`（免費）
5. 其他參數保持預設

#### 步驟四：（可選）加入 Google Gemini 作為備選
1. 加入 **Google Gemini Chat Model** 節點
2. 設定 Google API 憑證：
   - 前往 [Google AI Studio](https://makersuite.google.com/app/apikey)
   - 取得 API Key（免費）
   - 在節點中新增憑證並貼上 API Key
3. 可以切換連接到 AI Agent，測試不同模型

#### 步驟五：設定 System Prompt
1. 開啟 **AI Agent** 節點
2. 在 **Options** → **System Message** 欄位輸入：

```
你是一個友善且專業的客服助理。你的任務是協助客戶解決問題、回答疑問，並提供優質的服務體驗。公司名稱為 TechNova Solutions。

你的職責：
1. 親切地回應客戶問題
2. 提供準確的產品資訊
3. 協助解決客戶問題
4. 在無法解決時，引導客戶聯繫人工客服
   - 客服電話：02-1234-5678
   - 客服經理：李先生

對話原則：
- 保持回應簡潔，不超過 150 字
- 使用繁體中文溝通
- 記住對話中的重要資訊
- 適時使用表情符號增加親切感
```

#### 步驟六：加入記憶功能
1. 加入 **Buffer Window Memory** 節點
2. 連接到 **AI Agent** 的「Memory」輸入端
3. 設定 `Context Window Length`：20（記住最近 20 則訊息）

#### 步驟七：測試工作流程
1. 點擊右上角「啟動」按鈕
2. 點擊「客服聊天」節點
3. 點擊「Test Chat」開啟測試介面
4. 發送測試訊息觀察回應

## 💡 實際應用場景

- **客服系統**：24/7 自動回應客戶問題
- **產品諮詢**：回答產品相關問題
- **預約系統**：協助客戶預約服務
- **FAQ 問答**：回答常見問題

## 🔧 進階功能擴展

### 練習 1：比較不同 AI 模型的回應
嘗試切換不同的模型，觀察回應差異：

**步驟**：
1. 在 OpenRouter 節點中切換模型：
   - `meta-llama/llama-3.3-70b-instruct:free`
   - `google/gemini-2.0-flash-exp:free`
   - `mistralai/mistral-7b-instruct:free`
2. 使用相同的問題測試
3. 比較回應的速度、品質、風格

**觀察重點**：
- 回應速度差異
- 語言理解能力
- 回答的詳細程度
- 是否符合 System Prompt 的指示

### 練習 2：修改 System Prompt
嘗試修改 System Prompt，讓 AI 表現不同的性格：

**專業型客服**：
```
你是一個專業且嚴謹的技術支援專員。
使用正式、專業的語氣，提供精確的技術資訊。
```

**親切型客服**（預設）：
```
你是一個友善親切的客服夥伴。
使用溫暖的語氣，像朋友一樣與客戶互動。
```

**效率型客服**：
```
你是一個高效率的客服機器人。
快速理解問題，直接提供解決方案，不使用表情符號。
```

### 練習 3：調整記憶長度
實驗不同的記憶設定：

1. 開啟 **Buffer Window Memory** 節點
2. 修改 `Context Window Length` 參數：
   - 10：短期記憶（適合簡單對話）
   - 20：預設值（平衡）
   - 50：長期記憶（適合複雜諮詢）
3. 測試長對話，觀察 AI 是否還記得前面的內容

### 練習 4：加入知識庫（RAG）
整合 **Vector Store** 和 **RAG**，讓 AI 能夠查詢內部文件：

**需要的節點**：
- **Document Loader**（載入文件）
- **Embeddings**（建立向量索引）
- **Vector Store**（儲存向量）
- **Retriever Tool**（查詢工具）

**步驟**：
1. 準備產品文件或 FAQ 文件
2. 使用 Document Loader 載入
3. 連接 Embeddings 和 Vector Store
4. 將 Retriever Tool 連接到 AI Agent
5. AI 就能查詢文件回答問題！

📚 詳細教學請參考「範例二：知識庫查詢系統」

### 練習 5：多語言支援
在 System Prompt 中加入多語言支援：

```
你可以使用繁體中文、簡體中文、英文、日文進行對話。
自動偵測用戶的語言，並使用相同語言回應。

範例：
- 用戶說「Hello」→ 你用英文回應
- 用戶說「你好」→ 你用繁體中文回應
```

測試不同語言的問題，觀察 AI 的語言切換能力。

## 🔄 如何切換不同的 AI 模型

### OpenRouter 提供的免費模型選擇

在 **OpenRouter Chat Model** 節點中，您可以選擇不同的免費模型：

| 模型 | 特色 | 適用情境 |
|------|------|---------|
| `meta-llama/llama-3.3-70b-instruct:free` | 最新 Llama 模型，效果優秀 | 推薦使用 ⭐ |
| `google/gemini-2.0-flash-exp:free` | Google 模型，速度快 | 快速回應需求 |
| `mistralai/mistral-7b-instruct:free` | 小型模型，速度極快 | 簡單對話 |

只需在節點中修改「Model」欄位即可切換！

### 切換為 Google Gemini

如果想使用 Google 官方的 Gemini：

1. 在 Workflow 中將 **OpenRouter Chat Model** 的連接線改為連接 **Google Gemini Chat Model**
2. 或直接刪除 OpenRouter 節點，只保留 Gemini 節點
3. 確認 Gemini 節點已設定 API Key

## 📌 常見問題

### Q: 免費 API 有使用限制嗎？
**A**: 
- **OpenRouter 免費模型**：有每日請求次數限制，但對教學使用綽綽有餘
- **Google Gemini**：有每分鐘和每日的請求限制
- 超過限制時會暫時無法使用，等待一段時間後即可恢復
- 💡 如需大量使用，可升級為付費方案

### Q: AI 回應太慢怎麼辦？
**A**: 
- 切換為較小的模型（例如：Mistral 7B）
- 減少 System Prompt 的長度
- 檢查網路連線速度
- 確認 API Key 是否有效

### Q: 如何讓 AI 記住用戶資訊？
**A**: 
- 使用 **Buffer Window Memory** 節點（本範例已包含）
- 在 System Prompt 中明確指示 AI 記住重要資訊
- 調整 Memory 的 Context Window Length 參數

### Q: 如何限制 AI 的回應長度？
**A**: 
- 在 System Prompt 中加入：「請保持回應簡潔，不超過 100 字」
- 在模型節點的 Options 中設定 **Max Tokens** 參數

### Q: OpenRouter 和 Google Gemini 哪個比較好？
**A**: 
| 特性 | OpenRouter | Google Gemini |
|------|------------|---------------|
| 模型選擇 | 多種模型可切換 | 單一 Gemini 模型 |
| 免費額度 | 較寬鬆 | 中等 |
| 回應品質 | 視模型而定 | 優秀 |
| 設定難度 | 簡單 | 簡單 |
| **推薦** | ⭐ 教學首選 | 備選方案 |

**建議**：先使用 OpenRouter，如遇到限制再切換 Gemini

## 📥 快速導入指南

### 🎯 3 分鐘快速開始

1. **導入 Workflow**
   ```
   方法 A：點擊上方的「📥 下載 Workflow JSON 檔案」
   方法 B：在 GitHub 中直接複製 JSON 內容
   
   在 n8n 中：⋮ 選單 → Import from File/Clipboard
   ```

2. **設定 API Key**（二選一）
   
   **選項 A - OpenRouter（推薦）**：
   - 前往 https://openrouter.ai/keys
   - 建立免費 API Key
   - 在「OpenRouter Chat Model」節點設定憑證
   
   **選項 B - Google Gemini**：
   - 前往 https://makersuite.google.com/app/apikey
   - 取得免費 API Key  
   - 在「Google Gemini Chat Model」節點設定憑證
   - 將連接線改為連接 Gemini 節點

3. **啟動測試**
   ```
   啟動 Workflow → 點擊「客服聊天」→ Test Chat
   ```

### 🔍 驗證清單

完成後確認以下項目：

- [ ] Workflow 成功導入
- [ ] API Key 已設定（OpenRouter 或 Gemini）
- [ ] 節點連接正確（查看視覺化截圖）
- [ ] Workflow 已啟動（右上角顯示綠色）
- [ ] 可以開啟聊天介面
- [ ] AI 能正常回應訊息
- [ ] AI 能記住對話內容（測試記憶功能）

## 🧪 測試對話腳本

匯入後使用以下對話測試功能：

```
👤 你好
🤖 （應該有友善的歡迎訊息）

👤 我叫小明
🤖 （應該記住名字）

👤 公司名稱是什麼？
🤖 （應該回答 TechNova Solutions）

👤 我剛才說我叫什麼名字？
🤖 （應該回答小明 - 測試記憶功能）

👤 如果你無法回答問題，我該怎麼辦？
🤖 （應該提供客服電話和聯絡人資訊）
```

## 📚 相關資源

### 官方文件
- [n8n AI Agent 文件](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.agent/)
- [n8n LangChain 整合](https://docs.n8n.io/integrations/builtin/cluster-nodes/sub-nodes/n8n-nodes-langchain/)

### API 申請與文件
- [OpenRouter 官網](https://openrouter.ai/) - 取得免費 API Key
- [OpenRouter 模型列表](https://openrouter.ai/models) - 查看所有可用模型
- [OpenRouter API 文件](https://openrouter.ai/docs)
- [Google Gemini API 文件](https://ai.google.dev/docs) - Gemini 使用指南
- [Google AI Studio](https://makersuite.google.com/app/apikey) - 取得 Gemini API Key

### 延伸學習
- [Prompt Engineering 指南](https://www.promptingguide.ai/zh) - 學習如何寫好的 System Prompt
- [LangChain 文件](https://js.langchain.com/docs/) - 了解 AI Agent 背後的技術

---

## 💰 成本比較

| 服務 | 免費額度 | 付費方案 | 適用對象 |
|------|---------|---------|---------|
| **OpenRouter 免費模型** | 每日限額 | $0.001-0.1/1M tokens | ⭐ 教學、實驗 |
| **Google Gemini** | 每分鐘 60 次請求 | 尚未推出 | ⭐ 個人專案 |
| OpenAI GPT-3.5 | 無 | $0.5/1M tokens | 商業應用 |
| OpenAI GPT-4 | 無 | $5/1M tokens | 高階應用 |

**本範例使用完全免費的方案，非常適合學習和教學！** 🎓

---


