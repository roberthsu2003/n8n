# n8n Code Node 執行機制與全域變數詳解

> 📖 **目標讀者**：有程式基礎的開發者，想深入理解 n8n Code Node 的底層運作機制

---

## 🎯 核心問題

當你在 n8n 的 Code Node 中寫下這段程式碼：

```javascript
const data = $input.all();
const current = $json;
return { json: { result: 'ok' } };
```

你是否想過：
- ❓ `$input` 和 `$json` 到底是什麼？
- ❓ 它們從哪裡來的？
- ❓ 為什麼可以直接使用而不需要 `import` 或 `require`？
- ❓ n8n 是如何處理迴圈的？

---

## 1️⃣ 全域變數的本質：Runtime 注入

### 什麼是 Runtime 注入？

n8n 在執行你的程式碼之前，會先建立一個**執行環境（Execution Context）**，並將預先準備好的物件**注入**到這個環境中。

### 簡化的執行流程

```javascript
// 這是 n8n 內部執行邏輯的簡化版本（概念示意）
class CodeNodeExecutor {
  execute(userCode, inputItems, nodeInfo) {
    // 1. 準備全域變數
    const globalContext = this.createContext(inputItems, nodeInfo);
    
    // 2. 在沙盒環境中執行使用者程式碼
    const result = this.runInSandbox(userCode, globalContext);
    
    // 3. 回傳結果
    return result;
  }
  
  createContext(inputItems, nodeInfo) {
    // 建立 $input 物件
    const $input = {
      all: () => inputItems,
      first: () => inputItems[0] || { json: {}, binary: {} },
      last: () => inputItems[inputItems.length - 1] || { json: {}, binary: {} },
      item: inputItems[0] || { json: {}, binary: {} }
    };
    
    // 快捷變數
    const $json = inputItems[0]?.json || {};
    const $binary = inputItems[0]?.binary || {};
    
    // 節點資訊
    const $node = nodeInfo;
    
    return {
      $input,
      $json,
      $binary,
      $node,
      console,  // 允許使用 console.log
      // ... 其他全域變數
    };
  }
  
  runInSandbox(code, context) {
    // 使用 vm 模組或類似機制執行程式碼
    const vm = require('vm');
    return vm.runInNewContext(code, context, {
      timeout: 60000  // 60 秒逾時
    });
  }
}
```

### 類似的概念

這種模式在其他框架中也很常見：

| 框架/環境 | 注入的全域變數 | 用途 |
|----------|--------------|------|
| 瀏覽器 | `window`, `document`, `console` | DOM 操作與除錯 |
| Node.js | `process`, `__dirname`, `require` | 環境資訊與模組載入 |
| Jest | `describe`, `it`, `expect` | 測試框架 |
| Webpack | `process.env.NODE_ENV` | 環境變數 |
| n8n | `$input`, `$json`, `$node` | 工作流程資料存取 |

---

## 2️⃣ `$input` 物件完整解析

### 物件結構

```typescript
interface InputObject {
  // 方法
  all: () => INodeExecutionData[];      // 取得所有項目的陣列
  first: () => INodeExecutionData;      // 取得第一個項目
  last: () => INodeExecutionData;       // 取得最後一個項目
  
  // 屬性
  item: INodeExecutionData;             // 當前處理的項目
}

interface INodeExecutionData {
  json: any;                            // JSON 資料物件
  binary?: {                            // 二進位資料（可選）
    [key: string]: IBinaryData;
  };
  pairedItem?: {                        // 配對項目資訊（追蹤來源）
    item: number;
    input?: number;
  };
}
```

### 方法詳解

#### `$input.all()`

```javascript
// 回傳所有輸入項目的陣列
const items = $input.all(); // Type: INodeExecutionData[](類似Array型別)

// 實際回傳的結構
[
  {
    json: { name: "Alice", age: 30 },
    binary: {}
  },
  {
    json: { name: "Bob", age: 25 },
    binary: {}
  },
  {
    json: { name: "Charlie", age: 35 },
    binary: {}
  }
]

// 使用情境：需要處理所有項目時
console.log(`共有 ${items.length} 個項目`);
```

#### `$input.first()`

```javascript
// 回傳第一個項目
const firstItem = $input.first(); // Type: INodeExecutionData(類似Object型別)

// 相當於
const firstItem = $input.all()[0];

// 回傳結構
{
  json: { name: "Alice", age: 30 },
  binary: {}
}

// 使用情境：只需要第一筆資料（例如讀取配置）
const config = $input.first().json;
```

#### `$input.last()`

```javascript
// 回傳最後一個項目
const lastItem = $input.last(); // Type: INodeExecutionData(類似Object型別) 

// 相當於
const items = $input.all();
const lastItem = items[items.length - 1];

// 使用情境：取得最新的一筆資料
const latestRecord = $input.last().json;
```

#### `$input.item`

```javascript
// 這是一個屬性，不是方法
const currentItem = $input.item;

// 在 "Run Once for All Items" 模式下：預設是第一個項目
// 在 "Run Once for Each Item" 模式下：是當前迭代的項目

// 使用情境：處理單一項目
const data = $input.item.json;
```

