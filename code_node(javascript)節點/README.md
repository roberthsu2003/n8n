# n8n Low Code 平台中為什麼仍需要學習 Node.js Code

## 課程說明

雖然 n8n 是一個 Low Code 平台,提供了視覺化的節點來建立工作流程,但在某些情況下,使用 Node.js Code 可以讓您:
- ✅ 處理複雜的資料轉換邏輯
- ✅ 實現多條件判斷和分類
- ✅ 進行陣列、物件的進階操作
- ✅ 撰寫可重複使用的邏輯
- ✅ 提升工作流程的效率和可讀性

---

## 🔑 n8n Code Node 重要變數

### 輸入資料變數
```javascript
$input.all()      // 取得所有輸入項目的陣列
$input.first()    // 取得第一個項目
$input.last()     // 取得最後一個項目
$input.item       // 取得當前處理的項目
item.json         // 該項目的 JSON 資料
item.binary       // 該項目的二進位資料(檔案)
```

### 快捷變數
```javascript
$json             // 等同於 $input.item.json
$binary           // 等同於 $input.item.binary
```

### 其他有用變數
```javascript
$node             // 當前節點的資訊
$workflow         // Workflow 的資訊
$execution        // 執行的資訊
```

### 輸出格式
```javascript
// 單一項目
return { json: {...} }

// 多個項目
return [
  { json: {...} },
  { json: {...} }
]
```

---

## 實作範例導覽

本教學提供三個完整的實作範例，從初級到進階，幫助您循序漸進掌握 Code Node：

### [⭐ 範例一：將日期格式標準化](./將日期格式標準化/README.md)
**難度**: 初級 | **學習時間**: 20-30 分鐘

學習如何使用正規表達式和 JavaScript Date 物件處理日期格式轉換。

**⚠️ 重點注意**：
- 理解 `$input.all()` 和 `item.json` 的使用方式
- 掌握 `.replace(/\//g, '-')` 正規表達式的全域替換
- 學會建構正確的 Code Node 輸出格式 `{ json: {...} }`

---

### [⭐⭐ 範例二：根據多個條件分類資料](./根據多個條件分類資料/README.md)
**難度**: 中級 | **學習時間**: 40-60 分鐘

實作複雜的客戶分級邏輯，包含多重條件判斷與動態標籤生成。

**⚠️ 重點注意**：
- 使用 `&&` (AND) 和 `||` (OR) 組合多個條件
- 使用陣列 `.push()` 動態建立標籤列表
- **避免除以零**：使用三元運算子 `data.total_orders > 0 ? ... : 0`
- 使用 `.join(', ')` 將陣列轉為字串輸出

---

### [⭐⭐⭐ 範例三：陣列操作與資料重組](./陣列操作與資料重組/README.md)
**難度**: 進階 | **學習時間**: 60-90 分鐘

將扁平化交易資料重組為多維度統計報表，展示進階陣列與物件操作技巧。

**⚠️ 重點注意**：
- **動態物件分組**：使用 `if (!obj[key])` 檢查鍵是否存在
- **複製陣列再排序**：使用 `[...array]` 避免修改原始資料
- 理解 `Object.values()` 將物件轉為陣列的用途
- 掌握 `.reduce()` 累加計算和 `.forEach()` 遍歷的差異
- 學會建構巢狀的 JSON 報表結構

---

## ⚡ 通用注意事項

在所有範例中，請特別注意以下幾點：

1. **輸出格式必須正確**
   ```javascript
   // ✅ 正確：使用 json 屬性包裝
   return { json: { name: "測試" } }
   
   // ❌ 錯誤：直接回傳物件
   return { name: "測試" }
   ```

2. **處理空值或未定義的資料**
   ```javascript
   // ✅ 安全做法
   const value = item.json.field || '預設值';
   const count = data.items?.length || 0;
   ```

3. **使用 console.log() 除錯**
   ```javascript
   console.log('當前資料:', item.json);  // 會顯示在 n8n 執行記錄中
   ```

4. **避免修改原始陣列**
   ```javascript
   // ✅ 正確：先複製再排序
   const sorted = [...array].sort();
   
   // ❌ 錯誤：直接修改原陣列
   const sorted = array.sort();
   ```

---

## �📚 範例一:簡單資料轉換(日期格式標準化)

### 使用場景
當您收到的日期格式是 `2024/03/15`,但需要轉換成標準的 ISO 格式 `2024-03-15`

### 為什麼需要 Code?
- ❌ n8n 的 Set Node 無法做字串替換
- ❌ 沒有內建的日期格式轉換節點可處理多種格式
- ✅ 使用 Code 可以靈活處理各種日期格式

### 程式碼重點
```javascript
const items = $input.all();
const outputItems = [];

for (const item of items) {
  const orderDate = item.json.order_date;
  
  // 字串替換:將 / 替換成 -
  const isoDate = orderDate.replace(/\//g, '-');
  
  // 使用 JavaScript 內建的日期物件格式化
  const formattedDate = new Date(isoDate).toLocaleDateString('zh-TW', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  });
  
  outputItems.push({
    json: {
      customer_name: item.json.customer_name,
      amount: item.json.amount,
      order_date_original: orderDate,
      order_date_iso: isoDate,
      formatted_date: formattedDate
    }
  });
}

return outputItems;
```

### 學習重點
1. 使用 `$input.all()` 取得所有輸入資料
2. 使用迴圈處理每一個項目
3. 字串操作:`.replace()` 方法
4. JavaScript 日期物件的使用
5. 建構輸出陣列的格式

---

