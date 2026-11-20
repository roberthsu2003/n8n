-- =============================================================
-- 範例 03：圖書館逾期還書提醒
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 借閱日期以「今天」為基準自動產生，可重複執行
-- 資料表與欄位都用中文命名，PostgreSQL 可以直接使用，不需要加雙引號
-- =============================================================

DROP TABLE IF EXISTS public.借閱紀錄;
DROP TABLE IF EXISTS public.館藏書籍;
DROP TABLE IF EXISTS public.圖書館讀者;

-- 1. 讀者
CREATE TABLE public.圖書館讀者 (
    編號      SERIAL PRIMARY KEY,
    姓名      TEXT NOT NULL,
    電子郵件  TEXT NOT NULL UNIQUE,
    電話      TEXT,
    讀者類型  TEXT NOT NULL DEFAULT '一般讀者'  -- 一般讀者 / 學生 / 樂齡
);

-- 2. 館藏
CREATE TABLE public.館藏書籍 (
    編號  SERIAL PRIMARY KEY,
    書名  TEXT NOT NULL,
    作者  TEXT NOT NULL,
    分類  TEXT NOT NULL,
    條碼  TEXT NOT NULL UNIQUE
);

-- 3. 借閱紀錄
CREATE TABLE public.借閱紀錄 (
    編號          SERIAL PRIMARY KEY,
    讀者編號      INT  NOT NULL REFERENCES public.圖書館讀者(編號),
    書籍編號      INT  NOT NULL REFERENCES public.館藏書籍(編號),
    借出日期      DATE NOT NULL,
    應還日期      DATE NOT NULL,           -- 借期 21 天
    歸還日期      DATE,                    -- NULL（空白）代表還沒還
    最後提醒日期  DATE,                    -- 最後一次寄提醒信的日期（防止同一天重複寄）
    提醒次數      INT  NOT NULL DEFAULT 0  -- 已經提醒過幾次
);

INSERT INTO public.圖書館讀者 (姓名, 電子郵件, 電話, 讀者類型) VALUES
    ('陳怡君', 'yijun.chen@example.com',   '0912-100-201', '一般讀者'),
    ('林俊傑', 'junjie.lin@example.com',   '0912-100-202', '一般讀者'),
    ('黃淑芬', 'shufen.huang@example.com', '0912-100-203', '樂齡'),
    ('張志明', 'zhiming.chang@example.com','0912-100-204', '一般讀者'),
    ('李佳穎', 'chiaying.lee@example.com', '0912-100-205', '學生'),
    ('王建國', 'chienkuo.wang@example.com','0912-100-206', '樂齡'),
    ('吳雅婷', 'yating.wu@example.com',    '0912-100-207', '學生'),
    ('劉家豪', 'chiahao.liu@example.com',  '0912-100-208', '一般讀者'),
    ('蔡宜蓁', 'yizhen.tsai@example.com',  '0912-100-209', '學生'),
    ('楊宗翰', 'tsunghan.yang@example.com','0912-100-210', '一般讀者'),
    ('許美玲', 'meiling.hsu@example.com',  '0912-100-211', '樂齡'),
    ('鄭凱文', 'kaiwen.cheng@example.com', '0912-100-212', '學生'),
    ('謝欣妤', 'hsinyu.hsieh@example.com', '0912-100-213', '一般讀者'),
    ('郭冠廷', 'kuanting.kuo@example.com', '0912-100-214', '學生'),
    ('洪詩涵', 'shihan.hung@example.com',  '0912-100-215', '一般讀者'),
    ('邱柏宇', 'boyu.chiu@example.com',    '0912-100-216', '學生'),
    ('曾雅雯', 'yawen.tseng@example.com',  '0912-100-217', '一般讀者'),
    ('廖文彬', 'wenpin.liao@example.com',  '0912-100-218', '樂齡'),
    ('賴佩珊', 'peishan.lai@example.com',  '0912-100-219', '學生'),
    ('周子豪', 'zihao.chou@example.com',   '0912-100-220', '一般讀者'),
    ('徐靜宜', 'chingyi.hsu@example.com',  '0912-100-221', '一般讀者'),
    ('蘇哲宇', 'cheyu.su@example.com',     '0912-100-222', '學生'),
    ('莊惠如', 'huiju.chuang@example.com', '0912-100-223', '樂齡'),
    ('呂承恩', 'chengen.lu@example.com',   '0912-100-224', '學生'),
    ('江雨萱', 'yuhsuan.chiang@example.com','0912-100-225', '一般讀者'),
    ('何俊賢', 'junhsien.ho@example.com',  '0912-100-226', '一般讀者'),
    ('葉思妤', 'ssuyu.yeh@example.com',    '0912-100-227', '學生'),
    ('方信宏', 'hsinhung.fang@example.com','0912-100-228', '樂齡'),
    ('石佳蓉', 'chiajung.shih@example.com','0912-100-229', '一般讀者'),
    ('高偉倫', 'weilun.kao@example.com',   '0912-100-230', '學生');

