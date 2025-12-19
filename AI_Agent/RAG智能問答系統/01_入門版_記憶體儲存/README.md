# 🎯 RAG 入門版 - 記憶體儲存

## 📖 什麼是這個範例？

這是 **最簡單的 RAG 實作**，讓您在 5 分鐘內體驗 RAG（檢索增強生成）技術的魅力！

整個系統只需要**一個工作流程**，就能實現：
- 📤 上傳文件（PDF、CSV）
- 🔍 自動建立向量索引
- 💬 智能問答對話

## ✨ 核心特色

### **為什麼從這裡開始？**

| 特點 | 說明 |
|------|------|
| 🚀 **超級簡單** | 只需一個工作流程，5分鐘快速體驗 |
| 💾 **記憶體儲存** | 使用 In-Memory Vector Store，無需外部資料庫 |
| 🆓 **零成本** | 可使用 HuggingFace 免費嵌入模型 |
| ⚡ **即時體驗** | 上傳檔案後立即可以開始問答 |
| 📚 **學習友善** | 專注於 RAG 核心概念，無額外複雜度 |

### **適用場景**

✅ RAG 技術學習和概念驗證  
✅ 快速測試和演示  
✅ 個人小規模使用（少量文件）  
✅ 教學和實驗

### **限制與注意事項**

⚠️ **資料不持久**：工作流程重啟或執行結束後，向量資料會消失  
⚠️ **不適合大量文件**：記憶體有限，建議小於 50 份文件  
⚠️ **無法跨流程共用**：每次執行都是獨立的索引  
⚠️ **適合測試**：生產環境建議使用基礎版或進階版

---

## 🎓 什麼是 RAG？

**RAG (Retrieval-Augmented Generation)** = 檢索增強生成

簡單來說，RAG 讓 AI 能夠：
1. 📖 **讀取**您的文件
2. 🔍 **檢索**相關資訊
3. 💬 **回答**基於文件內容的問題

### **RAG 的工作流程**

```
┌─────────────────────────────────────────────┐
│          RAG 工作流程（入門版）              │
├─────────────────────────────────────────────┤
│                                             │
│  Step 1: 📤 上傳文件                        │
│         ↓                                   │
│  Step 2: ✂️ 文件分割成小片段                │
│         ↓                                   │
│  Step 3: 🔢 將片段轉換為向量（Embedding）   │
│         ↓                                   │
│  Step 4: 💾 儲存到記憶體（In-Memory Store） │
│         ↓                                   │
│  Step 5: 💬 使用者提問                      │
│         ↓                                   │
│  Step 6: 🔍 語義搜尋相關片段                │
│         ↓                                   │
│  Step 7: 🤖 AI 根據片段生成答案             │
│                                             │
└─────────────────────────────────────────────┘
```

---

## 🏗️ 系統架構

### **節點說明**

