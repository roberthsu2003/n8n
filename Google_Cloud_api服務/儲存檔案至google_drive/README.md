# 整合 Google 服務
## 範例 1：自動下載政府開放資料並轉存 Excel 至 Google Drive

### 📚 工作流程說明

這個 n8n 工作流程示範如何將**外部開放資料（Open Data）自動下載、解析並轉存至 Google 雲端硬碟**。流程首先透過 HTTP Request 下載台北市開放資料平台的 CSV 檔案，利用 Extract from File 節點解析內容，接著透過 Convert to File 節點自動封裝為現代 Excel (`.xlsx`) 格式，最後自動上傳至指定的 Google Drive 資料夾中，實現完全無人值守的雲端定時備份。

---

### 流程架構圖

```mermaid
flowchart LR
    A["🖱️ 手動觸發 / Schedule 定時啟動"] --> B["🌐 下載 CSV 開放資料 (HTTP Request)"]
    B --> C["📥 解析 CSV 資料列 (Extract from File)"]
    C --> D["📊 封裝為 Excel 檔案 (Convert to File)"]
    D --> E["📁 自動上傳至雲端硬碟 (Google Drive)"]
```

---

### 工作流程樣版下載

- [📥 儲存檔案至 Google Drive 工作流程樣版 (儲存檔案至google_drive.json)](./儲存檔案至google_drive.json)

---

### 📋 節點詳細說明

1. **手動觸發 / 定時排程 (`Manual / Schedule Trigger`)**
   - **功能**：工作流程的啟動起點，支援手動測試或設定每週/每日定時自動執行。

2. **下載 CSV 開放資料檔案 (`HTTP Request` v4.4)**
   - **URL**：台北市政府開放資料平台 API 端點。
   - **Response Format**：`File`（二進位檔案模式），自動保留原始檔案串流。

3. **解析 CSV 資料 (`Extract from File` v1)**
   - **功能**：自動解構 CSV 內容，`headerRow: true` 將首列標題轉為標準 JSON 屬性。

4. **轉換為 Excel 檔案 (`Convert to File` v1.1)**
   - **Operation**：`Convert to XLSX`
   - **動態檔名**：`=台北市開放資料備份_{{ $now.format('yyyyMMdd_HHmmss') }}.xlsx`

5. **上傳至 Google Drive (`Google Drive` v3)**
   - **功能**：將產生的 Excel 檔案透過 Google Drive API 自動上傳至指定目錄。

---

### 🧪 測試與驗證方法

1. 在 n8n 匯入 [`儲存檔案至google_drive.json`](./儲存檔案至google_drive.json)。
2. 設定您的 **Google Drive OAuth2** 憑證。
3. 點擊「**Execute workflow**（執行工作流程）」。
4. 流程結束後，打開您的 Google 雲端硬碟，即可看見最新產生的 Excel 檔案！

---

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 在上傳完成後，自動將檔案公開分享連結複製並輸出至日誌。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在目前的「儲存檔案至 Google Drive」工作流程後進行延伸：
1. 保持下載 CSV、轉換 Excel 並上傳至 Google Drive 的流程。
2. 在 Google Drive 節點後，接續新增一個 Google Drive 節點（Operation: Share），設定將上傳的檔案分享權限設為「知道連結的人皆可檢視」。
3. 串接 Set 節點，輸出包含 file_name, file_id, web_view_link 的摘要資訊。
請幫我建立相關節點與連線！
```
</details>

---

**適用對象**：入門初學者 / 資料備份實戰  
**預計教學時間**：30 - 45 分鐘