INSERT INTO public.館藏書籍 (書名, 作者, 分類, 條碼) VALUES
    ('原子習慣',                     '詹姆斯．克利爾',   '心理勵志', 'B0001'),
    ('被討厭的勇氣',                 '岸見一郎、古賀史健', '心理勵志', 'B0002'),
    ('蛤蟆先生去看心理師',           '羅伯．狄保德',     '心理勵志', 'B0003'),
    ('底層邏輯',                     '劉潤',             '商業理財', 'B0004'),
    ('致富心態',                     '摩根．豪瑟',       '商業理財', 'B0005'),
    ('窮爸爸富爸爸',                 '羅勃特．T．清崎',  '商業理財', 'B0006'),
    ('解憂雜貨店',                   '東野圭吾',         '文學小說', 'B0007'),
    ('嫌疑犯X的獻身',                '東野圭吾',         '文學小說', 'B0008'),
    ('三體',                         '劉慈欣',           '文學小說', 'B0009'),
    ('小王子',                       '安東尼．聖修伯里', '文學小說', 'B0010'),
    ('天橋上的魔術師',               '吳明益',           '文學小說', 'B0011'),
    ('哈利波特：神秘的魔法石',       'J.K. 羅琳',        '文學小說', 'B0012'),
    ('人類大歷史',                   '哈拉瑞',           '人文史地', 'B0013'),
    ('槍炮、病菌與鋼鐵',             '賈德．戴蒙',       '人文史地', 'B0014'),
    ('真確',                         '漢斯．羅斯林',     '人文史地', 'B0015'),
    ('Python 程式設計入門',          '洪錦魁',           '電腦資訊', 'B0016'),
    ('n8n 自動化實戰',               '王小明',           '電腦資訊', 'B0017'),
    ('資料庫系統概論',               '陳大同',           '電腦資訊', 'B0018'),
    ('深度學習的數學',               '涌井良幸',         '電腦資訊', 'B0019'),
    ('ChatGPT 提示工程',             '林小華',           '電腦資訊', 'B0020'),
    ('一個人的料理日常',             '小田真規子',       '生活風格', 'B0021'),
    ('怦然心動的人生整理魔法',       '近藤麻理惠',       '生活風格', 'B0022'),
    ('台灣野鳥圖鑑',                 '廖本興',           '自然科普', 'B0023'),
    ('時間簡史',                     '史蒂芬．霍金',     '自然科普', 'B0024'),
    ('自私的基因',                   '理查．道金斯',     '自然科普', 'B0025'),
    ('灌籃高手 1',                   '井上雄彥',         '漫畫',     'B0026'),
    ('航海王 1',                     '尾田榮一郎',       '漫畫',     'B0027'),
    ('進擊的巨人 1',                 '諫山創',           '漫畫',     'B0028'),
    ('好餓的毛毛蟲',                 '艾瑞．卡爾',       '兒童繪本', 'B0029'),
    ('猜猜我有多愛你',               '山姆．麥克布雷尼', '兒童繪本', 'B0030');