---

## 3️⃣ `$json` 和 `$binary` 快捷變數

### 它們是什麼？

```javascript
// $json 是 $input.item.json 的快捷方式
const $json = $input.item.json;

// $binary 是 $input.item.binary 的快捷方式
const $binary = $input.item.binary;
```

### 為什麼需要快捷變數？

```javascript
// ❌ 沒有快捷變數時（較冗長）
const name = $input.item.json.name;
const age = $input.item.json.age;

// ✅ 使用快捷變數（更簡潔）
const name = $json.name;
const age = $json.age;
```

### 注意事項

```javascript
// ⚠️ 這些是快照（snapshot），不是引用
$json.name = "New Name";  // 修改 $json
// 這不會影響 $input.item.json，因為它們是獨立的物件

// ✅ 正確的做法：使用解構或複製
const data = { ...$json, name: "New Name" };
return { json: data };
```

---

## 4️⃣ n8n 的兩種執行模式

### 模式一：Run Once for All Items（預設）

**n8n 不會執行迴圈**，你的程式碼只執行**一次**，你需要自己處理陣列。

```javascript
// 你的程式碼只會被呼叫一次
const items = $input.all();  // 取得所有項目（陣列）

// 你需要自己寫迴圈處理每個項目
const results = [];
for (const item of items) {
  results.push({
    json: {
      name: item.json.name,
      processed: true
    }
  });
}

return results;  // 回傳處理後的陣列
```

**執行流程**：

```
上一個節點傳入 3 個項目
         ↓
    [Item1, Item2, Item3]
         ↓
  你的程式碼執行「一次」
         ↓
處理所有項目並回傳結果
         ↓
    [Result1, Result2, Result3]
```

### 模式二：Run Once for Each Item

**n8n 會執行迴圈**，你的程式碼會被呼叫**多次**（每個項目一次）。

```javascript
// n8n 會對每個項目執行一次這段程式碼
// 所以你不需要寫迴圈

const name = $json.name;  // 當前項目的資料

return {
  json: {
    name: name,
    processed: true
  }
};
```

**執行流程**：

```
上一個節點傳入 3 個項目
         ↓
    [Item1, Item2, Item3]
         ↓
   n8n 自動執行迴圈
         ↓
你的程式碼執行 3 次：
  第1次: 處理 Item1 → Result1
  第2次: 處理 Item2 → Result2
  第3次: 處理 Item3 → Result3
         ↓
    [Result1, Result2, Result3]
```

### 兩種模式的比較

| 項目 | Run Once for All Items | Run Once for Each Item |
|------|------------------------|------------------------|
| 執行次數 | 1 次 | N 次（N = 項目數量） |
| `$input.all()` | 所有項目的陣列 | 所有項目的陣列 |
| `$json` | 第一個項目的 json | 當前項目的 json |
| 何時使用 | 需要處理整個陣列（統計、分組） | 每個項目獨立處理 |
| 效能 | 較快（只執行一次） | 較慢（多次執行） |

### 選擇建議

```javascript
// ✅ 使用 "Run Once for All Items" 的情境
// 1. 需要統計所有項目
const total = $input.all().reduce((sum, item) => sum + item.json.amount, 0);

// 2. 需要分組
const grouped = {};
$input.all().forEach(item => {
  const key = item.json.category;
  if (!grouped[key]) grouped[key] = [];
  grouped[key].push(item.json);
});

// 3. 需要排序
const sorted = [...$input.all()].sort((a, b) => a.json.date - b.json.date);

// ✅ 使用 "Run Once for Each Item" 的情境
// 1. 簡單的資料轉換（每個項目互相獨立）
return {
  json: {
    fullName: `${$json.firstName} ${$json.lastName}`,
    email: $json.email.toLowerCase()
  }
};

// 2. 每個項目需要呼叫 API（會在每次迭代中執行）
// 注意：這種情況通常應該用 HTTP Request Node，這裡只是示意
```

---

## 5️⃣ 其他全域變數

### `$node` 物件

```javascript
// 當前節點的資訊
const $node = {
  name: "Code Node 1",          // 節點名稱
  id: "abc123",                 // 節點 ID
  type: "n8n-nodes-base.code",  // 節點類型
  typeVersion: 2                // 版本
};

// 使用情境：除錯或記錄
console.log(`執行節點: ${$node.name}`);
```

### `$workflow` 物件

```javascript
// Workflow 的資訊
const $workflow = {
  id: "workflow123",
  name: "我的工作流程",
  active: true
};
```

### `$execution` 物件

```javascript
// 當前執行的資訊
const $execution = {
  id: "exec456",
  mode: "manual",  // 或 "trigger", "webhook" 等
  resumeUrl: "..."
};
```

---

## 6️⃣ 實際範例：深入理解

### 範例 1：Run Once for All Items

