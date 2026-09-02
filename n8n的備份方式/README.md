# n8n 的備份與還原完整指南

在 Docker 環境中備份 n8n 非常安全且容易，關鍵在於**備份 n8n 的儲存空間（Volume/資料夾）**或**匯出工作流程與憑證**。

根據學生與常見部署方式，主要分為以下三種備份情境：

---

## 🚀 情境一：Docker 具名 Volume 備份（學生最常用：`n8n_data`）

如果學生是使用 Docker 具名 Volume 啟動 n8n（例如：`-v n8n_data:/home/node/.n8n`，在 Docker Desktop 的 **Volumes** 頁面會看到名為 **`n8n_data`** 的項目）：

> [!IMPORTANT]
> **備份前務必先停止 n8n 容器**！  
> n8n 預設使用 SQLite 資料庫（`database.sqlite`），如果在容器運行中複製，可能因資料正在寫入而導致備份檔損毀。

---

### 📦 步驟 1：暫停 n8n 容器
- 在 Docker Desktop 的 **Containers** 頁面找到 n8n 容器，點擊 ⏹️ **Stop**。
- 或在終端機執行：
  ```bash
  docker stop <你的n8n容器名稱或ID>
  ```

---

### 📦 步驟 2：執行單行打包備份指令

開啟終端機（Mac 終端機 / Windows PowerShell），切換到你想存放備份檔的目錄（如桌面），執行以下對應指令：

#### 🍏 Mac / Linux 終端機：
```bash
docker run --rm -v n8n_data:/data -v "$(pwd)":/backup alpine tar czvf /backup/n8n_data_backup_$(date +%Y%m%d).tar.gz -C /data .
```

#### 🪟 Windows PowerShell：
```powershell
docker run --rm -v n8n_data:/data -v "${PWD}:/backup" alpine tar czvf /backup/n8n_data_backup_$(Get-Date -Format "yyyyMMdd").tar.gz -C /data .
```

#### 🪟 Windows CMD（命令提示字元）：
```cmd
docker run --rm -v n8n_data:/data -v "%cd%":/backup alpine tar czvf /backup/n8n_data_backup.tar.gz -C /data .
```

> **💡 指令原理解析**：
> - `--rm`：打包完成後自動銷毀臨時的 Alpine 容器，不佔空間。
> - `-v n8n_data:/data`：掛載名為 `n8n_data` 的 Volume。
> - `-v "$(pwd)":/backup`：將本機目前所在的目錄掛載為 `/backup`。
> - `tar czvf ...`：將 `/data` 內的所有資料壓縮成 `.tar.gz` 壓縮檔。

---

### 📦 步驟 3：重新啟動 n8n 容器
備份完成後，在 Docker Desktop 點擊 ▶️ **Start** 即可恢復運作。

---

### 🔄 如何還原 Volume 備份（換電腦或重灌時）

當需要將備份還原到新電腦時：

1. **建立全新的 `n8n_data` Volume**（如果尚未建立）：
   ```bash
   docker volume create n8n_data
   ```

2. **將備份檔還原進 Volume**（請在存放備份檔的目錄下執行）：
   - **Mac / Linux**：
     ```bash
     docker run --rm -v n8n_data:/data -v "$(pwd)":/backup alpine sh -c "rm -rf /data/* && tar xzvf /backup/n8n_data_backup_*.tar.gz -C /data"
     ```
   - **Windows PowerShell**：
     ```powershell
     docker run --rm -v n8n_data:/data -v "${PWD}:/backup" alpine sh -c "rm -rf /data/* && tar xzvf /backup/n8n_data_backup_*.tar.gz -C /data"
     ```

3. **啟動新 n8n 容器**，所有工作流程、帳號與連線資訊就會完整恢復！

---

## 🖥️ 情境二：使用 Docker Desktop 介面直接匯出

如果你偏好圖形介面：

1. **先停止 n8n 容器**。
2. 進入 Docker Desktop 左側選單的 **Volumes**。
3. 點擊進入 **`n8n_data`**。
4. 切換到上方頁籤的 **Data**，可檢視其中的資料（如 `database.sqlite`、`config` 等）。
5. 點擊右側 Actions 的 🗂️ **Export / Save volume data**（複製圖示），即可將整個 Volume 內容匯出至本機硬碟。

---

## 📁 情境三：本地資料夾備份（Bind Mount / docker-compose）

如果你當初啟動時是將本機資料夾掛載到容器（例如 `./n8n_data:/home/node/.n8n`）：

1. **停止 n8n 容器**：
   ```bash
   docker stop <你的n8n容器名稱>
   ```
2. **打包資料夾**：
   ```bash
   tar -czvf n8n_backup.tar.gz /path/to/your/n8n_data
   ```
3. **備份 `docker-compose.yml`**：將 Compose 設定檔連同壓縮檔一起妥善保存。

---

## 📄 情境四：使用 n8n 內建 CLI 匯出（純 JSON 工作流與憑證）

如果只想單純備份或轉移**工作流程（Workflows）**與**憑證（Credentials）**，不需要備份整個資料庫：

### 匯出指令：
```bash
# 1. 匯出所有工作流程為 JSON
docker exec -it <你的n8n容器名稱> n8n export:workflow --all --output=/files/all_workflows.json

# 2. 匯出所有憑證
docker exec -it <你的n8n容器名稱> n8n export:credentials --all --output=/files/all_credentials.json
```
*註：執行後請使用 `docker cp` 將 `/files/` 內的 JSON 複製到電腦硬碟。*

### 還原指令：
```bash
# 在新容器中匯入
docker exec -it <新n8n容器名稱> n8n import:workflow --input=/files/all_workflows.json
docker exec -it <新n8n容器名稱> n8n import:credentials --input=/files/all_credentials.json
```

---

## ⚠️ 極度重要注意事項（避免換電腦後密碼失效）

> [!CAUTION]
> n8n 在首次啟動時會自動生成一組 **資料加密金鑰（Encryption Key）**，用於加密資料庫中儲存的 API Token、密碼等敏感憑證。

如果換到新電腦：
1. 請檢查舊環境的 `N8N_ENCRYPTION_KEY`（或舊資料夾內的 `config` 檔）。
2. 在新電腦啟動時，**務必使用完全相同的金鑰**，否則還原後已儲存的 API 金鑰會因無法解密而失效：
   ```yaml
   # docker-compose.yml 範例
   environment:
     - N8N_ENCRYPTION_KEY=你的舊金鑰（務必保持一致）
   ```