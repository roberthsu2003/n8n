# Google Cloud API 服務設定指南 ☁️

本指南詳細說明如何使用 **Google Cloud Console** 建立專案、啟用 Google 服務 API，並透過標準 **OAuth 2.0** 授權流程取得憑證，讓 n8n 能代表您安全地操作 Google 試算表 (Sheets)、雲端硬碟 (Drive)、Gmail 與日曆 (Calendar) 等服務。

---

## 📍 申請位置與快速入口

* **步驟 1**：進入 [Google Cloud Console](https://console.cloud.google.com/)（首次使用請先建立新專案）。
* **步驟 2**：在頂部搜尋欄輸入搜尋 **`Google Auth Platform`**（或「Google 驗證平台」），進入整合式驗證設定頁面。
* **步驟 3**：在「**總覽 (Overview)**」頁面，點擊「**建立 OAuth 用戶端**」開始設定。
* **步驟 4**：應用程式類型選擇「**網頁應用程式 (Web application)**」。
* **步驟 5**：建立用戶端名稱，並在「**已授權的重新導向 URI**」填入 n8n 的回呼網址（Redirect URL）。
* **步驟 6**：取得 **Client ID** 與 **Client Secret**，填入 n8n 的 Credentials (憑證) 中，並點擊「**Sign in with Google**」完成授權。

---

## 目錄

- [設定前置畫面參考](#設定前置畫面參考)
- [詳細設定步驟](#詳細設定步驟)
  - [第 1 部分：Google Cloud 平台設定](#第-1-部分google-cloud-平台設定)
  - [第 2 部分：n8n 平台設定](#第-2-部分n8n-平台設定)
  - [第 3 部分：完成雙向綁定與授權](#第-3-部分完成雙向綁定與授權)
- [🔄 授權驗證流程（實際畫面）](#-授權驗證流程實際畫面)
- [⚠️ 常見錯誤與排錯重點 (必看)](#️-常見錯誤與排錯重點-必看)

---

## 設定前置畫面參考

### Google Cloud 設定畫面參考

- **1. 品牌設定 (OAuth 同意畫面 / 品牌資訊)**
  - **應用程式名稱**：設定自訂名稱（例如：`My n8n Workflow`）。
  - **使用者支援電子郵件**：選擇您自己的 Google / Gmail 電子郵件。
  - **授權網域 (Authorized domains)**：輸入您的 **n8n 自訂網域**（例如：`xxxx.ngrok-free.dev` 或您的獨立網域，請勿包含 `https://`）。
  - **開發人員聯絡資訊**：填寫您自己的 Email。
  
  ![品牌](./images/品牌.png)

- **2. 目標對象設定 (Audience / 測試使用者設定)**
  - **使用者類型**：設定為「**外部 (External)**」。
  - **測試使用者 (Test users)**：**務必點擊「+ ADD USERS」將您自己的 Gmail 加入名單**，否則驗證時會被 Google 拒絕 (Error 403: access_denied)。
  
  ![目標對象](./images/目標對象.png)

- **3. 用戶端 ID 與密碼取得**
  ![用戶端](./images/用戶端.png)
  ![用戶端1](./images/用戶端1.png)

### n8n 憑證設定畫面參考

- **n8n Google OAuth2 API 憑證畫面**
  ![n8n](./images/n8n.png)

---

## 詳細設定步驟

### 第 1 部分：Google Cloud 平台設定

1. **登入並建立新專案**
   - 前往 [Google Cloud Console](https://console.cloud.google.com/)。
   - 點擊頂部專案選單 > 點選「**新增專案 (New Project)**」，輸入專案名稱（例如：`n8n-automation`）並點擊「建立」。
   - 確保頂部專案選單已切換至剛剛建立的專案。

2. **啟用您需要的 Google API**
   - 在左側導覽「**API 與服務**」>「**程式庫**」（或頂部搜尋目標 API 名稱）。
   - 依據需求搜尋並點擊「**啟用**」對應的 API：
     - **Google Sheets API**（試算表讀寫）
     - **Google Drive API**（雲端硬碟檔案上傳與搜尋）
     - **Gmail API**（郵件讀取與自動發信）
     - **Google Calendar API**（日曆活動讀寫）

3. **設定 OAuth 同意畫面 (Google Auth Platform)**
   - 在 Console 頂部搜尋欄輸入 **`Google Auth Platform`** 進入設定。
   - 使用者類型選擇「**外部 (External)**」。
   - 填寫**應用程式名稱**（如 `My n8n Automation`）、**使用者支援信箱**與**開發人員聯絡資訊**。
   - 授權網域填入 n8n 的網域名稱（例如：`xxxx.ngrok-free.dev`）。
   - **重要**：在「**測試使用者 (Test users)**」欄位，點擊「**+ ADD USERS**」加入您要登入授權的 Gmail 帳號。

4. **建立 OAuth 2.0 用戶端 ID**
   - 點選「**憑證 (Credentials)**」>「**+ 建立憑證**」>「**OAuth 用戶端 ID**」。
   - **應用程式類型**：選擇「**網頁應用程式 (Web application)**」。
   - **名稱**：自訂名稱（例如 `n8n Client`）。
   - **已授權的重新導向 URI (Authorized redirect URIs)**：先保持開啟，下一步前往 n8n 複製回呼網址。

---

### 第 2 部分：n8n 平台設定

1. 登入 n8n 工作區，點選左側「**Credentials (憑證)**」> 點擊「**Add credential**」。
2. 搜尋並選擇「**Google OAuth2 API**」（或各特定節點對應的 Google 憑證）。
3. 在設定面板中，複製「**OAuth Redirect URL**」（例如：`https://xxxx.ngrok-free.dev/rest/oauth2/callback`）。

---

### 第 3 部分：完成雙向綁定與授權

1. 回到 GCP 的建立用戶端頁面，在「**已授權的重新導向 URI**」點擊「**+ 新增 URI**」，貼上剛剛從 n8n 複製的網址並點擊「**建立**」。
2. 建立成功後，Google 會彈出視窗顯示 **用戶端 ID (Client ID)** 與 **用戶端密碼 (Client Secret)**：
   - 複製 **Client ID** 貼到 n8n 的「**Client ID**」欄位。
   - 複製 **Client Secret** 貼到 n8n 的「**Client Secret**」欄位。
3. 在 n8n 憑證頁面點擊右下角「**Save**」儲存。

---

## 🔄 授權驗證流程（實際畫面）

1. 儲存後，在 n8n 憑證頁面點擊「**Sign in with Google**」按鈕。
2. 瀏覽器會彈出 Google 登入視窗，請選擇您在「測試使用者」中加入的 Gmail 帳號。
3. 若出現「**Google 尚未驗證這個應用程式**」的畫面：
   - 點擊左下角的「**進階 (Advanced)**」。
   - 點擊「**前往「My n8n Workflow」(不安全)**」（此為個人專案正常現象）。
4. 勾選授權存取項目並點擊「**允許 (Allow)**」。
5. 視窗關閉並返回 n8n，顯示「**Connection successful!**」綠色提示即代表授權成功！🎉

---

## ⚠️ 常見錯誤與排錯重點 (必看)

1. **Error 403: access_denied（存取被拒）**：
   - 原因：未將登入帳號加入「測試使用者 (Test users)」。
   - 解法：回到 Google Cloud Console > Google Auth Platform > 目標對象，將該 Gmail 加入測試使用者清單。
2. **Error 400: redirect_uri_mismatch（重新導向 URI 不相符）**：
   - 原因：GCP 填寫的「已授權重新導向 URI」與 n8n 的 Redirect URL 不一致。
   - 解法：確保 ngrok 公開網址完整填寫且末端為 `/rest/oauth2/callback`。
3. **API not enabled（API 尚未啟用）**：
   - 原因：n8n 連線成功但在工作流執行節點時報錯。
   - 解法：至 GCP 的「API 與服務」>「程式庫」搜尋該服務（如 Google Drive API、Gmail API）並點擊啟用。
4. **Client Secret 遺失**：
   - 建立時請立即複製保存；若遺失可於 GCP 憑證頁面重新生成一組密碼並更新至 n8n。
