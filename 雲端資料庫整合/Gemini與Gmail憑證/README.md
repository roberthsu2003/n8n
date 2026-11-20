# Gemini 與 Gmail 憑證設定

本章範例的 AI 都使用 **Google Gemini**（聊天模型 + Embedding 向量模型），通知與信件都使用 **Gmail**。這份指南說明兩種憑證的建立方式。

| 範例 | Gemini Chat Model | Gemini Embeddings | Gmail |
| :--- | :---: | :---: | :---: |
| 01 社團活動報名系統 | | | ✅ 寄確認信 |
| 02 早餐店每日營收日報 | | | ✅ 寄日報 |
| 03 圖書館逾期還書提醒 | | | ✅ 寄提醒信 |
| 04 網拍小賣家 AI 資料助理 | ✅ | | |
| 05 公司員工手冊問答機器人 | ✅ | ✅ | |
| 06 餐廳菜單智慧推薦 | ✅ | ✅ | |
| 07 維修中心客服信自動回覆 | ✅ | ✅ | ✅ 讀信、建立草稿 |

---

## 🤖 Google Gemini 憑證

### 第一步：取得 API Key

1. 前往 [Google AI Studio](https://aistudio.google.com/)，用 Google 帳號登入。
2. 點選左側 **Get API key** ➔ **Create API key**，選擇（或建立）一個 Google Cloud 專案。
3. 複製產生的 API Key（以 `AIza` 開頭）。

> 💡 不需要綁信用卡，免費額度足夠上課練習。免費額度有**每分鐘請求次數限制**，若出現 `429 Too Many Requests`，等一分鐘再執行即可。

### 第二步：在 n8n 建立憑證

1. n8n 左側選單 **Credentials** ➔ **Add Credential** ➔ 搜尋 **Google Gemini(PaLM) Api**。
2. **Host** 保留預設值 `https://generativelanguage.googleapis.com`，**API Key** 貼上剛才的金鑰。
3. 憑證名稱改為 `Google Gemini`，點 **Save**。

### 本章使用的模型

| 節點 | 模型 | 說明 |
| :--- | :--- | :--- |
| **Google Gemini Chat Model** | `models/gemini-2.5-flash` | 速度快、免費額度充足。若下拉選單有更新的 Flash 版本也可以換用 |
| **Embeddings Google Gemini** | `models/gemini-embedding-001` | 輸出 **3072 維**向量，對應 Pinecone Index 的 Dimension |

> ⚠️ **Embedding 模型不要隨便更換**。寫入 Pinecone 和查詢時必須使用同一個模型，換了模型就要清空 Namespace 重新寫入。

---

## 📧 Gmail 憑證

Gmail 使用 **OAuth 2.0** 授權。依照您的 n8n 安裝方式選擇：

### 方式 A：n8n Cloud（最簡單）

1. **Add Credential** ➔ 搜尋 **Gmail OAuth2 API**。
2. 點選 **Sign in with Google**，選擇帳號並允許權限即可。

### 方式 B：自行架設的 n8n（Docker / npm）

需要先在 Google Cloud 建立自己的 OAuth 用戶端，請依照課程中的完整步驟操作：

1. 📘 [OAuth 2.0 觀念說明](../../OAuth/README.md)
2. ☁️ [Google Cloud API 服務設定指南](../../google_cloud設定/README.md)（啟用 **Gmail API**、設定同意畫面、建立 OAuth 用戶端）
3. 在 n8n 建立 **Gmail OAuth2 API** 憑證，填入 Client ID 與 Client Secret，按 **Sign in with Google** 完成授權。

憑證名稱改為 `Gmail`，點 **Save**。

> 💡 **測試時寄給自己**：範例 01～03 的資料庫裡都是虛構的 Email（例如 `xxx@example.com`），測試時請把收件信箱換成自己的 Gmail：01 報名時在表單填自己的 Email；02 修改「設定」節點的 `老闆信箱`；03 修改「設定」節點的 `測試信箱`（有填就全部寄給自己）。
