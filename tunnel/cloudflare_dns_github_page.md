# GoDaddy 域名 + Cloudflare DNS 應用流程說明

![](./images/網域管轄權的轉移.png)

## 一、整體架構概念

* **域名（Domain）**：就像網站的「門牌號碼」，讓人可以找到你
* **DNS**：像是「電話簿」，負責把域名轉成真正的位址
* **主機 / 平台**：實際放網站內容的地方（例如 GitHub Pages）

👉 重點觀念：

> **域名在哪裡買不重要，DNS 指到哪裡才是關鍵**

---

## 二、整體流程

1. 在 GoDaddy 購買域名
2. 將域名 Nameserver 改為 Cloudflare 提供的Nameserver
3. 在 Cloudflare 設定 DNS（A / CNAME / Proxy）
4. 目標服務（如 GitHub Pages）完成驗證
5. HTTPS 生效

---

## 三、Step 1：GoDaddy 的角色（你只要記住一件事）

### GoDaddy 負責什麼？

* 域名註冊
* 設定 Nameserver（NS）

### 不負責什麼？

* ❌ 不負責 A / CNAME 設定（一旦交給 Cloudflare）
* ❌ 不負責 HTTPS

### 一定要記住

* 只要 **Nameserver 指向 Cloudflare**
* GoDaddy 的 DNS 畫面之後可以「忽略」

---

## 四、Step 2：為什麼我們要用 Cloudflare？

### Cloudflare 提供的功能

* DNS 管理（A / CNAME）
* Proxy（橘色雲朵）隱藏真實 IP
* 免費 HTTPS（Universal SSL）
* 防 DDoS

### 一句話重點

> Cloudflare = 「DNS 管理 + 防護 + HTTPS」

---

## 五、Step 3：Cloudflare DNS 設定重點

### 常見紀錄類型

#### 1️⃣ A Record

* 用途：指向「IP 位址」
* 範例：

  * example.com → 15.xxx.xxx.xxx

> 如何有example.com → 15.xxx.xxx.xxx,可以測試ping example.com 看是否能ping通  
> 沒有使用到A record, 可以刪除,使用ping example.com 看是否能ping通

#### 2️⃣ CNAME Record

* 用途：指向「另一個網域名稱」
* 範例：

  * profile.example.com → username.github.io

  > 這個範例是指向github page的域名

### 驗證 DNS 設定（dig 測試）

除了用 `ping` 確認連線，用 **dig** 可以直接查詢 DNS 紀錄，確認 A、CNAME 是否正確指向。

#### 如何安裝 dig

* **Linux（Ubuntu / Debian）**：`sudo apt install dnsutils`

#### 用 dig 測試 A Record

```bash
dig example.com
```

看輸出中的 **ANSWER SECTION**，應會看到 `example.com` 對應的 IP（例如 `185.xxx.xxx.xxx` 為 Cloudflare）。  
若沒有 ANSWER SECTION 或 IP 不對，代表 A 紀錄尚未生效或設定錯誤。

#### 用 dig 測試 CNAME Record（例如 GitHub Pages）

```bash
dig profile.example.com CNAME
```

看 **ANSWER SECTION** 是否出現 `profile.example.com` → `username.github.io`。  
有正確 CNAME 且 GitHub Pages 已驗證，網站才會正常。

#### 簡易解讀

* `dig` 回傳的 **ANSWER SECTION** = 實際生效的 DNS 紀錄
* 若查不到或還是舊紀錄，代表 DNS 尚未傳播完成，可過幾分鐘再查一次

---

## 六、Proxy（橘雲 / 灰雲）

### 灰雲（DNS only）

* 只做 DNS 解析
* 不經過 Cloudflare
* 真實 IP 可被看到

### 橘雲（Proxied）

* 流量經過 Cloudflare
* 對外 IP 會變成 Cloudflare
* 可啟用 HTTPS、防護

### 記憶口訣（考試／實作都會用到）

> 看到 Cloudflare IP 是「正常現象」

