/**
 * ==============================================================================
 * 範例 3：Google Apps Script (GAS) 動態多列報價單與收據生成腳本
 * ==============================================================================
 * 說明：
 * 接收 n8n 傳送的陣列型商品明細清單 (items)，自動在 Google Docs 報價單表格中
 * 動態新增列、填入商品名稱、數量、單價與小計，並替換稅金與總金額。
 */

function doPost(e) {
  try {
    var requestData = JSON.parse(e.postData.contents);
    
    var templateId = requestData.templateId;
    var targetFolderId = requestData.folderId;
    var quotationNo = requestData.quotationNo || "QUO-2026-001";
    var clientName = requestData.clientName || "客戶名稱";
    var clientTaxId = requestData.clientTaxId || "-";
    var date = requestData.date || Utilities.formatDate(new Date(), "Asia/Taipei", "yyyy-MM-dd");
    var items = requestData.items || [];
    var subtotal = requestData.subtotal || "$0";
    var tax = requestData.tax || "$0";
    var grandTotal = requestData.grandTotal || "$0";

    // 1. 複製報價單範本
    var templateFile = DriveApp.getFileById(templateId);
    var targetFolder = targetFolderId ? DriveApp.getFolderById(targetFolderId) : DriveApp.getRootFolder();
    var newFileName = "【報價單】" + clientName + "_" + quotationNo;
    var newDocFile = templateFile.makeCopy(newFileName, targetFolder);
    var newDocId = newDocFile.getId();

    var doc = DocumentApp.openById(newDocId);
    var body = doc.getBody();

    // 2. 搜尋包含 {{ITEM_NAME}} 的動態表格
    var foundItem = body.findText("\\{\\{ITEM_NAME\\}\\}");
    if (foundItem) {
      var cell = foundItem.getElement().getParent();
      while (cell.getType() !== DocumentApp.ElementType.TABLE_CELL) {
        cell = cell.getParent();
      }
      var row = cell.getParent().asTableRow();
      var table = row.getParent().asTable();
      var rowIndex = table.getChildIndex(row);

      // 動態遍歷商品陣列並插入新列
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        var newRow = table.insertTableRow(rowIndex + i + 1);
        
        newRow.appendTableCell(String(item.name || ""));
        newRow.appendTableCell(String(item.qty || "1"));
        newRow.appendTableCell(String(item.price || "$0"));
        newRow.appendTableCell(String(item.subtotal || "$0"));
      }

      // 移除原本的佔位符列
      table.removeRow(rowIndex);
    }

    // 3. 替換表頭與表尾金額文字佔位符
    body.replaceText("\\{\\{QUOTATION_NO\\}\\}", quotationNo);
    body.replaceText("\\{\\{CLIENT_NAME\\}\\}", clientName);
    body.replaceText("\\{\\{CLIENT_TAX_ID\\}\\}", clientTaxId);
    body.replaceText("\\{\\{DATE\\}\\}", date);
    body.replaceText("\\{\\{SUBTOTAL\\}\\}", subtotal);
    body.replaceText("\\{\\{TAX\\}\\}", tax);
    body.replaceText("\\{\\{GRAND_TOTAL\\}\\}", grandTotal);

    doc.saveAndClose();

    var response = {
      status: "success",
      message: "動態報價單已成功生成！",
      docId: newDocId,
      docName: newFileName,
      docUrl: newDocFile.getUrl(),
      totalItems: items.length,
      grandTotal: grandTotal
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
