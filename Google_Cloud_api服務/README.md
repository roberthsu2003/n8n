# 整合 Google 服務實作範例 🔗

本章節提供豐富的 Google 服務整合實作範例，透過 n8n 連接 Google Drive、Gmail、Google Sheets 與 Google 表單，打造自動化的辦公室與資料處理流程。

---

## 📌 前置準備

在開始實作以下範例前，請確保您已完成 Google Cloud Console 上的 OAuth 2.0 憑證設定並成功於 n8n 中授權：

👉 **請先參考**：[**Google Cloud API 服務設定指南**](../google_cloud設定/README.md)

---

## 目錄

- [⭐ 範例一：儲存檔案至 Google Drive](#-範例一儲存檔案至-google-drive)
- [⭐⭐ 範例二：自動寄送 Gmail](#-範例二自動寄送-gmail)
- [⭐⭐ 範例三：寄送一則笑話](#-範例三寄送一則笑話)
- [⭐⭐⭐ 範例四：學生體驗回饋問卷範本](#-範例四學生體驗回饋問卷範本)
- [⭐⭐ 範例五：訂便當系統](#-範例五訂便當系統)
- [⭐⭐⭐ 範例六：取得台北市 YouBike 資料](#-範例六取得台北市-youbike-資料)
- [🎯 學習路徑建議](#-學習路徑建議)

---

## 📚 實作範例導覽

### [⭐ 範例一：儲存檔案至 Google Drive](./儲存檔案至google_drive/README.md)
**難度**: 中級 | **學習時間**: 30-45 分鐘

學習如何使用 Google Drive 節點將檔案上傳至 Google Drive 指定資料夾中。

**學習重點**：
- Google Drive API 整合
- OAuth 2.0 認證設定
- 檔案上傳與資料夾管理
- 二進位資料 (Binary Data) 處理

---

### [⭐⭐ 範例二：自動寄送 Gmail](./自動寄送gmail/README.md)
**難度**: 中級 | **學習時間**: 30-45 分鐘

結合定時觸發 (Schedule Trigger) 與 Gmail 節點，自動發送每日引言信件。

**學習重點**：
- Schedule Trigger 排程觸發
- HTTP 請求取得外部資料
- Gmail API 整合
- 動態郵件內容生成

---

### [⭐⭐ 範例三：寄送一則笑話](./寄送一個笑話/README.md)
**難度**: 中級 | **學習時間**: 40-60 分鐘

串接多個 API 來源（引言 + 程式笑話），組合成更有趣的自動化內容並發送信件。

**學習重點**：
- 多個 HTTP 請求串接
- 資料合併與處理
- Gmail 郵件模板設計
- 錯誤處理觀念

---

### [⭐⭐⭐ 範例四：學生體驗回饋問卷範本](./學生體驗回饋問卷範本/README.md)
**難度**: 進階 | **學習時間**: 60-90 分鐘

自動偵測 Google 表單回覆，並根據條件過濾與發送通知郵件。

**學習重點**：
- Google Form 與 Google Sheets 整合
- Google Sheets Trigger 觸發器
- 條件判斷與資料過濾
- 自動化通知系統

---

### [⭐⭐ 範例五：訂便當系統](./訂便當/README.md)
**難度**: 中級 | **學習時間**: 40-60 分鐘

建立一個完整的線上訂便當系統，使用者透過網頁表單訂購，系統自動將訂單儲存至 Google 試算表。

**學習重點**：
- Form Trigger 表單觸發器
- 字串處理與資料分割
- 資料型態轉換
- Google Sheets 資料寫入

---

### [⭐⭐⭐ 範例六：取得台北市 YouBike 資料](./取得台北市youbike資料/README.md)
**難度**: 進階 | **學習時間**: 45-60 分鐘

抓取臺北市 YouBike 2.0 即時開放資料 API，過濾警戒站點，並透過 Google Drive 搜尋智慧判斷今日試算表是否存在，自動新增 Sheet 或建立新試算表歸檔紀錄。

**學習重點**：
- 開放資料 API 串接與欄位中文化
- 多條件數據過濾與警戒站點監控
- n8n 資料流 Aggregate 與 Code 拆解技巧
- Google Drive 自動搜尋與 Google Sheets 動態分頁建檔

---

## 🎯 學習路徑建議

建議按照以下順序實作：

1. **儲存檔案至 Google Drive** → 學習基本的 Google API 整合
2. **自動寄送 Gmail** → 掌握排程觸發與郵件發送
3. **寄送一則笑話** → 進階的多 API 串接技巧
4. **訂便當系統** → 學習表單觸發與資料處理技巧
5. **學生體驗回饋問卷範本** → 完整的表單處理自動化流程
6. **取得台北市 YouBike 資料** → 動態檔案搜尋、條件分支與進階 Sheets 歸檔

---

## 📚 相關資源

- [Google Cloud 設定指南](../google_cloud設定/README.md)
- [OAuth (開放授權) 的概念](../OAuth/README.md)
- [Google Cloud Console](https://console.cloud.google.com/)
- [n8n 官方文件](https://docs.n8n.io/)
