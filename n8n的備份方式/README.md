# n8n的備份方式
在 Docker 上備份 n8n 其實非常簡單，關鍵在於「打包資料夾」**或**「備份資料庫與設定」。

依據你當初啟動 n8n 的方式（使用單純的 Data Volume，還是綁定本地資料夾的 Bind Mount），主要有以下兩種最常見且安全的備份方法。

---

## 方法一：直接備份資料夾（最推薦、最簡單）

如果你當初是用 `docker-compose` 或者有將 n8n 的資料夾透過 `-v` 參數對應到你電腦的實體路徑（例如 `/home/user/n8n_data`），那麼你所有的工作流、認證資料、SQLite 資料庫都在這個資料夾裡。

### 備份步驟：

1. **停止 n8n 容器**（避免備份到一半有資料在寫入而損壞）：
```bash
docker stop <你的n8n容器名稱>

```


2. **將資料夾壓縮備份**：
把你的 n8n 資料夾（包含內部的 `.n8n` 或 `git` 等隱藏檔案）直接壓縮起來。
```bash
tar -czvf n8n_backup.tar.gz /path/to/your/n8n_data

```


3. **導出環境設定**：
如果你有使用 `docker-compose.yml`，請連同這個 `.yml` 檔案一起複製保存。它記錄了你的環境變數和加密金鑰（`N8N_ENCRYPTION_KEY`）。

### 還原到新電腦：

1. 將 `n8n_backup.tar.gz` 和 `docker-compose.yml` 複製到新電腦。
2. 解壓縮資料夾到指定路徑。
3. 在新電腦上執行 `docker compose up -d`，n8n 就會完美復活，所有 Workflow 和帳號都在。

---

## 方法二：使用 n8n 內建的 CLI 命令導出（純工作流備份）

如果你當初**沒有**把資料夾映射出來（資料存在 Docker 的匿名 Volume 裡），或者你**只想備份工作流（Workflows）與憑證（Credentials）**，可以用 n8n 自帶的指令直接匯出成 JSON 檔。

### 備份步驟：

1. **導出所有工作流（Workflows）：**
```bash
docker exec -it <你的n8n容器名稱> n8n export:workflow --all --output=/files/all_workflows.json

```


2. **導出所有憑證設定（Credentials）：**
```bash
docker exec -it <你的n8n容器名稱> n8n export:credentials --all --output=/files/all_credentials.json

```


*註：`/files/` 是 n8n 容器內的預設路徑，執行完後，記得把這兩個 JSON 檔從容器內複製出來（`docker cp`）存到你的電腦。*

### 還原到新電腦：

在新電腦裝好乾淨的 n8n 後，將 JSON 檔放入新容器，並執行導入指令：

```bash
docker exec -it <新n8n容器名稱> n8n import:workflow --input=/files/all_workflows.json
docker exec -it <新n8n容器名稱> n8n import:credentials --input=/files/all_credentials.json

```

---

## ⚠️ 極度重要注意事項（漏掉這步，換電腦會打不開）

不論你用哪種方法，n8n 在第一次啟動時都會自動生成一組「資料加密金鑰（Encryption Key）」。用來加密你在 n8n 裡儲生的密碼、API Key 等敏感資訊。

如果你換到新電腦，**必須確保新舊電腦的加密金鑰完全一致**，否則就算工作流還原了，所有的帳號密碼都會因為無法解密而失效！

**做法：**
請檢查你舊電腦的環境變數，找到 `N8N_ENCRYPTION_KEY` 的數值（如果是用 SQLite，通常也可以在舊資料夾的 `config` 裡找到）。在新電腦啟動時，務必在 Docker 環境變數中帶入同一個金鑰：

```yaml
# docker-compose.yml 範例
environment:
  - N8N_ENCRYPTION_KEY=你的舊金鑰（絕對不能變）

```