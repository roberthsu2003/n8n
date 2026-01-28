# Ollama 安裝與設定（零成本入門）

如果您想從零成本的本地模型開始學習 AI Agent，建議先安裝 Ollama。這樣您可以立即開始實作，無需申請任何 API 金鑰。

## 什麼是 Ollama？

Ollama 是一個讓您在本地電腦運行大型語言模型的工具，具有以下優勢：
- ✅ **完全免費**：無需支付 API 使用費用
- ✅ **隱私保護**：資料不會傳送到外部伺服器
- ✅ **離線運作**：不需要網路連線即可使用
- ✅ **簡單易用**：幾個指令即可完成安裝

## 系統需求

- **作業系統**：macOS、Linux 或 Windows
- **記憶體**：建議至少 8GB RAM（16GB 更佳）
- **硬碟空間**：至少 10GB 可用空間

## 安裝步驟

### macOS 安裝

使用 Homebrew 安裝（推薦）：
```bash
brew install ollama
```

或從官網下載安裝程式：
1. 前往 [Ollama 官網](https://ollama.ai)
2. 下載 macOS 安裝程式
3. 執行安裝程式並依照指示完成安裝

### Linux 安裝

執行一行安裝指令：
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

### Windows 安裝

1. 前往 [Ollama 官網](https://ollama.ai)
2. 下載 Windows 安裝程式
3. 執行安裝程式並依照指示完成安裝

## 啟動 Ollama 服務

安裝完成後，啟動 Ollama 服務：

```bash
ollama serve
```

服務會在 `http://localhost:11434` 運行。

## 下載推薦的 LLM 模型

為了配合本教學的第一個範例，建議下載以下模型：

### 選項一：gpt-oss:20b（教學範例使用）
```bash
ollama pull gpt-oss:20b
```
- 模型大小：約 12GB
- 適合：一般對話和工具使用
- 需要記憶體：約 16GB RAM

### 選項二：llama2:7b（輕量級選擇）
```bash
ollama pull llama2:7b
```
- 模型大小：約 4GB
- 適合：記憶體較少的電腦
- 需要記憶體：約 8GB RAM

### 選項三：mistral:7b（推薦平衡選擇）
```bash
ollama pull mistral:7b
```
- 模型大小：約 4GB
- 適合：效能與品質的平衡
- 需要記憶體：約 8GB RAM

## 驗證安裝

下載完成後，驗證模型是否可用：

```bash
# 列出已安裝的模型
ollama list

# 測試模型（以 llama2:7b 為例）
ollama run llama2:7b "你好，請自我介紹"
```

## 在 n8n 中設定 Ollama

1. **新增 Ollama 憑證**
   - 在 n8n 中點擊「Credentials」
   - 選擇「Ollama API」
   - Base URL 設定為：`http://localhost:11434`
   - 儲存憑證

2. **選擇模型**
   - 在工作流程中加入「Ollama Chat Model」節點
   - 選擇您剛才下載的模型名稱
   - 連接到 AI Agent 節點

## 常見問題

**Q: Ollama 無法啟動怎麼辦？**
- 檢查是否有其他程式佔用 11434 port
- 確認防火牆設定允許本地連線
- 重新安裝 Ollama

**Q: 模型下載很慢？**
- 模型檔案較大，請耐心等待
- 確保網路連線穩定
- 可以使用較小的模型（如 llama2:7b）

**Q: 記憶體不足怎麼辦？**
- 選擇較小的模型（7b 參數版本）
- 關閉其他應用程式釋放記憶體
- 考慮使用雲端 API（OpenAI、Gemini）

## 提示

- 如果您的電腦配置較低，可以跳過 Ollama 安裝，直接從「智能客服聊天機器人」範例開始，使用雲端 API
- Ollama 適合學習和開發，生產環境建議使用雲端 API 以獲得更穩定的效能
- 您可以隨時在 Ollama 和雲端 API 之間切換，只需更換 Chat Model 節點即可
