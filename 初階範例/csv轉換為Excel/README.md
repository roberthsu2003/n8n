# 初階範例
## CSV 轉換為 Excel

### 📚 工作流程說明

這個 n8n 工作流程示範如何從網路下載 CSV 格式的開放資料，並將其轉換為 Excel (.xlsx) 格式。透過這個範例，你將學會處理二進位檔案、使用最新的 Extract from File 節點解析 CSV 資料，以及使用 Convert to File 節點將資料轉換為 Excel 格式。

**✨ 更新說明**：此範例使用 n8n 最新的檔案處理節點，提供更好的效能和更多功能。

**資料來源**：臺北市就業服務處求職求才職缺資訊  
**資料網址**：https://data.taipei/api/dataset/9cb8ebf1-8d21-4523-908c-af853867eea1/resource/cec51213-9585-4b4a-ae18-5c9309ddf453/download

### 預覽圖

![CSV轉換為Excel](./images/CSV轉換為Excel.png)

### 工作流程圖下載

[CSV轉換為Excel.json](./CSV轉換為Excel.json)

---

## 📋 節點詳細說明

### 1. **📝 工作流程說明（Sticky Note）**
   - **功能**：顯示工作流程的操作說明和更新資訊
   - **內容**：
     - 說明完整的 4 步驟轉換流程
     - 標示使用最新的 Extract from File 和 Convert to File 節點
     - 說明這些新節點取代了舊的 Spreadsheet File 節點
     - 標示資料來源網址

### 2. **▶️ 手動觸發（Manual Trigger）**
   - **功能**：手動觸發器，啟動工作流程
   - **操作方式**：點擊「執行工作流程」按鈕開始執行
   - **用途**：適合測試或單次執行的檔案轉換任務

### 3. **⬇️ 下載CSV檔案（HTTP Request Node）**
   - **功能**：從臺北市政府開放資料平台下載 CSV 檔案
   - **設定說明**：
     - **請求方式**：GET
     - **URL**：`https://data.taipei/api/dataset/9cb8ebf1-8d21-4523-908c-af853867eea1/resource/cec51213-9585-4b4a-ae18-5c9309ddf453/download`
     - **回應格式**：設定為檔案（File）
   - **為什麼這樣設定**：將回應格式設為「File」會讓檔案以二進位格式傳遞給下一個節點
   - **輸出**：CSV 格式的二進位資料

### 4. **📥 解析CSV資料（Extract from File Node）** ✨ 新節點
   - **功能**：從檔案中提取資料並解析為 JSON 格式
   - **節點類型**：Extract from File（n8n 新版檔案處理節點）
   - **新版優勢**：
     - 專門用於從各種格式檔案提取資料
     - 支援 CSV、JSON、XML 等多種格式
     - 自動處理編碼問題，更加穩定
     - 效能更好，處理大型檔案更快速
   - **設定說明**：
     - **操作模式**：CSV
     - **分隔符號**：`,`（逗號）
     - **包含表頭**：是（第一行為欄位名稱）
     - **啟用 BOM**：否
   - **處理過程**：自動將 CSV 的每一列轉換為 JSON 物件
   - **輸出**：包含所有職缺資料的 JSON 陣列

### 5. **📊 轉換為Excel（Convert to File Node）** ✨ 新節點
   - **功能**：將 JSON 資料轉換為 Excel (.xlsx) 檔案
   - **節點類型**：Convert to File（n8n 新版檔案生成節點）
   - **新版優勢**：
     - 專門用於將資料轉換成各種檔案格式
     - 支援 XLSX、CSV、PDF、HTML 等多種輸出格式
     - 可自訂檔案名稱、工作表名稱等細節
     - 更靈活的格式化選項
   - **設定說明**：
     - **操作**：轉換為 XLSX（Convert to XLSX）
     - **輸出格式**：Excel 2007+ (.xlsx)
   - **輸出**：可下載的 Excel 檔案

---

## 🎯 學習重點

### 1. **HTTP 請求下載檔案**
   - 了解如何使用 HTTP Request 節點下載檔案
   - 學習設定回應格式為「檔案」而非「JSON」

### 2. **處理二進位資料**
   - 理解 n8n 中二進位資料的概念
   - 學習在節點之間傳遞檔案資料

### 3. **使用新版 Extract from File 節點**
   - 掌握最新的 Extract from File 節點使用方法
   - 了解如何從檔案中提取和解析資料
   - 學習 CSV 的分隔符號、編碼等設定

### 4. **使用新版 Convert to File 節點**
   - 學習使用最新的 Convert to File 節點
   - 掌握將 JSON 資料轉換為 Excel 格式的方法
   - 理解 JSON ↔ 檔案之間的轉換流程

### 5. **資料處理流程**
   - 下載 → 解析 → 轉換 → 輸出
   - 建立完整的檔案處理自動化流程

---

## 💡 實際應用場景

這個範例可以延伸應用到：

### 📊 **資料報表自動化**
- 定期下載政府開放資料並轉換為 Excel
- 整合多個 CSV 資料來源並合併為單一 Excel 報表
- 在轉換前對資料進行篩選、排序或計算

### 📧 **資料分發**
- 將轉換後的 Excel 檔案透過 Email 自動發送給團隊
- 上傳到 Google Drive 或 Dropbox 供他人使用
- 發送通知到 Slack 並附上檔案連結