```
┌──────────────────────────────────────────────────────────┐
│                    單一工作流程                           │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  [上傳檔案] (Form Trigger)                               │
│      ↓                                                   │
│  [Simple Vector Store] (Insert Mode) ←─ [Embeddings]    │
│      ↑                                                   │
│  [Default Data Loader]                                   │
│                                                          │
│  ─────────────────────────────────────────────────────   │
│                                                          │
│  [When chat message received] (Chat Trigger)             │
│      ↓                                                   │
│  [AI Agent] ←─ [OpenRouter Chat Model]                  │
│      ↓                                                   │
│  [Query Data Tool] ←─ [Embeddings]                       │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### **節點詳細說明**

| 節點名稱 | 類型 | 功能 |
|---------|------|------|
| **上傳檔案** | Form Trigger | 提供網頁表單讓使用者上傳 PDF/CSV 檔案 |
| **Default Data Loader** | Document Loader | 讀取並解析文件內容 |
| **Embeddings** | HuggingFace Inference | 將文字轉換為向量（使用 BAAI/bge-m3 模型） |
| **Simple Vector Store (Insert)** | Vector Store | 將文件向量儲存到記憶體中 |
| **When chat message received** | Chat Trigger | 接收使用者的問題 |
| **AI Agent** | Agent | 協調查詢和回答流程 |
| **OpenRouter Chat Model** | Language Model | 使用 Nvidia Nemotron 模型生成答案 |
| **Query Data Tool** | Vector Store Retriever | 從記憶體中檢索相關文件片段 |

---

## 🚀 快速開始（5 分鐘）

### **前置需求**

- ✅ n8n 帳號（本地安裝或雲端版都可）
- ✅ HuggingFace API Key（[免費申請](https://huggingface.co/settings/tokens)）
- ✅ OpenRouter API Key（[免費額度](https://openrouter.ai/)）

### **步驟 1：匯入工作流程**

1. 下載 `RAG入門_記憶體儲存.json`
2. 在 n8n 中點擊 **Import from File**
3. 選擇檔案並匯入

### **步驟 2：設定憑證**

#### **2.1 HuggingFace API**

1. 前往 [HuggingFace Tokens](https://huggingface.co/settings/tokens)
2. 建立新 Token（Read 權限即可）
3. 在 n8n 中新增 `HuggingFaceApi` 憑證
4. 貼上您的 API Token

#### **2.2 OpenRouter API**

1. 前往 [OpenRouter](https://openrouter.ai/)
2. 註冊並取得 API Key（新用戶有免費額度）
3. 在 n8n 中新增 `OpenRouter` 憑證
4. 貼上您的 API Key

### **步驟 3：取得上傳網址**

1. 開啟工作流程
2. 點擊 `上傳檔案` 節點
3. 複製 **Production URL**
4. 在瀏覽器中開啟該網址

### **步驟 4：上傳測試文件**

1. 準備一個 PDF 或 CSV 檔案（建議小於 5MB）
2. 在表單中上傳檔案
3. 等待處理完成（約 10-30 秒）

### **步驟 5：開始問答**

1. 回到 n8n 工作流程
2. 點擊 `When chat message received` 節點
3. 複製 **Chat URL**
4. 在瀏覽器中開啟聊天介面
5. 開始提問！

---

## 💡 測試範例

### **測試 1：簡單事實查詢**

**上傳文件**：產品說明書 PDF

**提問**：
```
這個產品的主要功能是什麼？
```

**預期結果**：AI 會從文件中找到產品功能列表並回答

---

### **測試 2：步驟性問題**

**上傳文件**：使用手冊 PDF

**提問**：
```
如何設定初始密碼？
```

**預期結果**：AI 會提供清楚的步驟說明

---

### **測試 3：找不到答案**

**提問**：
```
明天天氣如何？
```

**預期結果**：AI 應該回答「文件中沒有相關資訊」

---

## 🎯 核心概念理解

### **1. Embeddings（嵌入）是什麼？**

**簡單比喻**：將文字轉換為數字向量，讓電腦能理解「意義」

```
文字：「貓是一種可愛的動物」
     ↓ (Embedding)
向量：[0.23, -0.45, 0.89, ..., 0.12]
```

**為什麼重要？**
- 電腦無法直接理解文字
- 向量可以計算「相似度」
- 語義相近的文字會有相似的向量

### **2. Vector Store（向量資料庫）**

**作用**：儲存文件的向量表示，並支援快速搜尋

**記憶體儲存 vs 持久化儲存**

| 特性 | In-Memory（本範例） | Simple Vector Store | 雲端資料庫（Pinecone） |
|------|---------------------|---------------------|----------------------|
| **資料持久性** | ❌ 執行結束即消失 | ✅ 儲存在本地檔案 | ✅ 儲存在雲端 |
| **適用規模** | 小（<50 文件） | 中（<1000 文件） | 大（無限制） |
| **設定複雜度** | 🟢 超簡單 | 🟡 簡單 | 🔴 需要註冊服務 |
| **成本** | 🆓 免費 | 🆓 免費 | 💳 付費（有免費額度） |

### **3. 語義搜尋 vs 關鍵字搜尋**

**關鍵字搜尋**（傳統方式）
```
問題：「如何重置密碼？」
搜尋：找包含「重置」和「密碼」的文字
問題：如果文件中寫的是「忘記密碼的解決方法」就找不到了
```

**語義搜尋**（RAG 使用）
```
問題：「如何重置密碼？」
轉換為向量後，能找到意義相近的內容：
  ✅ "忘記密碼的解決方法"
  ✅ "密碼變更步驟"
  ✅ "重新設定登入資訊"
