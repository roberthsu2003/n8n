# 初階範例

歡迎來到 n8n 初階範例教學！這裡提供了一系列適合初學者的實作範例，幫助您從零開始學習 n8n 的基本操作和核心概念。

## 📚 範例導覽

本教學提供四個完整的實作範例，從最基礎的資料處理到檔案格式轉換，幫助您循序漸進掌握 n8n：

### [範例：初體驗](./初體驗/README.md)
**難度**: 初級 | **學習時間**: 15-20 分鐘

第一個 n8n 工作流！學習基本的觸發與資料傳遞。

**學習重點**：
- 手動觸發工作流程
- 從資料來源獲取資料
- 使用 Set 節點整理資料欄位
- 理解 n8n 的資料流向

---

### [範例：透過互動式逐步教程學習 JSON 基礎](./json基礎/README.md)
**難度**: 初級 

JSON 是自動化流程的資料核心。透過這個互動式實作範例，您將學會如何建立和操作 JSON 格式。

**學習重點**：
- JSON 語法基礎（鍵值對、資料型態）
- 六種基本 JSON 資料型態（字串、數字、布林值、陣列、物件、Null）
- n8n 表達式的使用
- 資料結構化與引用

---

### [範例：透過網站取得引言](./透過網站取得隨機引言/README.md)
**難度**: 初級 

學習如何使用 **HTTP Request** 節點發送請求並抓取外部 API 資料。

**學習重點**：
- HTTP 請求的基本概念
- 使用 HTTP Request 節點呼叫外部 API
- 資料處理與欄位重新命名
- n8n 表達式的實際應用

**技術重點**：HTTP 請求、欄位整理

---

### [範例：CSV轉換為Excel](./csv轉換為Excel/README.md)
**難度**: 中級 

學習如何下載 CSV 檔案，並將其轉換為 Excel 格式。這個範例展示了完整的檔案處理流程。

**學習重點**：
- HTTP 請求下載檔案
- 處理二進位資料
- 使用 Extract from File 節點解析 CSV
- 使用 Convert to File 節點轉換為 Excel

**技術重點**：HTTP 請求下載、CSV轉換為Excel、檔案處理

**練習**

1. 下載政府開放平台的csv和json

2. 下載pdf檔

```
n8n  Extract From File  測試
財務報表 PDF
https://www.sample-videos.com/pdf/Sample-pdf-5-mb.pdf

發票報表範例
https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dense/invoice.pdf

商業報表
https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-pdf-file.pdf


```

---

## n8n內建的DataTable節點
**難度**: 初級 

學習如何使用 n8n 內建DataTable節點。

### [範例:DataTable](./DataTable/)

---

### n8n內建表單節點
**難度**: 中級 

### [範例:新增表單觸發節點](./表單節點/)

[**youtube內建表單參考影片**](https://youtu.be/yGm0X6YtME4?si=HGcvQFlu4LdA2B8o)

[**youtube內建表單參考影片**](https://youtu.be/HPIfP_IN95o?si=81ag2Cuw9u-DKqUR)

**學習重點**：
- n8n 內建表單節點

---

## 🎯 學習路徑建議

## 📚 相關資源

- [n8n 官方文件](https://docs.n8n.io/)
- [n8n 官方教學範例](https://blog.n8n.io/tag/tutorial/)
- [n8n 簡介與安裝](../n8n簡介與安裝/README.md)

---

**🎓 完成這些範例後，您將具備基礎的 n8n 操作能力，可以開始探索更進階的功能！**
