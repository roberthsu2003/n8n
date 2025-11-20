# 初階範例
## 透過互動式逐步教程學習 JSON 基礎（適合初學者）

### 📚 工作流程說明

這個 n8n 工作流程是一個互動式的教學指南，專門為了幫助初學者理解 JSON (JavaScript Object Notation) 的基礎概念而設計。透過視覺化的節點操作，你將一步步學習 JSON 的核心結構（鍵與值）、各種資料型態（字串、數字、布林值、陣列、物件、Null），以及如何在 n8n 中透過表達式（Expressions）來靈活運用這些資料。這不需要任何程式設計背景，只需跟隨流程中的便利貼（Sticky Notes）指引即可輕鬆上手。

### 預覽圖

![](./images/json_basics_tutorial.png)

#### 🔄 工作流程圖

```
[Execute to Start] → [Key & Value] → [String] → [Number] → [Boolean] → [Null] → [Array] → [Object] → [Using JSON] → [Final Exam]
```

#### 📋 節點詳細說明

1. **👆 Execute to Start (Manual Trigger)**
   - **功能**：流程的起點。
   - **操作**：點擊「Execute Workflow」按鈕來啟動整個教學流程。

2. **🔑 Key & Value (Set)**
   - **功能**：介紹 JSON 的基本單位。
   - **概念**：展示「鍵 (Key)」與「值 (Value)」的配對關係。

3. **🔡 String (Set)**
   - **功能**：介紹字串型態。
   - **概念**：文字資料，必須使用雙引號 `""` 包圍。

4. **🔢 Number (Set)**
   - **功能**：介紹數字型態。
   - **概念**：整數或浮點數，不需要引號。

5. **✅ Boolean (Set)**
   - **功能**：介紹布林值。
   - **概念**：只有 `true` (真) 或 `false` (假) 兩種狀態，適合用於邏輯判斷。

6. **🚫 Null (Set)**
   - **功能**：介紹空值。
   - **概念**：代表「無」或「空」，與 0 或空字串不同。

7. **qh Array (Set)**
   - **功能**：介紹陣列。
   - **概念**：有序的資料列表，使用方括號 `[]` 包圍。

8. **📦 Object (Set)**
   - **功能**：介紹物件。
   - **概念**：複雜的資料結構，包含多個鍵值對，使用大括號 `{}` 包圍。

9. **⚡ Using JSON (Expressions)**
   - **功能**：學習資料引用。
   - **操作**：展示如何使用 n8n 的表達式 `{{ ... }}` 來讀取前面節點產生的資料。

10. **🎓 Final Exam (Set)**
    - **功能**：綜合練習。
    - **內容**：彙整所有學到的資料型態，建立一個完整的 JSON 摘要。

#### 🎯 學習重點

- **JSON 語法基礎**：掌握引號、括號與逗號的正確使用方式。
- **資料型態辨識**：能夠區分並正確使用六種基本的 JSON 資料型態。
- **n8n 表達式**：學會如何在後續節點中引用前序節點的 JSON 資料（Data Mapping）。
- **資料結構化**：理解如何利用 Array 和 Object 來組織複雜的資訊。

#### 💡 實際應用場景

- **API 串接**：理解並處理 RESTful API 回傳的 JSON 格式資料。
- **資料轉換**：將不同來源的資料整理成統一的 JSON 格式。
- **設定檔管理**：讀取或產生 JSON 格式的設定檔。

#### ⚙️ 設定步驟

1. **匯入流程**：將此工作流程代碼複製並貼上至 n8n 編輯器中。
2. **執行流程**：點擊畫面底部的「Execute Workflow」按鈕。
3. **互動學習**：
   - 依照畫面上便利貼（Sticky Notes）的編號順序閱讀說明。
   - 點擊每個節點，查看其「Output Data」面板，觀察 JSON 資料的實際樣貌。
   - 在「Using JSON」與「Final Exam」節點中，觀察表達式是如何運作的。

### 💻 工作流程代碼

