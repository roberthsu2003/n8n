# 整合 RAG 的實作

本區為 **RAG（檢索增強生成）** 的獨立大章節。RAG 讓 AI 能依據**你的文件**回答問題，是知識庫問答、企業搜尋、客服機器人等應用的核心技術。本區範例由淺至深，從入門的記憶體儲存到進階的雲端向量資料庫，便於學生循序學習。

**建議先修**：可先完成 [整合 LLM 的 AI Agent](../AI_Agent/README.md) 的純對話或工具使用再來 RAG；或直接從本區「入門」範例開始亦可。

---

## RAG 範例大綱（由淺至深）

以下範例按學習順序排列；已有實作的附上連結，預留項標為「（規劃中）」供未來補上。

| 順序 | 階段 | 範例名稱 | 說明／學習重點 | 連結 |
|------|------|----------|----------------|------|
| 1 | 入門 | RAG 初體驗：記憶體儲存 | 什麼是 RAG、Embeddings、In-Memory Vector Store、單一工作流程、上傳即問答 | [01 入門版（記憶體儲存）](../AI_Agent/RAG智能問答系統/01_入門版_記憶體儲存/README.md) |
| 2 | 入門 | 精簡版文件問答（選讀） | Q&A Chain + Simple Vector Store，最精簡流程 | [文件智能問答系統](../AI_Agent/文件智能問答系統/README.md) |
| 3 | 基礎 | RAG 基礎：向量持久化與多來源 | 分離式架構（索引／查詢）、Supabase、本機＋Google Drive、來源過濾 | [02 基礎版（Supabase 雲端儲存）](../AI_Agent/RAG智能問答系統/02_基礎版_Supabase雲端儲存/README.md) |
| 4 | 基礎 | RAG 與檢索策略 | 進階檢索（Hybrid、Rerank）、Chunk 策略、Metadata 過濾 | （規劃中） |
| 5 | 進階 | RAG 進階：本地向量資料庫 | PostgreSQL + PGVector、自建向量庫、完全本地控制 | [03 進階版（本地 PostgreSQL）](../AI_Agent/RAG智能問答系統/03_進階版_本地PostgreSQL/README.md) |
| 6 | 進階 | RAG 進階：雲端向量資料庫（Pinecone） | 雲端向量庫、Google Drive→向量→Pinecone、Gemini Embeddings、Chat + 檢索 | [Pinecone 向量資料庫](./pinecone向量資料庫/README.md) |
| 7 | 進階 | 多模態 RAG 或企業應用 | 圖片/表格檢索、權限與多租戶、評測與優化 | （規劃中） |

---

## 本區現有範例快速連結

- **入門**：[RAG 智能問答系統（入門版）](../AI_Agent/RAG智能問答系統/01_入門版_記憶體儲存/README.md)｜[精簡版文件問答（選讀）](../AI_Agent/文件智能問答系統/README.md)
- **基礎**：[RAG 智能問答系統（基礎版 Supabase）](../AI_Agent/RAG智能問答系統/02_基礎版_Supabase雲端儲存/README.md)
- **進階**：[RAG 智能問答系統（進階版 PostgreSQL）](../AI_Agent/RAG智能問答系統/03_進階版_本地PostgreSQL/README.md)｜[Pinecone 向量資料庫](./pinecone向量資料庫/README.md)
