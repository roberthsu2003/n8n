# 🌐 前端網頁與 WebAPI 整合
## 範例 4：大檔/圖片上傳與自動雲端託管 API（Multipart FormData 與 Google Drive 轉存）

### 📚 工作流程說明

前端網頁經常需要讓使用者上傳大頭照、履歷 PDF、合約附件或報表。透過 n8n，您可以輕鬆建立支援 `multipart/form-data` 的檔案上傳 API，自動將檔案二進位資料儲存至 Google 雲端硬碟、AWS S3 或 Supabase Storage，並將公開檢視網址即時回傳給前端。

本範例展示：
1. **拖曳式上傳前端**：支援 Drag & Drop 拖放、檔案大小與名稱即時預覽、上傳進度條動畫。
2. **n8n 後端接收 Binary**：Webhook 節點接收二進位檔案流（`$binary`），解析檔案大小與 MIME Type。
3. **雲端託管與 URL 生成**：透過 **Respond to Webhook 節點** 即時回傳雲端硬碟存取網址，前端立即生成可點擊的下載連結。

---

### 流程架構圖

```mermaid
flowchart LR
    A["👤 前端拖曳檔案 (FormData Multipart)"] -->|1. POST /upload-api| B["⚡ Webhook 節點 (接收二進位 $binary)"]
    
    subgraph n8n_Backend_API["n8n 檔案處理與雲端託管"]
        C["🔍 解析檔案中繼資料 (檔名/大小/MIME)"]
        D["☁️ 上傳至 Google Drive 企業資料夾"]
        E["🔓 設定公開檢視權限與產生 URL"]
        F["📤 Respond to Webhook 回傳檔案網址"]
    end
    
    B --> C --> D --> E --> F
    F -->|2. 回傳 { success, fileName, fileUrl }| G["📱 前端顯示上傳成功與檔案檢視連結"]
```

---

### 工作流程與前端檔案下載

- [📥 n8n WebAPI 工作流程樣版 (04_file_upload_api_workflow.json)](./04_file_upload_api_workflow.json)
- [💻 前端拖曳檔案上傳網頁原始碼 (website/index.html)](./website/index.html)

---

#### 📋 節點詳細說明

1. **📝 流程說明（Sticky Note）**
   - **功能**：說明 `FormData`、`multipart/form-data` 傳輸原理與 n8n `$binary` 二進位物件處理。

2. **⚡ 接收 Multipart 檔案上傳 (POST)（Webhook Node）**
   - **HTTP Method**：`POST`
   - **Path**：`upload-api`
   - **Response Mode**：`Using 'Respond to Webhook' Node`

3. **🔍 解析檔案二進位資訊（Code Node）**
   - **核心屬性**：`$binary.data.fileName`、`$binary.data.fileSize`、`$binary.data.mimeType`。

4. **📤 回傳檔案雲端 URL（Respond to Webhook Node）**
   - **回傳內容**：包含 `fileName`、`fileSize`、`fileUrl`。

---

#### 🧪 測試與驗證方法

1. **瀏覽器介面測試**：
   - 開啟 `website/index.html`。
   - 將任何圖片（JPG/PNG）或 PDF 文件拖入虛線框中。
   - 點擊「開始上傳至雲端」，觀察進度條跑動並在下方取得檔案 URL！

2. **curl 上傳測試**：
   ```bash
   curl -X POST http://localhost:5678/webhook/upload-api \
     -F "file=@/path/to/your/image.png"
   ```

---

#### 🎯 學習重點

- **`FormData` 前端上傳規範**：前端使用 `const formData = new FormData(); formData.append('file', file)` 發送，瀏覽器會自動附加正確的 `Content-Type: multipart/form-data; boundary=...` 標頭。
- **n8n 二進位數據管道**：理解 n8n 如何在工作流程節點間傳遞二進位檔案流，無需 base64 編碼轉換即可直接上傳雲端。

---

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 串接 Google Drive 節點將檔案實際存入指定資料夾，並設定公開共用。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在「檔案上傳 WebAPI」流程中真正串接 Google Drive：
1. 在 Code 節點後，串接 Google Drive 節點（Operation: Upload File），將 $binary.data 寫入名為「網站用戶上傳」的資料夾。
2. 串接 Google Drive 節點（Operation: Share File），將權限設為 Anyone with link can view。
3. 取得 webViewLink 與 webContentLink，透過 Respond to Webhook 節點回傳給前端。
請幫我配置好 Google Drive 節點與連線！
```
</details>
