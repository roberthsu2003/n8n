# Docker容器化基礎與n8n部署準備

**Docker 不是目的，而是「工具」**。這 6 小時的目標不是讓他們成為 DevOps 工程師，而是讓他們具備「**有能力部署、除錯並維護 n8n 容器**」的技能。

根據您 Python 講師的背景，我為您規劃了一份**由淺入深、強調實作**的 6 小時 Docker 課程大綱。這份大綱特別強調「資料持久化 (Volumes)」和「Docker Compose」，因為這兩者是長期運行 n8n 的關鍵。

---

### 課程主題：Docker 容器化基礎與 n8n 部署準備

**總時數：6 小時**
**教學目標：** 學生能夠理解容器概念，學會基本的 Docker 指令，並能使用 Docker Compose 撰寫 `docker-compose.yml` 來管理 n8n 服務。

---

### 第一階段：概念與基礎操作 (前 1.5 小時)

**目標：打破對虛擬機的舊有觀念，建立「映象檔 (Image)」與「容器 (Container)」的物件導向概念。**

1. **Docker 核心概念 (30 分鐘)**
* **痛點分析**：為什麼以前部署很痛苦？（環境不一致、依賴衝突）。
* **核心比喻**：
* **虛擬機 (VM)** vs **容器 (Container)**：像是「整棟房子」vs「IKEA 樣品屋 (輕量、共用地基)」。
* **Image (映象檔)** vs **Container (容器)**：
* 對 Python 學生解釋：Image 是 `Class` (類別)，Container 是 `Instance` (實例)。
* 對一般學生解釋：Image 是「食譜」，Container 是照著食譜做出來的「這盤菜」。






2. **安裝與 Hello World (30 分鐘)**
* Docker Desktop (Mac/Windows) 或 Docker Engine (Linux) 安裝簡介。
* 執行第一個容器：`docker run hello-world`。
* 解讀 Log：發生了什麼事？(Client -> Daemon -> Registry -> Image -> Container)。


3. **基礎指令實戰 (30 分鐘)**
* 尋找資源：Docker Hub 導覽。
* 拉取：`docker pull nginx`。
* 檢視：`docker images`, `docker ps` (正在執行), `docker ps -a` (包含已停止)。



### 第二階段：網路與與資料持久化 (重點！1.5 小時)

**目標：解決 n8n 架設最常遇到的兩個問題：「連不到網頁」與「重啟後 Workflow 不見了」。**

1. **端口映射 (Port Mapping) (45 分鐘)**
* **概念**：容器是封閉的監獄，`-p` 是開窗戶。
* **實作**：
* `docker run -d -p 8080:80 nginx`
* 解釋 `Host Port : Container Port` 的對應關係。
* 瀏覽器打開 `localhost:8080` 看到 Nginx 歡迎頁面。


* **除錯**：為什麼 `localhost:80` 打不開？(因為沒對應)。


2. **Volume 資料卷 (45 分鐘) —— *n8n 存活關鍵***
* **慘痛教訓演示**：
* 在 Nginx 容器內建立一個檔案。
* 刪除容器 (`docker rm -f`) 再重開。
* 檔案消失了！(說明容器的短暫性)。


* **解決方案**：Bind Mounts 與 Volumes。
* **實作**：
* `docker run -v $(pwd)/html:/usr/share/nginx/html ...`
* 在主機修改 `index.html`，容器內即時更新 (這對 n8n 備份至關重要)。





---

### 第三階段：進階管理與 Docker Compose (1.5 小時)

**目標：從「手動下指令」進化到「基礎設施即代碼 (IaC)」，這是架設 n8n 的標準姿勢。**

1. **環境變數 (Environment Variables) (30 分鐘)**
* **概念**：不修改程式碼，透過 `-e` 改變軟體行為。
* **實作**：使用一個簡單的 Python Web Server 或是 MySQL 容器，設定 `MYSQL_ROOT_PASSWORD`。
* **關聯 n8n**：預告 n8n 需要設定 `WEBHOOK_URL` 或加密金鑰等變數。


2. **Docker Compose 登場 (1 小時)**
* **為什麼需要 Compose**：當你要同時啟動 n8n、PostgreSQL (資料庫) 和 Redis 時，一行一行打指令太累了。
* **YAML 語法速成**：縮排的藝術。
* **編寫第一個 `docker-compose.yml**`：
```yaml
version: '3.8'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html

```


* **指令**：`docker-compose up -d` 與 `docker-compose down`。



---

### 第四階段：專題實戰 - 模擬 n8n 部署環境 (1.5 小時)

**目標：將前 4.5 小時的知識總結，實際演練 n8n 的部署流程 (先不進入 n8n 操作，專注於架設)。**

1. **解讀 n8n 官方 Docker Compose (45 分鐘)**
* 帶領學生看懂 n8n 的 `docker-compose.yml` 範本。
* 解釋其中的關鍵欄位：
* `restart: always` (當機自動重啟)。
* `volumes` (n8n 的資料存在哪？`~/.n8n`)。
* `ports` (5678 port)。




2. **實戰演練 (45 分鐘)**
* **任務**：使用 Docker Compose 啟動 n8n。
* **步驟**：
1. 建立資料夾。
2. 撰寫 `docker-compose.yml` (包含 n8n 服務)。
3. 建立 `.env` 檔案 (存放帳號密碼等敏感資訊)。
4. 啟動並檢查 Logs (`docker-compose logs -f`)。
5. 成功登入 n8n 歡迎畫面。


