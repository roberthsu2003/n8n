# 💻 Code Node (JavaScript)
## 範例 3：多條件分類與動態標籤（替代複雜 IF 節點）

### 📚 工作流程說明

在 CRM 客戶分級、風險控管或工單分流中，往往需要同時依據消費金額、歷史訂單數、距離上次下單天數等「多重維度」進行綜合判定。若使用 n8n 原生的 IF 或 Switch 節點，通常需要串接十幾個節點，流程圖會變得非常雜亂且難以維護。

本範例展示：
1. 在單一 **Code 節點** 內使用簡潔清晰的 JavaScript 條件邏輯（`if ... else if`、`&&`、`||`）。
2. 動態使用陣列 `.push()` 依客戶行為貼上多重標籤（如 `['高價值客戶', '活躍', '高客單價']`）。
3. 使用三元運算子 `data.total_orders > 0 ? ... : 0` 防止除以零錯誤，輸出完整的客戶畫像結構。

---

### 流程架構圖

```mermaid
flowchart LR
    A["▶️ 手動觸發 / CRM 客戶資料匯入"] --> B["👥 客戶消費歷史資料 (Set 節點)"]
    B --> C["⚙️ 多條件分級與動態標籤 (Code 節點)"]
    
    subgraph Multi_Condition_Engine["多維度 JavaScript 決策引擎"]
        D["🏆 依累積金額與訂單數評定 VIP 等級"]
        E["⏰ 依未下單天數判斷活躍度與流失風險"]
        F["💰 安全計算客單價 (防除以零)"]
        G["🏷️ 動態生成標籤陣列與字串"]
    end
    
    C --> D --> E --> F --> G
    G --> H["📊 輸出結構化客戶評級與分析報告"]
```

---

### 工作流程樣版下載

- [📥 多條件分類與動態標籤工作流程樣版 (03_customer_classification.json)](./03_customer_classification.json)

---

#### 📋 節點詳細說明

1. **📝 流程說明（Sticky Note）**
   - **功能**：介紹多條件邏輯運算元與陣列動態組合技巧。

2. **👥 客戶消費資料（Set Node）**
   - **total_orders**：`25`
   - **total_amount**：`150000`
   - **days_since_last_order**：`10`

3. **⚙️ 客戶分級與動態標籤 (Code Node)**
   - **核心程式碼**：
     ```javascript
     if (data.total_amount >= 100000 && data.total_orders >= 20) {
       customerLevel = 'VIP 尊榮會員';
       discount = 15;
       tags.push('高價值客戶');
     }
     ```

---

#### 🎯 學習重點

- **單一節點取代龐大流程**：將多層 IF/Switch 節點濃縮於 Code 節點中，大幅提升維護性與執行效能。
- **除以零防禦性程式設計**：`total_orders > 0 ? (total_amount / total_orders) : 0`，避免資料庫出現 `NaN` 或拋出異常。

---

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 增加「客戶健康度評分 (Health Score: 0~100)」演算法。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在「客戶分級邏輯」Code 節點中加入健康度評分 (0-100 分) 運算：
1. 訂單數權重 40%（超過 20 筆滿分）。
2. 消費金額權重 40%（超過 10 萬元滿分）。
3. 活躍天數權重 20%（7 天內滿分，超過 90 天 0 分）。
4. 在輸出 JSON 中新增 health_score 與 score_level ('極佳' | '良好' | '危險')。
請提供修改後的 Code 節點程式碼！
```
</details>
