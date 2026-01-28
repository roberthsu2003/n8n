# 實作 Pinecone 向量資料庫

這個 n8n 工作流實作了一個完整的 RAG (Retrieval-Augmented Generation) 系統，使用 Pinecone 作為向量資料庫，結合 Google Gemini 進行文件處理和對話。

## 功能特色

- 📁 **自動文件處理**: 從 Google Drive 資料夾下載文件並轉換為向量
- 🔍 **智能檢索**: 使用 Pinecone 向量資料庫進行語意搜尋
- 💬 **AI 對話**: 結合 Gemini 模型提供智能問答服務
- 🔄 **批次處理**: 支援大量文件的高效處理

## 工作流架構

### 文件處理流程
1. **手動觸發** - 啟動工作流
2. **Google Drive 搜尋** - 從指定資料夾獲取文件列表
3. **文件下載** - 下載所有文件到本地
4. **批次處理** - 逐個處理文件
5. **向量化** - 使用 Gemini Embeddings 將文件轉換為向量
6. **儲存** - 將向量儲存到 Pinecone

### 對話流程
1. **Chat Trigger** - 接收用戶訊息
2. **AI Agent** - 處理對話邏輯
3. **向量檢索** - 從 Pinecone 檢索相關文件
4. **Gemini Chat** - 生成回應

## 前置設定

### 1. Pinecone 設定
```bash
# 安裝 Pinecone 套件
pip install pinecone-client

# 建立索引
import pinecone
pinecone.init(api_key="YOUR_API_KEY", environment="YOUR_ENVIRONMENT")
pinecone.create_index("n8n-user1", dimension=1536)
```

### 2. Google Drive 設定
- 建立 Google Cloud 專案
- 啟用 Google Drive API
- 設定 OAuth 2.0 憑證
- 在 n8n 中新增 Google Drive 憑證

### 3. Google Gemini 設定
- 取得 Google AI Studio API 金鑰
- 在 n8n 中新增 Google PaLM API 憑證

## 工作流下載

[下載工作流](./pinecone向量資料庫.json)

## 匯入步驟

1. 開啟 n8n 編輯器
2. 點擊「Import from file」
3. 選擇下載的 JSON 檔案
4. 設定所需的憑證
5. 更新 Google Drive 資料夾 ID
6. 測試工作流

## 憑證設定

### Pinecone API
- **名稱**: PineconeApi account
- **類型**: Pinecone API
- **設定**: API Key 和 Environment

### Google Drive OAuth2
- **名稱**: Google Drive localhost
- **類型**: Google Drive OAuth2 API
- **設定**: Client ID 和 Client Secret

### Google PaLM API
- **名稱**: Google Gemini(PaLM) Api account
- **類型**: Google PaLM API
- **設定**: API Key

## 使用說明

### 建立向量資料庫
1. 點擊「Execute workflow」按鈕
2. 工作流會自動處理 Google Drive 中的文件
3. 等待所有文件完成向量化

### 進行對話測試
1. 啟動 Chat Trigger 節點
2. 發送測試訊息
3. 系統會檢索相關文件並生成回應

## 自訂設定

### 修改資料夾路徑
在「搜尋n8n_rag資料夾」節點中更新：
```json
"folderId": {
  "__rl": true,
  "value": "YOUR_GOOGLE_DRIVE_FOLDER_ID",
  "mode": "list"
}
```

### 修改 Pinecone 索引
在 Pinecone 節點中更新：
```json
"pineconeIndex": {
  "__rl": true,
  "value": "YOUR_INDEX_NAME",
  "mode": "list"
}
```

### 修改系統提示
在 AI Agent 節點中更新：
```json
"systemMessage": "你是一位熱心服務的專家"
```

## 故障排除

### 常見問題

**Q: Pinecone 連接失敗**
A: 檢查 API Key 和 Environment 是否正確設定

**Q: Google Drive 權限錯誤**
A: 確認 OAuth 憑證已正確設定並授權

**Q: 文件處理失敗**
A: 檢查文件格式是否支援，建議使用 PDF、TXT、DOCX

**Q: 向量化緩慢**
A: 考慮減少批次大小或使用更高效的 Embeddings 模型

## 效能優化

- 使用適當的批次大小處理文件
- 定期清理 Pinecone 中的舊向量
- 監控 API 使用量避免超額
- 考慮使用 CDN 加速文件下載

## 擴展功能

- 支援更多文件格式 (圖片、音訊、影片)
- 加入文件摘要功能
- 實作多語言支援
- 新增文件版本控制

## 授權

本專案採用 MIT 授權條款。