```

---

## 🔧 進階調整

### **調整 1：更換 Embedding 模型**

**預設模型**：`BAAI/bge-m3`（多語言支援，效果好）

**其他選擇**：
- `sentence-transformers/all-MiniLM-L6-v2`（輕量級，速度快）
- `intfloat/multilingual-e5-large`（大型模型，效果更好但較慢）

**如何更換**：
1. 點擊 `Embeddings HuggingFace Inference` 節點
2. 修改 `Model Name` 參數
3. **注意**：Insert 和 Retrieve 兩個地方都要改成同一個模型

### **調整 2：更換語言模型**

**預設模型**：`nvidia/nemotron-nano-12b-v2-vl:free`（免費）

**其他選擇**：
```bash
# OpenRouter 支援的免費模型
- meta-llama/llama-3.2-3b-instruct:free
- google/gemini-flash-1.5:free
- qwen/qwen-2-7b-instruct:free
```

### **調整 3：限制檢索數量**

在 `Query Data Tool` 節點中：
- `Top K`：預設為 4，表示檢索 4 個最相關片段
- 增加到 6-8 可以提高準確度，但會增加 Token 使用量

---

## ❓ 常見問題

### **Q1: 為什麼我的文件上傳後無法問答？**

**可能原因**：
1. Embedding 模型設定不一致
2. Memory Key 設定錯誤
3. 文件格式不支援

**解決方法**：
1. 檢查兩個 Vector Store 節點的 `Memory Key` 都設為 `vector_store_key`
2. 確認兩個 Embeddings 節點使用相同模型
3. 確認文件是 PDF 或 CSV 格式

### **Q2: 重新執行工作流程後，之前上傳的文件不見了？**

**這是正常的！**

In-Memory Vector Store 的資料儲存在記憶體中，每次執行都是全新的索引。

**解決方案**：
- 升級到 **基礎版**（使用 Simple Vector Store，資料會持久化）
- 或升級到 **進階版**（使用雲端向量資料庫）

### **Q3: 支援哪些文件格式？**

**目前支援**：
- ✅ PDF（.pdf）
- ✅ CSV（.csv）

**想支援更多格式？**
1. 點擊 `上傳檔案` 節點
2. 修改 `Accept File Types` 參數
3. 加入：`.txt,.docx,.xlsx`

### **Q4: 可以一次上傳多個文件嗎？**

可以！Form Trigger 支援多檔案上傳。

**設定方法**：
1. 點擊 `上傳檔案` 節點
2. 在 `Upload your file(s)` 欄位設定中
3. 確認允許多檔案選擇

### **Q5: HuggingFace Embedding 太慢怎麼辦？**

**替代方案**：

**選項 1**：使用 OpenAI Embeddings（付費但快速）
- 節點類型：`Embeddings OpenAI`
- 模型：`text-embedding-3-small`
- 成本：約 $0.02 / 1M tokens

**選項 2**：使用 Google Gemini Embeddings（免費且快速）
- 節點類型：`Embeddings Google Gemini`  
- 模型：`text-embedding-004`
- 成本：免費（有配額限制）

---

## 📚 學習路徑

### **完成這個範例後，您已經學會：**

✅ RAG 的基本概念和工作流程  
✅ Embeddings（嵌入）的作用  
✅ Vector Store（向量資料庫）的運作原理  
✅ 語義搜尋 vs 關鍵字搜尋的差異  
✅ AI Agent 如何使用工具檢索資訊

### **下一步學習建議：**

1. **📁 基礎版 - 簡單向量儲存**
   - 學習資料持久化
   - 分離索引和問答流程
   - 多來源整合（本機 + Google Drive）

2. **☁️ 進階版 - 雲端向量資料庫**
   - 使用 Pinecone、Qdrant 等專業資料庫
   - 學習大規模文件管理
   - 企業級應用設計

---

## 🎓 教學建議

### **教學流程（45 分鐘）**

#### **Part 1：概念講解（15 分鐘）**
1. 什麼是 RAG？為什麼需要 RAG？
2. Embeddings 和 Vector Store 的基本概念
3. 語義搜尋的工作原理
4. 介紹範例架構

#### **Part 2：實作演示（20 分鐘）**
1. 匯入工作流程
2. 設定憑證（HuggingFace + OpenRouter）
3. 上傳測試文件
4. 執行問答測試
5. 觀察執行日誌，理解每個節點的作用

#### **Part 3：互動實驗（10 分鐘）**
1. 學生上傳自己的文件
2. 測試不同類型的問題
3. 討論 AI 回答的準確度
4. 嘗試調整參數（Top K、Temperature）

---

## 📖 參考資源

### **官方文件**
- [n8n AI Agent 文件](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.agent/)
- [Vector Store 說明](https://docs.n8n.io/integrations/builtin/cluster-nodes/sub-nodes/n8n-nodes-langchain.vectorstoreinmemory/)
- [RAG 完整指南](https://docs.n8n.io/advanced-ai/rag-in-n8n/)

### **相關範本**
- [n8n RAG Starter](https://n8n.io/workflows/5010)
- [Document Q&A Template](https://n8n.io/workflows/2340)

### **延伸閱讀**
- [什麼是 RAG？](https://aws.amazon.com/what-is/retrieval-augmented-generation/)
- [Embeddings 深入解析](https://platform.openai.com/docs/guides/embeddings)
- [向量資料庫比較](https://zilliz.com/blog/vector-database-comparison)

---

## 🎉 完成檢查清單

- [ ] 成功匯入工作流程
- [ ] 設定 HuggingFace 和 OpenRouter 憑證
- [ ] 上傳一個測試文件
- [ ] 成功進行問答對話
- [ ] 理解 RAG 的基本工作流程
- [ ] 理解 Embeddings 和 Vector Store 的作用
- [ ] 知道 In-Memory Store 的限制
- [ ] 準備好學習基礎版或進階版

---

**🎓 恭喜完成 RAG 入門！您已經掌握了 RAG 的核心概念。**

**💡 下一步**：前往 [基礎版](../02_基礎版_簡單向量儲存/README.md) 學習資料持久化和多來源整合！
