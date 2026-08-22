# Ollama 安裝指南 🦙

**Ollama** 是一個能在本機與雲端環境輕鬆下載、管理與執行開源大型語言模型（LLM）的工具。透過 Ollama，您可以登入官方帳號獲取 API Key 並執行雲端與本地模型（如 `gpt-oss:20b`），與 n8n 的 AI Agent 及 LLM 節點進行串接。

---

## 目錄

- [1. Windows 與 macOS 安裝](#1-windows-與-macos-安裝)
- [2. Raspberry Pi (Linux) 安裝與設定流程](#2-raspberry-pi-linux-安裝與設定流程)
  - [步驟 1：安裝 Ollama](#步驟-1安裝-ollama)
  - [步驟 2：設定 Ollama 監聽所有 IP（解決 ECONNREFUSED 錯誤）](#步驟-2設定-ollama-監聽所有-ip解決-econnrefused-錯誤)
  - [步驟 3：測試 Docker 容器內部連線](#步驟-3測試-docker-容器內部連線)
  - [步驟 4：備用方案（若非 systemd 服務啟動）](#步驟-4備用方案若非-systemd-服務啟動)
- [3. 登入 Ollama 帳號與建立 API Key](#3-登入-ollama-帳號與建立-api-key)
- [4. 執行雲端 (Cloud) 模型（GPT、Gemma、Llama）](#4-執行雲端-cloud-模型gptgemmallama)
- [5. 在 n8n 中設定 Ollama 憑證](#5-在-n8n-中設定-ollama-憑證)

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

> ⚠️ **常見錯誤原因**：
> 當 n8n 出現 `ECONNREFUSED 172.17.0.1:11434`，代表 Docker 容器已找到主機，但 Ollama 預設僅監聽 `127.0.0.1`，拒絕了來自 Docker 橋接網卡（`172.17.0.1`）的連線。

請依序執行以下步驟進行設定：

#### 1. 檢查目前環境變數與監聽 Port
```bash
sudo systemctl show ollama --property=Environment
```

```bash
sudo ss -ltnp | grep 11434
```

如果沒有看到 `0.0.0.0:11434` 或 `*:11434`，請繼續以下步驟建立覆寫設定檔。

#### 2. 建立 systemd 覆寫設定檔
```bash
sudo mkdir -p /etc/systemd/system/ollama.service.d
sudo nano /etc/systemd/system/ollama.service.d/override.conf
```

在檔案中貼上以下內容：
```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
```
*(在 nano 編輯器中，按 `Ctrl + O` 存檔，按 `Enter` 確認，再按 `Ctrl + X` 離開)*

#### 3. 重新載入並重啟 Ollama 服務
```bash
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

#### 4. 再次確認監聽狀態
```bash
sudo ss -ltnp | grep 11434
```
確認輸出中包含 `0.0.0.0:11434`。

---

### 步驟 3：測試 Docker 容器內部連線

在終端機直接測試 n8n 容器是否能成功呼叫 Ollama API：

```bash
docker exec n8n node -e "fetch('http://host.docker.internal:11434/api/tags').then(r=>r.text()).then(console.log).catch(console.error)"
```

如果能正常印出 JSON 模型資訊（或 `{"models":[]}`），即代表連線完全正常！🎉

---

### 步驟 4：備用方案（若非 systemd 服務啟動）

如果執行 `sudo systemctl restart ollama` 顯示找不到服務，請改用指令直接前景啟動：

```bash
pkill ollama
OLLAMA_HOST=0.0.0.0:11434 ollama serve
```
> ⚠️ **請保持該終端機視窗開啟運行**。

---

## 3. 登入 Ollama 帳號與建立 API Key 🔑

為了存取 Ollama 雲端服務與進行授權驗證，請完成以下登入與金鑰建立流程：

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

## 4. 執行雲端 (Cloud) 模型（GPT、Gemma、Llama）☁️

在登入 Ollama 帳號並完成 API Key 設定後，您可以直接調用雲端支援的各類主流大型語言模型（無需消耗本機龐大的 GPU 與記憶體算力）：

### 常用雲端 (Cloud) 模型清單：

| 模型系列 | 推薦模型名稱 | 類型 | 說明 |
| :--- | :--- | :--- | :--- |
| ⭐️ **GPT 系列** | **`gpt-oss:20b`** | ☁️ 雲端強力推薦 | 具備出色的邏輯推理與工具使用（Function Calling / Tools）能力，為本課程 AI Agent 首選 |
| 💎 **Gemma 系列** | **`gemma2:9b`** / **`gemma2:27b`** | ☁️ 雲端 Google 架構 | Google 開源的高效能模型，在繁體中文理解與摘要上表現極佳 |
| 🦙 **Llama 系列** | **`llama3.3:70b`** / **`llama3.2:3b`** | ☁️ 雲端 Meta 架構 | Meta 最新開源旗艦模型，泛用性高且生態支援最完整 |

### 執行與測試指令：

```bash
# 1. 執行 GPT 雲端模型（課程推薦）
ollama run gpt-oss:20b

# 2. 執行 Gemma 雲端模型
ollama run gemma2:9b

# 3. 執行 Llama 雲端模型
ollama run llama3.3:70b

# 4. 查看目前已下載/可用的模型清單
ollama list
```

---

## 5. 在 n8n 中設定 Ollama 憑證

1. 開啟 n8n 工作區，進入 **Credentials** > 新增 **Ollama API** 憑證。
2. 填入連線設定：
   - **Base URL**：
     ```text
     http://host.docker.internal:11434
     ```
   - **API Key**：填入在 [ollama.com](https://ollama.com) 取得的 API Key。
3. 點選 **Save** 儲存並測試連線。
4. 在工作流中新增 **Ollama Chat Model** 節點，在 Model 欄位填入或選擇您要使用的雲端模型（例如 **`gpt-oss:20b`**、**`gemma2:9b`** 或 **`llama3.3:70b`**），即可無縫整合至 AI Agent 工作流！

