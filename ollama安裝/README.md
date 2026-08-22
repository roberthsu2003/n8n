# Ollama 安裝指南 🦙

**Ollama** 是一個能在本機輕鬆下載、管理與執行開源大型語言模型（LLM）的工具。透過 Ollama，您可以在不依賴付費雲端 API 的情況下，免費在本地運行 AI 模型，並與 n8n 的 AI Agent 與 LLM 節點進行串接。

---

## 目錄

- [1. Windows 與 macOS 安裝](#1-windows-與-macos-安裝)
- [2. Raspberry Pi (Linux) 安裝與設定流程](#2-raspberry-pi-linux-安裝與設定流程)
  - [步驟 1：安裝 Ollama](#步驟-1安裝-ollama)
  - [步驟 2：設定 Ollama 監聽所有 IP（解決 ECONNREFUSED 錯誤）](#步驟-2設定-ollama-監聽所有-ip解決-econnrefused-錯誤)
  - [步驟 3：測試 Docker 容器內部連線](#步驟-3測試-docker-容器內部連線)
  - [步驟 4：備用方案（若非 systemd 服務啟動）](#步驟-4備用方案若非-systemd-服務啟動)
- [3. 下載推薦模型](#3-下載推薦模型)
- [4. 在 n8n 中設定 Ollama 憑證](#4-在-n8n-中設定-ollama-憑證)

---

## 1. Windows 與 macOS 安裝

Windows 與 macOS 使用者可直接前往官網下載安裝程式：

- 💻 **Windows**：[下載 Ollama for Windows](https://ollama.com/download/windows)
- 🍎 **macOS**：[下載 Ollama for macOS](https://ollama.com/download/mac)

---

## 2. Raspberry Pi (Linux) 安裝與設定流程

在 Raspberry Pi (需 64-bit 系統) 或 Linux 伺服器上，為了讓運行於 Docker 容器內的 n8n 能夠成功連線到本機的 Ollama，必須確保 Ollama 監聽 `0.0.0.0:11434`。

### 步驟 1：安裝 Ollama

在樹莓派終端機執行官方一鍵安裝腳本：

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

---

### 步驟 2：設定 Ollama 監聽所有 IP（解決 ECONNREFUSED 錯誤）

> ⚠️ **常見錯誤原因**：
> 當 n8n 出現 `ECONNREFUSED 172.17.0.1:11434`，代表 Docker 容器已找到 Raspberry Pi 主機，但 Ollama 預設僅監聽 `127.0.0.1`，拒絕了來自 Docker 橋接網卡（`172.17.0.1`）的連線。

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

## 3. 下載推薦模型

在樹莓派或終端機中下載適合的模型：

| 模型名稱 | 參數量 / 大小 | 記憶體需求 | 說明 |
| :--- | :--- | :--- | :--- |
| **`llama3.2:1b`** | 約 1.3 GB | ~ 2 GB | 🍓 Raspberry Pi 4/5 速度最快首選 |
| **`qwen2.5:1.5b`** | 約 1.0 GB | ~ 2 GB | 🍓 樹莓派繁體中文極佳選擇 |
| **`llama3.2:3b`** | 約 2.0 GB | ~ 4 GB | 💻 繁中與工具調用平衡推薦 |
| **`qwen2.5:7b`** | 約 4.7 GB | ~ 8 GB | 💻 PC / 筆電推薦高理解力模型 |

#### 下載指令：
```bash
# 以下載 llama3.2:1b 為例
ollama run llama3.2:1b

# 查看已下載的模型
ollama list
```

---

## 4. 在 n8n 中設定 Ollama 憑證

在 n8n 建立 Ollama 憑證（Ollama API）：

- **Base URL**：
  ```text
  http://host.docker.internal:11434
  ```
- **API Key**：`留白`

點選 **Test Connection** 測試連線成功後，即可在 **Ollama Chat Model** 節點中選擇您剛下載的模型！
