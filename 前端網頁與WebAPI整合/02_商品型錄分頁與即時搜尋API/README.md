# 🌐 前端網頁與 WebAPI 整合
## 範例 2：動態商品型錄分頁與即時搜尋 API（GET 查詢參數與防抖搜尋）

### 📚 工作流程說明

在現代電商與 SaaS 平台中，前端通常需要具備**即時關鍵字搜尋**、**分類標籤篩選**與**伺服器端分頁（Pagination）**功能。

本範例展示：
1. **前端即時搜尋與防抖**：前端網頁在用戶輸入文字時，採用 300ms 防抖（Debounce）機制，使用 `GET` 方法將 `search`、`category`、`page` 與 `limit` 查詢字串傳入 n8n。
2. **n8n 後端查詢與分頁運算**：Webhook 節點接收 Query 參數，後端進行條件比對與資料切片（Slice），動態計算總頁數與總筆數。
3. **動態渲染卡片**：透過 **Respond to Webhook 節點** 回傳結構化 JSON，前端即時更新商品網格與分頁按鈕狀態。

---

### 流程架構圖

```mermaid
flowchart LR
    A["👤 前端輸入關鍵字 / 切換分類 / 點擊下一頁"] -->|1. GET /catalog-search?search=ai&page=1| B["⚡ Webhook 節點 (GET)"]
    
    subgraph n8n_Backend_API["n8n 搜尋與分頁引擎"]
        C["🔍 解析 $json.query 參數 (Code 節點)"]
        D["🎯 執行分類篩選與關鍵字比對"]
        E["📊 伺服器端分頁切片與元數據計算"]
        F["📤 Respond to Webhook 回傳 JSON 陣列"]
    end
    
    B --> C --> D --> E --> F
    F -->|2. 回傳 { success, data, pagination }| G["📱 前端動態更新商品卡片與分頁列"]
```

---

### 工作流程與前端檔案下載

- [📥 n8n WebAPI 工作流程樣版 (02_catalog_search_api_workflow.json)](./02_catalog_search_api_workflow.json)
- [💻 前端商品型錄網頁原始碼 (website/index.html)](./website/index.html)

---

#### 📋 節點詳細說明

1. **📝 流程說明（Sticky Note）**
   - **功能**：介紹 RESTful API 的 `GET` 方法與 URL Query Parameters (`$json.query`) 的讀取。

2. **⚡ 接收 GET 搜尋與分頁請求（Webhook Node）**
   - **HTTP Method**：`GET`
   - **Path**：`catalog-search`
   - **Response Mode**：`Using 'Respond to Webhook' Node`

3. **🔍 篩選搜尋與分頁運算（Code Node）**
   - **讀取參數**：`$json.query.search`、`$json.query.category`、`$json.query.page`、`$json.query.limit`。
   - **分頁邏輯**：`filtered.slice((page - 1) * limit, page * limit)`。

4. **📤 回傳商品資料給前端（Respond to Webhook Node）**
   - **回傳內容**：包含 `data`（當前頁面商品清單）與 `pagination`（`page`, `limit`, `totalPages`, `totalItems`）。

---

#### 🧪 測試與驗證方法

1. **瀏覽器介面測試**：
   - 開啟 `website/index.html`，輸入 n8n Webhook 網址。
   - 在搜尋框輸入「AI」，觀察網格是否立即過濾出「AI 智慧客服機器人」與「多代理協作系統」。
   - 點擊「上一頁 / 下一頁」測試分頁切換。

2. **瀏覽器直接輸入 URL 測試**：
   ```text
   http://localhost:5678/webhook/catalog-search?category=database&page=1&limit=2
   ```

---

#### 🎯 學習重點

- **GET 請求與 Query String**：理解前端使用 `new URLSearchParams()` 組裝參數，後端在 n8n 中使用 `$json.query.xxx` 存取。
- **前端防抖 (Debounce) 技術**：避免使用者每打一個字就發送一次請求，大幅減輕 n8n 伺服器負載。

---

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 將商品資料來源改為從 Supabase `products` 資料表動態 SQL 查詢。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我將「商品型錄搜尋 API」的資料來源改接 Supabase 資料庫：
1. 接收前端傳入的 search 與 category 參數。
2. 串接 Postgres 節點執行 SQL：SELECT * FROM products WHERE (category = $1 OR $1 = 'all') AND (name ILIKE '%' || $2 || '%') ORDER BY id DESC LIMIT $3 OFFSET $4;
3. 額外執行 COUNT 查詢計算總筆數。
4. 組裝分頁資料並透過 Respond to Webhook 回傳給前端。
請幫我配置好 SQL 語句與節點連線！
```
</details>
