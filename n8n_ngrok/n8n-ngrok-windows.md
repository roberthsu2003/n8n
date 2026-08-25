# n8n + ngrok 安裝教學（Windows 版）

使用 Docker Compose 一次啟動 **n8n** 與 **ngrok** 兩個容器，讓你的 n8n 擁有一個固定的對外 HTTPS 網址，可以接收 LINE、Google、Notion 等外部服務的 Webhook。

> 本文件為 Windows 版本。使用 macOS 請看 [n8n-ngrok-mac.md](./n8n-ngrok-mac.md)。

---

## 目錄

- [為什麼需要 ngrok](#為什麼需要-ngrok)
- [事前準備](#事前準備)
- [步驟一：取得 ngrok Authtoken 與固定網域](#步驟一取得-ngrok-authtoken-與固定網域)
- [步驟二：建立專案資料夾](#步驟二建立專案資料夾)
- [步驟三：建立 4 個檔案](#步驟三建立-4-個檔案)
- [步驟四：啟動](#步驟四啟動)
- [日常操作](#日常操作)
- [常見問題排除](#常見問題排除)
- [重要提醒](#重要提醒)

---

## 為什麼需要 ngrok

n8n 跑在你自己的電腦上，網址是 `http://localhost:5678`，**只有你自己看得到**。

但是 Webhook 的運作方式是「外部服務主動打你的網址」。LINE 的伺服器在日本，它沒辦法連到你家電腦的 `localhost`。

ngrok 的作用就是在中間搭一條隧道（tunnel）：

```
LINE 伺服器  →  https://你的網域.ngrok-free.dev  →  ngrok 容器  →  n8n 容器
   (外部)              (ngrok 的公開網址)              (你的電腦內部)
```

這樣外部服務就能順利把資料送進你電腦裡的 n8n。

---

## 事前準備

### 1. 安裝 Docker Desktop

到 [Docker 官網](https://www.docker.com/products/docker-desktop/) 下載安裝 Windows 版。

安裝完成後，開啟 **命令提示字元（cmd）** 或 **PowerShell**，輸入以下指令確認安裝成功：

```powershell
docker --version
docker compose version
```

有跑出版本號就代表安裝成功。例如：

```
Docker version 27.3.1, build ce12230
Docker Compose version v2.29.7-desktop.1
```

### 2. 確認 Docker Desktop 正在執行

右下角工作列要看得到 Docker 的鯨魚圖示，而且是「執行中」的狀態。**Docker Desktop 沒開，所有指令都會失敗。**

### 3. 註冊 ngrok 帳號

到 [ngrok.com](https://ngrok.com/) 註冊一個免費帳號（可以用 Google 帳號登入）。

---

## 步驟一：取得 ngrok Authtoken 與固定網域

ngrok 免費帳號現在預設都會直接提供 **1 組專屬的固定網址 (Static Domain)**，每次啟動通道時網址都會維持固定，不會隨機變動（這代表設定在 LINE Bot 後台的 Webhook URL 永遠不會失效）。

### 1-1 取得 Authtoken

1. 登入 [dashboard.ngrok.com](https://dashboard.ngrok.com/)。
2. 左側選單點選 **Your Authtoken**。
3. 複製那一長串英數字（長得像 `2abc...XYZ`），先貼在記事本上備用。

### 1-2 取得專屬固定網域（Static Domain）

1. 左側選單點選 **Domains**（或 **Cloud Edge** > **Domains**）。
2. 你會看到 ngrok 系統自動為您分配的一組專屬免費固定網址，長得像：
   ```text
   xxxx-xxxx.ngrok-free.dev
   ```
   *(若首次進入尚未產生，只需點擊 **+ New Domain** 或 **Claim Domain** 即可立即取得)*
3. 將這組固定網域名稱複製起來（**只要網域名稱，不包含 `https://`**），一樣先貼在記事本上備用。

---

## 步驟二：建立專案資料夾

在你習慣的位置建一個資料夾，例如：

```
D:\n8n-ngrok\
```

⚠️ **路徑不要有中文、空白或特殊符號**，例如 `D:\我的專案\n8n` 可能會出問題，改用 `D:\n8n-ngrok` 這種純英文路徑。

最後這個資料夾裡面會有 4 個檔案：

```
D:\n8n-ngrok\
├── compose.yaml      ← 容器設定檔（核心）
├── .env              ← 放你的 Authtoken 和網域
├── up.bat            ← 啟動用
└── down.bat          ← 關閉用
```

---

## 步驟三：建立 4 個檔案

> **建立檔案的注意事項**
>
> Windows 的「記事本」預設會偷偷幫你加上 `.txt` 副檔名，變成 `compose.yaml.txt`，這樣 Docker 會找不到檔案。
>
> **解決方式（擇一）：**
> - **推薦**：安裝 [VS Code](https://code.visualstudio.com/) 來編輯（老師上課會用到，建議直接裝）
> - 或：在檔案總管點「檢視」→ 勾選「副檔名」，就能看到真正的檔名並手動改掉
> - 或：用記事本存檔時，「存檔類型」選 **所有檔案 (\*.\*)**，檔名打上完整的 `compose.yaml`

### 檔案 1：`.env`

放你的機密資料。**這個檔案的檔名就是 `.env`，前面有一個點，沒有主檔名。**

```env
NGROK_AUTHTOKEN=在這裡貼上你的Authtoken
NGROK_DOMAIN=abcd-1234.ngrok-free.dev
```

**填寫範例：**

```env
NGROK_AUTHTOKEN=2abcDEFghiJKLmnoPQRstuVWXyz_1a2B3c4D5e6F7g8H9i
NGROK_DOMAIN=teacher-class-01.ngrok-free.dev
```

⚠️ 注意事項：
- `=` 前後**不要有空白**
- 值**不要加引號**
- `NGROK_DOMAIN` **不要加 `https://`**，只寫網域本身

---

### 檔案 2：`compose.yaml`

這是整個設定的核心，定義了兩個容器要怎麼跑。

```yaml
services:
  n8n:
    image: docker.n8n.io/n8nio/n8n
    container_name: n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=${NGROK_DOMAIN}
      - N8N_PROTOCOL=https
      - N8N_PORT=5678
      - N8N_EDITOR_BASE_URL=https://${NGROK_DOMAIN}
      - WEBHOOK_URL=https://${NGROK_DOMAIN}
      - GENERIC_TIMEZONE=Asia/Taipei
      - TZ=Asia/Taipei
      - N8N_RUNNERS_ENABLED=true
    volumes:
      - n8n_data:/home/node/.n8n

  ngrok:
    image: ngrok/ngrok:latest
    container_name: ngrok
    depends_on:
      - n8n
    environment:
      - NGROK_AUTHTOKEN=${NGROK_AUTHTOKEN}
    command: http --url=https://${NGROK_DOMAIN} --log=stdout n8n:5678

volumes:
  n8n_data:
```

**這段設定在做什麼？（給想理解原理的同學）**

| 設定 | 說明 |
|---|---|
| `image` | 要用哪個現成的映像檔，Docker 會自動去網路上下載 |
| `container_name` | 容器的名字，方便你下指令時指定 |
| `ports: 5678:5678` | 把容器的 5678 埠對應到你電腦的 5678 埠，讓你能用 `localhost:5678` 開 |
| `WEBHOOK_URL` | 告訴 n8n「你對外的網址是這個」，n8n 產生 Webhook 連結時才會給對的網址 |
| `volumes: n8n_data` | 把 n8n 的資料存在 Docker 的儲存空間，容器刪掉資料也還在 |
| `depends_on` | 確保 n8n 先啟動，ngrok 才啟動 |
| `command: ... n8n:5678` | 叫 ngrok 把隧道接到名為 `n8n` 的容器的 5678 埠 |

**關於「兩個容器共用網路」：** Docker Compose 會自動幫同一個 `compose.yaml` 裡的所有容器建立一個共用的內部網路。所以 ngrok 可以直接用容器名稱 `n8n` 當作主機名稱來連線，不需要額外設定。

---

### 檔案 3：`up.bat`（啟動）

```bat
@echo off
cd /d %~dp0
echo ========================================
echo   啟動 n8n + ngrok
echo ========================================
docker compose up -d
echo.
docker compose ps
echo.
echo 完成！請開啟瀏覽器前往你的 ngrok 網址
pause
```

**指令說明：**
- `@echo off`：不要把指令本身印出來，畫面比較乾淨
- `cd /d %~dp0`：自動切換到這個 `.bat` 檔所在的資料夾（這樣你放在哪都能用）
- `docker compose up -d`：啟動所有容器，`-d` 代表在背景執行
- `docker compose ps`：列出容器狀態，確認有沒有正常跑起來
- `pause`：暫停畫面，讓你看得到結果（不然視窗會一閃而過）

---

### 檔案 4：`down.bat`（關閉並移除容器）

```bat
@echo off
cd /d %~dp0
echo ========================================
echo   關閉並移除 n8n + ngrok 容器
echo ========================================
docker compose down
echo.
echo 容器已移除，資料仍保留在 n8n_data 中
pause
```

---

## 步驟四：啟動

1. **確認 Docker Desktop 已經開啟並執行中**
2. 雙擊 `up.bat`
3. 第一次執行會下載映像檔，需要幾分鐘，請耐心等待

**成功的畫面長這樣：**

```
NAME    IMAGE                        STATUS         PORTS
n8n     docker.n8n.io/n8nio/n8n      Up 5 seconds   0.0.0.0:5678->5678/tcp
ngrok   ngrok/ngrok:latest           Up 3 seconds
```

兩個容器的 `STATUS` 都是 `Up` 就代表成功了。

4. 打開瀏覽器，輸入你的 ngrok 網址：

```
https://abcd-1234.ngrok-free.dev
```

第一次進入 n8n 會要求你建立管理員帳號（Email + 密碼），設定完成後就可以開始使用了。

> 你也可以用 `http://localhost:5678` 在本機開啟，但是 **Webhook 測試一定要用 ngrok 網址**。

---

## 日常操作

| 我想要… | 怎麼做 |
|---|---|
| 開機後啟動 | 先開 Docker Desktop，再雙擊 `up.bat` |
| 關閉並移除容器 | 雙擊 `down.bat` |
| 打開 n8n 操作介面 | 瀏覽器前往 `https://你的網域.ngrok-free.dev` |
| 查看 ngrok 連線狀況 | 命令列輸入 `docker logs ngrok` |
| 查看 n8n 的錯誤訊息 | 命令列輸入 `docker logs n8n` |
| 即時監看紀錄 | `docker logs -f n8n`（按 `Ctrl + C` 停止） |
| 確認容器狀態 | `docker compose ps` |
| 更新到最新版 n8n | `docker compose pull` 之後再跑一次 `up.bat` |

### 為什麼沒有寫 `restart: always`？

如果加上 `restart: always`，Docker Desktop 一開機容器就會自動跑起來，你就沒機會「手動啟動」了。

本文件的設定是**完全手動控制**：要用才開，不用就關。這樣比較省資源，也符合上課的使用情境。

### `down.bat` 會不會刪掉我的資料？

**不會。** `docker compose down` 只會移除「容器」和「網路」，你的工作流程、憑證、設定都存在 `n8n_data` 這個 volume 裡面，下次 `up` 起來資料完整保留。

如果直接關掉 Docker Desktop 而沒跑 `down.bat`，容器只會變成「停止」而不是「移除」，下次 `up` 一樣能用，只是不符合「乾淨移除」的習慣。**建議養成先按 `down.bat` 的習慣。**

---

## 常見問題排除

### Q1：`docker` 不是內部或外部命令

**原因**：Docker Desktop 沒安裝，或安裝後沒有重新開機。

**解法**：重新安裝 Docker Desktop，安裝完**重開機**，再試一次。

---

### Q2：`error during connect: ... The system cannot find the file specified`

**原因**：Docker Desktop 沒有在執行。

**解法**：從開始選單開啟 Docker Desktop，等右下角鯨魚圖示變成穩定狀態（不再跑動畫），再執行 `up.bat`。

---

### Q3：`Bind for 0.0.0.0:5678 failed: port is already allocated`

**原因**：5678 這個埠已經被其他程式佔用了，通常是你之前用 `docker run` 建立的舊 n8n 容器還在。

**解法**：先移除舊容器

```powershell
docker rm -f n8n
```

然後再執行 `up.bat`。

---

### Q4：ngrok 容器一直重啟 / `docker logs ngrok` 出現錯誤

**先看錯誤訊息**：

```powershell
docker logs ngrok
```

| 錯誤訊息包含 | 原因 | 解法 |
|---|---|---|
| `authentication failed` | Authtoken 錯了 | 檢查 `.env` 裡的 token 有沒有貼完整 |
| `unknown flag: --url` | ngrok agent 版本較舊 | 把 `--url=https://${NGROK_DOMAIN}` 改成 `--domain=${NGROK_DOMAIN}`（注意不加 `https://`） |
| `is not a registered domain` | 網域打錯或沒申請 | 回 ngrok Dashboard → Domains 確認網域拼字 |
| `limited to 1 simultaneous session` | 你在電腦上另外開了 ngrok | 把本機的 ngrok 視窗關掉，免費帳號只能同時開一條隧道 |

---

### Q5：可以進 n8n，但 Webhook 收不到資料

**檢查順序：**

1. 確認 `.env` 的 `NGROK_DOMAIN` 和 ngrok Dashboard 上的網域**完全一致**
2. 確認 n8n 的流程有按下 **Active** 開關（測試模式的 Webhook 只有 120 秒有效）
3. 確認 n8n 節點顯示的 Webhook URL 開頭是 `https://你的網域...`，如果顯示 `localhost` 代表 `WEBHOOK_URL` 沒吃到，重跑一次 `down.bat` 再 `up.bat`

---

### Q6：修改了 `.env` 或 `compose.yaml`，但好像沒生效

環境變數只在容器**建立時**讀取一次。改完設定要重建容器：

```powershell
docker compose down
docker compose up -d
```

也就是先跑 `down.bat` 再跑 `up.bat`。

---

### Q7：防毒軟體擋住了

本教學**刻意把 ngrok 也放進 Docker 容器裡**，就是為了避免在 Windows 上直接安裝 `ngrok.exe` 被防毒軟體攔截或隔離。

所有網路連線都由 Docker 處理，不需要在系統上額外安裝執行檔。如果防毒軟體對 Docker Desktop 本身有意見，請聯絡你的 IT 人員把 Docker Desktop 加入白名單。

---

## 重要提醒

### 🔴 絕對不要執行 `docker compose down -v`

那個 `-v` 參數會**連同 volume 一起刪除**，你的所有 n8n 工作流程、憑證、設定都會消失且**無法復原**。

`down.bat` 裡面沒有 `-v`，請不要自己加上去。

---

### 🔴 `.env` 不要上傳到 GitHub

`.env` 裡面有你的 ngrok Authtoken，等於你的帳號密碼。上傳到公開的 GitHub 等於把帳號送人。

在專案資料夾裡建立一個 `.gitignore` 檔案，內容寫：

```gitignore
.env
```

這樣 Git 就會自動忽略它。

同時建議另外做一個 `.env.example` 範本檔上傳（不含真實資料），讓其他人知道要填什麼：

```env
NGROK_AUTHTOKEN=your_ngrok_authtoken_here
NGROK_DOMAIN=your-domain.ngrok-free.dev
```

---

### 🟡 免費版 ngrok 的限制

- 同時只能開 **1 條**隧道
- 固定網域只有 **1 個**
- 每個月有流量上限
- 訪客第一次進入時可能會看到 ngrok 的警告頁面，點「Visit Site」即可

以上限制對上課練習來說完全足夠。

---

### 🟡 這個環境不適合正式上線

ngrok 免費版 + 本機 Docker 是**開發與教學用**的組合。你的電腦關機，服務就斷了。

如果要做正式的自動化服務，應該租用雲端主機（VPS）並使用自己的網域。

---

## 附錄：完整檔案清單

複製貼上時請對照這份清單，確認一個都沒漏。

| 檔名 | 用途 | 是否可上傳 GitHub |
|---|---|---|
| `compose.yaml` | 容器設定 | ✅ 可以 |
| `.env` | 機密資料 | ❌ **絕對不行** |
| `.env.example` | 設定範本 | ✅ 可以 |
| `.gitignore` | 忽略清單 | ✅ 可以 |
| `up.bat` | 啟動腳本 | ✅ 可以 |
| `down.bat` | 關閉腳本 | ✅ 可以 |
