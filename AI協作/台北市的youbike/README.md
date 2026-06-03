# 台北市 YouBike 低車輛站點自動記錄

## 功能說明

每次手動執行時，自動從台北市政府開放資料取得所有 YouBike 2.0 站點即時資訊，篩選出**可借或可還車輛數不足 3 輛**的低車輛站點，並依照執行日期自動寫入 Google Sheets，方便追蹤各站點的供車狀況。

---

## Workflow 流程圖

```
手動觸發
  ↓
取得台北市 YouBike 即時資料（HTTP Request）
  ↓
欄位繁體中文化（Set）
  ↓
過濾低車輛站點（Filter：可借 < 3 或 可還 < 3）
  ↓
彙整為一筆（Aggregate）
  ↓
┌─────────────────────────────────────┐
搜尋今天試算表（Google Drive）      整理搜尋結果（Code）
└─────────────────────────────────────┘
  ↓
判斷是否存在（IF）
  ├─ 存在 → 新增 Sheet 至現有試算表 → 展開站點 → 寫入資料（現有）
  └─ 不存在 → 建立新試算表 → 展開站點 → 寫入資料（新建）
```

---

## 節點說明

| 節點名稱 | 類型 | 說明 |
|----------|------|------|
| When clicking 'Execute workflow' | Manual Trigger | 手動執行觸發點 |
| 取得台北市youbike資料 | HTTP Request | GET `https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json` |
| 欄位繁體中文化 | Set | 將原始英文欄位對應為中文欄位名稱 |
| 過濾低車輛站點 | Filter | 可借車輛數 < 3 **或** 可還車輛數 < 3 |
| 彙整為一筆 | Aggregate | 將所有站點合併為單一陣列 `站點清單` |
| 搜尋今天試算表 | Google Drive | 搜尋 Google Drive 中是否有今天日期的試算表 |
| 整理搜尋結果 | Code | 判斷搜尋結果，回傳 `{ id, name, exists }` |
| 判斷是否存在 | IF | 依 `exists` 欄位分流 |
| 新增Sheet至現有試算表 | Google Sheets | 在既有試算表新增以時間命名的 Sheet |
| 建立新試算表 | Google Sheets | 建立新試算表，名稱為 `yyyy-MM-dd_youbike低車輛站點` |
| 展開站點（現有/新建） | Code | 將彙整陣列展開為多筆資料 |
| 寫入資料（現有/新建） | Google Sheets | Append 寫入所有篩選站點資料 |

---

## 資料欄位對應

| 中文欄位 | 原始欄位 | 說明 |
|----------|----------|------|
| 站點編號 | sno | 站點唯一識別碼 |
| 站點名稱 | sna | 站點中文名稱 |
| 區域 | sarea | 所在行政區 |
| 時間 | mday | 資料更新時間 |
| 地址 | ar | 站點地址 |
| 站點狀況 | act | 站點是否啟用（1=啟用） |
| 總停車格數 | Quantity | 站點總格數 |
| 可借車輛數 | available_rent_bikes | 目前可借台數 |
| 可還車輛數 | available_return_bikes | 目前可還空格數 |

---

## Google Sheets 命名規則

- **試算表名稱**：`yyyy-MM-dd_youbike低車輛站點`（例：`2026-06-04_youbike低車輛站點`）
- **Sheet 名稱**：`HH-mm-ss`（例：`09-30-00`）
- 同一天多次執行會在同一試算表內新增不同時間的 Sheet

---

## 給 AI 的 Prompt 範本

將以下 prompt 提供給 Claude（已連接 n8n Connector），即可自動建立此 workflow：

```
請幫我在 n8n 建立一個 workflow，功能如下：

1. 手動觸發
2. 用 HTTP Request GET 取得台北市 YouBike 2.0 即時資料：
   https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json
3. 用 Set 節點將欄位改為繁體中文：
   sno→站點編號、sna→站點名稱、sarea→區域、mday→時間、ar→地址、
   act→站點狀況、Quantity→總停車格數、available_rent_bikes→可借車輛數、
   available_return_bikes→可還車輛數
4. 用 Filter 過濾出「可借車輛數 < 3 或 可還車輛數 < 3」的站點
5. 用 Aggregate 節點將所有站點彙整為一筆，欄位名稱為「站點清單」
6. 同時：
   a. 用 Google Drive 節點搜尋今天日期命名的試算表（格式：yyyy-MM-dd_youbike低車輛站點）
   b. 用 Code 節點整理搜尋結果，回傳 { id, name, exists }
7. 用 IF 節點判斷試算表是否存在：
   - 存在：用 Google Sheets 新增一個以當前時間（HH-mm-ss）命名的 Sheet，再展開站點清單並 Append 寫入
   - 不存在：用 Google Sheets 建立新試算表（名稱：yyyy-MM-dd_youbike低車輛站點），Sheet 名稱為當前時間，再展開站點清單並 Append 寫入
```