```json
{
  "nodes": [
    {
      "parameters": {},
      "id": "10bfb2f0-254f-492b-becd-76e87dbb75dc",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Execute to Start",
      "type": "n8n-nodes-base.manualTrigger",
      "creator": "Lucas Peyrin",
      "position": [
        -3344,
        1008
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "json_example_string",
              "type": "string",
              "value": "This is a simple string. In JSON, it's always enclosed in double quotes."
            }
          ]
        },
        "options": {}
      },
      "id": "aa706cae-193a-42af-a8b6-8acaeb84d2cb",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "String",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -2704,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "key",
              "type": "string",
              "value": "value"
            },
            {
              "id": "b5f030f4-6650-4181-881f-de44790bb24b",
              "name": "another_key",
              "type": "string",
              "value": "another_value"
            }
          ]
        },
        "options": {}
      },
      "id": "fb242689-3334-4830-85d1-72a088a28daa",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Key & Value",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -2992,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "json_example_integer",
              "type": "number",
              "value": 10
            },
            {
              "id": "12345",
              "name": "json_example_float",
              "type": "number",
              "value": 12.5
            }
          ]
        },
        "options": {}
      },
      "id": "c4596d25-696b-4ad6-9b75-02352f3487b1",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Number",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -2416,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "json_example_boolean",
              "type": "boolean",
              "value": false
            }
          ]
        },
        "options": {}
      },
      "id": "2fb1e8dd-efc6-4eec-a394-1152cebd1701",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Boolean",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -2128,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "json_example_array",
              "type": "array",
              "value": "[\"first element\", 2, false, null]"
            }
          ]
        },
        "options": {}
      },
      "id": "127f9542-9041-446c-8eae-6466204b5e72",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Array",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -1552,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "json_example_object",
              "type": "object",
              "value": "{\"key\":\"value\",\"array\":[1,2,3],\"boolean\":false,\"integer\":123,\"sub_object\":{\"sub_key\":\"Find me!\"}}"
            }
          ]
        },
        "options": {}
      },
      "id": "77bf61c7-261c-48bd-a09b-816979ef9718",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Object",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -1248,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "## 教學 - 什麼是 JSON？\n\n歡迎！本工作流程將教您 JSON 的基礎知識，JSON 是應用程式和 n8n 節點用來交換資訊的語言。\n\n**什麼是 JSON？ **\n\n想像一張聯絡人卡片：\n\n- **姓名：** John Doe\n\n- **年齡：** 30\n\n- **是否有子女：** 是\n\n- **電話號碼：** [\"555-1234\", \"555-5678\"]\n\nJSON 只是將這些資訊以電腦能夠完全理解的方式記錄下來。\n\n**如何使用本教學：**\n\n1. 點選**「執行工作流程」**按鈕。\n\n2. 按順序逐一點擊每個節點。\n\n3. 查看右側面板中節點的輸出，並閱讀相關的便箋以了解正在發生的事情。",
        "height": 752,
        "width": 460
      },
      "id": "08bc587e-1ecf-46fb-919f-441ce0b654a5",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -3568,
        416
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### JSON 的核心：鍵與值\n\nJSON 中的一切都基於鍵值對：\n\n- 一個 **鍵**（資料名稱，總是用雙引號 `\"` 括起來）。\n\n- 一個 **值**（資料本身）。\n\n`\"key\": \"value\"`\n\n在這個節點的輸出中，你會看到兩個鍵值對。這是後續所有內容的基本建置模組。",
        "height": 516,
        "width": 260,
        "color": 7
      },
      "id": "105cb655-6695-4812-badf-f30b97e6fa7b",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note1",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -3072,
        656
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### 資料型態：字串\n\n字串就是文字。\n\n- **文法：**文字總是用雙引號 `\" \"` 括起來。\n\n查看輸出：`json_example_string` 的值就是我們定義的文字。",
        "height": 516,
        "width": 260,
        "color": 7
      },
      "id": "41de1184-3997-45bf-83eb-7bc27384888a",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note2",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -2784,
        656
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### 資料型態：數字\n\n這只是一個數字。它可以是整數（例如 10），也可以是浮點數（例如 12.5）。\n\n- **語法：** 直接輸入數字即可，**無需引號**。\n\n`\"age\": 30`（正確）\n\n`\"age\": \"30\"`（錯誤，這是一個字串！）\n\n這種差異對於數學運算至關重要！",
        "height": 516,
        "width": 260,
        "color": 7
      },
      "id": "d6aca924-7370-49f3-b75a-6ade676c3729",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note3",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -2496,
        656
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### 資料型態：布林值\n\n布林值只能為**TRUE**或**FALSE**。\n\n- **語法：**`true` 或 `false`（永遠小寫且**不帶引號**）。\n\n你可以把它想像成一個電燈開關：開（`true`）或關（`false`）。它非常適合用於條件判斷（If/Then邏輯）。",
        "height": 516,
        "width": 260,
        "color": 7
      },
      "id": "0b40f47e-7e71-49a0-8fc7-66645b04da07",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note4",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -2208,
        656
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### 資料型態：數組\n\n數組是一個有順序的元素列表。\n\n- **文法**以 `[` 開頭，以 `]` 結尾。元素之間以逗號分隔。\n\n陣列可以包含任何類型的資料：字串、數字、布林值，甚至其他陣列或物件！",
        "height": 516,
        "width": 260,
        "color": 7
      },
      "id": "eebbb8d8-3c5c-4cad-acc9-eba47c030f65",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note5",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -1632,
        656
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### 資料型態：物件（JSON 物件）\n\n這是核心概念！物件是**鍵值對的集合**。\n\n- **文法**以 `{` 開頭，以 `}` 結尾。\n\n正是這種特性使我們能夠建立複雜的資料結構，例如我們一開始創建的聯絡人卡片。請注意，這個物件包含了我們之前看到的所有其他資料類型！",
        "height": 516,
        "width": 280,
        "color": 7
      },
      "id": "6b733d30-f51f-4540-8a86-14ee3f15b73d",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note6",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -1344,
        656
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "json_example_null",
              "type": "null",
              "value": {}
            }
          ]
        },
        "options": {}
      },
      "id": "d0613842-5cd7-4842-be42-fb4e18142498",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Null",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -1840,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### 資料型態：null\n\n這種特殊類型表示“無”、“無值”或“空”。\n\n- **文法：** `null`（小寫，**不帶引號**）。\n\n它不同於 `0`（表示數字）或 `\"\"\"（表示空字串）。`null` 表示有意不賦值。",
        "height": 516,
        "width": 260,
        "color": 7
      },
      "id": "8d9e62a7-b0dc-4c83-82d0-c6331b0d37ba",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note7",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -1920,
        361
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "message",
              "type": "string",
              "value": "=Hello, the number from the tutorial is: {{ $('Number').item.json.json_example_integer }}"
            },
            {
              "id": "61f385f4-b8e2-4c69-b873-9ffc3ab3fe94",
              "name": "sub_key",
              "type": "string",
              "value": "={{ $json.json_example_object.sub_object.sub_key }}"
            },
            {
              "id": "bd752a0f-64bf-44b1-b39b-fca28e86aa5b",
              "name": "array_second_item",
              "type": "string",
              "value": "={{ $json.json_example_object.array[1] }}"
            }
          ]
        },
        "options": {}
      },
      "id": "91421c0a-b767-4663-aadf-6d6c065839f1",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Using JSON (Expressions)",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -912,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### ⭐ 關鍵步驟：在 n8n 中使用 JSON！\n\n現在，神奇之處在於：如何使用前一個節點的資料？答案是使用**表達式** `{{ }}`。\n\n這個節點創建了一個自訂訊息。看看 `message` 欄位的值：\n\n`Hello, the number from the tutorial is: {{ $('Number').item.json.json_example_integer }}`\n\n它動態地從“Number”節點中提取了數字 `10`！這就是讓節點之間相互通訊的方式。",
        "height": 516,
        "width": 340,
        "color": 5
      },
      "id": "10475c6a-0b2d-4125-b51b-0a3a01b9c523",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note8",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -1040,
        656
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "e87952cb-878e-4feb-8261-342eaf887838",
              "name": "summary_string",
              "type": "string",
              "value": "={{ $('String').item.json.json_example_string }}"
            },
            {
              "id": "12345",
              "name": "summary_number",
              "type": "number",
              "value": "={{ $('Number').item.json.json_example_integer }}"
            },
            {
              "id": "67890",
              "name": "summary_boolean",
              "type": "boolean",
              "value": "={{ $('Boolean').item.json.json_example_boolean }}"
            },
            {
              "id": "abcde",
              "name": "summary_null",
              "type": "null",
              "value": "={{ $('Null').item.json.json_example_null }}"
            },
            {
              "id": "fghij",
              "name": "summary_array",
              "type": "array",
              "value": "={{ $('Array').item.json.json_example_array }}"
            },
            {
              "id": "klmno",
              "name": "summary_object",
              "type": "object",
              "value": "={{ $('Object').item.json.json_example_object }}"
            }
          ]
        },
        "options": {}
      },
      "id": "d8361785-2e9d-49df-a28a-bcb1dbe33fb2",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Final Exam",
      "type": "n8n-nodes-base.set",
      "creator": "Lucas Peyrin",
      "position": [
        -560,
        1008
      ],
      "typeVersion": 3.4,
      "notes": "© 2025 Lucas Peyrin"
    },
    {
      "parameters": {
        "content": "#### 🎓 期末考：融會貫通\n\n最後一個節點使用表達式從**所有先前的節點**提取數據，從而創建一個最終物件。\n\n點擊此節點，查看每個欄位中的表達式。它完美地總結了你所學的所有內容。\n\n**恭喜！你現在已經掌握了 JSON 的基礎知識以及如何在 n8n 中使用它。 **",
        "height": 516,
        "width": 324,
        "color": 6
      },
      "id": "c3c871c2-786f-4edb-9450-8b504dd7bab0",
      "cid": "Ikx1Y2FzIFBleXJpbiI",
      "name": "Sticky Note9",
      "type": "n8n-nodes-base.stickyNote",
      "creator": "Lucas Peyrin",
      "position": [
        -672,
        656
      ],
      "typeVersion": 1,
      "notes": "© 2025 Lucas Peyrin"
    }
  ],
  "connections": {
    "Execute to Start": {
      "main": [
        [
          {
            "node": "Key & Value",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "String": {
      "main": [
        [
          {
            "node": "Number",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Key & Value": {
      "main": [
        [
          {
            "node": "String",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Number": {
      "main": [
        [
          {
            "node": "Boolean",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Boolean": {
      "main": [
        [
          {
            "node": "Null",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Array": {
      "main": [
        [
          {
            "node": "Object",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Object": {
      "main": [
        [
          {
            "node": "Using JSON (Expressions)",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Null": {
      "main": [
        [
          {
            "node": "Array",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Using JSON (Expressions)": {
      "main": [
        [
          {
            "node": "Final Exam",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "pinData": {},
  "meta": {
    "instanceId": "d135f5bcfa8bdece905b6d778df94a7be68624c12d1878e14ba64eeb17a04d82"
  }
}
```