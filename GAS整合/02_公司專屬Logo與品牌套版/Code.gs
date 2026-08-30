/**
 * ==============================================================================
 * 範例 2：Google Apps Script (GAS) 公司專屬 Logo 與品牌自訂套版
 * ==============================================================================
 * 說明：
 * 接收 n8n 傳來的企業品牌資訊與 Logo 圖片網址 (logoUrl)，
 * 在 Google Docs 範本中動態置入企業 Logo 圖片，並套入品牌標語、統一編號與聯絡資訊。
 */

function doPost(e) {
  try {
    var requestData = JSON.parse(e.postData.contents);
    
    var templateId = requestData.templateId;
    var targetFolderId = requestData.folderId;
    var companyName = requestData.companyName || "企業總部";
    var taxId = requestData.taxId || "00000000";
    var logoUrl = requestData.logoUrl;
    var slogan = requestData.slogan || "專業 · 創新 · 卓越";
    var address = requestData.address || "台北市信義區";
    var contactEmail = requestData.contactEmail || "service@example.com";
    var date = Utilities.formatDate(new Date(), "Asia/Taipei", "yyyy-MM-dd");

    // 1. 複製公版範本
    var templateFile = DriveApp.getFileById(templateId);
    var targetFolder = targetFolderId ? DriveApp.getFolderById(targetFolderId) : DriveApp.getRootFolder();
    var newFileName = "【正式公文】" + companyName + "_品牌通知函";
    var newDocFile = templateFile.makeCopy(newFileName, targetFolder);
    var newDocId = newDocFile.getId();

    var doc = DocumentApp.openById(newDocId);
    var body = doc.getBody();

    // 2. 動態尋找並置換 {{COMPANY_LOGO}} 圖片佔位符
    if (logoUrl) {
      var foundLogo = body.findText("\\{\\{COMPANY_LOGO\\}\\}");
      if (foundLogo) {
        var textElement = foundLogo.getElement();
        var paragraph = textElement.getParent().asParagraph();
        
        // 下載 Logo 圖片 Blob
        var imageBlob = UrlFetchApp.fetch(logoUrl).getBlob();
        var inlineImage = paragraph.insertInlineImage(0, imageBlob);
        
        // 設定 Logo 顯示尺寸 (例如寬 160px，高等比例縮放或設為 50px)
        inlineImage.setWidth(160);
        inlineImage.setHeight(50);
        
        // 清除文字佔位符
        textElement.asText().replaceText("\\{\\{COMPANY_LOGO\\}\\}", "");
      }
    }

    // 3. 替換品牌文字佔位符
    body.replaceText("\\{\\{COMPANY_NAME\\}\\}", companyName);
    body.replaceText("\\{\\{TAX_ID\\}\\}", taxId);
    body.replaceText("\\{\\{SLOGAN\\}\\}", slogan);
    body.replaceText("\\{\\{ADDRESS\\}\\}", address);
    body.replaceText("\\{\\{CONTACT_EMAIL\\}\\}", contactEmail);
    body.replaceText("\\{\\{DATE\\}\\}", date);

    doc.saveAndClose();

    var response = {
      status: "success",
      message: "企業品牌與 Logo 範本已成功套版！",
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
