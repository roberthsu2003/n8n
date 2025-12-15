# 整合 Webhook 的實作

Webhook 是現代自動化系統的核心技術之一，它允許外部應用程式透過 HTTP 請求來觸發 n8n 工作流程。透過 Webhook，您可以建立 API 端點，讓其他服務、應用程式或網站能夠與您的 n8n 工作流程互動。

## 📚 什麼是 Webhook？

Webhook 是一種「反向 API」的概念：
- **傳統 API**：您的應用程式主動去「拉取」資料
- **Webhook**：外部服務主動「推送」資料給您

當外部事件發生時（例如：使用者提交表單、收到訊息、完成付款），外部服務會自動發送 HTTP 請求到您指定的 Webhook URL，觸發 n8n 工作流程執行。

## 🎯 Webhook 的應用場景

- **表單處理**：接收網站表單提交的資料
- **通知系統**：接收來自第三方服務的通知
- **API 整合**：建立自訂 API 端點供其他應用程式呼叫
- **即時回應**：建立聊天機器人或問答系統
- **資料同步**：接收外部系統的資料更新通知

## 📚 實作範例導覽

### [⭐ 範例一：自動化問候系統](./自動化問候系統/README.md)
**難度**: 初級 | **學習時間**: 45-60 分鐘

透過 Webhook 接收外部 POST 請求，驗證使用者資料並回傳個人化問候訊息。

**學習重點**：
- Webhook 觸發器的設定與使用
- 理解 Webhook 接收的資料結構（`$json.body`）
- IF 節點的條件判斷
- Set 節點的資料處理
- Respond to Webhook 節點的回應處理
- 使用 curl 和網頁介面測試 Webhook

**技術重點**：
- Webhook 觸發器
- 條件判斷（IF 節點）
- 動態內容生成（Set 節點）
- JSON 回應（Respond to Webhook）

**特色功能**：
- 提供精美的網頁測試介面
- 完整的錯誤處理機制
- 詳細的教學說明與除錯技巧

---

## 🎯 學習路徑建議

1. **自動化問候系統** → 學習 Webhook 的基本概念與操作

完成此範例後，您將能夠：
- 建立自己的 Webhook 端點
- 接收並處理外部 HTTP 請求
- 根據資料進行條件判斷
- 回傳 JSON 格式的回應

## 💡 學習建議

- **理解資料結構**：Webhook 接收的資料會被包裝在 `body` 物件中，記得使用 `$json.body.欄位名稱`
- **測試工具**：可以使用 curl、Postman 或提供的網頁介面來測試 Webhook
- **啟用工作流程**：Webhook 觸發器需要將工作流程設為「Active」才能接收外部請求
- **查看執行記錄**：在 n8n 的「Executions」區域查看每次 Webhook 觸發的執行記錄

## 🔧 Webhook 設定重點

### 1. 建立 Webhook 觸發器
- 在工作流程中加入「Webhook」節點
- 選擇 HTTP Method（GET、POST、PUT、DELETE 等）
- 設定 Path（例如：`/greeting`）

### 2. 啟用工作流程
- 點擊右上角的「啟用」按鈕
- Webhook 只有在工作流程啟用時才能接收請求

### 3. 取得 Webhook URL
- 點擊 Webhook 節點
- 複製「Production URL」或「Test URL」
- Production URL 格式：`https://your-n8n-domain/webhook/path`

### 4. 測試 Webhook
```bash
# POST 請求範例
curl -X POST https://your-n8n-domain/webhook/greeting \
  -H "Content-Type: application/json" \
  -d '{"name": "小明", "age": 25}'
```

## 📚 相關資源

- [n8n Webhook 節點文件](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)
- [n8n 簡介與安裝](../n8n簡介與安裝/README.md) - 學習如何設定 ngrok 接收外部 Webhook
- [n8n 官方文件](https://docs.n8n.io/)
- [HTTP 請求基礎](https://developer.mozilla.org/zh-TW/docs/Web/HTTP/Methods)

## ⚠️ 常見問題

### Q: Webhook URL 無法訪問？
**A**: 確認工作流程已啟用，且 n8n 伺服器正在運行。如果使用本地開發，需要設定 ngrok 或類似的隧道服務。

### Q: 為什麼要用 `$json.body.name` 而不是 `$json.name`？
**A**: Webhook 節點會將 POST 請求的資料包裝在 `body` 物件中，所以需要使用 `$json.body.欄位名稱` 來存取資料。

### Q: 如何保護 Webhook 避免被濫用？
**A**: 可以使用以下方法：
- 在 Webhook 節點中設定 Authentication（Basic Auth、Header Auth 等）
- 使用 Query Parameters 或 Headers 進行驗證
- 在流程中加入 IP 白名單檢查

### Q: Webhook 可以接收 GET 請求嗎？
**A**: 可以！Webhook 節點支援多種 HTTP Method，包括 GET、POST、PUT、DELETE 等。GET 請求的參數會存在 `$json.query` 中。

---

**🎓 完成這些範例後，您將能夠建立自己的 API 端點，讓其他應用程式與您的 n8n 工作流程互動！**

