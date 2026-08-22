# Docker 安裝指南 🐳

本教學提供 **Windows**、**macOS** 以及 **Raspberry Pi (Linux)** 的 Docker 安裝步驟，請依據您的作業系統進行安裝。

---

## 目錄

- [1. Windows 安裝 Docker Desktop](#1-windows-安裝-docker-desktop)
- [2. macOS 安裝 Docker Desktop](#2-macos-安裝-docker-desktop)
- [3. Raspberry Pi / Linux 安裝 Docker](#3-raspberry-pi--linux-安裝-docker)
- [4. 驗證 Docker 安裝是否成功](#4-驗證-docker-安裝是否成功)

---

## 1. Windows 安裝 Docker Desktop

Windows 建議透過 **WSL 2（Windows Subsystem for Linux）** 作為後端核心來運行 Docker Desktop。

### 步驟 1：啟用 WSL 2
以**系統管理員身分**開啟 PowerShell 或終端機，執行以下指令安裝 WSL：
```powershell
wsl --install
```
> 💡 若系統提示需要重新啟動電腦，請先重開機以完成 WSL 啟用。

### 步驟 2：下載與安裝 Docker Desktop
您可以使用以下兩種方式之一進行安裝：

- **方法一（官方安裝檔）**：
  前往 Docker 官網下載 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/) 安裝檔並執行，安裝過程中請確保勾選 **「Use WSL 2 instead of Hyper-V (recommended)」**。

- **方法二（透過 winget 套件管理工具）**：
  在 PowerShell 執行：
  ```powershell
  winget install Docker.DockerDesktop
  ```

### 步驟 3：啟動 Docker Desktop
1. 從「開始」功能表搜尋並啟動 **Docker Desktop**。
2. 接受服務條款（Accept Terms），等待右下角狀態燈變為 **綠色 (Engine Running)** 即可。

---

## 2. macOS 安裝 Docker Desktop

macOS 支援 Apple Silicon (M1/M2/M3/M4) 與 Intel 處理器。

### 步驟 1：下載與安裝 Docker Desktop
您可以使用以下兩種方式之一進行安裝：

- **方法一（官方安裝檔）**：
  前往 Docker 官網下載 [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)，請依晶片架構選擇對應版本：
  - **Apple Silicon (M系列晶片)**：選擇 *Mac with Apple chip*
  - **Intel 處理器**：選擇 *Mac with Intel chip*
  下載 `.dmg` 檔案後開啟，將 **Docker.app** 拖曳至 **Applications (應用程式)** 資料夾。

- **方法二（透過 Homebrew 安裝）**：
  開啟終端機執行：
  ```bash
  brew install --cask docker
  ```

### 步驟 2：啟動 Docker Desktop
1. 在應用程式資料夾或 Spotlight 搜尋並開啟 **Docker**。
2. 首次開啟時依提示輸入系統管理員密碼以賦予網路權限。
3. 頂部選單列出現 Docker 鯨魚圖示且顯示 **Docker Desktop is running** 即可。

---

## 3. Raspberry Pi / Linux 安裝 Docker

Raspberry Pi OS（建議使用 64-bit 系統）與 Debian / Ubuntu Linux 建議直接使用 Docker 官方提供的便利安裝腳本。

### 步驟 1：更新系統套件
在樹莓派終端機執行：
```bash
sudo apt update && sudo apt upgrade -y
```

### 步驟 2：使用官方腳本安裝 Docker Engine
```bash
# 下載官方安裝腳本並執行
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### 步驟 3：設定免 sudo 執行 Docker（非 root 權限）
為了讓目前使用者可以直接執行 docker 指令而不需要每次輸入 `sudo`：
```bash
# 將當前登入的使用者加入 docker 群組
sudo usermod -aG docker $USER
```
> ⚠️ **重要**：設定完成後，請**登出並重新登入**（或執行 `sudo reboot` 重啟樹莓派），權限才會正式生效。

### 步驟 4：設定 Docker 開機自動啟動
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

### 步驟 5：安裝 Docker Compose 外掛
```bash
sudo apt install -y docker-compose-plugin
```

---

## 4. 驗證 Docker 安裝是否成功

安裝完成後，請開啟終端機（Windows 請開 PowerShell / Command Prompt，macOS / Raspberry Pi 請開 Terminal），執行以下指令驗證：

### 1. 檢查 Docker 版本
```bash
docker --version
```
*預期輸出範例：`Docker version 27.x.x, build ...`*

### 2. 檢查 Docker Compose 版本
```bash
docker compose version
```
*預期輸出範例：`Docker Compose version v2.x.x`*

### 3. 執行測試容器（Hello World）
```bash
docker run --rm hello-world
```
如果看到 **`Hello from Docker!`** 的訊息，表示 Docker 已在您的系統上成功運作！🎉