### 🔄 **定期資料更新**
- 搭配 Schedule Trigger 設定每日/每週自動執行
- 自動下載最新的職缺資料並更新到公司內部系統
- 建立資料備份機制

### 🎨 **資料加工**
- 在轉換前使用 Code Node 清洗資料
- 新增計算欄位或分類標籤
- 套用格式化規則（如日期格式、數字格式）

---

## ⚙️ 設定步驟

### **步驟一：匯入工作流程**
1. 登入 n8n
2. 點擊「新增工作流程」
3. 點擊右上角「...」選單 → 「匯入自檔案」
4. 選擇 `CSV轉換為Excel.json`

### **步驟二：執行測試**
1. 點擊畫面上方的「執行工作流程」按鈕
2. 觀察各節點的執行狀態（綠色勾勾表示成功）
3. 點擊「Convert to Excel」節點查看輸出

### **步驟三：下載檔案**
1. 在「Convert to Excel」節點的輸出視窗中
2. 點擊「Binary」標籤
3. 點擊下載圖示即可取得 Excel 檔案

---

## 🔧 進階功能擴展

### **練習 1：更改資料來源**
嘗試將資料來源改為其他開放資料平台：
- [政府資料開放平臺](https://data.gov.tw/)
- [台北市資料大平台](https://data.taipei/)
- [高雄市政府開放資料](https://data.kcg.gov.tw/)

### **練習 2：資料篩選**
在 Import CSV 和 Convert to Excel 之間加入 Code Node：
```javascript
// 篩選包含特定關鍵字的職缺
const items = $input.all();
return items.filter(item => {
  const jobTitle = item.json['職缺名稱'] || '';
  return jobTitle.includes('工程師');
});
```

### **練習 3：自動發送 Email**
在最後加入 Gmail 或 Send Email 節點：
- 將 Excel 檔案作為附件
- 自動寄送給指定收件人
- 信件內容包含資料更新時間

### **練習 4：定期自動化**
將 Manual Trigger 替換為 Schedule Trigger：
- 設定每天早上 8:00 自動執行
- 下載最新資料並轉換
- 自動上傳到雲端硬碟

### **練習 5：多檔案批次處理**
擴展工作流程處理多個 CSV 檔案：
- 使用 Loop 節點處理檔案清單
- 將所有 CSV 合併為單一 Excel 的多個工作表
- 產生索引頁列出所有資料來源

---

## 📌 常見問題

### **Q1: 下載的 CSV 檔案是亂碼怎麼辦？**
**A**: 這個問題通常是編碼問題。新的 Extract from File 節點會自動處理編碼，但如果仍然出現亂碼，可以：
- 檢查 CSV 檔案的原始編碼
- 嘗試在下載時在 HTTP Request 節點設定特定的編碼
- 常見編碼：UTF-8（最常用）、Big5（繁體中文）、GB2312（簡體中文）

### **Q2: 轉換後的 Excel 檔案沒有表頭？**
**A**: 確保「解析CSV資料」（Extract from File）節點的「包含表頭」選項已勾選。

### **Q3: 如何修改 Excel 檔案名稱？**
**A**: 在「轉換為Excel」（Convert to File）節點中可以設定檔案名稱，例如：
- 固定名稱：`職缺資料`
- 動態名稱：`={{ "職缺資料_" + new Date().toISOString().split('T')[0] }}`
- 加入時間戳記：`={{ "職缺資料_" + $now.toFormat('yyyy-MM-dd') }}`

### **Q4: 可以轉換為其他格式嗎？**
**A**: 可以！Convert to File 節點支援多種輸出格式：
- `XLSX`：Excel 2007+（最常用）
- `CSV`：逗號分隔值檔案
- `PDF`：可移植文件格式（需額外設定）
- `HTML`：網頁表格格式

**注意**：新的 Convert to File 節點比舊的 Spreadsheet File 支援更多格式！

### **Q5: 如何處理大型 CSV 檔案？**
**A**: 新的 Extract from File 節點在處理大型檔案時效能更好。對於非常大的檔案（超過 50MB），建議：
- 增加 n8n 的記憶體限制
- 使用分批處理（在下載後分割檔案）
- 考慮使用資料庫作為中介儲存
- 使用串流處理方式（streaming）

---

## 🎓 相關資源

- [n8n HTTP Request 節點文件](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/)
- [n8n Extract from File 節點文件](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.extractfromfile/) ✨ 新
- [n8n Convert to File 節點文件](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.converttofile/) ✨ 新
- [n8n Spreadsheet File 節點文件（舊版）](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.spreadsheetfile/)
- [臺北市資料大平台](https://data.taipei/)
- [CSV 檔案格式說明](https://zh.wikipedia.org/zh-tw/%E9%80%97%E5%8F%B7%E5%88%86%E9%9A%94%E5%80%BC)

---

**難度**: ⭐☆☆ (初級)  
**適用對象**: 初學者、需要處理檔案格式轉換的使用者  
**預計學習時間**: 15-20 分鐘  
**前置知識**: 了解基本的 n8n 節點操作

**範例亮點**:
- 🌐 實際使用政府開放資料
- 📁 學習檔案下載與處理
- ✨ 使用最新的 Extract from File 和 Convert to File 節點
- 🔄 掌握現代化的格式轉換技巧
- 💼 可直接應用到實際工作中
- 🚀 體驗 n8n 新版節點帶來的效能提升

