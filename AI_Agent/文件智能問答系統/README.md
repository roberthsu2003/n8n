# 範例二：文件智能問答系統

## 📚 學習目標

學習 RAG（檢索增強生成）技術，建立一個能夠從文件中檢索資訊並回答問題的智能問答系統。

## 🎯 難度等級

**難度**: ⭐⭐☆ (中級)  
**學習時間**: 45-60 分鐘  
**階段**: 階段一：基礎入門

## 📋 工作流程說明

這個範例展示如何建立一個文件問答系統，能夠：
- 載入文件並建立向量索引
- 根據問題檢索相關文件片段
- 使用 AI 生成基於文件的回答
- 提供準確且可追溯的答案

## 🔧 使用節點

- **Chat Trigger** - 對話入口
- **AI Agent** - AI 處理核心
- **OpenAI Chat Model** - 語言模型
- **Question and Answer Chain** - RAG 檢索鏈
- **Default Data Loader** - 載入文件
- **Simple Vector Store** - 向量資料庫
- **Embeddings OpenAI** - 文字嵌入

## 📌 Sticky 規劃

```
📌 Sticky 1: "資料準備 - 文件載入與向量化"
📌 Sticky 2: "對話入口"
📌 Sticky 3: "AI 檢索與回答"
```

### Sticky 使用原則：
- 🟦 **藍色 Sticky**：輸入/觸發器
- 🟩 **綠色 Sticky**：AI 處理核心
- 🟨 **黃色 Sticky**：工具與外部服務
- 🟧 **橘色 Sticky**：輸出/回應
- 🟥 **紅色 Sticky**：錯誤處理

## 🎓 教學重點

### 1. 什麼是 Embeddings（嵌入）

**Embeddings** 是將文字轉換為數值向量的技術：
- 語義相似的文字會有相似的向量
- 可以用來計算文字之間的相似度
- 是 RAG 技術的基礎

**範例**：
- "人工智慧" 和 "AI" 會有相似的向量
- "蘋果"（水果）和 "蘋果"（公司）會有不同的向量

### 2. Vector Store 的作用

**Vector Store**（向量資料庫）用於：
- 儲存文件的向量表示
- 快速搜尋相似的文件片段
- 支援語義搜尋（而非關鍵字搜尋）

**工作流程**：
1. 文件 → Embeddings → 向量
2. 向量 → 儲存到 Vector Store
3. 問題 → Embeddings → 向量
4. 在 Vector Store 中搜尋相似向量
5. 取得相關文件片段

### 3. RAG 的工作原理

**RAG（Retrieval-Augmented Generation）** 流程：

1. **檢索（Retrieval）**：
   - 將用戶問題轉換為向量
   - 在 Vector Store 中搜尋最相關的文件片段
   - 取得 Top-K 個相關片段

2. **增強（Augmentation）**：
   - 將檢索到的文件片段加入 Prompt
   - 提供上下文資訊給 AI 模型

3. **生成（Generation）**：
   - AI 模型基於檢索到的資訊生成回答
   - 回答更準確且可追溯

## ⚙️ 設定步驟

### 步驟一：準備文件
1. 準備要索引的文件（PDF、TXT、MD 等格式）
2. 將文件上傳到 n8n 或提供 URL

### 步驟二：載入文件
1. 加入 **Default Data Loader** 節點
2. 設定文件來源（檔案或 URL）
3. 選擇文件格式

### 步驟三：建立向量索引
1. 加入 **Embeddings OpenAI** 節點
2. 設定 OpenAI API 憑證
3. 選擇 Embedding 模型（例如：`text-embedding-ada-002`）
4. 連接 **Default Data Loader** 到 **Embeddings OpenAI**

### 步驟四：建立 Vector Store
1. 加入 **Simple Vector Store** 節點
2. 連接 **Embeddings OpenAI** 到 **Simple Vector Store**
3. 設定向量儲存方式（記憶體或檔案）

### 步驟五：設定 RAG 鏈
1. 加入 **Question and Answer Chain** 節點
2. 連接 **Simple Vector Store** 到 **Question and Answer Chain**
3. 設定檢索參數：
   - **Top K**：檢索的文件片段數量（建議 3-5）
   - **Similarity Threshold**：相似度閾值

### 步驟六：設定 AI Agent
1. 加入 **Chat Trigger** 和 **AI Agent** 節點
2. 在 AI Agent 中使用 **Question and Answer Chain**
3. 設定 System Prompt：
   ```
   你是一個文件問答助手。根據提供的文件內容回答問題。
   如果文件中沒有相關資訊，請誠實地說不知道。
   回答時請引用文件來源。
   ```

### 步驟七：測試系統
1. 啟用工作流程
2. 發送測試問題
3. 觀察系統如何檢索和回答

## 💡 實際應用場景

- **企業知識庫**：回答員工關於公司政策、流程的問題
- **產品文件**：回答用戶關於產品使用方法的問題
- **法律文件**：查詢法律條文和案例
- **學術研究**：從論文中檢索相關資訊
- **技術文件**：回答開發者關於 API 或技術的問題

## 🔧 進階功能擴展

### 練習 1：優化檢索品質
- 調整 **Top K** 參數，找到最佳的文件片段數量
- 使用不同的 Embedding 模型比較效果
- 嘗試不同的文件分塊策略

### 練習 2：加入來源引用
修改 System Prompt，讓 AI 在回答時引用文件來源：
```
回答時請使用以下格式：
[答案內容]
來源：[文件名稱，第 X 頁]
```

### 練習 3：多文件支援
擴展系統支援多個文件來源：
- 使用 **Loop** 節點處理多個文件
- 為每個文件建立獨立的 Vector Store
- 在檢索時合併多個來源的結果

### 練習 4：增量更新
建立文件更新機制：
- 當文件更新時，重新建立向量索引
- 使用版本控制追蹤文件變更
- 自動通知系統更新索引

## 📌 常見問題

### Q: 為什麼檢索不到相關文件？
**A**: 
- 檢查 Embedding 模型是否正確設定
- 確認文件已正確載入和分塊
- 調整相似度閾值
- 檢查問題的表述是否清楚

### Q: 回答不準確怎麼辦？
**A**: 
- 增加檢索的文件片段數量（Top K）
- 優化 System Prompt，明確指示 AI 只使用提供的文件
- 檢查文件品質和相關性
- 嘗試不同的文件分塊大小

### Q: Vector Store 儲存在哪裡？
**A**: 
- **Simple Vector Store** 預設儲存在記憶體中（重啟後會消失）
- 可以設定儲存到檔案，持久化保存
- 生產環境建議使用專業的向量資料庫（如 Pinecone、Weaviate）

## 📚 相關資源

- [n8n Vector Store 文件](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.vectorstore/)
- [RAG 技術說明](https://www.pinecone.io/learn/retrieval-augmented-generation/)
- [OpenAI Embeddings 文件](https://platform.openai.com/docs/guides/embeddings)

---

**🎓 完成此範例後，您將理解 RAG 技術的工作原理，可以建立自己的文件問答系統！**

