# 第一章：n8n 簡介與安裝

![](./images/n8n容器透視圖.png)

## 目錄

- [1.1 什麼是 n8n？](#11-什麼是-n8n)
- [1.2 n8n 的應用場景](#12-n8n-的應用場景)
- [1.3 安裝方式](#13-安裝方式)
- [1.4 初次啟動與設定](#14-初次啟動與設定)
- [n8n(Name Volume)備份的方式](#n8nname-volume備份的方式)
- [Mac的備份方式](#mac的備份方式)

## 1.1 什麼是 n8n？

n8n 是一個功能強大的開源自動化工作流工具，採用無程式碼（No Code）/低程式碼（Low Code）的設計理念，讓使用者能夠透過視覺化介面輕鬆建立自動化工作流程。

### 核心特色

- **開源免費**：完全開源，可自行部署和管理
- **視覺化設計**：透過拖放節點的方式設計工作流程，無需撰寫複雜程式碼
- **豐富整合**：支援數百種 API 和服務的整合
- **彈性擴充**：支援自訂節點和函數，滿足特殊需求
- **資料安全**：可完全私有化部署，資料不經過第三方服務

## 1.2 n8n 的應用場景

n8n 可以應用在各種自動化場景，以下是一些常見用途：

### 📊 資料同步
- 在不同系統間自動同步資料
- 定時備份重要資料
- 資料格式轉換與遷移

### 🔔 通知提醒
- 重要事件的即時通知
- 定期報告自動發送
- 多平台訊息同步

### 🔄 資料處理
- 資料清洗與轉換
- 批量處理檔案
- 資料驗證與過濾

### 🔌 API 整合
- 連接不同服務的 API
- 建立統一的工作流程
- 實現跨平台資料流動

### ⚙️ 自動化任務
- 定時執行重複性工作
- 事件驅動的自動化流程
- 複雜業務邏輯的自動化處理

## 1.3 安裝方式

### 使用 Docker（推薦方式）

Docker 是最簡單且推薦的安裝方式，適用於 Windows、macOS 和 Linux 系統。使用 Docker 可以確保環境一致性，並簡化後續的維護工作。

#### 前置需求

- 已安裝 Docker Desktop 或 Docker Engine
- 確保 Docker 服務正在運行

#### 安裝步驟

1. **建立資料卷**（用於持久化儲存 n8n 的設定和資料）

```bash
docker volume create n8n_data
```

2. **啟動 n8n 容器,使用本機**

適用於 Windows 和 macOS（透過 Docker Desktop）：

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e GENERIC_TIMEZONE="Asia/Taipei" \
  docker.n8n.io/n8nio/n8n
```

--- 
1. **啟動 n8n 容器,使用Raspberry**

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e GENERIC_TIMEZONE="Asia/Taipei" \
  -e N8N_SECURE_COOKIE=false \
  docker.n8n.io/n8nio/n8n
```

> **mac或window 連線至raspberry的方法*‌*
> 
> 原因是Google API 通常不允許 http:// 開頭的網址作為「已授權的重新導向 URI (Authorized redirect URIs)」，除非它是 localhost。當你使用 http://192.168.x.x:5678 或類似的內部 IP 時，Google 會拒絕連線。

**所以必需使用SSH Tunnel**

這是最簡單的方法，不需要公開你的 n8n 到網際網路，也不用買網域。我們透過 SSH 將你 Mac 的 localhost:5678 映射到 Raspberry Pi 的 5678 port。

```bash
# 語法：ssh -L <本地Port>:localhost:<遠端Port> <使用者>@<Pi的IP>
ssh -L 5678:localhost:5678 pi@192.168.1.100
```

---

### 建立固定網址

[**Raspberry Pi + n8n + ngrok,建立固定網址**](./Raspberry_Pi+n8n+ngrok.md)

#### 重要說明

- **連接本機服務**：若需要在 n8n 工作流程中連接本機電腦的服務（如本地 API、資料庫等），請使用 `host.docker.internal` 作為主機名稱
  - 例如：`http://host.docker.internal:8080/api`
- **時區設定**：已設定為 `Asia/Taipei`，確保工作流程的時間戳記正確
- **資料持久化**：使用 `n8n_data` 卷儲存所有設定，即使容器重新啟動也不會遺失資料

#### 驗證安裝

執行以下命令檢查容器是否正常運行：

```bash
docker ps | grep n8n
```

應該會看到 n8n 容器在運行中。

## 1.4 初次啟動與設定

### 訪問 n8n

1. 開啟瀏覽器，訪問：`http://localhost:5678`
2. 若看到 n8n 的歡迎頁面，表示安裝成功

### 建立帳號

首次訪問時，n8n 會要求您建立第一個使用者帳號：

- **使用者名稱**：設定您的登入名稱
- **密碼**：建議使用強密碼
- **電子郵件**：可選填，用於密碼重設等功能

### 熟悉介面

完成帳號建立後，您將進入 n8n 的主介面，建議先熟悉以下區域：

- **工作流程清單**：顯示所有已建立的工作流程
- **節點面板**：左側面板顯示所有可用的節點類型
- **工作流程畫布**：中間區域用於設計和編輯工作流程
- **執行歷史**：查看工作流程的執行記錄和結果

## n8n(Name Volume)備份的方式
- 備份完後,手動儲存到雲端資料夾(n8n)
### Mac的備份方式

```bash
# 1. 確認您的 n8n Volume 名稱為 n8n_data
# 2. 確定您在 Mac 終端機內位於想要儲存備份檔的位置（例如：~/Desktop/backup）

docker run --rm \
    -v n8n_data:/data \
    -v $(pwd):/backup \
    alpine sh -c "cd /data && tar -czvf /backup/n8n_backup_$(date +%Y%m%d).tar.gz ."
```

- docker run --rm: 運行一個執行完畢就會自動刪除的臨時容器。

- -v n8n_data:/data: 將您的 n8n Volume 掛載到臨時容器的 /data 資料夾。

- -v $(pwd):/backup: 將您當前所在的 Mac 資料夾 ($(pwd)) 掛載到臨時容器的 /backup 資料夾。

- alpine sh -c "...": 在容器內執行壓縮指令，將 /data（n8n 資料）打包成 .tar.gz 檔，並輸出到 /backup（您的 Mac 本機）。

執行完畢後，您就會在終端機當前所在的目錄找到名為 n8n_backup_YYYYMMDD.tar.gz 的完整備份檔，接著您就可以將它上傳到雲端了。

