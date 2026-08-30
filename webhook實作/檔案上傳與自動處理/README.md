# Webhook 實作範例
## 檔案上傳與自動處理

### 📚 工作流程說明

這個工作流程示範如何透過 Webhook 接收外部系統上傳的實體檔案（如 `multipart/form-data` 格式的 CSV 檔案）。n8n 接收到二進位檔案後，利用 Extract from File 節點解析其內部資料列，並由 Code 節點統計筆數並抽取前幾筆範例，最後即時回傳處理狀態與摘要給上傳者。

### 流程架構圖

```mermaid
flowchart LR
    A["📁 用戶上傳 CSV 實體檔案"] --> B["⚡ 檔案上傳 Webhook (multipart/form-data)"]
    B --> C["📄 解析 CSV 內容 (Extract from File)"]
    C --> D["📊 生成處理摘要 (Code 節點)"]
    D --> E["📤 回傳解析結果 (Respond to Webhook)"]
    E --> F["💻 客戶端收到統計報表 JSON"]
```

---

### 工作流程樣版下載

- [📥 檔案上傳與自動處理工作流程樣版 (檔案上傳與自動處理.json)](./檔案上傳與自動處理.json)

---

### 📋 節點詳細說明

1. **📁 Webhook 觸發器 (`檔案上傳 Webhook`)**
   - **HTTP Method**：`POST`
   - **Path**：`upload-file`
   - **Response Mode**：`Using 'Respond to Webhook' Node`
   - **特性**：可接收帶有二進位檔案（Binary File）的表單上傳。

2. **📄 Extract from File 節點 (`解析 CSV 內容`)**
   - **Operation**：`CSV`
   - **Binary Property**：`data`
   - **功能**：自動將上傳的二進位 CSV 檔案轉為多筆 JSON 物件。

3. **📊 Code 節點 (`生成處理摘要`)**
   - **功能**：彙整解析後的資料列數，並擷取前 3 筆資料作為範例預覽。

4. **📤 Respond to Webhook 節點 (`回傳解析結果`)**
   - **功能**：回傳 `200 OK` 及 JSON 處理摘要。

---

### 🧪 測試與驗證方法

#### 準備測試 CSV 檔案（例如 `students.csv`）：
```csv
name,chinese,english,math
王小明,88,92,95
李小美,76,85,80
張大同,90,70,88
```

#### 使用 curl 上傳檔案測試：
```bash
curl -X POST https://<你的n8n網址>/webhook/upload-file \
  -F "data=@students.csv"
```

**預期 JSON 回應**：
```json
{
  "message": "檔案解析成功",
  "total_records": 3,
  "sample_records": [
    { "name": "王小明", "chinese": "88", "english": "92", "math": "95" },
    { "name": "李小美", "chinese": "76", "english": "85", "math": "80" },
    { "name": "張大同", "chinese": "90", "english": "70", "math": "88" }
  ],
  "processed_at": "2026-08-20T14:35:00.000Z"
}
```

---

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