---

## 七、GitHub Pages + Cloudflare CNAME 的整合應用

![GitHub Pages + Cloudflare CNAME 的整合應用](./images/github_pages.png)

這一章會把 GitHub Pages 與 Cloudflare 的 CNAME 設定 串在一起說，並同時解釋你在實作時最常看到、也最容易緊張的系統訊息。

### 7-1 為什麼 GitHub Pages 需要 CNAME？

GitHub Pages 本身並不是用 IP 讓你連線，而是用「網址對網址」的方式運作，因此在 Cloudflare 裡：

* ✅ 一定要使用 CNAME Record
* ❌ 不使用 A Record（除非是 apex domain 進階設定）

📌 範例設定：

```
profile.example.com → username.github.io
```

### 7-2 Cloudflare 中的 CNAME 設定重點

在 Cloudflare DNS 頁面中，你會設定：

* **類型**：CNAME
* **名稱（Name）**：子網域（例如 profile）
* **目標（Target）**：username.github.io

#### Proxy 狀態建議（非常重要）

* 一開始先關閉 Proxy（灰雲）
* 等 GitHub Pages 顯示驗證成功
* 再視情況開啟 Proxy（橘雲）

### 7-3 GitHub Pages 介面中常見訊息說明

你在 GitHub Pages 設定頁，可能會看到以下訊息：

* DNS Check in Progress
* DNS check unsuccessful
* Enforce HTTPS — Unavailable for your site because your domain is not properly configured

#### 這些訊息代表什麼？

* DNS 設定剛完成，全球尚未同步（TTL）
* Proxy 狀態剛切換
* GitHub 尚未驗證到正確的 CNAME

👉 這些都屬於「正常過程」，不是你設定錯誤。

### 7-4 GitHub 與 Cloudflare「一定要兩邊都設定」的觀念（非常重要）

很多同學第一次做 GitHub Pages 時，會以為：

> 「我只要在 Cloudflare 設好 DNS 就好了」

👉 這是錯的觀念。

#### 📌 正確觀念一定要記住：

* ✅ Cloudflare：負責 DNS 指向（CNAME）
* ✅ GitHub Pages：負責驗證這個網域是你的
* ➡️ 兩邊一定都要設定，缺一不可。

### 7-5 為什麼 DNS 不會馬上成功？（一定要有耐心）

DNS 設定完成後，不會立刻生效，這是正常現象。

#### 原因是：

* DNS 需要時間
* 讓「全世界的 DNS 伺服器」知道這個新設定
* 這個過程叫做 DNS 傳播（DNS Propagation）

#### ⏳ 常見等待時間：

* 幾分鐘 ～ 10 分鐘（有時更快）
* 最慢可能到 1～24 小時

**如何確認 DNS 是否已生效？** 可用終端機執行 `dig 你的網域` 或 `dig 你的網域 CNAME`，看 **ANSWER SECTION** 是否已出現正確紀錄（詳見上方「驗證 DNS 設定（dig 測試）」）。

👉 在這段時間內，你可能會看到：

* 一下可以連
* 一下不能連
* GitHub 顯示驗證中

📌 這些都不是你做錯，而是還在等待。

### 7-6 建議實作順序（照做成功率最高）

1. 在 Cloudflare 建立 CNAME（先用灰雲）
2. 到 GitHub Pages 填入自訂網域
3. 等待 GitHub 顯示驗證成功
4. 耐心等待 DNS 傳播完成
5. 確認網站可正常連線
6. 回到 Cloudflare 視需要開啟 Proxy（橘雲）

### 7-7 為什麼有時候「一下成功、一下失敗」？

這不是系統壞掉，而是因為：

* DNS 查詢節點不同
* 瀏覽器快取不同
* Cloudflare 與 GitHub 驗證時間不同步

#### 📌 解法建議：

* 等 5～15 分鐘再重新整理
* 不要頻繁開關 Proxy
* 用無痕視窗測試
---


