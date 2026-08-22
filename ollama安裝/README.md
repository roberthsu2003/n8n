# Ollama 安裝指南 🦙

**Ollama** 是一個能在本機與雲端環境輕鬆下載、管理與執行大型語言模型（LLM）的工具。透過 Ollama，您可以登入官方帳號獲取 API Key，直接使用帶有 **`:cloud`** 標籤的雲端模型（如 **`gemma4:cloud`**），無需消耗本機硬體算力，即可與 n8n 的 AI Agent 及 LLM 節點進行串接。

---

## 目錄

- [1. Windows 與 macOS 安裝](#1-windows-與-macos-安裝)
- [2. Raspberry Pi (Linux) 安裝與設定流程](#2-raspberry-pi-linux-安裝與設定流程)
  - [步驟 1：安裝 Ollama](#步驟-1安裝-ollama)
  - [步驟 2：設定 Ollama 監聽所有 IP（解決 ECONNREFUSED 錯誤）](#步驟-2設定-ollama-監聽所有-ip解決-econnrefused-錯誤)
  - [步驟 3：備用方案（若非 systemd 服務啟動）](#步驟-3備用方案若非-systemd-服務啟動)
- [3. 登入 Ollama 帳號與建立 API Key](#3-登入-ollama-帳號與建立-api-key)
- [4. 安裝與執行 Gemma 4 雲端 (Cloud) 模型（`:cloud` 標籤）](#4-安裝與執行-gemma-4-雲端-cloud-模型cloud-標籤)
  - [雲端模型命名規則（必須包含 `:cloud`）](#雲端模型命名規則必須包含-cloud)
  - [Gemma 4 雲端模型推薦清單](#gemma-4-雲端模型推薦清單)
  - [安裝與執行指令](#安裝與執行指令)
  - [查詢目前已附加 / 支援的模型清單 (`ollama list`)](#查詢目前已附加--支援的模型清單-ollama-list)
- [5. 驗證與測試模型是否可正常運作 🧪](#5-驗證與測試模型是否可正常運作-)
  - [測試 1：本機終端機快速單行測試](#測試-1本機終端機快速單行測試)
  - [測試 2：從 Docker n8n 容器內部測試 API 推論](#測試-2從-docker-n8n-容器內部測試-api-推論)
- [6. 在 n8n 中設定 Ollama 憑證與 Gemma 4 雲端模型](#6-在-n8n-中設定-ollama-憑證與-gemma-4-雲端模型)

---

## 1. Windows 與 macOS 安裝

Windows 與 macOS 使用者可直接前往官網下載安裝程式：

- 💻 **Windows**：[下載 Ollama for Windows](https://ollama.com/download/windows)
- 🍎 **macOS**：[下載 Ollama for macOS](https://ollama.com/download/mac)

---

## 2. Raspberry Pi (Linux) 安裝與設定流程

在 Raspberry Pi (需 64-bit 系統) 或 Linux 伺服器上，為了讓運行於 Docker 容器內的 n8n 能夠成功連線到主機的 Ollama，必須確保 Ollama 監聽 `0.0.0.0:11434`。

### 步驟 1：安裝 Ollama

在樹莓派終端機執行官方一鍵安裝腳本：

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

---

### 步驟 2：設定 Ollama 監聽所有 IP（解決 ECONNREFUSED 錯誤）

> 💡 **為什麼需要設定？**
> n8n 運行在 Docker 容器內，會透過宿主機網關（如 `172.17.0.1`）連線。但 Ollama 預設僅監聽 `127.0.0.1`，因此會出現 `ECONNREFUSED` 連線被拒錯誤。

只需在樹莓派終端機**直接複製並執行以下一行指令**即可完成設定並自動重啟服務（免手動開啟編輯器）：

```bash
sudo mkdir -p /etc/systemd/system/ollama.service.d && \
echo -e '[Service]\nEnvironment="OLLAMA_HOST=0.0.0.0:11434"' | sudo tee /etc/systemd/system/ollama.service.d/override.conf > /dev/null && \
sudo systemctl daemon-reload && \
sudo systemctl restart ollama
```

#### 驗證設定：
執行以下指令確認是否已監聽 `0.0.0.0:11434`：
```bash
sudo ss -ltnp | grep 11434
```
*看到 `0.0.0.0:11434` 或 `*:11434` 即代表設定成功！*

---

### 步驟 3：備用方案（若非 systemd 服務啟動）

如果執行 `sudo systemctl restart ollama` 顯示找不到服務，請改用指令直接前景啟動：

```bash
pkill ollama
OLLAMA_HOST=0.0.0.0:11434 ollama serve
```
> ⚠️ **請保持該終端機視窗開啟運行**。

---

## 3. 登入 Ollama 帳號與建立 API Key 🔑

為了存取 Ollama 雲端模型與進行授權驗證，請完成以下登入與金鑰建立流程：

1. **註冊 / 登入 Ollama 帳號**：
   - 前往 [ollama.com](https://ollama.com) 並登入帳號。
2. **建立 / 複製 API Key**：
   - 前往個人設定頁面（Settings / API Keys），建立一組專屬的 API Key 並妥善保存。
3. **在終端機登入 Ollama**：
   - 開啟終端機執行以下指令完成帳號授權綁定：
     ```bash
     ollama login
     ```
   - 依照終端機提示在瀏覽器中完成授權。

---

## 4. 安裝與執行 Gemma 4 雲端 (Cloud) 模型（`:cloud` 標籤）☁️

### 雲端模型命名規則（必須包含 `:cloud`）
> 💡 **關鍵概念**：
> 在 Ollama 中，所有雲端模型名稱後面**必須帶有 `:cloud` 標籤**（例如 `gemma4:cloud`、`gemma4:26b-cloud`、`gemma4:31b-cloud`）。
> 當您指定 `:cloud` 模型時，本地 Ollama 客戶端會自動將推理請求導向雲端伺服器，**完全不佔用本地硬碟與 GPU 記憶體**。

### Gemma 4 雲端模型推薦清單：

| 模型名稱 | 雲端標籤 | 說明 |
| :--- | :--- | :--- |
| **`gemma4:cloud`** | ☁️ 雲端 | ⭐️ **本課程推薦首選**，最新 Google Gemma 4 架構，兼具超高推論速度、中文語意理解與強大 Tool-Calling 工具調用能力 |
| **`gemma4:26b-cloud`** / **`gemma4:31b-cloud`** | ☁️ 雲端 | Gemma 4 高參數量旗艦版，適合複雜邏輯分析與長文本深度推理 |

### 安裝與執行指令：

#### 1. 下載 / 附加雲端模型至 Ollama (`ollama pull`)
```bash
# 下載並綁定 Gemma 4 雲端模型（課程推薦首選）
ollama pull gemma4:cloud
```

#### 2. 互動式對話測試 (`ollama run`)
```bash
# 啟動 Gemma 4 雲端模型進行即時互動對話
ollama run gemma4:cloud
```
*(輸入 `/bye` 可隨時退出對話介面)*

---

### 查詢目前已附加 / 支援的模型清單 (`ollama list`)

在終端機中執行 `ollama list`（或 `ollama ls`），即可查看目前已附加的雲端模型清單：

```bash
ollama list
```

預期輸出範例：
```text
NAME                     ID              SIZE      MODIFIED
gemma4:cloud             cloud-g4abc12   0 B       2 minutes ago
```
*(注意：雲端模型的 `SIZE` 通常為 `0 B` 或極小，因為權重直接運行於 Ollama 雲端硬體上)*

---

## 5. 驗證與測試模型是否可正常運作 🧪

在將模型連接到 n8n 前，您可以透過以下兩種方式快速驗證雲端模型與 Docker 網路是否正常：

### 測試 1：本機終端機快速單行測試
直接在終端機發送一句提問，測試模型能否成功回應：

```bash
ollama run gemma4:cloud "請用繁體中文回答：Gemma 4 雲端模型測試成功！"
```
*如果能直接印出繁體中文回覆，代表 Ollama 雲端連線與帳號授權完全正常！*

---

### 測試 2：從 Docker n8n 容器內部測試 API 推論
這一步能直接驗證 **n8n 容器是否能透過宿主機網路成功呼叫 Ollama 並獲得回答**：

```bash
docker exec n8n node -e "
fetch('http://host.docker.internal:11434/api/generate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    model: 'gemma4:cloud',
    prompt: '請回答：Docker 容器與 Ollama 連線成功！',
    stream: false
  })
})
.then(r => r.json())
.then(d => console.log('✅ 模型回應結果：\n', d.response))
.catch(err => console.error('❌ 連線失敗：', err));
"
```
*預期輸出：印出 `✅ 模型回應結果：` 與 Gemma 4 的回答，代表容器網路完全打通！*

---

## 6. 在 n8n 中設定 Ollama 憑證與 Gemma 4 雲端模型

1. 開啟 n8n 工作區，進入 **Credentials** > 新增 **Ollama API** 憑證。
2. 填入連線設定：
   - **Base URL**：
     ```text
     http://host.docker.internal:11434
     ```
   - **API Key**：填入在 [ollama.com](https://ollama.com) 取得的 API Key。
3. 點選 **Save** 儲存並測試連線。
4. 在工作流中新增 **Ollama Chat Model** 節點：
   - 在 **Model** 欄位**手動輸入帶有 `:cloud` 的完整名稱**：**`gemma4:cloud`**。
5. 將 Ollama Chat Model 節點連線至 **AI Agent** 節點，即可開始在工作流中調用 Gemma 4 雲端模型！
