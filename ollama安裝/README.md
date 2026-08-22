# Ollama 安裝指南 🦙

**Ollama** 是一個能在本機輕鬆下載、管理與執行開源大型語言模型（LLM）的工具。透過 Ollama，您可以在不依賴付費雲端 API 的情況下，免費在本地運行 AI 模型，並與 n8n 的 AI Agent 與 LLM 節點進行串接。

---

## 目錄

- [1. Windows 安裝 Ollama](#1-windows-安裝-ollama)
- [2. macOS 安裝 Ollama](#2-macos-安裝-ollama)
- [3. Raspberry Pi / Linux 安裝 Ollama](#3-raspberry-pi--linux-安裝-ollama)
- [4. 關鍵設定：允許 Docker 容器連線 (OLLAMA_HOST)](#4-關鍵設定允許-docker-容器連線-ollama_host)
- [5. 常用模型下載與驗證](#5-常用模型下載與驗證)
- [6. 在 n8n 中連接 Ollama](#6-在-n8n-中連接-ollama)

---

## 1. Windows 安裝 Ollama

### 步驟 1：下載與安裝
您可以選擇以下任一種方式安裝：

- **方法一（官方安裝檔）**：
  前往 [Ollama 官網下載頁面](https://ollama.com/download/windows) 下載 `OllamaSetup.exe`，直接執行並完成安裝。
- **方法二（透過 winget 安裝）**：
  以系統管理員身分開啟 PowerShell 執行：
  ```powershell
  winget install Ollama.Ollama
  ```

### 步驟 2：啟動 Ollama
安裝完成後，Ollama 會自動在背景啟動（系統匣會出現羊駝圖示）。

---

## 2. macOS 安裝 Ollama

### 步驟 1：下載與安裝
您可以選擇以下任一種方式安裝：

- **方法一（官方安裝檔）**：
  前往 [Ollama 官網下載頁面](https://ollama.com/download/mac) 下載 `Ollama-darwin.zip`，解壓縮後將 `Ollama.app` 拖移至「應用程式」資料夾。
- **方法二（透過 Homebrew 安裝）**：
  開啟終端機執行：
  ```bash
  brew install ollama
  ```

### 步驟 2：啟動 Ollama
在應用程式中開啟 **Ollama**，依提示安裝 Command Line 工具。

---

## 3. Raspberry Pi / Linux 安裝 Ollama

Raspberry Pi OS（需使用 64-bit 系統）與 Linux 支援透過官方一鍵安裝腳本快速安裝。

### 步驟 1：執行官方安裝腳本
在樹莓派終端機執行：
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### 步驟 2：檢查服務狀態
安裝完成後，Ollama 會自動註冊為 systemd 系統服務並在背景運行：
```bash
sudo systemctl status ollama
```

---

## 4. 關鍵設定：允許 Docker 容器連線 (OLLAMA_HOST)

> ⚠️ **重要觀念**：
> 預設情況下，Ollama 僅監聽本機 `127.0.0.1:11434`。如果您的 **n8n 運行在 Docker 容器內**，n8n 容器將無法直接訪問宿主機的 `127.0.0.1`。
> 因此必須將 Ollama 的監聽位址設定為 `0.0.0.0`。

### 各平台設定方式：

- **macOS**：
  開啟終端機執行指令設定環境變數並重啟：
  ```bash
  launchctl setenv OLLAMA_HOST "0.0.0.0"
  ```
  *(或在終端機手動啟動：`OLLAMA_HOST=0.0.0.0 ollama serve`)*

- **Windows**：
  1. 開啟「系統內容」 > 「進階」 > 「環境變數」。
  2. 在「使用者變數」或「系統變數」中新增：
     - 變數名稱：`OLLAMA_HOST`
     - 變數值：`0.0.0.0`
  3. 重新啟動 Ollama 應用程式。

- **Raspberry Pi / Linux**：
  修改 systemd 服務設定檔：
  ```bash
  sudo systemctl edit ollama.service
  ```
  在開啟的編輯區塊中加入以下內容：
  ```ini
  [Service]
  Environment="OLLAMA_HOST=0.0.0.0"
  ```
  儲存後重啟服務：
  ```bash
  sudo systemctl daemon-reload
  sudo systemctl restart ollama
  ```

---

## 5. 常用模型下載與驗證

在終端機（PowerShell 或 Terminal）中執行以下指令下載並執行模型：

### 推薦常用模型：

| 模型名稱 | 參數大小 | 記憶體需求 | 推薦適用平台 |
| :--- | :--- | :--- | :--- |
| **`llama3.2:1b`** | 約 1.3 GB | ~ 2 GB | 🍓 Raspberry Pi 4/5 首選 |
| **`qwen2.5:1.5b`** | 約 1.0 GB | ~ 2 GB | 🍓 樹莓派繁體中文極佳選擇 |
| **`llama3.2:3b`** | 約 2.0 GB | ~ 4 GB | 💻 筆電 / PC 平衡推薦 |
| **`qwen2.5:7b`** | 約 4.7 GB | ~ 8 GB | 💻 繁中理解與工具調用推薦 |

### 下載與測試指令：
```bash
# 下載並直接進入對話測試
ollama run llama3.2:3b

# 查看已下載的模型清單
ollama list
```

---

## 6. 在 n8n 中連接 Ollama

1. 開啟 n8n 畫布，新增 **Ollama Model** 或 **Ollama Chat Model** 節點。
2. 在 **Credential to connect with** 建立新的 Ollama 憑證：
   - **Base URL** 請設定為：
     ```text
     http://host.docker.internal:11434
     ```
3. 點選 **Test Connection** 測試連線，成功後即可在節點的 **Model** 下拉選單選擇已下載的本機模型！
