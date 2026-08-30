# Telegram 整合實作
## 範例 4：Telegram 發送照片與多媒體/文件檔案（圖文與報表自動推播）

### 📚 工作流程說明

這個 n8n 工作流程示範如何利用 Telegram 節點發送**高解析度照片（Send Photo）**與**文件檔案（Send Document，如 CSV、PDF、Excel 等）**。在自動化流程中，除了純文字推播外，將數據圖表化並即時附上報表檔案，能夠極大化資訊傳達效率。Telegram 提供完善的多媒體支援，並允許在發送圖片或檔案時一併附加 **Markdown 排版的說明文字（Caption）**。

---

### 流程架構圖

```mermaid
flowchart LR
    A["👆 手動或排程觸發 (Trigger)"] --> B["📋 設定多媒體與報表資料 (Set 節點)"]
    B --> C["🖼️ 發送 Telegram 照片與圖表 (Send Photo)"]
    C --> D["📁 發送 Telegram 文件檔案 (Send Document)"]
    D --> E["📱 Telegram 聊天室收到圖文與下載檔案"]
```

---

### 工作流程樣版下載

- [📥 Telegram 發送多媒體與文件樣版 (telegram_send_media.json)](./telegram_send_media.json)

---

#### 📋 節點詳細說明

1. **📝 流程說明（Sticky Note）**
   - **功能**：說明如何傳遞外部圖片網址或本機/二進位檔案，以及設定圖文說明的技巧。

2. **👆 手動觸發測試（Manual Trigger Node）**
   - **功能**：點擊「Execute Workflow」手動執行測試（亦可替換為 Schedule Trigger 排程觸發）。

3. **📋 設定多媒體與報表資料（Edit Fields / Set Node）**
   - **功能**：準備推播相關素材與目標聊天室 ID：
     - `targetChatId`：接收檔案的 Telegram Chat ID。
     - `photoUrl`：高畫質圖片或圖表公開 URL（亦可為 n8n 二進位資料 `data`）。
     - `photoCaption`：圖片下方顯示的 Markdown 說明文字。
     - `documentUrl`：報表檔案 URL（例如 CSV 檔）。
     - `documentCaption`：檔案下方附帶的說明文字。

4. **🖼️ 發送 Telegram 照片與圖表（Telegram Node - Send Photo）**
   - **功能**：調用 Telegram `sendPhoto` API。
   - **設定要點**：
     - **Resource**：`Photo`
     - **Operation**：`Send Photo`
     - **Chat ID**：`={{ $json.targetChatId }}`
     - **File**：`={{ $json.photoUrl }}`（可填入網址或以 `binaryData` 格式傳入）
     - **Additional Fields > Caption**：填入 `photoCaption` 並設定 `Parse Mode` 為 `Markdown`。

5. **📁 發送 Telegram 文件檔案（Telegram Node - Send Document）**
   - **功能**：調用 Telegram `sendDocument` API 發送實體檔案。
   - **設定要點**：
     - **Resource**：`Document`
     - **Operation**：`Send Document`
     - **Chat ID**：`={{ $('設定多媒體與報表資料').item.json.targetChatId }}`
     - **File**：`={{ $('設定多媒體與報表資料').item.json.documentUrl }}`
     - **Additional Fields > Caption**：填入檔案說明文字。

---

#### 🎯 學習重點

- **多媒體 Resource 操作**：掌握 Telegram 節點在 `Message`、`Photo`、`Document` 間的切換設定。
- **圖文整合 Caption**：學會為照片與檔案附加具備格式化排版的說明文字。
- **URL 與 Binary 資料相容性**：理解 Telegram 節點既支援直接給予公開網址，也支援上游節點產生的二進位檔案（如 Convert to File 節點轉換出的 Excel）。

---

#### 💡 實際應用場景

- **即時監視器/截圖告警**：網路攝影機或網頁異常時，自動截圖並推播至管理員 Telegram。
- **每週財務與業務報表**：自動產出 Excel / PDF 報表並直接推送至主管 Telegram 私聊。
- **AI 繪圖成果通知**：串接 Midjourney / Stable Diffusion 生成圖片後直接回傳給用戶。

---

#### ⚙️ 設定步驟

1. **匯入工作流程**：下載並將 [`telegram_send_media.json`](./telegram_send_media.json) 匯入至 n8n。
2. **填入目標 Chat ID**：在「設定多媒體與報表資料」節點中，將 `targetChatId` 改為您的實際 Chat ID。
3. **綁定 Telegram 憑證**：確認兩個 Telegram 節點皆已選取 Telegram 憑證。
4. **執行測試**：點擊「Execute Workflow」，即可在 Telegram 依序收到精美的圖文卡片與 CSV 下載檔案！
