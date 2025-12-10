# 範例一：日期格式標準化

## 📋 範例說明

這個範例展示如何使用 Code Node 將不同格式的日期轉換為標準格式，這是資料處理中非常常見的需求。

## 🎯 使用場景

當您從不同來源接收資料時，日期格式可能不一致：
- 訂單系統使用 `2024/03/15` 格式
- Excel 匯出可能是 `2024-03-15` 格式
- API 回傳可能是 ISO 8601 格式

您需要將這些格式統一，以便後續處理或儲存到資料庫。

## 為什麼需要 Code Node？

❌ **n8n Set Node 的限制**：
- 無法進行字串的正規表達式替換
- 無法使用 JavaScript 的日期處理函數

✅ **使用 Code Node 的優勢**：
- 靈活處理各種日期格式
- 可以同時輸出多種格式供不同用途
- 支援語系化的日期顯示

## 📦 工作流程結構

```
When clicking 'Execute workflow' → 模擬訂單資料 → 日期格式轉換 (Code)
```

### 節點說明

1. **When clicking 'Execute workflow'** (Manual Trigger)：手動觸發工作流程
2. **模擬訂單資料** (Set Node v3.4)：建立測試資料
   - `order_date`: "2024/03/15"
   - `customer_name`: "王小明"
   - `amount`: "1500"
3. **日期格式轉換** (Code Node)：執行日期格式轉換邏輯

## 💻 核心程式碼解析

```javascript
const items = $input.all();
const outputItems = [];

for (const item of items) {
  // 取得原始日期字串
  const orderDate = item.json.order_date;
  
  // 將 2024/03/15 轉換為 2024-03-15 (ISO 格式)
  const isoDate = orderDate.replace(/\//g, '-');
  
  // 建立輸出資料
  outputItems.push({
    json: {
      customer_name: item.json.customer_name,
      amount: item.json.amount,
      order_date_original: orderDate,
      order_date_iso: isoDate,
      formatted_date: new Date(isoDate).toLocaleDateString('zh-TW', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
      })
    }
  });
}

return outputItems;
```

### 🔑 程式碼重點說明

1. **`$input.all()`**：取得所有輸入項目
2. **`.replace(/\//g, '-')`**：使用正規表達式將所有斜線 `/` 替換為破折號 `-`
   - `/\//g` 是正規表達式，`g` 表示全域替換
3. **`new Date(isoDate)`**：將字串轉換為 JavaScript 日期物件
4. **`.toLocaleDateString('zh-TW', {...})`**：格式化為繁體中文日期顯示
5. **輸出多種格式**：同時保留原始格式、ISO 格式與在地化格式

## 🔍 預期輸出

```json
{
  "customer_name": "王小明",
  "amount": "1500",
  "order_date_original": "2024/03/15",
  "order_date_iso": "2024-03-15",
  "formatted_date": "2024/03/15"
}
```

## 🚀 如何使用

### 步驟一：匯入工作流程

1. 登入 n8n
2. 點擊「新增工作流程」
3. 點擊右上角「...」選單 → 「匯入自檔案」
4. 選擇 `example1_date_format.json`

### 步驟二：執行測試

1. 點擊畫面上方的「執行工作流程」按鈕（或點擊手動觸發節點後選擇「執行節點」）
2. 查看「日期格式轉換 (Code)」節點的輸出

### 步驟三：修改測試資料

您可以修改「模擬訂單資料」節點中的日期格式來測試不同情況：
- `2024/03/15`
- `2024-03-15`
- `2024.03.15`

## 💡 延伸練習

### 練習 1：處理多種輸入格式
修改程式碼，使其能自動辨識並處理以下格式：
- `2024/03/15`
- `2024-03-15`
- `03/15/2024`
- `15/03/2024`

**提示**：使用條件判斷檢查字串格式，然後套用對應的轉換邏輯。

### 練習 2：加入日期驗證
增加邏輯檢查日期是否有效：
- 月份是否在 1-12 之間
- 日期是否符合該月份的天數

### 練習 3：計算日期差
加入計算「距離今天幾天」的功能：
```javascript
const today = new Date();
const orderDate = new Date(isoDate);
const daysDiff = Math.floor((today - orderDate) / (1000 * 60 * 60 * 24));
```

## 🎓 學習重點

1. ✅ 理解 `$input.all()` 和 `item.json` 的使用
2. ✅ 掌握正規表達式 `.replace()` 的用法
3. ✅ 學會 JavaScript `Date` 物件的操作
4. ✅ 了解如何建構 Code Node 的輸出格式
5. ✅ 認識 `.toLocaleDateString()` 的語系化功能

---

**難度**: ⭐☆☆ (初級)  
**適用對象**: 初學者  
**預計學習時間**: 20-30 分鐘
