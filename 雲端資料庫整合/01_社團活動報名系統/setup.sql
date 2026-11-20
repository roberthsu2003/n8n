-- =============================================================
-- 範例 01：社團活動報名系統
-- 在 Supabase ➔ SQL Editor 貼上全部內容並執行 (Run)
-- 可重複執行：會先刪除本範例的資料表再重建
-- =============================================================

DROP VIEW  IF EXISTS public.club_activity_seats;
DROP TABLE IF EXISTS public.club_registrations;
DROP TABLE IF EXISTS public.club_activities;

-- 1. 活動資料表
CREATE TABLE public.club_activities (
    id          BIGSERIAL PRIMARY KEY,
    title       TEXT        NOT NULL UNIQUE,   -- 活動名稱（表單下拉選單要一模一樣）
    club        TEXT        NOT NULL,          -- 主辦社團
    event_date  DATE        NOT NULL,          -- 活動日期
    location    TEXT        NOT NULL,          -- 地點
    capacity    INT         NOT NULL,          -- 名額上限
    fee         INT         NOT NULL DEFAULT 0 -- 報名費
);

-- 2. 報名資料表
CREATE TABLE public.club_registrations (
    id           BIGSERIAL PRIMARY KEY,
    activity_id  BIGINT      NOT NULL REFERENCES public.club_activities(id) ON DELETE CASCADE,
    student_name TEXT        NOT NULL,
    student_id   TEXT        NOT NULL,
    email        TEXT        NOT NULL,
    department   TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (activity_id, email)                -- 同一個 Email 不能重複報名同一個活動
);

-- 3. 檢視表 (View)：即時計算每個活動「已報名人數」與「剩餘名額」
--    Supabase 節點可以像讀資料表一樣讀取 View
CREATE VIEW public.club_activity_seats AS
SELECT
    a.id,
    a.title,
    a.club,
    a.event_date,
    a.location,
    a.capacity,
    a.fee,
    COUNT(r.id)::INT              AS registered,
    (a.capacity - COUNT(r.id))::INT AS remaining
FROM public.club_activities a
LEFT JOIN public.club_registrations r ON r.activity_id = a.id
GROUP BY a.id;

-- 4. 授權給 service_role（n8n Supabase 節點使用的金鑰），確保 REST API 可以存取
--    （DO 區塊：在非 Supabase 的 PostgreSQL 執行時會自動略過）
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
        GRANT SELECT, INSERT, UPDATE, DELETE ON public.club_activities, public.club_registrations TO service_role;
        GRANT SELECT ON public.club_activity_seats TO service_role;
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO service_role;
    END IF;
END $$;

-- 5. 測試資料：5 個活動（日期以今天為基準往後排）
INSERT INTO public.club_activities (title, club, event_date, location, capacity, fee) VALUES
    ('陽明山夜衝看星星',     '天文社',   CURRENT_DATE + 7,  '陽明山擎天崗',     20, 150),
    ('手沖咖啡入門體驗',     '咖啡研究社', CURRENT_DATE + 10, '學生活動中心 301', 12, 200),
    ('街舞基礎 Breaking 課', '熱舞社',   CURRENT_DATE + 14, '體育館舞蹈教室',   25, 0),
    ('桌遊之夜：狼人殺大會', '桌遊社',   CURRENT_DATE + 5,  '圖書館 B1 討論室', 10, 50),
    ('淨灘志工：八里海岸',   '服務學習社', CURRENT_DATE + 21, '新北八里挖子尾',   40, 0);

-- 6. 測試資料：已經有人報名的狀況
--    「桌遊之夜」名額 10 人、已報名 10 人 ➔ 用來測試「額滿」
--    「手沖咖啡」名額 12 人、已報名 11 人 ➔ 只剩最後 1 位
INSERT INTO public.club_registrations (activity_id, student_name, student_id, email, department)
SELECT a.id, s.name, s.sid, s.email, s.dept
FROM public.club_activities a
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
) AS s(title, name, sid, email, dept) ON s.title = a.title;

-- 7. 驗證：看看每個活動的剩餘名額
SELECT title, capacity, registered, remaining FROM public.club_activity_seats ORDER BY id;
