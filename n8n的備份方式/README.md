# 💾 n8n 備份與還原完整指南

在 Docker 環境中備份 n8n 非常安全且容易，核心關鍵在於**備份 n8n 的儲存空間（Volume/資料庫）**與**保存加密金鑰（Encryption Key）**。

> 🌟 **【學生 / 初學者強烈推薦】**：  
> 請直接使用 **情境一：Docker Desktop 圖形化介面一鍵備份**！完全不需要輸入複雜的終端機指令，點擊幾下滑鼠即可完成備份與還原。

---

## 🌟 情境一：【推薦學生首選】使用 Docker Desktop 圖形介面備份（免打指令）

Docker Desktop 內建了完整的 Volume 管理與匯出功能，適合所有學生與新手操作：

### 📦 步驟 1：暫停 n8n 容器
> ⚠️ **極度重要**：備份前務必先暫停容器！n8n 預設使用 SQLite 資料庫（`database.sqlite`），運行中複製可能會因資料寫入中而導致檔案損毀。
1. 開啟 **Docker Desktop**。
2. 點擊左側選單的 **Containers**。
3. 找到你的 **n8n 容器**，點擊右側的 ⏹️ **Stop** 按鈕將其暫停。

---

### 📦 步驟 2：一鍵匯出 Volume 備份檔
1. 點擊 Docker Desktop 左側選單的 **Volumes**。
2. 找到名為 **`n8n_data`** 的 Volume 項目。
3. 點擊該項目右側的 **「...」（三點選單）** 或進入頁面後點擊 **Export**（匯出）。
4. 選擇儲存路徑（例如：電腦桌面或雲端硬碟備份資料夾），檔案將會自動儲存為 `.tar` 或壓縮備份檔（例如 `n8n_data.tar`）。

---

### 📦 步驟 3：重新啟動 n8n 容器
備份檔案儲存完成後：
1. 回到 Docker Desktop 左側的 **Containers**。
2. 找到 n8n 容器，點擊 ▶️ **Start** 繼續使用。

---

### 🔄 如何在 Docker Desktop 還原備份（換電腦或重灌時）

當換到新電腦或需要還原資料時：
1. 確定 n8n 容器處於 **停止（Stop）** 狀態。
2. 進入 Docker Desktop 的 **Volumes** 頁面。
3. 點選 **`n8n_data`**（若尚未建立可點右上角 **Create Volume** 建立同名 Volume）。
4. 點選右側的 **Import**（匯入）或在該 Volume 點選 **「...」➔ Import Data**。
5. 選擇當初匯出的備份檔（`.tar`），點擊確認匯入。
6. 回到 **Containers** 重新啟動 n8n，所有工作流程、歷史紀錄與連線憑證即刻全數恢復！

---

## 🚀 情境二：使用終端機指令備份 Docker Volume（進階/自動化腳本）

若習慣使用命令列或需要撰寫自動化備份腳本，可使用單行指令將 Volume 打包：

### 📦 步驟 1：停止容器
```bash
docker stop <你的n8n容器名稱或ID>
```

### 📦 步驟 2：執行單行打包指令
開啟終端機（Mac 終端機 / Windows PowerShell），切換至想存檔的目錄（如桌面）：

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
> - `--rm`：打包完成後自動銷毀臨時 Alpine 容器。
> - `-v n8n_data:/data`：掛載 `n8n_data` Volume。
> - `-v "$(pwd)":/backup`：將本機目前目錄掛載為 `/backup`。
> - `tar czvf ...`：將 `/data` 資料壓縮成 `.tar.gz` 壓縮檔。

### 📦 步驟 3：重啟容器
```bash
docker start <你的n8n容器名稱或ID>
```

### 🔄 終端機還原指令：
```bash
# Mac / Linux 還原指令
docker run --rm -v n8n_data:/data -v "$(pwd)":/backup alpine sh -c "rm -rf /data/* && tar xzvf /backup/n8n_data_backup_*.tar.gz -C /data"

# Windows PowerShell 還原指令
docker run --rm -v n8n_data:/data -v "${PWD}:/backup" alpine sh -c "rm -rf /data/* && tar xzvf /backup/n8n_data_backup_*.tar.gz -C /data"
```

---

## 📁 情境三：本地資料夾掛載備份（Bind Mount / docker-compose）

若啟動 n8n 時是直接掛載本機資料夾（例如 `./n8n_data:/home/node/.n8n`）：

1. **先停止容器**：
   ```bash
   docker stop <你的n8n容器名稱>
   # 或在 docker-compose 目錄下執行
   docker compose down
   ```
2. **手動複製或壓縮本機資料夾**：
   - 直接將本機的 `n8n_data` 資料夾複製一份備份到外部硬碟或雲端硬碟。
   - 或使用壓縮指令：
     ```bash
     tar -czvf n8n_backup.tar.gz ./n8n_data
     ```
3. **備份 `docker-compose.yml`**：將 Compose 設定檔連同資料夾一起妥善保存。

---

## 📄 情境四：使用 n8n CLI 匯出（純 JSON 工作流程與憑證）

如果只想單純備份或轉移**工作流程（Workflows）**與**憑證（Credentials）**，不需要備份整個底層資料庫：

### 匯出指令：
```bash
# 1. 匯出所有工作流程為 JSON
docker exec -it <你的n8n容器名稱> n8n export:workflow --all --output=/files/all_workflows.json

# 2. 匯出所有憑證
docker exec -it <你的n8n容器名稱> n8n export:credentials --all --output=/files/all_credentials.json
```
*註：執行後請使用 `docker cp` 將容器內的 `/files/` 目錄複製到本機。*

### 還原指令：
```bash
# 在新容器中匯入
docker exec -it <新n8n容器名稱> n8n import:workflow --input=/files/all_workflows.json
docker exec -it <新n8n容器名稱> n8n import:credentials --input=/files/all_credentials.json
```

---

## ⚠️ 極度重要：密碼與金鑰防呆提醒（換電腦必看）

> [!CAUTION]
> **換新電腦時，憑證失效的最常見原因**：  
> n8n 在首次啟動時會自動生成一組 **資料加密金鑰（Encryption Key）**，用於對資料庫中儲存的 API Key、密碼等機密資訊進行加密。

1. **查看你的金鑰**：
   - 在已備份的 `n8n_data` 檔案中，金鑰存放在 `config` 檔案中。
   - 或可以在終端機執行：
     ```bash
     docker exec -it <你的n8n容器名稱> cat /home/node/.n8n/config
     ```
2. **在新電腦保持金鑰一致**：
   - 如果使用完整的 Volume 備份還原（包含 `config` 檔案），金鑰會自動被還原。
   - 如果使用 docker-compose 重新部署，建議在環境變數中固定指定：
     ```yaml
     environment:
       - N8N_ENCRYPTION_KEY=你的舊金鑰（務必保持完全相同）
     ```

---

<details>
<summary>🔑 <b>本機 n8n 加密金鑰備忘錄（點擊展開查看）</b></summary>

```json
{
  "encryptionKey": "11FpZn6tsYW+C+Ui+CKF6nc2iOcEtYBT"
}
```

- **環境變數設定範例**：
  ```yaml
  environment:
    - N8N_ENCRYPTION_KEY=11FpZn6tsYW+C+Ui+CKF6nc2iOcEtYBT
  ```
</details>