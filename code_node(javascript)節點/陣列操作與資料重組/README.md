# 範例三：銷售報表資料重組

## 📋 範例說明

這個進階範例展示如何使用 Code Node 將多筆交易記錄重新組織成多維度的統計報表，包括區域統計、類別分析、日期分組和亮點摘要。

## 🎯 使用場景

在商業分析中，原始交易資料通常是扁平化的記錄，但管理者需要從不同角度檢視數據：
- **按區域**：北中南各區的銷售表現
- **按類別**：3C 產品、傢俱等類別的業績
- **按日期**：每日銷售趨勢
- **關鍵指標**：最高/最低交易、平均值等

這種多維度的資料重組，若使用 n8n 內建節點會非常複雜，Code Node 可以一次完成所有處理。

## 為什麼需要 Code Node？

❌ **使用內建節點的限制**：
- Aggregate Node 功能有限，無法做複雜分組
- 需要多個節點分別處理不同維度
- 無法同時計算多種統計指標
- 難以產生巢狀的報表結構

✅ **使用 Code Node 的優勢**：
- 一次處理所有統計需求
- 同時產生多種分組維度
- 靈活運用 JavaScript 陣列和物件操作
- 輸出結構化的完整報表

## 📦 工作流程結構

```
開始 → 交易資料 → 銷售報表分析 (Code)
```

### 節點說明

1. **開始**：觸發工作流程
2. **交易資料** (Set Node)：建立測試交易記錄
   ```json
   [
     {"product":"筆記型電腦","category":"3C產品","amount":35000,"date":"2024-03-01","region":"北區"},
     {"product":"滑鼠","category":"3C產品","amount":500,"date":"2024-03-01","region":"北區"},
     {"product":"鍵盤","category":"3C產品","amount":1200,"date":"2024-03-02","region":"南區"},
     {"product":"顯示器","category":"3C產品","amount":8000,"date":"2024-03-02","region":"北區"},
     {"product":"辦公椅","category":"傢俱","amount":4500,"date":"2024-03-01","region":"中區"}
   ]
   ```
3. **銷售報表分析** (Code Node)：執行多維度統計

## 💻 核心程式碼解析

### 完整程式碼結構

```javascript
const item = $input.first();
const transactions = JSON.parse(item.json.transactions);

// === 1. 按區域統計 ===
const regionStats = {};
transactions.forEach(t => {
  if (!regionStats[t.region]) {
    regionStats[t.region] = {
      region: t.region,
      total_amount: 0,
      transaction_count: 0,
      products: []
    };
  }
  regionStats[t.region].total_amount += t.amount;
  regionStats[t.region].transaction_count += 1;
  regionStats[t.region].products.push(t.product);
});

// === 2. 按類別統計 ===
const categoryStats = {};
transactions.forEach(t => {
  if (!categoryStats[t.category]) {
    categoryStats[t.category] = {
      category: t.category,
      total_amount: 0,
      items: []
    };
  }
  categoryStats[t.category].total_amount += t.amount;
  categoryStats[t.category].items.push({
    product: t.product,
    amount: t.amount
  });
});

// 計算平均值
Object.values(categoryStats).forEach(cat => {
  cat.avg_amount = Math.round(cat.total_amount / cat.items.length);
});

// === 3. 找出最高和最低金額的交易 ===
const sortedTransactions = [...transactions].sort((a, b) => b.amount - a.amount);
const topTransaction = sortedTransactions[0];
const lowestTransaction = sortedTransactions[sortedTransactions.length - 1];

// === 4. 按日期分組 ===
const dailyStats = {};
transactions.forEach(t => {
  if (!dailyStats[t.date]) {
    dailyStats[t.date] = {
      date: t.date,
      daily_total: 0,
      transaction_count: 0
    };
  }
  dailyStats[t.date].daily_total += t.amount;
  dailyStats[t.date].transaction_count += 1;
});

// === 5. 計算整體統計 ===
const totalAmount = transactions.reduce((sum, t) => sum + t.amount, 0);
const avgTransaction = Math.round(totalAmount / transactions.length);

// === 組合最終報表 ===
return {
  json: {
    report_date: new Date().toISOString(),
    summary: {
      total_transactions: transactions.length,
      total_amount: totalAmount,
      avg_transaction: avgTransaction
    },
    by_region: Object.values(regionStats),
    by_category: Object.values(categoryStats),
    daily_breakdown: Object.values(dailyStats),
    highlights: {
      highest_transaction: topTransaction,
      lowest_transaction: lowestTransaction
    },
    raw_transactions: transactions
  }
};
```

### 🔑 關鍵技術說明

#### 1. 動態物件分組
```javascript
const regionStats = {};
if (!regionStats[t.region]) {
  regionStats[t.region] = { ... };
}
```
- 使用物件作為鍵值對儲存分組資料
- 動態檢查鍵是否存在，不存在則初始化

#### 2. forEach 遍歷與累加
```javascript
transactions.forEach(t => {
  regionStats[t.region].total_amount += t.amount;
});
```
- `.forEach()` 遍歷陣列的每個元素
- 使用 `+=` 累加數值

