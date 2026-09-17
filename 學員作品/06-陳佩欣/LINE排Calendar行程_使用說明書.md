# LINE 排 Calendar 行程 — 使用說明書

> 工作流 ID：`3672izY5thhJqIHu`
> Webhook 路徑：`https://crummy-unrigged-unenvied.ngrok-free.dev/webhook/line_bot`
> 狀態：已啟用（Active）

---

## 一、這個工作流在做什麼

使用者在 LINE 裡隨手打一句自然語言的行程描述，機器人會自動：

1. 讀懂這句話裡的「標題、時間、地點、時長」
2. 換算成正確的日期時間
3. 直接寫進你的 Google Calendar
4. 回一則確認訊息給使用者

範例輸入 → 輸出：

| 你在 LINE 打的話 | 系統建立的行程 |
|---|---|
| 明天早上十點和廠商開會，在會議室A，大概一小時 | 隔天 10:00–11:00，地點：會議室A |
| 下週五下午兩點半 客戶簡報 兩小時 | 下週五 14:30–16:30 |
| 9/25 全天 教育訓練 | 9/25 全天事件 |

---

## 二、流程架構

```
使用者在 LINE 打字
      │
      ▼
Webhook 收到訊息 ──┬── 立即回應 LINE 平台（避免逾時）
                   │
                   └── 判斷是否為文字訊息
                          │（是文字才繼續，貼圖/圖片會被忽略）
                          ▼
                   AI 抽取行程欄位（Gemini）
                   ├─ 帶入「現在的台北時間」當基準
                   └─ 抽出：標題／開始時間／時長／是否全天／地點
                          ▼
                   Code 節點計算結束時間
                   （全天事件另外處理成「日期＋隔天日期」的格式）
                          ▼
                   寫入 Google Calendar（真的建立事件）
                          ▼
                   整理訊息文字
                          ▼
                   呼叫 LINE Reply API，回覆使用者建立結果
```

### 節點對照表

| 節點名稱 | 類型 | 作用 |
|---|---|---|
| Line_bot接收訊息 | Webhook | 接收 LINE 平台傳來的所有事件 |
| 回應給line_bot 	| Respond to Webhook | 立刻回 200，滿足 LINE 平台的逾時要求 |
| 是否為文字訊息 | IF | 過濾掉非文字訊息（貼圖、圖片、語音等） |
| AI 抽取行程欄位 | Information Extractor（Gemini） | 把自然語言解析成結構化欄位 |
| Google Gemini Chat Model | 語言模型 | 供上一個節點使用的 AI 引擎 |
| Code 算結束時間 | Code | 用開始時間＋時長精確計算結束時間；處理全天事件的日期格式 |
| Google Calendar 建立事件 | Google Calendar | 把行程寫進行事曆 `petty7244@gmail.com` |
| 清洗 | Edit Fields (Set) | 整理出要回覆給使用者的訊息文字 |
| 回覆建立結果給LINE | HTTP Request | 呼叫 LINE Reply API 把結果傳回使用者 |

---

## 三、使用方式（給實際使用者看）

直接在 LINE 對話框輸入一句話，建議包含以下三個要素：

- **做什麼**（標題）：例如「開會」「客戶簡報」「教育訓練」
- **什麼時候**：可以用「明天」「下週五」「9/25」等口語說法，也可以用「早上十點」「下午兩點半」等時間
- **多久 / 地點（可省略）**：「一小時」「兩小時」「在會議室A」

**沒有明確說時長時**，系統預設抓 **60 分鐘**。
**只有日期、沒有時間**時（例如「9/25 全天」），系統會建立**全天事件**。

建立成功後，LINE 會回覆類似：

```
✅ 已建立行程：和廠商開會
📍 地點：會議室A
🕐 時間：2026/09/16 10:00 ~ 11:00
```

---

## 四、已知限制

1. **只吃文字訊息**：傳貼圖、圖片、語音不會有任何反應（設計上刻意忽略，不是壞掉）。
2. **一次只能建立一個行程**：如果一句話講了兩件事，AI 只會抓出一組欄位。
3. **沒有「修改」或「取消」行程的功能**：目前只有建立，之後如果需要編輯/刪除既有行程，需要額外開發。
4. **AI 判斷仍可能出錯**：一句話越模糊（例如沒講清楚是上午還是下午），AI 誤判的機率越高，建議使用者盡量講清楚。
5. **這個 Webhook 路徑目前是獨佔的**：你帳號裡還有一個「售後政策 AI 客服」工作流，跟這個共用同一個 LINE Bot 頻道，但兩者不能同時啟用（LINE 一個頻道只能設定一組 Webhook URL）。**目前客服 AI 已停用**，如果要恢復客服功能，必須先把這個行事曆工作流停用，或未來把兩個工作流合併成一個、內部用意圖判斷分流。

---

## 五、維護資訊（給之後管理這個工作流的人）

### 使用到的憑證

| 憑證名稱 | 用途 |
|---|---|
| Google Gemini(PaLM) Api account | AI 抽取行程欄位 |
| Google Calendar account | 寫入行事曆 `petty7244@gmail.com` |
| Line_憑證（httpHeaderAuth） | 呼叫 LINE Reply API 的授權標頭 |

### 修改行事曆目標

若要改成寫入別的行事曆（例如共用行事曆），到「Google Calendar 建立事件」節點的 `Calendar` 欄位改選其他日曆即可，不需要改動其他節點。

### 常見問題排查

| 現象 | 可能原因 |
|---|---|
| LINE 完全沒反應 | 檢查工作流是否為 Active 狀態；檢查 Webhook 路徑是否被其他工作流搶走 |
| n8n 顯示「Unused Respond to Webhook node」錯誤 | Webhook 節點的 Response Mode 要設成「Using Respond to Webhook Node」，不能是「Immediately」 |
| Google Calendar 節點報「Not a valid Google Calendar ID」 | Calendar 欄位不能填 `primary` 文字，要從下拉選單實際選擇你的行事曆 |
| Google 授權出現 `redirect_uri_mismatch` | Google Cloud Console 裡的 OAuth 用戶端「Authorized redirect URIs」跟 n8n 顯示的不一致，需要新增比對 |
| Google 授權出現 `invalid_client` | Client ID / Secret 有誤，或 Google 那邊的 Secret 已被重置，建議直接在 Google Cloud Console 重新產生一組新的 Client Secret |
| 測試時看到「Invalid reply token」 | 這是正常現象——只有真實 LINE 使用者傳訊息才有合法的 replyToken，模擬測試資料本來就無法通過這一步 |

---

## 六、之後可以擴充的方向

- 支援「修改／取消行程」的口語指令
- 支援一次辨識多筆行程
- 加入行事曆衝突檢查（若該時段已有行程，提醒使用者）
- 跟「售後政策 AI 客服」整合成單一入口，用意圖判斷自動分流
