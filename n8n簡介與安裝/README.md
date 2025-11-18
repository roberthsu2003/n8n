## 第一章：n8n 簡介與安裝

### 1.1 什麼是 n8n？

- n8n 是一個開源的自動化工作流工具
- 無程式碼/低程式碼平台
- 可整合多種 API 和服務

### 1.2 n8n 的應用場景

- 資料同步
- 通知提醒
- 資料處理
- API 整合
- 自動化任務

### 1.3 安裝方式

使用 Docker

**window**

- 在n8n內連結本機電腦的網路使用`host.docker.internal`


```bash
docker volume create n8n_data

docker run -d \
 --name n8n \
 -p 5678:5678 \
 -v n8n_data:/home/node/.n8n \
 -e GENERIC_TIMEZONE="Asia/Taipei" \
 docker.n8n.io/n8nio/n8n
```

**Mac電腦**

- 在n8n內連結本機電腦的網路使用`host.docker.internal`

```bash
docker volume create n8n_data

docker run -d \
 --name n8n \
 -p 5678:5678 \
 -v n8n_data:/home/node/.n8n \
 -e GENERIC_TIMEZONE="Asia/Taipei" \
 docker.n8n.io/n8nio/n8n
```

### 1.4 初次啟動

- 瀏覽器訪問：`http://localhost:5678`
- 建立第一個帳號
- 熟悉初始介面