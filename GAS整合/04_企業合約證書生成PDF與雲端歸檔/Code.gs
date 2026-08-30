/**
 * ==============================================================================
 * 範例 4：Google Apps Script (GAS) 企業合約/證書生成 PDF 與雲端歸檔
 * ==============================================================================
 * 說明：
 * 接收 n8n 傳送的合約雙方條款與金額，自動套版、轉換為正式 PDF 唯讀格式、
 * 儲存至指定的 Google Drive 歸檔資料夾，並自動清理暫存 Google Doc 檔案。
 */

function doPost(e) {
  try {
    var requestData = JSON.parse(e.postData.contents);
    
    var templateId = requestData.templateId;
    var targetFolderId = requestData.folderId;
    var contractNo = requestData.contractNo || "CTR-2026-001";
    var partyA = requestData.partyA || "甲方企業";
    var partyATaxId = requestData.partyATaxId || "-";
    var partyB = requestData.partyB || "乙方企業";
    var partyBTaxId = requestData.partyBTaxId || "-";
    var effectiveDate = requestData.effectiveDate || "2026-01-01";
    var expiryDate = requestData.expiryDate || "2026-12-31";
    var contractAmount = requestData.contractAmount || "$0";
    var signDate = Utilities.formatDate(new Date(), "Asia/Taipei", "yyyy-MM-dd");

    // 1. 取得範本並建立臨時副本
    var templateFile = DriveApp.getFileById(templateId);
    var targetFolder = targetFolderId ? DriveApp.getFolderById(targetFolderId) : DriveApp.getRootFolder();
    var tempDocFile = templateFile.makeCopy("TEMP_" + contractNo, targetFolder);
    var tempDocId = tempDocFile.getId();

    var doc = DocumentApp.openById(tempDocId);
    var body = doc.getBody();

    // 2. 替換合約佔位符
    body.replaceText("\\{\\{CONTRACT_NO\\}\\}", contractNo);
    body.replaceText("\\{\\{PARTY_A\\}\\}", partyA);
    body.replaceText("\\{\\{PARTY_A_TAX_ID\\}\\}", partyATaxId);
    body.replaceText("\\{\\{PARTY_B\\}\\}", partyB);
    body.replaceText("\\{\\{PARTY_B_TAX_ID\\}\\}", partyBTaxId);
    body.replaceText("\\{\\{EFFECTIVE_DATE\\}\\}", effectiveDate);
    body.replaceText("\\{\\{EXPIRY_DATE\\}\\}", expiryDate);
    body.replaceText("\\{\\{CONTRACT_AMOUNT\\}\\}", contractAmount);
    body.replaceText("\\{\\{SIGN_DATE\\}\\}", signDate);

    doc.saveAndClose();

    // 3. 轉為 PDF Blob 並儲存至目標資料夾
    var pdfBlob = tempDocFile.getAs(MimeType.PDF);
    var pdfFileName = "【正式合約】" + partyA + "_" + partyB + "_" + contractNo + ".pdf";
    var pdfFile = targetFolder.createFile(pdfBlob).setName(pdfFileName);

    // 4. 刪除中間暫存的 Google Doc 文件，保持 Drive 乾淨
    tempDocFile.setTrashed(true);

    var response = {
      status: "success",
      message: "合約已成功生成 PDF 並完成 Google Drive 歸檔！",
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