#### 3. Object.values() 轉換
```javascript
Object.values(regionStats)
```
- 將物件轉換為陣列，方便輸出和進一步處理

#### 4. 陣列排序
```javascript
const sortedTransactions = [...transactions].sort((a, b) => b.amount - a.amount);
```
- `[...transactions]` 使用展開運算子複製陣列（避免修改原始資料）
- `.sort()` 依據金額降序排列

#### 5. reduce 累加計算
```javascript
const totalAmount = transactions.reduce((sum, t) => sum + t.amount, 0);
```
- `.reduce()` 將陣列簡化為單一值
- `0` 是初始值

## 🔍 預期輸出

```json
{
  "report_date": "2024-12-10T06:25:40.000Z",
  "summary": {
    "total_transactions": 5,
    "total_amount": 49200,
    "avg_transaction": 9840
  },
  "by_region": [
    {
      "region": "北區",
      "total": 43500,
      "count": 3,
      "avg": 14500,
      "products": "筆記型電腦, 滑鼠, 顯示器"
    },
    {
      "region": "南區",
      "total": 1200,
      "count": 1,
      "avg": 1200,
      "products": "鍵盤"
    },
    {
      "region": "中區",
      "total": 4500,
      "count": 1,
      "avg": 4500,
      "products": "辦公椅"
    }
  ],
  "by_category": [
    {
      "category": "3C產品",
      "total_amount": 44700,
      "avg_amount": 11175,
      "items": [...]
    },
    {
      "category": "傢俱",
      "total_amount": 4500,
      "avg_amount": 4500,
      "items": [...]
    }
  ],
  "daily_breakdown": [
    {
      "date": "2024-03-01",
      "daily_total": 40000,
      "transaction_count": 3
    },
    {
      "date": "2024-03-02",
      "daily_total": 9200,
      "transaction_count": 2
    }
  ],
  "highlights": {
    "highest_transaction": {
      "product": "筆記型電腦",
      "amount": 35000,
      "region": "北區"
    },
    "lowest_transaction": {
      "product": "滑鼠",
      "amount": 500,
      "region": "北區"
    }
  }
}
```

## 🚀 如何使用

### 步驟一：匯入工作流程

1. 登入 n8n
2. 點擊「新增工作流程」
3. 點擊右上角「...」選單 → 「匯入自檔案」
4. 選擇 `example3_sales_report.json`

### 步驟二：執行測試

1. 點擊「執行工作流程」
2. 查看「銷售報表分析 (Code)」節點的輸出
3. 展開各個統計維度查看結果

### 步驟三：修改資料測試

在「交易資料」節點中加入更多測試資料，觀察報表變化：
- 新增不同區域的交易
- 新增不同類別的商品
- 修改金額觀察最高/最低交易變化

## 💡 延伸練習

### 練習 1：加入時間段分析
將交易按「上午」「下午」「晚上」分組統計：
```javascript
const hour = new Date(t.date).getHours();
const timeSlot = hour < 12 ? '上午' : hour < 18 ? '下午' : '晚上';
```

### 練習 2：計算成長率
如果有歷史資料，計算每日成長率：
```javascript
const growthRate = ((today - yesterday) / yesterday * 100).toFixed(2);
```

### 練習 3：產品排行榜
建立「最暢銷商品 Top 5」：
```javascript
const productSales = {};
transactions.forEach(t => {
  productSales[t.product] = (productSales[t.product] || 0) + t.amount;
});
const top5 = Object.entries(productSales)
  .sort((a, b) => b[1] - a[1])
  .slice(0, 5);
```

### 練習 4：整合視覺化
將報表資料傳送到 Google Sheets 或建立圖表：
- 使用 Google Sheets 節點寫入分頁
- 每個維度一個分頁
- 使用 Chart.js 產生視覺化圖表

## 🎓 學習重點

1. ✅ 掌握物件作為動態鍵值對的使用
2. ✅ 理解 `.forEach()` 陣列遍歷
3. ✅ 學會 `.reduce()` 累加計算
4. ✅ 掌握 `.sort()` 陣列排序
5. ✅ 理解 `Object.values()` 物件轉陣列
6. ✅ 學會展開運算子 `[...]` 複製陣列
7. ✅ 理解巢狀資料結構的建立

## 🤔 進階思考

1. 如果交易記錄有千萬筆，這個程式碼的效能如何？可以如何優化？
2. 如何處理資料中的異常值（例如負數金額）？
3. 如果需要即時更新報表，應該如何設計 workflow？
4. 這個報表可以如何自動化發送給主管（例如每日早上 9 點）？

## 📊 實際應用場景

這個範例可以應用在：
- 📈 **電商平台**：每日銷售報表
- 🏪 **零售業**：門市業績分析
- 📦 **物流業**：配送區域統計
- 💼 **服務業**：客戶消費分析
- 🎯 **行銷部門**：活動成效追蹤

---

**難度**: ⭐⭐⭐ (進階)  
**適用對象**: 熟悉 JavaScript 的學生  
**預計學習時間**: 60-90 分鐘  
**前置知識**: 需理解陣列、物件、函數等 JavaScript 基礎概念
