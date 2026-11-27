-- =============================================================
-- 範例 01：社團活動報名系統
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 可重複執行：會先刪除本範例的資料表再重建
-- 資料表與欄位都用中文命名，PostgreSQL 可以直接使用，不需要加雙引號
-- =============================================================

SET TIME ZONE 'Asia/Taipei';

DROP VIEW  IF EXISTS public.活動剩餘名額;
DROP TABLE IF EXISTS public.社團報名;
DROP TABLE IF EXISTS public.社團活動;

-- 1. 活動資料表
CREATE TABLE public.社團活動 (
    編號      BIGSERIAL PRIMARY KEY,
    活動名稱  TEXT NOT NULL UNIQUE,     -- 表單下拉選單的文字要一模一樣
    主辦社團  TEXT NOT NULL,
    活動日期  DATE NOT NULL,
    地點      TEXT NOT NULL,
    名額上限  INT  NOT NULL,
    報名費    INT  NOT NULL DEFAULT 0
);

-- 2. 報名資料表
CREATE TABLE public.社團報名 (
    編號      BIGSERIAL PRIMARY KEY,
    活動編號  BIGINT      NOT NULL REFERENCES public.社團活動(編號) ON DELETE CASCADE,
    姓名      TEXT        NOT NULL,
    學號      TEXT        NOT NULL,
    電子郵件  TEXT        NOT NULL,
    科系      TEXT,
    報名時間  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (活動編號, 電子郵件)          -- 同一個 Email 不能重複報名同一個活動
);

-- 3. 檢視表 (View)：即時計算每個活動「已報名人數」與「剩餘名額」
--    Supabase 節點可以像讀資料表一樣讀取 View
CREATE VIEW public.活動剩餘名額 AS
SELECT
    a.編號,
    a.活動名稱,
    a.主辦社團,
    a.活動日期,
    a.地點,
    a.名額上限,
    a.報名費,
    COUNT(r.編號)::INT                AS 已報名人數,
    (a.名額上限 - COUNT(r.編號))::INT AS 剩餘名額
FROM public.社團活動 a
LEFT JOIN public.社團報名 r ON r.活動編號 = a.編號
GROUP BY a.編號;

-- 4. 授權給 service_role（n8n Supabase 節點使用的金鑰），確保 REST API 可以存取
--    （DO 區塊：在非 Supabase 的 PostgreSQL 執行時會自動略過）
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
        GRANT SELECT, INSERT, UPDATE, DELETE ON public.社團活動, public.社團報名 TO service_role;
        GRANT SELECT ON public.活動剩餘名額 TO service_role;
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO service_role;
    END IF;
END $$;

-- 5. 測試資料：5 個活動（日期以今天為基準往後排）
INSERT INTO public.社團活動 (活動名稱, 主辦社團, 活動日期, 地點, 名額上限, 報名費) VALUES
    ('陽明山夜衝看星星',     '天文社',   CURRENT_DATE + 7,  '陽明山擎天崗',     20, 150),
    ('手沖咖啡入門體驗',     '咖啡研究社', CURRENT_DATE + 10, '學生活動中心 301', 12, 200),
    ('街舞基礎 Breaking 課', '熱舞社',   CURRENT_DATE + 14, '體育館舞蹈教室',   25, 0),
    ('桌遊之夜：狼人殺大會', '桌遊社',   CURRENT_DATE + 5,  '圖書館 B1 討論室', 10, 50),
    ('淨灘志工：八里海岸',   '服務學習社', CURRENT_DATE + 21, '新北八里挖子尾',   40, 0);

