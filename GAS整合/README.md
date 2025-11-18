n8n 和 Google Apps Script (GAS) **可以完美整合**，而且這是一種非常強大且彈性的「進階」用法。

這種整合**不是**透過 n8n 內建的「Google Apps Script 節點」（n8n 沒有這個節點），而是透過兩者都支援的通用方法：**Webhook** 和 **HTTP 請求**。

簡單來說，您可以讓 n8n 和 GAS 互相「呼叫」對方。

整合的方式主要有兩種情境：

1.  **n8n 觸發 Google Apps Script** (n8n 呼叫 GAS)
2.  **Google Apps Script 觸發 n8n** (GAS 呼叫 n8n)

-----

### 🌍 情境一：n8n 觸發 Google Apps Script (n8n → GAS)

這是最常見的用法。您可以把 GAS 寫好的複雜功能，「發佈」成一個 API，然後讓 n8n 去呼叫它。

**適用時機：**

  * n8n 內建的 Google 節點（如 Google Sheets、Google Docs）功能不足時。
  * 您需要執行非常複雜的 Google 文件操作（例如：動態生成圖表、複雜的儲存格合併、管理文件權限）。
  * 您想在 Google Drive 中執行批次搜尋或檔案管理。

#### 實作步驟：

**1. 在 Google Apps Script (GAS) 端：**

  * 您需要編寫一個 `doPost(e)` 函式。這個函式會接收 n8n 傳來的資料。
  * **【關鍵】** 您必須將此 GAS 專案**部署為「網路應用程式」(Web App)**。
  * 部署時，將存取權設為「**任何人**(Anyone)」或「**任何知道連結的人**(Anyone, even anonymous)」。
      * *（安全提示：建議您在 GAS 程式碼中加入一個自訂的密鑰（Token）驗證，n8n 呼叫時必須在 Header 或參數中帶上這個密鑰，以確保安全。）*
  * 部署後，您會得到一個 **Web App URL**。

**範例 `doPost(e)` 程式碼：**

```javascript
// Google Apps Script (Code.gs)

function doPost(e) {
  try {
    // 1. 解析 n8n 傳來的 JSON 資料
    var data = JSON.parse(e.postData.contents);
    
    // 2. 取得資料
    var userName = data.name;
    var userEmail = data.email;
    
    // 3. 執行您複雜的 Google 服務邏輯
    //    例如：在 Google Docs 某個範本中填入資料
    var doc = DocumentApp.openById("YOUR_TEMPLATE_DOC_ID");
    doc.getBody().replaceText("{{NAME}}", userName);
    doc.getBody().replaceText("{{EMAIL}}", userEmail);
    doc.saveAndClose();
    
    // 4. 回傳成功訊息給 n8n
    return ContentService
      .createTextOutput(JSON.stringify({ "status": "success", "docId": doc.getId() }))
      .setMimeType(ContentService.MimeType.JSON);
      
  } catch (err) {
    // 5. 回傳錯誤訊息給 n8n
    return ContentService
      .createTextOutput(JSON.stringify({ "status": "error", "message": err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
```

**2. 在 n8n 端：**

  * 在您的工作流中，使用 **HTTP Request** 節點。
  * **Method:** 設為 `POST`。
  * **URL:** 貼上您從 GAS 部署後取得的 **Web App URL**。
  * **Body Content Type:** 設為 `JSON`。
  * **Body:** 放入您要傳送的 JSON 資料，例如：
    ```json
    {
      "name": "{{ $json.customerName }}",
      "email": "{{ $json.customerEmail }}"
    }
    ```

-----

### 🌍 情境二：Google Apps Script 觸發 n8n (GAS → n8n)

這種情況比較少見，但同樣有用。您可以讓 Google 環境中的事件（例如：試算表被編輯、定時器）來啟動 n8n 的工作流。

**適用時機：**

  * 當 Google Sheets 儲存格被手動編輯時 (使用 `onEdit` 觸發器)。
  * 當有 Google Form 提交時 (使用 `onFormSubmit` 觸發器)。
  * 您希望在 GAS 中設定一個定時排程 (Time-based trigger) 來啟動 n8n。

#### 實作步驟：

**1. 在 n8n 端：**

  * 在您的工作流中，使用 **Webhook** 節點作為觸發器。
  * **HTTP Method:** 設為 `POST`。
  * **Webhook URLs:** 複製「Test URL」（測試時用）或「Production URL」（正式上線用）。

**2. 在 Google Apps Script (GAS) 端：**

  * 您需要使用 GAS 的 `UrlFetchApp` 服務來呼叫 n8n 的 Webhook URL。
  * 您可以將這段程式碼放在任何您需要的觸發器函式中（如 `onEdit`, `onFormSubmit` 或定時器）。

**範例 `onEdit(e)` 程式碼：**

```javascript
// Google Apps Script (Code.gs)

function onSpreadsheetEdit(e) {
  // 1. 取得 n8n 的 Webhook URL
  var n8nWebhookUrl = "https://your-n8n-instance.com/webhook/YOUR_WEBHOOK_ID";
  
  // 2. 準備要傳送的資料
  var range = e.range;
  var sheetName = range.getSheet().getName();
  var cellValue = range.getValue();
  var cellA1 = range.getA1Notation();

  var payload = {
    "sheet": sheetName,
    "cell": cellA1,
    "newValue": cellValue,
    "user": e.user.getEmail()
  };

  // 3. 設定 HTTP POST 選項
  var options = {
    "method": "post",
    "contentType": "application/json",
    "payload": JSON.stringify(payload)
  };
  
  // 4. 呼叫 n8n Webhook
  try {
    UrlFetchApp.fetch(n8nWebhookUrl, options);
  } catch (err) {
    Logger.log("Failed to call n8n webhook: " + err);
  }
}

// 別忘了為這個函式設定 'onEdit' 觸發器！
// (在 GAS 編輯器 > 觸發條件 > 新增觸發條件)
```

-----

### 總結比較

| 整合方式 | **n8n 節點** | **GAS 函式** | **主要用途** |
| :--- | :--- | :--- | :--- |
| **n8n → GAS** | `HTTP Request` | `doPost(e)` (部署為 Web App) | 執行 n8n 節點做不到的複雜 Google 服務 (如 Docs, Drive) |
| **GAS → n8n** | `Webhook` | `UrlFetchApp.fetch()` (搭配觸發器) | 用 Google 內部的事件 (如 onEdit, onFormSubmit) 來啟動 n8n 流程 |

總之，n8n + GAS 是一個非常強大的組合，可以讓您克服 n8n 在 Google 生態系中可能遇到的功能限制。