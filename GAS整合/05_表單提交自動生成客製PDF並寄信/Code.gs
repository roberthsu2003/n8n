/**
 * ==============================================================================
 * 範例 5：Google Apps Script (GAS) 雙向整合腳本
 * ==============================================================================
 * 包含兩部分：
 * 1. onFormSubmit(e)：當客戶提交 Google 表單時，自動將填寫內容 POST 給 n8n Webhook。
 * 2. doPost(e)：接收 n8n 請求，產生具備企業 Logo 與客製格式的正式 PDF 確認函。
 */

// ------------------------------------------------------------------------------
// 第一部分：Google 表單提交觸發器（綁定在 Google 試算表或表單專案）
// ------------------------------------------------------------------------------
function onFormSubmit(e) {
  var n8nWebhookUrl = "https://<你的n8n網址>/webhook/google-form-submission";
  
  // 取得表單提交的回應內容
  var itemResponses = e.response.getItemResponses();
  var formData = {};
  
  for (var i = 0; i < itemResponses.length; i++) {
    var title = itemResponses[i].getItem().getTitle();
    var response = itemResponses[i].getResponse();
    formData[title] = response;
  }
  
  // 整合提交者 Email
  formData["customerEmail"] = e.response.getRespondentEmail() || formData["電子信箱"] || formData["Email"];
  formData["customerName"] = formData["姓名"] || formData["Name"] || "貴賓";
  formData["servicePlan"] = formData["服務方案"] || formData["預約項目"] || "企業客製化方案";
  formData["notes"] = formData["備註需求"] || "-";

  // 發送 POST 請求至 n8n Webhook
  var options = {
    method: "post",
    contentType: "application/json",
    payload: JSON.stringify(formData),
    muteHttpExceptions: true
  };

  UrlFetchApp.fetch(n8nWebhookUrl, options);
}

// ------------------------------------------------------------------------------
// 第二部分：PDF 套版 Web App 處理器 (doPost)
// ------------------------------------------------------------------------------
function doPost(e) {
  try {
    var requestData = JSON.parse(e.postData.contents);
    
    var templateId = requestData.templateId;
    var targetFolderId = requestData.folderId;
    var customerName = requestData.customerName || "貴賓";
    var customerEmail = requestData.customerEmail || "-";
    var servicePlan = requestData.servicePlan || "企業客製化方案";
    var notes = requestData.notes || "-";
    var date = Utilities.formatDate(new Date(), "Asia/Taipei", "yyyy-MM-dd HH:mm");

    // 1. 複製預約確認函範本
    var templateFile = DriveApp.getFileById(templateId);
    var targetFolder = targetFolderId ? DriveApp.getFolderById(targetFolderId) : DriveApp.getRootFolder();
    var tempDoc = templateFile.makeCopy("TEMP_CONFIRMATION_" + customerName, targetFolder);
    var tempDocId = tempDoc.getId();

    var doc = DocumentApp.openById(tempDocId);
    var body = doc.getBody();

    // 2. 替換佔位符
    body.replaceText("\\{\\{CUSTOMER_NAME\\}\\}", customerName);
    body.replaceText("\\{\\{CUSTOMER_EMAIL\\}\\}", customerEmail);
    body.replaceText("\\{\\{SERVICE_PLAN\\}\\}", servicePlan);
    body.replaceText("\\{\\{NOTES\\}\\}", notes);
    body.replaceText("\\{\\{SUBMIT_DATE\\}\\}", date);

    doc.saveAndClose();

    // 3. 產出 PDF 並儲存
    var pdfBlob = tempDoc.getAs(MimeType.PDF);
    var pdfFileName = "【預約確認單】" + customerName + "_" + servicePlan + ".pdf";
    var pdfFile = targetFolder.createFile(pdfBlob).setName(pdfFileName);

    // 4. 清理暫存檔案
    tempDoc.setTrashed(true);

    var response = {
      status: "success",
      message: "預約確認 PDF 已成功產生！",
      pdfId: pdfFile.getId(),
      pdfName: pdfFileName,
      pdfUrl: pdfFile.getUrl(),
      downloadUrl: "https://drive.google.com/uc?export=download&id=" + pdfFile.getId()
    };

    return ContentService.createTextOutput(JSON.stringify(response))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (error) {
    var errorResponse = {
      status: "error",
      message: error.toString()
    };
    return ContentService.createTextOutput(JSON.stringify(errorResponse))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
