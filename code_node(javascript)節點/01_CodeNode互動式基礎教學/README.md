# 💻 Code Node (JavaScript)
## 範例 1：Code Node 互動式入門教學（兩種執行模式與內建 Helper）

### 📚 工作流程說明

這是一個完整的互動式實作教學工作流程，透過 6 個連續進階關卡，引導您徹底掌握 n8n **Code 節點**的核心運作機制：
1. **兩種執行模式**：`runOnceForEachItem`（逐筆項目處理） vs `runOnceForAllItems`（整批聚合處理）。
2. **內建 Helper 呼叫外部 API**：使用 `this.helpers.httpRequest` 發送異步 HTTP 請求擴充資料。
3. **資料聚合與統計**：使用 JavaScript 陣列 `.reduce()` 計算平均年齡與總人數。
4. **二進位檔案生成**：使用 `this.helpers.prepareBinaryData` 將文字字串動態打包為 CSV 檔案。

---

### 流程架構圖

```mermaid
flowchart LR
    A["▶️ Start Tutorial (手動觸發)"] --> B["1. Sample Data (建立測試資料)"]
    B --> C["2. Split Out Users (陣列拆分項目)"]
    C --> D["3. Process Each User (逐筆模式: 年齡計算)"]
    D --> E["4. Fetch External Data (進階: API 請求)"]
    E --> F["5. Calculate Average Age (整批模式: 聚合平均)"]
    F --> G["6. Create a Binary File (生成 CSV 檔案)"]
```

---

### 工作流程樣版下載

- [📥 Code Node 互動式基礎教學工作流程樣版 (01_code_node_basics.json)](./01_code_node_basics.json)

---

#### 📋 關卡詳細說明

1. **關卡 1：逐筆處理模式 (`runOnceForEachItem`)**
   - **程式碼**：
     ```javascript
     const user = $input.item.json;
     const fullName = `${user.firstName} ${user.lastName}`;
     const birthDate = new Date(user.birthDate);
     const age = Math.abs(new Date(Date.now() - birthDate.getTime()).getUTCFullYear() - 1970);
     return { ...user, fullName, age };
     ```
   - **重點**：使用 `$input.item.json` 存取當前項目，回傳物件保留原始資料。

2. **關卡 2：呼叫外部 API (`this.helpers.httpRequest`)**
   - **程式碼**：
     ```javascript
     const user = $input.item.json;
     const response = await this.helpers.httpRequest({
       url: `https://api.genderize.io?name=${user.firstName}`,
       json: true
     });
     return { ...user, gender: response.gender };
     ```

3. **關卡 3：整批聚合模式 (`runOnceForAllItems`)**
   - **程式碼**：
     ```javascript
     const allUsers = $items();
     const totalAge = allUsers.reduce((sum, item) => sum + item.json.age, 0);
     return [{ json: { totalUsers: allUsers.length, averageAge: totalAge / allUsers.length } }];
     ```

4. **關卡 4：生成 CSV 二進位檔案 (`this.helpers.prepareBinaryData`)**
   - **程式碼**：
     ```javascript
     const binaryData = await this.helpers.prepareBinaryData(Buffer.from(csvContent), 'user_report.csv');
     return [{ json: { count: allUsers.length }, binary: { report: binaryData } }];
     ```

---

#### 🎯 學習重點

- **`$input.item.json` vs `$items()`**：前者用於逐筆迴圈模式，後者用於整批聚合模式。
- **異步運算 (`async / await`)**：在 Code 節點中呼叫外部 API 或建立 Binary 必須使用 `await`。

---

<details>
<summary>🤖 <strong>AI 賦能延伸實作（附 Prompt 提詞）</strong></summary>

> 💡 **任務目標**：透過 MCP 連線，讓 AI 在關卡 5 加入中位數 (Median) 與最大/最小年齡統計。

**可直接複製給 AI 的 Prompt 提詞**：
```text
請幫我在「5. Calculate Average Age」節點中擴充統計指標：
1. 計算所有使用者的最大年齡 (maxAge) 與最小年齡 (minAge)。
2. 將年齡陣列排序後計算年齡中位數 (medianAge)。
3. 在輸出 JSON 中同時包含 totalUsers, averageAge, maxAge, minAge, medianAge。
請提供修改後的 Code 節點 JavaScript 程式碼！
```
</details>
