![](./images/n8n實戰教學講義.png)

# n8n 實戰教學講義

## 📘 關於 n8n

**n8n** 起初的名稱為 **nodemation**（節點自動化），後簡化為 **n8n**（這種縮寫法來自 internationalization → i18n）。n8n 的核心理念是**整合所有帶有 API 的應用程式和服務**，並強調其**無程式碼 (No Code)** 或**低程式碼 (Low Code)** 的特性，讓非技術背景的使用者也能輕鬆建立自動化工作流。

## 🧩 n8n 工作流的五個核心邏輯要素

1. **觸發 (Trigger)** - 啟動工作流的起點
2. **連接 (Connect)** - 連結不同的服務和應用程式
3. **資料處理 (Transform)** - 轉換和處理資料
4. **測試 (Test)** - 驗證工作流是否正常運作
5. **啟動 (Activate)** - 執行自動化任務

---

## 📚 課程章節

### 🚀 [第一章：n8n 簡介與安裝](./n8n簡介與安裝/README.md)
學習 n8n 的核心概念、支援的安裝方式（Docker、npm），以及如何建立固定網址（ngrok）以接收外部 Webhook。

### 🔐 [關於 OAuth (開放授權) 的概念](./OAuth/README.md)
了解 OAuth 2.0 的運作原理，這是連接 Google、LINE 等第三方服務的關鍵技術。

### ☁️ [Google Cloud 的 API 服務設定重點](./Google_Cloud_api服務/README.md)
學習如何在 Google Cloud Platform 建立專案、啟用 API，以及設定 OAuth 憑證。

---

## 🎯 初階範例

### 1. [**初體驗**](./初階範例/範例_初體驗.md)
第一個 n8n 工作流！學習基本的觸發與資料傳遞。

```
[執行工作流] → [Customer Datastore] → [Edit Fields] → [Customer Messenger]
```

---

### 2. [**透過互動式逐步教程學習 JSON 基礎（適合初學者）**](./初階範例/範例_透過互動式逐步教程學習JSON基礎(適合初學者).md)
JSON 是自動化流程的資料核心。透過這個實作範例，您將學會如何建立和操作 JSON 格式。

```
[Execute to Start] → [Key & Value] → [String] → [Number] → [Boolean] → [Null] → [Array] → [Object] → [Using JSON] → [Final Exam]
```

---

### 3. [**透過網站取得引言**](./初階範例/範例_透過網站取得引言.md)
學習如何使用 **HTTP Request** 節點發送請求並抓取外部 API 資料。

**技術重點**：HTTP 請求、欄位整理

```
[便利貼說明] → [手動觸發] → [HTTP 請求取得引言] → [整理並重新命名欄位]
```

---

## 🔗 整合 Google 服務

### 1. [**自動寄送 Gmail**](./Google_Cloud_api服務/範例_寄送gmail.md)
結合定時觸發 (Schedule Trigger) 與 Gmail 節點，自動發送每日引言信件。

**技術重點**：HTTP 請求、Gmail API

```
[便利貼說明] → [排程觸發] → [HTTP 請求取得引言] → [整理並重新命名欄位] → [寄送 Gmail]
```

---

### 2. [**寄送一則笑話**](./Google_Cloud_api服務/範例_寄送一個笑話.md)
串接多個 API 來源（引言 + 程式笑話），組合成更有趣的自動化內容。

**技術重點**：多 HTTP 請求、資料合併、Gmail API

```
[便利貼說明] → [排程觸發] → [HTTP 引言] → [HTTP 程式笑話] → [整理欄位] → [寄送 Gmail]
```

---

### 3. [**學生體驗回饋問卷範本**](./Google_Cloud_api服務/學生體驗回饋問卷範本.md)
自動偵測 Google 表單回覆，並根據條件觸發通知郵件。

**技術重點**：
- 手動建立 Google Form
- 自動產生 Google Sheet
- Google Sheet 新增資料觸發
- 條件判斷與 Gmail 通知

---

## 🤖 整合 LLM 模型

> **即將推出**：學習如何將 OpenAI、Claude、Gemini 等大型語言模型整合到 n8n 工作流中。

---

## 整合Webhook的實作

### 1. [**自動化問候系統**](./Webhook的實作/README.md)

## 🗄️ [Supabase 整合](./supabase整合/README.md)
使用開源的 Firebase 替代方案 Supabase，學習即時資料庫、檔案儲存和身份驗證的整合。

## 📜 [Google Apps Script (GAS) 整合](./GAS整合/README.md)
結合 Google Apps Script 的自訂函數與 n8n 工作流，打造更強大的 Google 工作區自動化。

## ⚡ [FastAPI 整合](./FastAPI整合/)
建立自訂 Python API 服務，讓 n8n 能夠呼叫您自己的資料處理邏輯和機器學習模型。

## 🌍 [n8n 的免費部署方案](./n8n的部署/README.md)
了解如何將 n8n 部署到本機、Raspberry Pi、Oracle Cloud 等免費平台，打造 7x24 小時運行的自動化伺服器。

---

**🎓 持續更新中，敬請期待更多實戰範例！**
