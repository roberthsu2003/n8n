這非常適合 n8n！您正在做的事情是標準的 OAuth 2.0 授權流程，n8n 已經將其簡化了。

您的目標是讓 n8n (第三方應用) 獲得您的授權，以便代表您 (用戶) 去操作您在 Google 服務 (如 Sheets, Calendar, Drive) 上的資料。

以下是針對 n8n 節點設定 Google Cloud 個人專案的完整步驟、注意事項和流程。

---


### 圖片設定說明:
#### google cloud
- [品牌png](./images/品牌.png)
- [目標對象png](./images/目標對象.png)
- [用戶端png](./images/用戶端.png)
- [用戶端1png](./images/用戶端1.png)

####
- [n8npng](./images/n8n.png)

### 注意事項
- 用戶端密碼必需建立時保留,沒有保留就要新增一組密碼

### 🚀 設定的步驟

我們將這個過程分為兩大部分：
1.  **在 Google Cloud (GCP) 平台**：設定「同意畫面」並取得「憑證」。
2.  **在 n8n 平台**：貼上憑證並完成授權。

#### 第 1 部分：Google Cloud 平台設定

1.  **登入並選擇專案**
    * 登入 [Google Cloud Console](https://console.cloud.google.com/)。
    * 確保您已選擇了您的個人免費專案 (或建立一個新專案)。

2.  **啟用您需要的 API**
    * 這是**非常關鍵**的一步。您必須先「啟用」您想用的服務 API，否則 n8n 連線了也無法運作。
    * 到「API 與服務」>「程式庫」。
    * 搜尋並啟用您需要的 API，例如：
        * **Google Sheets API** (用於 Google Sheets 節點)
        * **Google Drive API** (用於 Google Drive 節點)
        * **Google Calendar API** (用於 Google Calendar 節點)
        * **Gmail API** (用於 Gmail 節點)
    * *提醒：啟用 API 是免費的，費用是根據「用量」計算的，而個人專案的免費額度 (Free Tier) 通常綽綽有餘。*

3.  **設定 OAuth 同意畫面 (Consent Screen)**
    * 這是 Google 向您顯示「您是否同意 n8n 存取您的資料？」的那個畫面。
    * 到「API 與服務」>「OAuth 同意畫面」。
    * 選擇「**外部 (External)**」。(因為您的帳號不是 Google Workspace 企業版)
    * **填寫基本資料**：
        * **應用程式名稱**：隨便填，例如 "My n8n Workflow"。
        * **使用者支援電子郵件**：選擇您自己的 Gmail。
        * **應用程式標誌**：可不填。
        * **開發人員聯絡資訊**：填寫您自己的 Gmail。
    * **設定範圍 (Scopes)**：您可以**先跳過**此步驟，n8n 會在連線時自動要求它需要的範圍。
    * **設定測試使用者 (Test Users)**：
        * **⚠️ 這是個人專案的【絕對重點】！**
        * 由於您的應用程式是「外部」且未發布，Google 會限制只有「測試使用者」才能登入。
        * 在「Test users」步驟中，點選「+ ADD USERS」，然後**輸入您自己的 Gmail 帳號**。
        * 如果您漏了這一步，您在 n8n 進行驗證時 100% 會被 Google 拒絕 (錯誤訊息 403: access_denied)。

4.  **建立 OAuth 2.0 憑證 (Client ID)**
    * 到「API 與服務」>「憑證」。
    * 點擊「+ 建立憑證」> 選擇「**OAuth 2.0 用戶端 ID**」。
    * **應用程式類型**：選擇「**網頁應用程式 (Web application)**」。
    * **名稱**：隨便填，例如 "n8n Credential"。
    * **已授權的重新導向 URI (Authorized redirect URIs)**：
        * **這是第二個重點！** 您需要在這裡填入 n8n 提供的「回呼網址 (Callback URL)」。
        * *請先暫停，我們跳到 n8n 介面去取得這個網址。*

#### 第 2 部分：n8n 平台設定

1.  **開啟 n8n 並建立新憑證**
    * 登入您的 n8n。
    * 在左側導覽列點選「Credentials (憑證)」。
    * 點擊「Add credential (新增憑證)」。
    * 在搜尋框中輸入 "Google"，然後選擇「**Google OAuth2 API**」。(這是適用於 Sheets, Drive 等的大多數 Google 節點的憑證)。

2.  **複製 n8n 的回呼網址 (Redirect URL)**
    * 在 n8n 的憑證設定畫面中，您會看到一個欄位叫做「**Redirect URL**」。
    * 它的格式通常是 `https://[your-n8n-domain]/rest/oauth2/callback`。
    * **複製**這個網址。

#### 第 3 部分：完成設定 (兩邊同步)

1.  **貼上回呼網址到 GCP**
    * 回到您在 GCP 的「建立 OAuth 2.0 用戶端 ID」頁面 (步驟 1-4)。
    * 在「已授權的重新導向 URI」下方，點擊「+ 新增 URI」。
    * **貼上**您剛剛從 n8n 複製的網址。
    * 點擊「**建立**」。

2.  **複製 Client ID 和 Secret 到 n8n**
    * GCP 建立成功後，會彈出一個視窗，顯示您的「**用戶端 ID (Client ID)**」和「**用戶端密碼 (Client Secret)**」。
    * **複製**這兩串文字。
    * 回到 n8n 的憑證設定頁面。
    * 將「用戶端 ID」貼到 n8n 的「**Client ID**」欄位。
    * 將「用戶端密碼」貼到 n8n 的「**Client Secret**」欄位。

3.  **儲存與驗證**
    * (可選) 在 n8n 的「**Scopes**」(範圍) 欄位，您可以先不填，或填入最常用的：
        `https://www.googleapis.com/auth/spreadsheets`
        `https://www.googleapis.com/auth/drive`
        `https://www.googleapis.com/auth/calendar`
        (用逗號分隔)
    * 點擊 n8n 憑證頁面右下角的「**Save**」。

---

### 🔄 驗證流程 (您會實際看到的)

設定完成後，n8n 會自動引導您進行第一次的驗證：

1.  點擊 n8n 憑證上的「**Sign in with Google**」按鈕。
2.  畫面會跳轉到 Google 登入頁面，請登入您在 GCP「測試使用者」中加入的那個 Gmail 帳號。
3.  您會看到一個「**Google 尚未驗證這個應用程式**」的警告畫面。
    * **這是正常的！** 因為這是您自己開發的個人專案。
    * 點擊「**進階 (Advanced)**」。
    * 點擊「**前往「My n8n Workflow」(不安全)**」(My n8n Workflow 是您在步驟 1-3 設定的應用程式名稱)。
4.  Google 會顯示 n8n (您的應用) 請求的權限 (例如「查看及管理您的 Google 試算表」)。
5.  點擊「**允許 (Allow)**」。
6.  畫面會跳轉回 n8n，並顯示「**Connection successful!**」的綠色提示。
7.  **恭喜！** 您的 n8n 節點現在可以使用 Google 服務了。

---

### ⚠️ 重點注意事項 (總結)

1.  **「測試使用者」是關鍵**：在「OAuth 同意畫面」設定中，**務必**將您要登入的 Gmail 帳號加入「測試使用者」名單，否則 100% 失敗。
2.  **API 必須啟用**：在 GCP 「程式庫」中，n8n 要用的每個 API (Sheets, Drive, Calendar...) 都必須手動啟用。如果您在 n8n 節點執行時看到 "API not enabled" 相關錯誤，就是這裡沒做。
3.  **「重新導向 URI」必須完全相符**：n8n 顯示的 `Redirect URL` 必須「完整且精確」地貼到 GCP 的「已授權的重新導向 URI」欄位中，多一個或少一個斜線都不行。
4.  **「不安全」警告是正常的**：個人專案在驗證時看到的「未經驗證的應用程式」警告是正常現象，請安心點選「進階」並繼續。
5.  **Client Secret 勿外洩**：GCP 產生的「用戶端密碼 (Client Secret)」等同於密碼，不要洩露給任何人或貼在公開的論壇上。順帶一提，如果要取得所有應用程式的完整功能，請開啟 Gemini 系列應用程式活動記錄。


