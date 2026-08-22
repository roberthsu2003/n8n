# SSH Tunnel

## 為什麼要SSH Tunnel

## 區域網路
  > [區域網路說明](./local_network.md)

## SSH連線和SSH Tunnel有什麼不同

SSH連線是基本遠端登入功能，而SSH Tunnel則在SSH連線基礎上建立埠轉發通道，實現流量加密轉送與突破限制。

![ssh連線和ssh_tunnel不同](./images/ssh連線和ssh_tunnel不同.png)

### 主要差別
SSH連線僅提供終端機存取（如`ssh pi@raspberry-ip`執行指令），不改變其他流量路徑；SSH Tunnel額外轉發指定埠流量，例如`ssh -L 8080:localhost:80 pi@raspberry-ip`讓本地8080埠連到Raspberry Pi的80埠服務。

### 主要觀念:

**SSH連線:**

透過1台電腦,可以操控多台伺服器

**SSH Tunnel**
2台電腦拉了一條專屬的安全延長線

### 功能比較

| 方面       | SSH連線                          | SSH Tunnel                          |
|------------|----------------------------------|-------------------------------------|
| **目的**  | 遠端Shell操作與檔案傳輸         | 加密轉發任意TCP流量（如Web、DB）   |
| **指令範例** | `ssh user@host`                 | `ssh -L localport:remotehost:port user@host` |
| **流量範圍** | 僅SSH埠22                       | 多埠轉發，偽裝成SSH流量            |
| **應用**  | 管理伺服器指令                  | 突破防火牆存取內網服務             |[1][6]

#### 1. 概念建立階段 (Concept)

- **痛點引導：**如果 Raspberry Pi 上有一個網頁伺服器只允許 `localhost` (本機) 連線，你要怎麼從你的 Windows 電腦看到它？
- **傳統解法 vs. 隧道解法：**
    - *傳統：* 修改防火牆、開放 Public IP (危險、麻煩)。
    - *隧道：* 透過已經建立的 SSH 連線，把 Raspberry Pi 的某個 Port「對應」到 Windows 的某個 Port。
    
    ![](./images/連線受阻的解決方法.png)

#### 2. 環境準備階段 (Setup)

- **Raspberry Pi (Server)：** 確認 SSH 服務已開啟，並安裝一個簡單的服務 (如網頁伺服器或資料庫)。
- **Windows (Client)：**
    - **推薦工具：** Windows 10/11 內建的 PowerShell 或 Command Prompt (CMD) 即可。
    - **備選工具：** 如果需要圖形化理解，可使用 MobaXterm 或 VS Code。

---

### 第二部分：學習範例 (Learning Example)

這裡我們使用 **Local Port Forwarding (本地通訊埠轉發)** 作為最經典的入門範例。

#### 步驟 1：在 Raspberry Pi 上製造一個「情境」

我們需要一個「只有 Pi 自己看得到」的服務。使用 Python 內建的 HTTP 伺服器最快。

請學生在 Raspberry Pi 上輸入：

Bash

```other
# 在 Pi 上建立一個簡單的測試資料夾
mkdir tunnel_test
cd tunnel_test
echo "<h1>Hello from the Secret Tunnel!</h1>" > index.html

# 啟動網頁伺服器，限定只能由 localhost (127.0.0.1) 存取，Port 為 8080
# 進入tunnel_test的資料夾
python3 -m http.server --bind 127.0.0.1 8080
```

> **驗證點：** 嘗試直接用 Windows 瀏覽器輸入 Pi 的 IP `:8080`，會發現**連不上**。這證明了防火牆或綁定限制生效中。

#### 步驟 2：在 Windows 上打通隧道

打開 Windows 的 PowerShell，輸入以下指令：

PowerShell

```other
# 語法：ssh -L [Windows本地Port]:[目標IP]:[目標Port] [使用者]@[Pi的IP]
ssh -L 9000:127.0.0.1:8080 pi@192.168.1.100
```

- **9000 (Local Port)：** 這是 Windows 端的入口。
- **127.0.0.1 (Target IP)：** 這是相對於 Pi 而言的目標（因為服務在 Pi 自己身上）。
- **8080 (Target Port)：** Pi 上服務運行的 Port。
- **pi@192.168.1.100：** 登入資訊。

#### 步驟 3：見證奇蹟

打開 Windows 的瀏覽器，網址列輸入：

[http://localhost:9000](http://localhost:9000)

結果： 他們將會看到 "Hello from the Secret Tunnel!"。

解釋： 瀏覽器以為連的是自己的 9000 Port，但其實 SSH 幫你把流量「偷渡」到了 Pi 的 8080 Port。

---

### 練習 (Practice Scenarios)

#### 情境：Jupyter Notebook(Data Science)

- **背景：** 一個電腦教室, 樹莓派上跑Jupyter伺服器 預設跑在8888 Port。
- **任務：** 只有部份電腦可以使用這個jupyter伺服器,學生只要執行一個bash檔就可以開啟伺服器。

- **樹莓派上建立jupyter notebook伺服器**
  - 預設綁定127.0.0.1:8888,無法從外部連結
  - 設定僅本地存取
  - 新的python現在預設要建立虛擬環境才可以安裝套件
  - 需要執行jupyter notebook才可以開啟
  
**安裝步驟**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install python3-pip python3-dev
python3 -m venv ~/jupyter_env #建立虛擬環境
source ~/jupyter_env/bin/activate #啟動虛擬環境
pip install jupyter notebook ipykernel #安裝jupyter notebook
jupyter notebook password #設定密碼
# 安裝到這一步後,本機已可以啟動jupyter notebook
jupyter notebook --generate-config # 產生設定檔
```

**設定僅本地存取**  

設定`/home/pi/.jupyter/jupyter_notebook_config.py`

```bash
c.NotebookApp.ip = '127.0.0.1'    # 僅本地存取
c.NotebookApp.port = 8888          # 預設埠
c.NotebookApp.open_browser = False # 不自動開瀏覽器
c.NotebookApp.allow_remote_access = False # 不充許遠端連結
```

**設定密碼**
```bash
jupyter notebook password
```

**本機執行jupyter notebook**
```bash
source ~/jupyter_env/bin/activate
jupyter notebook --no-browser --ip=127.0.0.1 --port=8888
```

- **解法：** `ssh -L 8888:localhost:8888 pi@<IP>`，直接在 Windows 瀏覽器寫 Python。
