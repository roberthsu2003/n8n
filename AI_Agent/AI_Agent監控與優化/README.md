# 範例七：AI Agent 監控與優化

## 📚 學習目標

學習 AI Agent 的最佳實踐，包括監控、評估、優化和安全管理。

## 🎯 難度等級

**難度**: ⭐⭐⭐ (進階)  
**學習時間**: 60-90 分鐘  
**階段**: 階段四：最佳實踐

## 📋 工作流程說明

這個範例展示如何建立 AI Agent 的監控與優化系統，包括：
- 使用 Guardrails 確保輸出安全
- 使用 Evaluation 測試 Agent 表現
- 成本監控與 Token 使用優化
- Prompt 版本管理
- 效能監控和日誌記錄

## 🎓 學習內容

### 1. 使用 Guardrails（防護欄）確保輸出安全

**Guardrails 的作用**：
- 過濾不當內容
- 防止敏感資訊洩露
- 確保輸出符合規範
- 保護系統安全

**實作方式**：
- 使用 **Guardrails** 節點
- 設定內容過濾規則
- 設定敏感詞過濾
- 設定輸出格式檢查

**範例設定**：
```
過濾規則：
- 禁止輸出個人資訊（電話、地址、身份證）
- 禁止輸出不當言論
- 確保輸出格式正確
- 限制輸出長度
```

### 2. Evaluation（評估節點）測試 Agent 表現

**評估指標**：
- **準確性**：回答是否正確
- **相關性**：回答是否相關
- **完整性**：回答是否完整
- **時效性**：回應時間

**實作方式**：
- 使用 **Evaluation** 節點
- 建立測試案例集
- 自動執行測試
- 生成評估報告

**測試案例範例**：
```json
{
  "question": "什麼是 AI？",
  "expected_answer": "AI 是人工智慧...",
  "category": "基礎知識"
}
```

### 3. 成本監控與 Token 使用優化

**監控指標**：
- Token 使用量
- API 呼叫次數
- 成本統計
- 使用趨勢

**優化策略**：
- 使用較便宜的模型處理簡單任務
- 快取重複的結果
- 優化 Prompt 長度
- 批次處理請求

**實作方式**：
- 記錄每次 API 呼叫的 Token 使用量
- 計算成本（Token 數 × 單價）
- 建立成本報表
- 設定成本警報

### 4. Prompt 版本管理

**版本管理的重要性**：
- 追蹤 Prompt 變更
- 比較不同版本的表現
- 回滾到舊版本
- 協作開發

**實作方式**：
- 使用 Git 管理 Prompt 檔案
- 建立 Prompt 版本號
- 記錄變更歷史
- 建立 A/B 測試機制

## ⚙️ 設定步驟

### 步驟一：設定 Guardrails
1. 加入 **Guardrails** 節點
2. 設定內容過濾規則：
   - 敏感詞列表
   - 個人資訊模式（電話、Email、身份證）
   - 不當內容關鍵字
3. 設定輸出格式檢查
4. 設定錯誤處理機制

### 步驟二：設定 Evaluation
1. 建立測試案例集（JSON 格式）
2. 加入 **Evaluation** 節點
3. 設定評估指標：
   - 準確性
   - 相關性
   - 完整性
4. 執行自動測試
5. 生成評估報告

### 步驟三：設定成本監控
1. 加入 **Set** 節點記錄 Token 使用量
2. 計算成本：
   ```javascript
   const inputTokens = $json.usage.prompt_tokens;
   const outputTokens = $json.usage.completion_tokens;
   const cost = (inputTokens * 0.001) + (outputTokens * 0.002);
   ```
3. 記錄到資料庫或 Google Sheets
4. 建立成本報表

### 步驟四：設定 Prompt 版本管理
1. 建立 Prompt 檔案結構：
   ```
   prompts/
     ├── v1.0/
     │   └── system_prompt.txt
     ├── v1.1/
     │   └── system_prompt.txt
     └── current -> v1.1
   ```
2. 使用 **Read Binary File** 節點讀取 Prompt
3. 加入版本號到 Context
4. 記錄 Prompt 使用歷史

### 步驟五：設定效能監控
1. 記錄每次執行的時間戳記
2. 計算處理時間：
   ```javascript
   const startTime = $json.start_time;
   const endTime = $json.end_time;
   const duration = endTime - startTime;
   ```
3. 記錄到監控系統
4. 設定效能警報

### 步驟六：建立監控儀表板
1. 使用 Google Sheets 或 Supabase 儲存數據
2. 建立視覺化報表：
   - 成本趨勢圖
   - Token 使用量統計
   - 回應時間分析
   - 錯誤率統計
3. 設定定期報告

## 💡 最佳實踐

### 1. 安全性最佳實踐
- **輸入驗證**：檢查所有輸入
- **輸出過濾**：使用 Guardrails 過濾輸出
- **權限控制**：限制 API 存取權限
- **日誌記錄**：記錄所有操作

### 2. 效能最佳實踐
- **快取機制**：快取重複的結果
- **批次處理**：合併多個請求
- **模型選擇**：根據任務選擇合適的模型
- **並行處理**：使用並行處理提高效率

### 3. 成本優化最佳實踐
- **模型選擇**：使用較便宜的模型處理簡單任務
- **Prompt 優化**：減少不必要的 Token
- **結果快取**：避免重複計算
- **監控和警報**：及時發現異常使用

### 4. 品質保證最佳實踐
- **定期評估**：定期測試 Agent 表現
- **持續優化**：根據評估結果優化
- **版本控制**：管理 Prompt 版本
- **A/B 測試**：比較不同版本的表現

## 🔧 進階功能擴展

### 練習 1：建立自動化測試流程
建立 CI/CD 流程：
- 自動執行測試案例
- 比較不同版本的表現
- 自動生成報告
- 設定通過/失敗標準

### 練習 2：實作智能成本優化
自動優化成本：
- 根據任務複雜度選擇模型
- 自動調整 Prompt 長度
- 智能快取策略
- 成本預測和建議

### 練習 3：建立即時監控系統
建立即時監控：
- 即時顯示系統狀態
- 異常警報
- 效能指標儀表板
- 自動故障恢復

## 📌 常見問題

### Q: 如何設定 Guardrails 規則？
**A**: 
- 根據應用場景定義規則
- 測試規則的有效性
- 定期更新規則
- 平衡安全性和可用性

### Q: 如何評估 Agent 表現？
**A**: 
- 建立標準測試案例集
- 定義評估指標
- 定期執行評估
- 根據結果優化

### Q: 如何控制成本？
**A**: 
- 監控 Token 使用量
- 使用較便宜的模型
- 優化 Prompt
- 快取結果

## 📚 相關資源

- [n8n Guardrails 文件](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.guardrails/)
- [OpenAI Token 計費](https://openai.com/pricing)
- [Prompt Engineering 最佳實踐](https://platform.openai.com/docs/guides/prompt-engineering)

---

**🎓 完成此範例後，您將理解 AI Agent 的最佳實踐，能夠建立安全、高效、可靠的 AI 系統！**

