/**
 * ==============================================================================
 * 範例 1：Google Apps Script (GAS) 基礎文字佔位符替換腳本
 * ==============================================================================
 * 說明：
 * 接收 n8n 透過 HTTP POST 傳送的 JSON 資料，複製 Google Docs 公版範本，
 * 將文件中的 {{CUSTOMER_NAME}}、{{COMPANY_NAME}} 等佔位符替換為真實資料，
 * 並將新文件儲存至指定的 Google 雲端硬碟資料夾。
 */

function doPost(e) {
  try {
    // 1. 解析 n8n 傳來的 JSON 資料
    var requestData = JSON.parse(e.postData.contents);
    
    var templateId = requestData.templateId;      // Google Doc 範本檔案 ID
    var targetFolderId = requestData.folderId;    // 存檔的 Drive 資料夾 ID
    var customerName = requestData.customerName || "貴賓";
    var companyName = requestData.companyName || "合作企業";
    var projectTitle = requestData.projectTitle || "專案合約";
    var date = requestData.date || Utilities.formatDate(new Date(), "Asia/Taipei", "yyyy-MM-dd");

    // 2. 取得範本並在指定資料夾建立副本
    var templateFile = DriveApp.getFileById(templateId);
    var targetFolder = targetFolderId ? DriveApp.getFolderById(targetFolderId) : DriveApp.getRootFolder();
    var newFileName = companyName + "_" + customerName + "_" + projectTitle;
    var newDocFile = templateFile.makeCopy(newFileName, targetFolder);
    var newDocId = newDocFile.getId();

    // 3. 開啟新副本文件並執行文字佔位符替換
    var doc = DocumentApp.openById(newDocId);
    var body = doc.getBody();

    body.replaceText("\\{\\{CUSTOMER_NAME\\}\\}", customerName);
    body.replaceText("\\{\\{COMPANY_NAME\\}\\}", companyName);
    body.replaceText("\\{\\{PROJECT_TITLE\\}\\}", projectTitle);
    body.replaceText("\\{\\{DATE\\}\\}", date);

    doc.saveAndClose();

    // 4. 回傳成功結果給 n8n
    var response = {
      status: "success",
      message: "文件已成功建立並替換佔位符！",
      docId: newDocId,
      docName: newFileName,
      docUrl: newDocFile.getUrl()
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
