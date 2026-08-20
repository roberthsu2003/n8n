# 🤖 AI 協作指南：依照你的 AI 帳號，為 n8n 注入自動化超能力

> 💡 **專為台灣使用者量身打造的講義**：在台灣，大部分人通常只訂閱或擁有**一個主力 AI 帳號**。本指南依照台灣最常見的三大 AI 排名（**Gemini ➔ ChatGPT ➔ Claude**），教你如何用手邊既有的帳號，無縫連線並賦能 n8n 自動化！

---

## 📑 目錄

1. [🌟 台灣三大 AI 帳號連線 n8n 總覽（一張表快速對照）](#overview)
2. [💡 通用輔助：免設定的 Chrome 瀏覽器側邊欄顧問](#chrome-assistant)
3. [⚙️ n8n Instance-level MCP 設定與功能指南](#n8n-mcp-settings)
4. [🥇 路線一：如果你只有 Gemini 帳號（Google）➔ 透過 Antigravity 連體協作](#route-gemini-antigravity)
5. [🥈 路線二：如果你只有 ChatGPT 帳號（OpenAI）➔ 透過 OpenCode 橋樑連線](#route-chatgpt-opencode)
6. [🥉 路線三：如果你只有 Claude 帳號（Anthropic）➔ 透過 Claude.ai Connector 直連](#route-claude-connector)
7. [📚 專題教學文件快速傳送門](#guides-links)
8. [🚲 課堂實戰範例（附 AI Prompt 提詞）](#practical-examples)

---

<a id="overview"></a>
## 🌟 台灣三大 AI 帳號連線 n8n 總覽（一張表快速對照）

找到你目前擁有的 AI 帳號，直接選擇對應的連線方式：

| 你的 AI 帳號 | 推薦的最佳協作方式 | 連線難易度 | 如何操控 n8n？ | 詳細指南連結 |
| :--- | :--- | :---: | :--- | :--- |
| 🥇 **Gemini**<br>(Google) | **Google Antigravity 連體協作**<br>+ Chrome「問問 Gemini」 | 🟢 **直覺強大** | 透過 Antigravity 內建的 Gemini 智慧代理與 MCP 協議，直接在開發環境中對話生成、除錯與執行工作流。 | 📘 [Antigravity 教學](./antigravity_mcp_setup_guide.md) |
| 🥈 **ChatGPT**<br>(OpenAI) | **OpenCode 登入 OpenAI 帳號**<br>+ ChatGPT in Chrome | 🟡 **靈活萬用** | 官方 ChatGPT 網頁無 MCP 連接器，但透過 OpenCode 登入 ChatGPT 帳號後，即可用 GPT-4o 模型全自動操控 n8n。 | 📘 [OpenCode 教學](./n8n_mcp_setup_guide.md#opencode-mcp) |
| 🥉 **Claude**<br>(Anthropic) | **Claude.ai 官方 Connector**<br>(網頁版 / 桌面版) | 🟡 **圖形化串接** | 在 Claude.ai 的 Connectors 設定中輸入 n8n 網址，完成 OAuth 授權後即可在對話框直接打字建流程。 | 📘 [Claude Connector 教學](./n8n_mcp_setup_guide.md#claude-connector) |

---

<a id="chrome-assistant"></a>
## 💡 通用輔助：免設定的 Chrome 瀏覽器側邊欄顧問

不管你用哪一家 AI，在 Chrome 瀏覽器安裝對應擴充套件，都能享有「邊看畫面邊發問」的即時輔助：

* 🌐 **Chrome 內建「問問 Gemini」**：點擊右上角側邊欄，自動抓取當前 n8n 網頁畫面與節點錯誤，即時診斷修復。
* 💬 **ChatGPT in Chrome**：在側邊欄即時生成 JavaScript 表達式、資料轉換函數與正則表達式。
* 🟣 **Claude in Chrome**：直接讀取畫布 DOM 結構，協助產生可複製貼上的 JSON 流程代碼。

---

<a id="n8n-mcp-settings"></a>
## ⚙️ n8n Instance-level MCP 設定與功能指南

n8n 內建的 **Instance-level MCP Server** 是讓所有外部 AI 工具（Antigravity、OpenCode、Claude 等）能夠安全讀取、操作與執行 n8n 工作流程的核心樞紐。

### 🛠️ 後台 3 大核心設定步驟：
1. **啟用 MCP 狀態**：前往 n8n 左下角 **Settings** ➔ **Instance-level MCP**，將 **MCP status** 切換為 **`● Enabled`**（綠色）。
2. **開放工作流程 (Workflows exposed)**：在 **Access** 區塊點選 **Workflows exposed**，勾選允許 AI 調用的工作流程並填寫詳細 Description（讓 AI 知道何時觸發該流程）。
3. **取得連線端點與授權**：點擊 **`[ 🔌 Connect ]`** 按鈕取得連線 Endpoint（需搭配 ngrok 等公開 HTTPS 網址：`https://<你的ngrok網域>/mcp-server/http`）。

> 📖 **完整介面按鈕解析與進階設定**：請參閱專題指南 **[n8n Instance-level MCP 連線設定與介面功能詳解 (v2.34.6)](./n8n_mcp_setup_guide.md)**。

---

<a id="route-gemini-antigravity"></a>
## 🥇 路線一：如果你只有 Gemini 帳號（Google）➔ 透過 Antigravity 連體協作

Google Gemini 是目前普及度極高的 AI 工具。透過 **Google Antigravity**，您可以將 Gemini 與 n8n 深度「連體」整合：

```text
┌─────────────────────────────────────────────────────────────┐
│                    Google Antigravity                       │
│    (內建 Gemini 核心大模型 + 視覺分析 + 智慧自動化代理)         │
└──────────────────────────────┬──────────────────────────────┘
                               │ 透過 MCP 協議 / 瀏覽器雙向互通
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 n8n 工作流畫布與自動化執行引擎                  │
└─────────────────────────────────────────────────────────────┘
```

### 🎯 運作與協作特點：
1. **連體開發與即時修復**：Antigravity 原生整合 Gemini 大模型，能一邊閱讀您的工作流程架構，一邊自動產生 n8n 所需的 JavaScript Code 節點程式碼與資料結構。
2. **多模態視覺除錯**：可直接辨識 n8n 畫布截圖與節點 Error Log，即時指出工作流連線哪裡斷掉、邏輯條件哪裡漏掉。
3. **搭配 Chrome「問問 Gemini」**：在 Chrome 瀏覽器中一邊編輯 n8n，一邊透過側邊欄隨時向 Gemini 發問，無需頻繁切換視窗。

> [!IMPORTANT]
> **認證方式重要提醒**：
> **Google Antigravity 目前不支援互動式 OAuth 授權流程**。若 n8n 服務端啟用了 MCP 認證，**請使用 Access Token（Bearer Token）**，在設定檔中的 `headers` 加入 `"Authorization": "Bearer <YOUR_ACCESS_TOKEN>"` 進行驗證。

### 🚀 專案等級（Workspace-level）快速設定 3 步驟：

1. **建立 `.agents` 專案目錄結構**：
   在專案根目錄下建立 `.agents` 與 Plugin 設定：
   ```text
   專案根目錄/
   └── .agents/
       ├── mcp_config.json
       └── plugins/
           └── n8n/
               ├── plugin.json
               └── mcp_config.json
   ```

2. **填寫 n8n MCP 設定檔 (`.agents/mcp_config.json`)**：
   ```json
   {
     "mcpServers": {
       "n8n": {
         "serverUrl": "https://<你的ngrok或公開網址>/mcp-server/http",
         "headers": {
           "Authorization": "Bearer <你的_n8n_ACCESS_TOKEN>",
           "Accept-Encoding": "identity"
         }
       }
     }
   }
   ```

3. **開啟新對話開始操作**：
   在 Antigravity 中開啟新對話（New Chat），即可直接向 Agent 提問：*「請列出目前 n8n 上的所有工作流」*。

> 📘 **詳細設定教學**：請參閱專題指南 **[Antigravity 專案等級 n8n MCP 設定教學](./antigravity_mcp_setup_guide.md)**。

---

<a id="route-chatgpt-opencode"></a>
## 🥈 路線二：如果你只有 ChatGPT 帳號（OpenAI）➔ 透過 OpenCode 橋樑連線

許多人擁有 ChatGPT Plus / OpenAI 帳號，但發現 **ChatGPT 官方網頁版目前沒有內建 MCP 連線按鈕**。解決方式就是**使用 OpenCode 作為連線橋樑**！

```text
┌─────────────────────────────────────────────────────────────┐
│                   ChatGPT / OpenAI 帳號                     │
└──────────────────────────────┬──────────────────────────────┘
                               │ 執行 opencode auth login 登入
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                     OpenCode CLI / 工具                      │
│            (調用 ChatGPT 的 GPT-4o / o1 模型作為大腦)          │
└──────────────────────────────┬──────────────────────────────┘
                               │ 透過 MCP 端點連線 (/mcp-server/http)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 n8n Instance-level MCP Server               │
└─────────────────────────────────────────────────────────────┘
```

### 🚀 快速上手 3 步驟：
1. **登入 ChatGPT 帳號**：
   在終端機執行指令，選擇 OpenAI / ChatGPT 登入：
   ```bash
   opencode auth login
   ```
2. **設定 n8n MCP 連線**：
   在全域 `~/.config/opencode/opencode.json` 或專案 `opencode.json` 加入 n8n 端點：
   ```json
   {
     "$schema": "https://opencode.ai/config.json",
     "mcp": {
       "n8n": {
         "type": "remote",
         "url": "https://<你的ngrok公開網域>/mcp-server/http",
         "enabled": true,
         "headers": {
           "Authorization": "Bearer <你的_n8n_ACCESS_TOKEN>",
           "Accept-Encoding": "identity"
         }
       }
     }
   }
   ```
3. **對話操控 n8n**：
   在 OpenCode 中直接打字：*「請讀取目前 n8n 的所有工作流程，並幫我檢查哪一個執行失敗」*，ChatGPT 模型即會透過 OpenCode 自動操作 n8n！

> 📘 **進階指南**：請參閱專題指南 **[n8n Instance-level MCP 連線設定與介面指南](./n8n_mcp_setup_guide.md#opencode-mcp)**。

---

<a id="route-claude-connector"></a>
## 🥉 路線三：如果你只有 Claude 帳號（Anthropic）➔ 透過 Claude.ai Connector 直連

如果您訂閱的是 Claude Pro 或擁有 Claude 帳號，可以使用官方的 **Claude Connector** 進行免寫程式碼的點擊授權連線：

```text
你對 Claude 說：「幫我建一個抓取開放資料並寫入 Google Sheets 的工作流程」
      │
      ▼
Claude 透過 Connector 自動在您的 n8n 畫布上建好所有節點！
```

### 🚀 快速上手 3 步驟：
1. **開啟 n8n MCP 狀態**：進入 n8n 後台 ➔ **Settings** ➔ **Instance-level MCP** ➔ 確認 **MCP status** 為 **`● Enabled`**（綠色）。
2. **在 Claude.ai 連線**：前往 Claude.ai ➔ 側邊欄 **Customize** ➔ **Connectors** ➔ 找到 **n8n** 點選 **`Connect`** ➔ 輸入 ngrok 公開網址。
3. **完成 OAuth 授權**：瀏覽器跳轉允許授權後，Status 顯示 **`✓` (已連線)** 即可開始對話建流程。

> 📘 **詳細設定教學**：請參閱專題指南 **[Claude Connector 設定手冊 (OAuth 模式)](./n8n_mcp_setup_guide.md#claude-connector)**。

---

<a id="guides-links"></a>
## 📚 專題教學文件快速傳送門

為方便快速查閱，各 AI 工具與 n8n MCP 的專題指引如下：

* 📘 **Antigravity 設定教學**：[Antigravity 專案等級 n8n MCP 設定教學](./antigravity_mcp_setup_guide.md)
* 📘 **n8n MCP 完整設定指南**：[n8n Instance-level MCP 連線設定與介面功能詳解 (v2.34.6)](./n8n_mcp_setup_guide.md)
* 📘 **Claude.ai 直連教學**：[Claude.ai Connector 設定手冊 (OAuth 模式)](./n8n_mcp_setup_guide.md#claude-connector)

---

<a id="practical-examples"></a>
## 🚲 課堂實戰範例（附 AI Prompt 提詞）

選好你的 AI 工具後，立即跟著實戰範例動手練習：

* 🚲 **[台北市 YouBike 低車輛站點自動記錄](./台北市的youbike/README.md)**
  * **任務目標**：定時抓取政府即時開放資料，篩選車輛不足 3 輛的站點並自動寫入 Google Sheets。
  * **課堂提詞**：內附完整的 **「AI Prompt 範本」**，直接貼給 Gemini、ChatGPT 或 Claude，讓 AI 替你全自動打造完整工作流程！