* **Q&A 與常見雷區**：
* 權限問題 (Linux/Mac 上的 Volume 讀寫權限)。
* Port 衝突怎麼辦？





---

---
可以，以下是一個**6 小時、以「為了順利理解與安裝 n8n 到 Docker」為目標**所設計的課程大綱。

這份大綱是以**教學導向、非專職工程師也能跟上**為前提，並刻意避開過度艱深的 Docker 細節，讓學生「夠用、敢用、用得懂」。

---

## **課程總目標（先讓學生知道為什麼要學）**

> 這 6 小時學完後，學生能：

- 理解 **Docker 在 n8n 中扮演的角色**
- 看得懂並修改 **docker run / docker-compose**
- 知道 **n8n 的資料為什麼會消失、怎麼保存**
- 為下一堂「實際安裝 n8n 並建工作流」做好準備

---

# **6 小時課程總覽**

| **時間** | **主題**                | **教學重點**                   |
| ------ | --------------------- | -------------------------- |
| 第 1 小時 | 為什麼 n8n 一定要搭配 Docker  | 建立「容器化思維」                  |
| 第 2 小時 | Docker 基本概念（夠用版）      | image / container / volume |
| 第 3 小時 | Docker 實戰（CLI）        | docker run + port + volume |
| 第 4 小時 | 容器資料保存與環境變數           | 為 n8n 鋪路                   |
| 第 5 小時 | Docker Compose（為什麼需要） | 多服務、可重現                    |
| 第 6 小時 | n8n 專用 Docker 架構預告    | 看懂官方範例                     |

---

## **第 1 小時：為什麼 n8n 幾乎「一定要用 Docker」**

### **教學目標**

讓學生 **先理解問題，再接受 Docker 是解法**

### **內容設計**

- n8n 是什麼？（一句話）
    - 不是寫程式
    - 是「工作流伺服器」
- 為什麼不能「直接下載執行」
    - Node.js 版本
    - 套件依賴
    - 更新地獄
- 實際案例說明
    - 同一個 n8n，在不同電腦跑不起來
- Docker 解決了什麼？
    - 環境一次封裝
    - 刪了再來一個一模一樣的

📌 **關鍵觀念句**

> Docker 不是讓你更厲害，是讓你「少出錯」

---

## **第 2 小時：Docker 核心概念（n8n 專用版本）**

### **教學目標**

學生能「用白話解釋 Docker 在幹嘛」

### **只教這 5 個名詞（其他全部不講）**

| **名詞**               | **教法**  |
| -------------------- | ------- |
| Image                | 已經煮好的便當 |
| Container            | 正在吃的便當  |
| Volume               | 外接硬碟    |
| Port                 | 對外開的門   |
| Environment Variable | 設定選項    |

### **視覺化說明**

- n8n image ≠ n8n container
- 刪 container ≠ 刪資料（如果有 volume）

---

## **第 3 小時：Docker CLI 實戰（先不用 n8n）**

### **教學目標**

讓學生 **親手跑過一個容器，不再害怕指令**

### **實作流程**

1. docker pull hello-world
2. docker run hello-world
3. docker ps / docker ps -a
4. 跑一個「會開網頁的容器」
    - 例如 nginx

```other
docker run -d -p 8080:80 nginx
```

### **重點不是記指令，而是理解**

- \-d 是什麼
- \-p 8080:80 在做什麼
- 為什麼瀏覽器能看到畫面

---

## **第 4 小時：資料為什麼會不見？（Volume 與環境變數）**

### **教學目標**

為 n8n「工作流消失」問題提前打預防針

### **教學情境**

- 刪 container → 資料消失
- 學生常見誤解：

    >> 「我不是都有存嗎？」

### **Volume 實作**

```other
docker run -d \
  -p 8081:80 \
  -v mydata:/usr/share/nginx/html \
  nginx
```

### **環境變數概念**

- 不改程式，就能改設定
- 為什麼 n8n 大量用 env

---

## **第 5 小時：Docker Compose（為什麼一定要學）**

### **教學目標**

學生能理解：

> 為什麼「docker run 很快就不夠用」

### **教學重點**

- 問題導向
    - 指令太長
    - 不好記
    - 不好交給別人
- docker-compose.yml 是什麼
    - **「一份可重現的說明書」**

### **範例（先用 nginx）**

```other
services:
  web:
    image: nginx
    ports:
      - "8080:80"
```

### **關鍵觀念**

- 專案 ≠ 單一 container
- n8n 幾乎一定是 compose

---

## **第 6 小時：n8n 的 Docker 架構「預告課」**

> 這一小時 **不安裝 n8n**

> 目標是「看得懂官方文件」

### **拆解 n8n 官方 docker-compose**

重點看這些：

- image: n8nio/n8n
- ports
- volumes
- environment

### **建立正確心理模型**

- n8n 是一個「長時間運作的服務」
- 資料一定要放在 volume
- 升級 = 換 image，不是重裝系統

---

## **課後學生應該能回答的問題**

如果學生能回答這些，代表你教成功了：

- 為什麼 n8n 用 Docker 比較安全？
- 刪 container 為什麼資料會不見？
- volume 在 n8n 中扮演什麼角色？
- docker run 和 docker compose 差在哪？
- 為什麼正式環境不用 docker run？

---

## **如果你願意，下一步我可以幫你**

- 幫你把這 6 小時變成 **投影片大綱**
- 幫你設計 **「學生常犯錯誤清單」**
- 幫你規劃 **第 7～9 小時：正式安裝 n8n + 第一個工作流**