-- 4. 借閱紀錄：刻意安排各種狀況，方便測試 SQL 條件
--    幾天前借：今天往前推幾天借出；應還日期 = 借出日期 + 21 天
INSERT INTO public.借閱紀錄 (讀者編號, 書籍編號, 借出日期, 應還日期, 歸還日期, 最後提醒日期, 提醒次數)
SELECT 讀者編號, 書籍編號,
       CURRENT_DATE - 幾天前借,
       CURRENT_DATE - 幾天前借 + 21,
       CASE WHEN 幾天前還 IS NULL THEN NULL ELSE CURRENT_DATE - 幾天前還 END,
       CASE WHEN 幾天前提醒 IS NULL THEN NULL ELSE CURRENT_DATE - 幾天前提醒 END,
       提醒次數
FROM (VALUES
    -- 【已歸還】不應該被提醒
    ( 1,  1, 40, 25,   NULL, 0),
    ( 2,  7, 35, 20,   NULL, 0),
    ( 3, 13, 30, 10,   NULL, 0),
    ( 4, 16, 50, 15,   3,    1),   -- 逾期後被提醒過，後來還了
    ( 5, 26, 25,  2,   NULL, 0),
    -- 【借閱中、還沒到期】不應該被提醒
    ( 6,  2,  3, NULL, NULL, 0),
    ( 7,  8,  8, NULL, NULL, 0),
    ( 8,  9, 12, NULL, NULL, 0),
    ( 9, 21, 15, NULL, NULL, 0),
    (10, 29, 20, NULL, NULL, 0),   -- 明天到期
    (11, 30, 21, NULL, NULL, 0),   -- 今天到期（還沒逾期）
    -- 【逾期 1～3 天】第一次提醒
    (12,  3, 22, NULL, NULL, 0),   -- 逾期 1 天
    (13, 17, 23, NULL, NULL, 0),   -- 逾期 2 天
    (14, 27, 24, NULL, NULL, 0),   -- 逾期 3 天
    -- 【逾期 7～14 天】已經提醒過，但不是今天
    (15,  4, 28, NULL, 4,    1),   -- 逾期 7 天
    (16, 10, 31, NULL, 3,    2),   -- 逾期 10 天
    (17, 18, 35, NULL, 7,    2),   -- 逾期 14 天
    -- 【今天已經提醒過】同一天不應該再寄
    (18,  5, 29, NULL, 0,    2),   -- 逾期 8 天，今天寄過了
    -- 【嚴重逾期 30 天以上】
    (19, 14, 52, NULL, 5,    4),   -- 逾期 31 天
    (20, 19, 66, NULL, 2,    6),   -- 逾期 45 天
    -- 同一位讀者借了好幾本都逾期
    (21, 11, 26, NULL, NULL, 0),   -- 逾期 5 天
    (21, 12, 26, NULL, NULL, 0),   -- 逾期 5 天
    (21, 28, 26, NULL, NULL, 0)    -- 逾期 5 天
) AS t(讀者編號, 書籍編號, 幾天前借, 幾天前還, 幾天前提醒, 提醒次數);

-- 5. 驗證：今天應該提醒的借閱（應有 11 本書、9 位讀者）
SELECT l.編號, m.姓名, b.書名, l.應還日期,
       CURRENT_DATE - l.應還日期 AS 逾期天數,
       l.最後提醒日期
FROM public.借閱紀錄 l
JOIN public.圖書館讀者 m ON m.編號 = l.讀者編號
JOIN public.館藏書籍   b ON b.編號 = l.書籍編號
WHERE l.歸還日期 IS NULL
  AND l.應還日期 < CURRENT_DATE
  AND (l.最後提醒日期 IS NULL OR l.最後提醒日期 < CURRENT_DATE)
ORDER BY 逾期天數 DESC;
