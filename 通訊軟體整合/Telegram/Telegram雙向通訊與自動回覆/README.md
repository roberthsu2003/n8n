# Telegram 整合實作
## 範例 3：Telegram 雙向通訊與指令自動回覆（Bot 完整對話流程）

### 📚 工作流程說明

這個 n8n 工作流程示範如何打造一個具備**斜線指令（Slash Commands）**與**自動應答能力**的互動式 Telegram 機器人。透過結合 **Telegram Trigger**、**Switch（路由分流節點）** 與多個 **Telegram 節點**，機器人能夠精準辨識使用者輸入的 `/start`、`/help`、`/info` 等指令並回傳客製化按鈕選單，若收到其他非指令的一般文字，亦會給予友善的預設回覆，建構出完整的雙向對話閉環。

---

### 流程架構圖

```mermaid
flowchart TD
    A["👤 用戶在 Telegram 發送訊息或指令"] --> B["⚡ Telegram 訊息觸發器"]
    B --> C["⚙️ 提取對話參數 (Set 節點)"]
    C --> D{"🔀 指令與文字路由器 (Switch 節點)"}
    
    D -->|匹配 /start| E1["📤 回覆 Start 指令 (含 Inline 按鈕選單)"]
    D -->|匹配 /help| E2["📤 回覆 Help 指令 (說明手冊)"]
    D -->|匹配 /info| E3["📤 回覆 Info 指令 (系統運行資訊)"]
    D -->|其他一般文字 (Fallback)| E4["📤 回覆一般文字訊息 (引述與提示)"]
    
    E1 --> F["📱 Telegram 聊天室即時顯示回覆"]
    E2 --> F
    E3 --> F
    E4 --> F
```

---

### 工作流程樣版下載

- [📥 Telegram 雙向通訊與指令自動回覆樣版 (telegram_bot_interactive.json)](./telegram_bot_interactive.json)

---

#### 📋 節點詳細說明

1. **📝 流程說明（Sticky Note）**
   - **功能**：說明雙向通訊架構、Switch 條件規則與各分支回應內容。

2. **⚡ Telegram 訊息觸發器（Telegram Trigger Node）**
   - **功能**：自動監聽 Telegram 私聊或群組內的所有使用者輸入。

3. **⚙️ 提取對話參數（Edit Fields / Set Node）**
   - **功能**：統一提取並修剪（`.trim()`）關鍵參數：
     - `chatId`：`={{ $json.message.chat.id }}`
     - `userName`：`={{ $json.message.from.first_name }}`
     - `userMessage`：`={{ ($json.message.text || '').trim() }}`

4. **🔀 指令與文字路由器（Switch Node）**
   - **功能**：使用不區分大小寫（Case-Insensitive）的 `startsWith` 規則進行指令分流：
     - **Output 0 (Start 指令)**：`userMessage startsWith /start`
     - **Output 1 (Help 指令)**：`userMessage startsWith /help`
     - **Output 2 (Info 指令)**：`userMessage startsWith /info`
     - **Fallback Output (其他文字)**：非上述指令的所有一般文字輸入。

5. **📤 分支回應節點（Telegram Node x 4）**
   - **Start 分支**：傳送 Markdown 格式的歡迎詞，並附加直覺的 Inline Keyboard 按鈕。
   - **Help 分支**：列出可用指令清單與提示用法。
   - **Info 分支**：回傳動態時間、Bot 版本與當前用戶 Chat ID。
   - **一般文字分支**：即時回覆確認收訊，並貼心提示可用指令。

---

#### 🎯 學習重點

- **指令路由與多路分流**：掌握 Switch 節點在聊天機器人指令處理上的設計模式。
- **全自動對話閉環**：無需手動處理 Token 過期問題，利用 Telegram API 即可隨時隨地免費應答。
- **美化 Markdown 與按鈕體驗**：透過結構化排版提供使用者如原生 App 般的互動介面。
- **容錯與 Fallback 機制**：為未定義的指令或任意文字設定友善引導回應。

---

#### 💡 實際應用場景

- **企業官方客服機器人**：提供 `/pricing`（報價）、`/faq`（常見問題）、`/support`（轉接專人）快捷選單。
- **自動化維運 Bot**：透過 `/deploy`、`/reboot`、`/metrics` 提供團隊即時伺服器操作入口。
- **活動報名與社群導流**：引導 Telegram 社群成員查看活動簡章與點擊報名連結。

---

#### ⚙️ 設定步驟

1. **匯入工作流程**：下載並將 [`telegram_bot_interactive.json`](./telegram_bot_interactive.json) 匯入至 n8n。
2. **綁定 Telegram 憑證**：確認「Telegram 訊息觸發器」與各分支的 Telegram 節點皆選取您的憑證。
3. **在 BotFather 設定指令提示（可選但推薦）**：
   - 在 Telegram 與 `@BotFather` 對話，輸入 `/setcommands`。
   - 選擇您的機器人，並貼上以下清單：
     ```text
     start - 開啟主選單與歡迎詞
     help - 查看指令說明手冊
     info - 查看系統運行狀態
     ```
   - 這樣使用者在輸入框打 `/` 時就會自動彈出精美指令選單！
4. **啟動工作流測試**：將工作流設為 **Active**，在 Telegram 點擊 `/start`、`/help`、`/info` 或隨意傳送文字，體驗即時互動反饋！