```javascript
// 情境：計算所有訂單的統計資料
const items = $input.all();

// 你的程式碼只執行一次，需要自己處理陣列
const stats = {
  totalOrders: items.length,
  totalAmount: 0,
  averageAmount: 0,
  maxAmount: 0,
  minAmount: Infinity,
  ordersByCategory: {}
};

// 自己寫迴圈處理
items.forEach(item => {
  const order = item.json;
  
  stats.totalAmount += order.amount;
  stats.maxAmount = Math.max(stats.maxAmount, order.amount);
  stats.minAmount = Math.min(stats.minAmount, order.amount);
  
  // 按類別分組
  if (!stats.ordersByCategory[order.category]) {
    stats.ordersByCategory[order.category] = 0;
  }
  stats.ordersByCategory[order.category]++;
});

stats.averageAmount = stats.totalAmount / stats.totalOrders;

// 回傳單一結果
return { json: stats };
```

### 範例 2：Run Once for Each Item

```javascript
// 情境：格式化每個訂單
// n8n 會自動執行迴圈，每個項目執行一次

// 直接使用 $json（當前項目）
const order = $json;

// 處理當前項目
const formatted = {
  orderNumber: `#${order.id.toString().padStart(6, '0')}`,
  customerName: order.customer_name.toUpperCase(),
  totalAmount: `NT$ ${order.amount.toLocaleString()}`,
  processedAt: new Date().toISOString()
};

// 回傳當前項目的結果
return { json: formatted };
```

---

## 7️⃣ 為什麼使用 `$` 前綴？

### 設計考量

1. **避免命名衝突**
   ```javascript
   // 使用者定義的變數不太會用 $
   const $input = "my data";  // 不常見
   const input = "my data";   // 常見
   ```

2. **明確標示這是框架變數**
   ```javascript
   // 一眼就知道這是 n8n 提供的
   const data = $input.all();
   
   // 這是使用者自己定義的
   const myData = calculateSomething();
   ```

3. **業界慣例**
   - jQuery: `$('#element')`
   - PHP: `$variable`
   - Bash: `$PATH`
   - Angular: `$scope`

---

## 8️⃣ 限制與注意事項

### 不能重新賦值

```javascript
// ❌ 這樣做無效或會報錯
$input = { custom: 'data' };
$json = { new: 'data' };

// ✅ 正確做法：使用新變數
const myData = { custom: 'data' };
```

### 只在 Code Node 中可用

```javascript
// ❌ 在其他節點的設置中不能使用
// 例如在 HTTP Request Node 的 URL 欄位中：
https://api.example.com/{{ $input.first() }}  // 無效

// ✅ 在表達式欄位中使用（不同的語法）
https://api.example.com/{{ $json.id }}  // 這是 n8n 表達式，不是 Code Node
```

### 執行逾時

```javascript
// ⚠️ Code Node 有執行時間限制（通常 60 秒）
// 避免無限迴圈或長時間運算

// ❌ 危險
while (true) {
  // 無限迴圈會導致逾時
}

// ✅ 安全
for (let i = 0; i < items.length; i++) {
  // 有限次數的迴圈
}
```

---

## 9️⃣ 除錯技巧

### 查看全域變數的內容

```javascript
// 查看 $input 物件的結構
console.log('$input keys:', Object.keys($input));
console.log('$input.all():', JSON.stringify($input.all(), null, 2));

// 查看當前項目
console.log('$json:', $json);

// 查看節點資訊
console.log('$node:', $node);
```

### 使用 try-catch

```javascript
const items = $input.all();
const results = [];

for (const item of items) {
  try {
    // 處理可能失敗的操作
    const result = processItem(item.json);
    results.push({ json: result });
  } catch (error) {
    console.error(`處理項目失敗: ${item.json.id}`, error);
    // 可以選擇跳過或回傳錯誤資訊
    results.push({
      json: {
        error: true,
        message: error.message,
        originalData: item.json
      }
    });
  }
}

return results;
```

---

## 🎓 總結

### 核心概念

1. **`$input`, `$json` 等是 n8n Runtime 注入的全域變數**
   - 類似瀏覽器的 `window`、Node.js 的 `process`
   - 在 Code Node 執行前就已經準備好

2. **兩種執行模式的差異**
   - **Run Once for All Items**: 程式碼執行 1 次，你處理陣列
   - **Run Once for Each Item**: 程式碼執行 N 次，n8n 處理迴圈

3. **`$input` 物件提供多種方法**
   - `.all()`: 所有項目
   - `.first()`: 第一個項目
   - `.last()`: 最後一個項目
   - `.item`: 當前項目（屬性）

4. **快捷變數讓程式碼更簡潔**
   - `$json` = `$input.item.json`
   - `$binary` = `$input.item.binary`

### 選擇執行模式的建議

| 需求 | 建議模式 |
|------|---------|
| 統計、聚合、分組 | Run Once for All Items |
| 排序、過濾整個陣列 | Run Once for All Items |
| 簡單的資料轉換 | Run Once for Each Item |
| 每個項目互相獨立 | Run Once for Each Item |

### 下一步

- 📖 閱讀 [官方文檔](https://docs.n8n.io/code-examples/)
- 🧪 實際動手練習各種執行模式
- 🔍 使用 `console.log()` 探索資料結構

---

**祝你在 n8n 的開發之旅順利！** 🚀