## 📚 範例二:中等複雜度(客戶分級與標籤)

### 使用場景
根據客戶的訂單數量、消費金額、最後訂單時間等多個條件,自動分級並貼上標籤

### 為什麼需要 Code?
- ❌ IF Node 只能處理簡單的單一條件判斷
- ❌ 需要多個 IF Node 串接,工作流程會變得複雜且難以維護
- ❌ 無法動態生成標籤陣列
- ✅ 使用 Code 可以在一個節點內完成所有邏輯

### 程式碼重點
```javascript
const items = $input.all();
const results = [];

for (const item of items) {
  const data = item.json;
  
  let customerLevel = '';
  let tags = [];
  let discount = 0;
  
  // 多重條件判斷
  if (data.total_amount >= 100000 && data.total_orders >= 20) {
    customerLevel = 'VIP';
    discount = 15;
    tags.push('高價值客戶');
  } else if (data.total_amount >= 50000 || data.total_orders >= 10) {
    customerLevel = '黃金會員';
    discount = 10;
    tags.push('重要客戶');
  } else if (data.total_orders >= 5) {
    customerLevel = '銀牌會員';
    discount = 5;
    tags.push('活躍客戶');
  } else {
    customerLevel = '一般會員';
    discount = 0;
  }
  
  // 根據活躍度添加標籤
  if (data.days_since_last_order <= 7) {
    tags.push('高度活躍');
  } else if (data.days_since_last_order <= 30) {
    tags.push('活躍');
  } else if (data.days_since_last_order <= 90) {
    tags.push('需關注');
  } else {
    tags.push('流失風險');
  }
  
  // 計算平均訂單金額
  const avgOrderAmount = data.total_orders > 0 
    ? Math.round(data.total_amount / data.total_orders) 
    : 0;
  
  if (avgOrderAmount >= 5000) {
    tags.push('高單價客戶');
  }
  
  results.push({
    json: {
      customer_id: data.customer_id,
      customer_name: data.customer_name,
      level: customerLevel,
      discount_rate: discount,
      tags: tags.join(', '),
      avg_order_amount: avgOrderAmount
    }
  });
}

return results;
```

### 學習重點
1. 複雜的 if-else 邏輯判斷
2. 使用陣列 `.push()` 動態添加標籤
3. 使用 `.join()` 將陣列轉換為字串
4. 計算平均值並處理除以零的情況
5. 組合多個條件進行判斷(`&&` 和 `||` 運算子)

---

## 📚 範例三:進階(銷售報表資料重組)

### 使用場景
將多筆交易記錄,重新組織成按區域、類別、日期分組的統計報表

### 為什麼需要 Code?
- ❌ n8n 內建的 Aggregate Node 功能有限,無法做複雜分組
- ❌ 需要同時產生多種統計維度(區域、類別、日期)
- ❌ 需要計算最大值、最小值、平均值等多種指標
- ✅ 使用 Code 可以一次完成所有資料重組和統計

### 程式碼重點
```javascript
const item = $input.first();
const transactions = JSON.parse(item.json.transactions);

// 1. 按區域統計
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

// 2. 按類別統計
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

// 3. 找出最高和最低金額
const sortedTransactions = [...transactions].sort((a, b) => b.amount - a.amount);
const topTransaction = sortedTransactions[0];
const lowestTransaction = sortedTransactions[sortedTransactions.length - 1];

// 4. 按日期分組
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

// 組合報表
return {
  json: {
    summary: {
      total_transactions: transactions.length,
      total_amount: transactions.reduce((sum, t) => sum + t.amount, 0)
    },
    by_region: Object.values(regionStats),
    by_category: Object.values(categoryStats),
    daily_breakdown: Object.values(dailyStats),
    highlights: {
      highest_transaction: topTransaction,
      lowest_transaction: lowestTransaction
    }
  }
};
```

### 學習重點
1. 使用物件作為動態鍵值對來分組資料
2. `.forEach()` 遍歷陣列
3. `.reduce()` 計算總和
4. `.sort()` 排序陣列
5. `Object.values()` 將物件轉換為陣列
6. 展開運算子 `[...array]` 複製陣列
7. 巢狀資料結構的建立和操作

---

## 💡 總結:何時應該使用 Code Node?

### ✅ 應該使用 Code 的情況
1. **複雜條件判斷**:需要多個 if-else 或巢狀條件
2. **陣列操作**:過濾、映射、分組、排序
3. **資料重組**:將扁平資料轉換為巢狀結構,或反之
4. **字串處理**:格式化、替換、拆分、組合
5. **數學計算**:統計、平均、累加、百分比
6. **動態邏輯**:根據資料動態決定處理方式

### ❌ 不需要使用 Code 的情況
1. **簡單的資料設定**:使用 Set Node 即可
2. **基本的條件分流**:使用 IF Node 或 Switch Node
3. **HTTP 請求**:使用 HTTP Request Node
4. **資料庫操作**:使用對應的資料庫 Node

---

## 🎯 給學生的建議

1. **先理解 Low Code 的限制**:當您發現需要很多節點才能完成一個簡單邏輯時,考慮使用 Code
2. **學習 JavaScript 基礎**:變數、迴圈、條件、陣列、物件操作
3. **善用 console.log()**:在開發時用來除錯
4. **參考官方文件**:n8n 提供很多 Code 範例
5. **逐步進階**:從簡單的資料轉換開始,慢慢學習更複雜的操作

記住:Low Code 是為了提高效率,但 Code 是為了提供彈性。兩者結合,才能發揮 n8n 的最大價值!