-- 6. 測試資料：已經有人報名的狀況
--    「桌遊之夜」名額 10 人、已報名 10 人 ➔ 用來測試「額滿」
--    「手沖咖啡」名額 12 人、已報名 11 人 ➔ 只剩最後 1 位
INSERT INTO public.社團報名 (活動編號, 姓名, 學號, 電子郵件, 科系)
SELECT a.編號, s.姓名, s.學號, s.電子郵件, s.科系
FROM public.社團活動 a
JOIN (VALUES
    ('桌遊之夜：狼人殺大會', '林冠宇', 'B11201001', 'guanyu.lin@example.com',   '資訊工程系'),
    ('桌遊之夜：狼人殺大會', '陳品妤', 'B11201002', 'pinyu.chen@example.com',   '企業管理系'),
    ('桌遊之夜：狼人殺大會', '黃柏翰', 'B11201003', 'bohan.huang@example.com',  '機械工程系'),
    ('桌遊之夜：狼人殺大會', '張語彤', 'B11201004', 'yutong.chang@example.com', '應用外語系'),
    ('桌遊之夜：狼人殺大會', '李承恩', 'B11201005', 'chengen.lee@example.com',  '電機工程系'),
    ('桌遊之夜：狼人殺大會', '王思妍', 'B11201006', 'siyan.wang@example.com',   '財務金融系'),
    ('桌遊之夜：狼人殺大會', '吳宥廷', 'B11201007', 'youting.wu@example.com',   '資訊管理系'),
    ('桌遊之夜：狼人殺大會', '劉芷晴', 'B11201008', 'zhiqing.liu@example.com',  '視覺傳達系'),
    ('桌遊之夜：狼人殺大會', '蔡宇翔', 'B11201009', 'yuxiang.tsai@example.com', '土木工程系'),
    ('桌遊之夜：狼人殺大會', '鄭安琪', 'B11201010', 'anchi.cheng@example.com',  '護理系'),
    ('手沖咖啡入門體驗',     '周子軒', 'B11202001', 'zixuan.chou@example.com',  '餐飲管理系'),
    ('手沖咖啡入門體驗',     '徐若瑜', 'B11202002', 'ruoyu.hsu@example.com',    '觀光系'),
    ('手沖咖啡入門體驗',     '孫浩然', 'B11202003', 'haoran.sun@example.com',   '資訊工程系'),
    ('手沖咖啡入門體驗',     '馬詩涵', 'B11202004', 'shihan.ma@example.com',    '企業管理系'),
    ('手沖咖啡入門體驗',     '朱俊宏', 'B11202005', 'junhong.chu@example.com',  '電機工程系'),
    ('手沖咖啡入門體驗',     '胡家瑜', 'B11202006', 'chiayu.hu@example.com',    '應用外語系'),
    ('手沖咖啡入門體驗',     '郭彥廷', 'B11202007', 'yenting.kuo@example.com',  '機械工程系'),
    ('手沖咖啡入門體驗',     '何欣怡', 'B11202008', 'hsinyi.ho@example.com',    '財務金融系'),
    ('手沖咖啡入門體驗',     '高睿哲', 'B11202009', 'ruizhe.kao@example.com',   '資訊管理系'),
    ('手沖咖啡入門體驗',     '羅子晴', 'B11202010', 'ziqing.lo@example.com',    '視覺傳達系'),
    ('手沖咖啡入門體驗',     '謝承翰', 'B11202011', 'chenghan.hsieh@example.com','餐飲管理系'),
    ('陽明山夜衝看星星',     '楊雅筑', 'B11203001', 'yachu.yang@example.com',   '物理系'),
    ('陽明山夜衝看星星',     '許家豪', 'B11203002', 'chiahao.hsu@example.com',  '資訊工程系'),
    ('陽明山夜衝看星星',     '曾詠晴', 'B11203003', 'yungching.tseng@example.com','護理系'),
    ('街舞基礎 Breaking 課', '潘冠廷', 'B11204001', 'kuanting.pan@example.com', '體育系'),
    ('街舞基礎 Breaking 課', '簡郁婷', 'B11204002', 'yuting.chien@example.com', '應用外語系')
) AS s(活動名稱, 姓名, 學號, 電子郵件, 科系) ON s.活動名稱 = a.活動名稱;

-- 7. 驗證：看看每個活動的剩餘名額
SELECT 活動名稱, 名額上限, 已報名人數, 剩餘名額 FROM public.活動剩餘名額 ORDER BY 編號;
