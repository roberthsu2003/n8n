# 範例二：客戶分級與標籤

## 📋 範例說明

這個範例展示如何使用 Code Node 實現複雜的客戶分級邏輯，根據多個條件自動為客戶分配等級、折扣率和標籤。

## 🎯 使用場景

在 CRM 或電商系統中，您需要根據客戶的消費行為進行分級管理：
- **訂單數量**：評估客戶忠誠度
- **消費金額**：評估客戶價值
- **最後訂單時間**：評估客戶活躍度
- **平均訂單金額**：評估客戶消費能力

傳統的 IF Node 無法處理如此複雜的多重條件判斷，這時 Code Node 就派上用場了。

## 為什麼需要 Code Node？

❌ **使用多個 IF Node 的問題**：
- 需要串接 5-10 個 IF 節點
- 工作流程變得複雜且難以維護
- 無法動態生成標籤陣列
- 難以理解整體邏輯

✅ **使用 Code Node 的優勢**：
- 所有邏輯集中在一個節點
- 可讀性高，易於維護
- 支援複雜的 AND/OR 條件組合
- 可以動態建立標籤列表

## 📦 工作流程結構

```
開始 → 客戶資料 → 客戶分級邏輯 (Code)
```

### 節點說明

1. **開始**：觸發工作流程
2. **客戶資料** (Set Node)：建立測試客戶資料
   - `customer_id`: "C001"
   - `customer_name`: "陳大華"
   - `total_orders`: 25（訂單總數）
   - `total_amount`: 150000（消費總額）
   - `days_since_last_order`: 10（距離上次訂單天數）
3. **客戶分級邏輯** (Code Node)：執行分級與標籤邏輯

## 💻 核心程式碼解析

```javascript
const items = $input.all();
const results = [];

for (const item of items) {
  const data = item.json;
  
  // 初始化變數
  let customerLevel = '';
  let tags = [];
  let discount = 0;
  
  // === 第一階段：根據訂單數量和金額判斷等級 ===
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
  
  // === 第二階段：根據最後訂單時間判斷活躍度 ===
  if (data.days_since_last_order <= 7) {
    tags.push('高度活躍');
  } else if (data.days_since_last_order <= 30) {
    tags.push('活躍');
  } else if (data.days_since_last_order <= 90) {
    tags.push('需關注');
  } else {
    tags.push('流失風險');
  }
  
  // === 第三階段：計算平均訂單金額 ===
  const avgOrderAmount = data.total_orders > 0 
    ? Math.round(data.total_amount / data.total_orders) 
    : 0;
  
  // 如果平均訂單金額高，加上標籤
  if (avgOrderAmount >= 5000) {
    tags.push('高單價客戶');
  }
  
  // === 組合輸出資料 ===
  results.push({
    json: {
      customer_id: data.customer_id,
      customer_name: data.customer_name,
      level: customerLevel,
      discount_rate: discount,
      tags: tags.join(', '),
      avg_order_amount: avgOrderAmount,
      analysis_date: new Date().toISOString(),
      original_data: {
        total_orders: data.total_orders,
        total_amount: data.total_amount,
        days_since_last_order: data.days_since_last_order
      }
    }
  });
}

return results;
```

### 🔑 程式碼重點說明

1. **複雜條件判斷**
   ```javascript
   if (data.total_amount >= 100000 && data.total_orders >= 20)
   ```
   - `&&` (AND)：同時滿足金額和訂單數條件
   - `||` (OR)：滿足其中一個條件即可

2. **動態標籤陣列**
   ```javascript
   let tags = [];
   tags.push('高價值客戶');
   tags.push('高度活躍');
   ```
   - 使用 `.push()` 動態添加標籤
   - 使用 `.join(', ')` 將陣列轉為字串

3. **安全的數學計算**
   ```javascript
   const avgOrderAmount = data.total_orders > 0 
     ? Math.round(data.total_amount / data.total_orders) 
     : 0;
   ```
   - 使用三元運算子避免除以零
   - 使用 `Math.round()` 四捨五入

4. **保留原始資料**
   - 將原始數據也一併輸出，方便後續追蹤

## 🔍 預期輸出

```json
{
  "customer_id": "C001",
  "customer_name": "陳大華",
  "level": "VIP",
  "discount_rate": 15,
  "tags": "高價值客戶, 高度活躍, 高單價客戶",
  "avg_order_amount": 6000,
  "analysis_date": "2024-12-10T06:25:40.000Z",
  "original_data": {
    "total_orders": 25,
    "total_amount": 150000,
    "days_since_last_order": 10
  }
}
```

## 🚀 如何使用

### 步驟一：匯入工作流程

1. 登入 n8n
2. 點擊「新增工作流程」
3. 點擊右上角「...」選單 → 「匯入自檔案」
4. 選擇 `example2_customer_classification.json`

### 步驟二：執行測試

1. 點擊「執行工作流程」
2. 查看「客戶分級邏輯 (Code)」節點的輸出

### 步驟三：測試不同場景

修改「客戶資料」節點的數值，觀察分級結果：

| 場景 | total_orders | total_amount | days_since_last_order | 預期等級 |
|------|-------------|--------------|---------------------|---------|
| 新客戶 | 2 | 5000 | 5 | 一般會員 |
| 活躍客戶 | 8 | 40000 | 15 | 銀牌會員 |
| 重要客戶 | 15 | 80000 | 20 | 黃金會員 |
| VIP | 25 | 150000 | 10 | VIP |
| 流失風險 | 5 | 30000 | 100 | 銀牌會員（流失風險標籤）|

## 💡 延伸練習

### 練習 1：加入季度分析
新增「季度消費排名」標籤，比較客戶在不同季度的表現。

### 練習 2：RFM 模型
實作 RFM (Recency, Frequency, Monetary) 分析模型：
- R (最近一次消費)：`days_since_last_order`
- F (消費頻率)：`total_orders`
- M (消費金額)：`total_amount`

為每個維度評分 1-5 分，組合成 RFM 分數。

### 練習 3：自動化行銷建議
根據客戶等級和標籤，自動產生行銷建議：
```javascript
let marketingAction = '';
if (tags.includes('流失風險')) {
  marketingAction = '發送優惠券挽回';
} else if (customerLevel === 'VIP') {
  marketingAction = '專屬會員活動邀請';
}
```

### 練習 4：整合通知系統
在分級後自動發送通知：
- VIP 客戶 → 發送 Slack 通知給客服主管
- 流失風險客戶 → 建立待辦事項提醒跟進

## 🎓 學習重點

1. ✅ 掌握複雜的 if-else 邏輯結構
2. ✅ 理解 `&&` (AND) 和 `||` (OR) 運算子
3. ✅ 學會使用陣列 `.push()` 和 `.join()` 方法
4. ✅ 掌握三元運算子避免錯誤
5. ✅ 理解如何組織多階段的資料處理邏輯

## 🤔 思考問題

1. 如果需要區分「新客戶」（第一次購買未滿 30 天），應該加入什麼資料欄位？
2. 如何避免「高單價但訂單數少」的客戶被錯誤分級？
3. 這個分級邏輯是否需要定期調整？如何設計可彈性調整的參數？

---

**難度**: ⭐⭐☆ (中級)  
**適用對象**: 有基礎 JavaScript 經驗的學生  
**預計學習時間**: 40-60 分鐘
