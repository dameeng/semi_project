-- ==============================================
-- 부평역사쇼핑몰 - 전체 스키마 + 더미데이터 (병합본)
-- 생성일: 2026-08-10 (기준일)
-- PostgreSQL 기준 작성 (SERIAL / BIGSERIAL / NOW() / INTERVAL 사용)
-- ==============================================

-- ==============================================
-- 기존 테이블 초기화
-- ==============================================
DROP TABLE IF EXISTS prepaid CASCADE;
DROP TABLE IF EXISTS store_discounts CASCADE;
DROP TABLE IF EXISTS parking_records CASCADE;
DROP TABLE IF EXISTS parking_spots CASCADE;
DROP TABLE IF EXISTS fee_policies CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS board CASCADE;
DROP TABLE IF EXISTS notice CASCADE;
DROP TABLE IF EXISTS qna CASCADE;
DROP TABLE IF EXISTS faq CASCADE;
DROP TABLE IF EXISTS usermember CASCADE;
DROP TABLE IF EXISTS stores CASCADE;

-- 1. 통합 회원 테이블 (usermember)
CREATE TABLE usermember (
    seq SERIAL PRIMARY KEY,
    id VARCHAR(50) NOT NULL UNIQUE,
    pw VARCHAR(100) NOT NULL,
    name VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    carTypes VARCHAR(30),
    carNum VARCHAR(15),
    auth INT NOT NULL DEFAULT 3,
    storeNum INT
);


-- 2. 입점 점포 테이블 (stores)
CREATE TABLE stores (
    storeNum SERIAL PRIMARY KEY,
    storeName VARCHAR(50) NOT NULL UNIQUE,
    floor INT NOT NULL,
    id VARCHAR(50) REFERENCES usermember(id) ON DELETE SET NULL,
    contact VARCHAR(20) NOT NULL
);

ALTER TABLE usermember
ADD CONSTRAINT fk_usermember_storeNum
FOREIGN KEY (storeNum) REFERENCES stores(storeNum) ON DELETE SET NULL;

ALTER TABLE usermember
ADD CONSTRAINT uq_usermember_storenum UNIQUE (storeNum);
-- 3. 자유게시판 테이블 (board)
CREATE TABLE board (
    seq BIGSERIAL PRIMARY KEY,
    writerid VARCHAR(50) NOT NULL REFERENCES usermember(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    readcount INT NOT NULL DEFAULT 0,
    ispinned BOOLEAN NOT NULL DEFAULT FALSE,
    wdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. 댓글 테이블 (comments)
CREATE TABLE comments (
    seq SERIAL PRIMARY KEY,
    board_seq BIGINT NOT NULL REFERENCES board(seq) ON DELETE CASCADE,
    writerid VARCHAR(50) NOT NULL REFERENCES usermember(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    wdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5. 공지사항 테이블 (notice)
CREATE TABLE notice (
    seq BIGSERIAL PRIMARY KEY,
    id VARCHAR(50) NOT NULL REFERENCES usermember(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    readcount INT NOT NULL DEFAULT 0,
    ispinned BOOLEAN NOT NULL DEFAULT FALSE,
    wdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. Q&A 게시판 테이블 (qna)
CREATE TABLE qna (
    seq BIGSERIAL PRIMARY KEY,
    id VARCHAR(50) NOT NULL REFERENCES usermember(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    readcount INT NOT NULL DEFAULT 0,
    issecret BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(20) NOT NULL DEFAULT 'WAITING',
    replycontent TEXT,
    replydate TIMESTAMP,
    wdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 7. FAQ 테이블 (faq)
CREATE TABLE faq (
    faqid SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    id VARCHAR(50) NOT NULL DEFAULT 'admin' REFERENCES usermember(id),
    wdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 8. 상가 주차장 요금 정책 테이블 (fee_policies)
CREATE TABLE fee_policies (
    policyId SERIAL PRIMARY KEY,
    gracePeriod INT NOT NULL DEFAULT 15,
    baseTime INT NOT NULL DEFAULT 30,
    baseFee INT NOT NULL DEFAULT 1000,
    extraTime INT NOT NULL DEFAULT 10,
    extraFee INT NOT NULL DEFAULT 1000,
    dailyMax INT NOT NULL DEFAULT 30000,
    id VARCHAR(50) REFERENCES usermember(id) ON DELETE SET NULL
);

-- 9. 입출차 및 주차 위치 기록 테이블 (parking_records)
CREATE TABLE parking_records (
    recordId BIGSERIAL PRIMARY KEY,
    carNum VARCHAR(15),
    carTypes VARCHAR(30),
    parkingFloor INT NOT NULL,
    parkingZone VARCHAR(20),
    parkingType VARCHAR(20) NOT NULL DEFAULT 'general',
    entryTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    exitTime TIMESTAMP,
    totalMin INT,
    rawFee INT DEFAULT 0,
    discountFee INT DEFAULT 0,
    finalFee INT DEFAULT 0,
    id VARCHAR(50) REFERENCES usermember(id) ON DELETE SET NULL
);

-- 10. 주차 자리(구역) 마스터 테이블 (parking_spots)
CREATE TABLE parking_spots (
    spotId VARCHAR(20) PRIMARY KEY,
    parkingFloor INT NOT NULL,
    section VARCHAR(10) NOT NULL,
    parkingType VARCHAR(20) NOT NULL DEFAULT 'general',
    recordId BIGINT UNIQUE REFERENCES parking_records(recordId) ON DELETE SET NULL,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. 상가 점포 할인 적용 내역 테이블 (store_discounts)
CREATE TABLE store_discounts (
    discountId BIGSERIAL PRIMARY KEY,
    recordId BIGINT NOT NULL REFERENCES parking_records(recordId) ON DELETE CASCADE,
    storeNum INT NOT NULL REFERENCES stores(storeNum) ON DELETE CASCADE,
    freeMin INT NOT NULL DEFAULT 0,
    id VARCHAR(50) REFERENCES usermember(id) ON DELETE SET NULL,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_store_discounts_record_store UNIQUE (recordId, storeNum),
    CONSTRAINT chk_store_discounts_max_2hr CHECK (freeMin >= 0 AND freeMin <= 120)
);

-- 12. 정기권 및 상주 차량 테이블 (prepaid)
CREATE TABLE prepaid (
    regId SERIAL PRIMARY KEY,
    userId VARCHAR(50) REFERENCES usermember(id) ON DELETE SET NULL,
    carNum VARCHAR(15) NOT NULL,
    ownerName VARCHAR(50) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'requested',
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    price INT NOT NULL DEFAULT 0
);

-- ==========================================
-- 1. 회원 데이터 (usermember) — admin 계정은 admin 1개만 존재
-- ==========================================
INSERT INTO usermember (id, pw, name, email, carTypes, carNum, auth, storeNum) VALUES
('admin',  '1234', '총괄관리자', 'admin@mbc.com',   '일반',   '00가0000', 1, NULL),
('owner01','1234', '김베이커리', 'owner01@mbc.com', '일반',   '11가1111', 2, NULL),
('owner02','1234', '이카페',    'owner02@mbc.com', '전기차', '22나2222', 2, NULL),
('owner03','1234', '박식당',    'owner03@mbc.com', '임산부', '33다3333', 2, NULL),
('owner04','1234', '최헤어',    'owner04@mbc.com', '장애인', '44라4444', 2, NULL),
('owner05','1234', '정과일',    'owner05@mbc.com', '일반',   '12마1212', 2, NULL),
('owner06','1234', '한서점',    'owner06@mbc.com', '전기차', '13바1313', 2, NULL),
('user01', '1234', '홍길동',    'user01@mbc.com',  '일반',   '55마5555', 3, NULL),
('user02', '1234', '강감찬',    'user02@mbc.com',  '전기차', '66바6666', 3, NULL),
('user03', '1234', '신사임당',  'user03@mbc.com',  '임산부', '77사7777', 3, NULL),
('user04', '1234', '유관순',    'user04@mbc.com',  '장애인', '88아8888', 3, NULL),
('user05', '1234', '이순신',    'user05@mbc.com',  '일반',   '99자9999', 3, NULL),
('user06', '1234', '정약용',    'user06@mbc.com',  '일반',   '10차1010', 3, NULL),
('user07', '1234', '김유신',    'user07@mbc.com',  '전기차', '21카2121', 3, NULL),
('user08', '1234', '장영실',    'user08@mbc.com',  '일반',   '32타3232', 3, NULL),
('user09', '1234', '허준',      'user09@mbc.com',  '임산부', '43파4343', 3, NULL),
('user10', '1234', '문익점',    'user10@mbc.com',  '장애인', '54하5454', 3, NULL),
('user11', '1234', '김만덕',    'user11@mbc.com',  '일반',   '65거6565', 3, NULL),
('user12', '1234', '전봉준',    'user12@mbc.com',  '일반',   '76너7676', 3, NULL),
('user13', '1234', '유일한',    'user13@mbc.com',  '전기차', '87더8787', 3, NULL),
('user14', '1234', '이황',      'user14@mbc.com',  '일반',   '98나6789', 3, NULL),
('user15', '1234', '이이',      'user15@mbc.com',  '전기차', '87다6543', 3, NULL),
('user16', '1234', '정몽주',    'user16@mbc.com',  '임산부', '76마2345', 3, NULL),
('user17', '1234', '최영',      'user17@mbc.com',  '장애인', '65바5432', 3, NULL),
('user18', '1234', '을지문덕',  'user18@mbc.com',  '일반',   '54사6543', 3, NULL),
('user19', '1234', '연개소문',  'user19@mbc.com',  '전기차', '43아3456', 3, NULL),
('user20', '1234', '계백',      'user20@mbc.com',  '일반',   '32자7654', 3, NULL),
('user21', '1234', '광개토대왕','user21@mbc.com',  '임산부', '21차8765', 3, NULL),
('user22', '1234', '세종대왕',  'user22@mbc.com',  '장애인', '10카9876', 3, NULL);

-- ==========================================
-- 1-1. 추가 점주 계정 (owner07~owner28)
-- 상가 28개 전부 auth=2(상인) 전용 계정이 소유하도록, 상가 개수만큼 점주 계정을 늘림.
-- user01~22는 순수 일반회원(auth=3)으로 유지하고 상가를 소유하지 않음.
-- ==========================================
INSERT INTO usermember (id, pw, name, email, carTypes, carNum, auth, storeNum) VALUES
('owner07', '1234', '김약사',     'owner07@mbc.com', '일반',   '07가0700', 2, NULL),
('owner08', '1234', '박안경',     'owner08@mbc.com', '전기차', '08가0800', 2, NULL),
('owner09', '1234', '최네일',     'owner09@mbc.com', '임산부', '09가0900', 2, NULL),
('owner10', '1234', '정세탁',     'owner10@mbc.com', '일반',   '10나1000', 2, NULL),
('owner11', '1234', '강모바일',   'owner11@mbc.com', '전기차', '11나1100', 2, NULL),
('owner12', '1234', '조치과',     'owner12@mbc.com', '일반',   '12나1200', 2, NULL),
('owner13', '1234', '남피트',     'owner13@mbc.com', '장애인', '13다1300', 2, NULL),
('owner14', '1234', '유꽃집',     'owner14@mbc.com', '일반',   '14다1400', 2, NULL),
('owner15', '1234', '김골프',     'owner15@mbc.com', '전기차', '15다1500', 2, NULL),
('owner16', '1234', '이국수',     'owner16@mbc.com', '일반',   '16라1600', 2, NULL),
('owner17', '1234', '박아이스',   'owner17@mbc.com', '일반',   '17라1700', 2, NULL),
('owner18', '1234', '최만화',     'owner18@mbc.com', '임산부', '18라1800', 2, NULL),
('owner19', '1234', '정네일아트', 'owner19@mbc.com', '일반',   '19마1900', 2, NULL),
('owner20', '1234', '강시계',     'owner20@mbc.com', '장애인', '20마2000', 2, NULL),
('owner21', '1234', '조영화',     'owner21@mbc.com', '일반',   '21마2100', 2, NULL),
('owner22', '1234', '남오락',     'owner22@mbc.com', '전기차', '22바2200', 2, NULL),
('owner23', '1234', '유스포츠',   'owner23@mbc.com', '일반',   '23바2300', 2, NULL),
('owner24', '1234', '김지에스',   'owner24@mbc.com', '일반',   '24바2400', 2, NULL),
('owner25', '1234', '이옥상',     'owner25@mbc.com', '전기차', '25사2500', 2, NULL),
('owner26', '1234', '박펫샵',     'owner26@mbc.com', '일반',   '26사2600', 2, NULL),
('owner27', '1234', '최이벤트',   'owner27@mbc.com', '임산부', '27사2700', 2, NULL),
('owner28', '1234', '정문구',     'owner28@mbc.com', '일반',   '28아2800', 2, NULL);

-- ==========================================
-- 2. 입점 점포 데이터 (stores) - 총 28개, 층당 4개씩 (1~7층)
-- ==========================================
INSERT INTO stores (storeName, floor, id, contact) VALUES
('부평 베이커리', 1, 'owner01', '032-111-0001'),
('MBC 카페',     1, 'owner02', '032-111-0002'),
('맛있는 식당',   1, 'owner03', '032-111-0003'),
('행복 약국',     1, 'owner07', '032-111-0004'),
('스타일 헤어',   2, 'owner04', '032-111-0005'),
('스마트 안경원', 2, 'owner08', '032-111-0006'),
('부평 네일숍',   2, 'owner09', '032-111-0007'),
('클린 세탁소',   2, 'owner10', '032-111-0008'),
('모바일 스토어', 3, 'owner11', '032-111-0009'),
('올바른 치과',   3, 'owner12', '032-111-0010'),
('피트니스 클럽', 3, 'owner13', '032-111-0011'),
('플라워 샵',     3, 'owner14', '032-111-0012'),
('청과물마트',    4, 'owner05', '032-111-0013'),
('부평 서점',     4, 'owner06', '032-111-0014'),
('스크린골프존',  4, 'owner15', '032-111-0015'),
('국숫집',        4, 'owner16', '032-111-0016'),
('아이스크림 전문점', 5, 'owner17', '032-111-0017'),
('만화카페',      5, 'owner18', '032-111-0018'),
('네일아트샵',    5, 'owner19', '032-111-0019'),
('시계수선점',    5, 'owner20', '032-111-0020'),
('부평 영화관',   6, 'owner21', '032-111-0021'),
('오락실',        6, 'owner22', '032-111-0022'),
('스포츠용품점',  6, 'owner23', '032-111-0023'),
('편의점 GS25',   6, 'owner24', '032-111-0024'),
('옥상정원 카페', 7, 'owner25', '032-111-0025'),
('반려동물샵',    7, 'owner26', '032-111-0026'),
('이벤트홀',      7, 'owner27', '032-111-0027'),
('문구점',        7, 'owner28', '032-111-0028');

-- ==========================================
-- 3. 회원 - 점포 매핑 (storeNum은 위 INSERT 순서 기준: 1~28)
-- ==========================================
UPDATE usermember SET storeNum = 1  WHERE id = 'owner01';
UPDATE usermember SET storeNum = 2  WHERE id = 'owner02';
UPDATE usermember SET storeNum = 3  WHERE id = 'owner03';
UPDATE usermember SET storeNum = 4  WHERE id = 'owner07';
UPDATE usermember SET storeNum = 5  WHERE id = 'owner04';
UPDATE usermember SET storeNum = 6  WHERE id = 'owner08';
UPDATE usermember SET storeNum = 7  WHERE id = 'owner09';
UPDATE usermember SET storeNum = 8  WHERE id = 'owner10';
UPDATE usermember SET storeNum = 9  WHERE id = 'owner11';
UPDATE usermember SET storeNum = 10 WHERE id = 'owner12';
UPDATE usermember SET storeNum = 13 WHERE id = 'owner05';
UPDATE usermember SET storeNum = 14 WHERE id = 'owner06';
UPDATE usermember SET storeNum = 15 WHERE id = 'owner15';
UPDATE usermember SET storeNum = 16 WHERE id = 'owner16';
UPDATE usermember SET storeNum = 18 WHERE id = 'owner18';
UPDATE usermember SET storeNum = 19 WHERE id = 'owner19';
UPDATE usermember SET storeNum = 21 WHERE id = 'owner21';
UPDATE usermember SET storeNum = 22 WHERE id = 'owner22';
UPDATE usermember SET storeNum = 25 WHERE id = 'owner25';
UPDATE usermember SET storeNum = 11 WHERE id = 'owner13';
UPDATE usermember SET storeNum = 12 WHERE id = 'owner14';
UPDATE usermember SET storeNum = 17 WHERE id = 'owner17';
UPDATE usermember SET storeNum = 20 WHERE id = 'owner20';
UPDATE usermember SET storeNum = 23 WHERE id = 'owner23';
UPDATE usermember SET storeNum = 24 WHERE id = 'owner24';
UPDATE usermember SET storeNum = 26 WHERE id = 'owner26';
UPDATE usermember SET storeNum = 27 WHERE id = 'owner27';
UPDATE usermember SET storeNum = 28 WHERE id = 'owner28';

-- ==========================================
-- 4. 게시판 및 고객센터 (고정된 개별 날짜 및 다양한 시/분/초 적용)
-- ==========================================

-- 자유게시판 (board)
INSERT INTO board (writerid, title, content, readcount, wdate) VALUES 
('user01', '자유게시판 첫 번째 글입니다.', '안녕하세요. 가입 인사드립니다.', 15, '2026-07-20 09:14:22'),
('user02', '오늘 주차장 이용해보신 분?', '1층 주차 구역 혼잡도가 궁금합니다.', 23, '2026-07-22 14:05:10'),
('user03', '베이커리 매장 추천해요', '1층 빵집 너무 맛있네요!', 45, '2026-07-23 18:30:45'),
('owner01', '신메뉴 출시 안내입니다.', '갓 구운 소금빵 맛보러 오세요.', 89, '2026-07-25 11:12:00'),
('owner02', '카페 할인 이벤트 진행중', '주차 등록 시 아메리카노 10% 할인해드립니다.', 102, '2026-07-27 16:45:33'),
('user04', '전기차 충전소 속도 어떤가요?', '급속 충전 잘 되는지 궁금합니다.', 18, '2026-07-28 08:20:15'),
('user05', '주차비 정산 앱 오류 문의', '사전 정산기 관련 질문이 있습니다.', 30, '2026-07-29 13:50:00'),
('user06', '3층 치과 친절하네요', '스케일링 잘 받고 갑니다.', 12, '2026-07-30 19:04:12'),
('admin', '게시판 이용 수칙 안내', '클린한 게시판 문화를 만들어주세요.', 210, '2026-08-01 10:30:25'),
('owner03', '식당 신규 오픈했습니다.', '점심 특선 메뉴 구성 공유합니다.', 67, '2026-08-02 15:15:40'),
('user01', '주차 정산 꿀팁 공유', '상가 영수증 합산 할인 팁입니다.', 94, '2026-08-04 12:00:00'),
('user02', '주차 공간 쾌적해서 좋네요', 'A구역 조명이 밝아서 좋습니다.', 8, '2026-08-05 17:22:11'),
('user07', '전기차 충전 자리가 부족해요', '충전 구역이 자주 만차인 것 같습니다. 확충 부탁드려요.', 20, '2026-08-08 09:40:05'),
('owner05', '청과물 신선하게 입고했어요', '오늘 아침 신선한 과일 많이 들어왔습니다. 많이 이용해주세요!', 33, '2026-08-09 07:15:30'),
('user08', '장애인 주차구역 좀 지켜주세요', '일반 차량이 장애인 구역에 주차되어 있는 경우가 많습니다.', 27, '2026-08-10 06:50:00');

-- 댓글 (comments)
INSERT INTO comments (board_seq, writerid, content, wdate) VALUES 
(1, 'user02', '반갑습니다! 자주 소통해요.', '2026-07-20 10:05:11'),
(1, 'user03', '어서오세요 환영합니다!', '2026-07-20 11:42:00'),
(2, 'owner01', '1층은 오전 11시 이후로 조금 붐비는 편입니다.', '2026-07-22 15:20:30'),
(3, 'owner01', '감사합니다! 더 맛있는 빵으로 보답하겠습니다.', '2026-07-23 19:10:05'),
(4, 'user04', '소금빵 나오는 시간 알려주세요!', '2026-07-25 12:01:45'),
(5, 'user05', '오늘 방문해보겠습니다.', '2026-07-27 17:30:12'),
(6, 'admin', '전기차 급속 충전기는 1층 A구역에 위치해 있습니다.', '2026-07-28 09:15:22'),
(7, 'admin', '어떤 오류가 발생하셨는지 자세히 말씀해주시면 확인해보겠습니다.', '2026-07-29 14:05:00'),
(8, 'user06', '저도 다음 주에 예약해야겠네요.', '2026-07-30 20:11:55'),
(10, 'user01', '점심에 방문하겠습니다.', '2026-08-02 16:00:30'),
(11, 'user03', '유용한 정보 감사합니다!', '2026-08-04 13:45:10'),
(12, 'admin', '좋은 후기 감사드립니다.', '2026-08-05 18:10:00'),
(7, 'user01', '저도 이중결제 경험 있어요. 빠른 처리 부탁드립니다.', '2026-07-29 15:30:00'),
(13, 'admin', '건의 감사합니다. 충전 구역 추가 설치를 검토하겠습니다.', '2026-08-08 10:20:15'),
(13, 'user08', '저도 같은 불편을 겪었어요.', '2026-08-08 11:05:40'),
(14, 'user09', '신선한 과일 좋아요! 오늘 방문할게요.', '2026-08-09 08:30:00'),
(15, 'admin', '민원 확인 후 단속 강화하겠습니다.', '2026-08-10 07:10:00');

-- 공지사항 (notice)
INSERT INTO notice (id, title, content, readcount, ispinned, wdate) VALUES 
('admin', '[필독] 상가 주차장 이용 안내 수칙', '주차장 이용 시간 및 정산 방법 안내입니다.', 500, TRUE, '2026-07-01 09:00:00'),
('admin', '[공지] 주차 시스템 정기 점검 안내', '새벽 2시부터 4시까지 정산 시스템이 일시 중단됩니다.', 320, TRUE, '2026-07-05 10:30:15'),
('admin', '[안내] 전기차 충전 구역 불법주차 단속', '일반 차량 주차 시 과태료가 부과될 수 있습니다.', 280, FALSE, '2026-07-10 14:15:20'),
('admin', '장애인 전용 주차구역 관련 안내', '주차 표지 미부착 차량 단속을 강화합니다.', 150, FALSE, '2026-07-12 11:00:00'),
('admin', '상가 할인 쿠폰 중복 적용 안내', '점포별 최대 무료 주차 적용 시간을 확인하세요.', 410, FALSE, '2026-07-15 16:20:45'),
('admin', '하절기 주차장 환기 시스템 가동 안내', '지하 주차장 공기질 개선 작업 진행 예정입니다.', 90, FALSE, '2026-07-18 09:45:10'),
('admin', '입점 점포 주차 등록 절차 변경', '점주 전용 페이지에서 실시간 등록이 가능합니다.', 130, FALSE, '2026-07-20 13:10:00'),
('admin', '정기권 연장 신청 기간 안내', '매월 25일부터 말일까지 신청 바랍니다.', 250, FALSE, '2026-07-23 15:30:25'),
('admin', '2층 B구역 일부 도색 공사 안내', '공사 기간 동안 B구역 이용이 제한됩니다.', 180, FALSE, '2026-07-26 11:50:00'),
('admin', '무인 정산기 신규 설치 완료 안내', '1층 출입구 전용 정산기가 추가 설치되었습니다.', 210, FALSE, '2026-07-29 17:05:30'),
('admin', '주차요금 감면 대상 사전 등록 안내', '경차 및 친환경차 등록 안내입니다.', 300, FALSE, '2026-08-01 08:30:00'),
('admin', '주말 및 공휴일 주차장 혼잡 안내', '가급적 대중교통 이용을 권장합니다.', 110, FALSE, '2026-08-03 14:20:10'),
('admin', '여름철 집중호우 대비 안내', '호우 특보 시 저층 주차 구역 이용에 유의해주세요.', 75, FALSE, '2026-08-06 09:20:00'),
('admin', '8월 정기권 만료 예정 안내', '8월 말 만료 예정인 정기권 회원은 갱신 신청 바랍니다.', 130, FALSE, '2026-08-08 14:10:00'),
('admin', '연휴 기간 주차장 운영 안내', '연휴 기간 중 입점 매장 휴무로 할인 적용이 제한될 수 있습니다.', 60, FALSE, '2026-08-10 08:00:00');

-- Q&A (qna)
INSERT INTO qna (id, title, content, readcount, issecret, status, replycontent, replydate, wdate) VALUES 
('user01', '정기권 환불 규정이 궁금합니다.', '개인 사정으로 중도 해지 시 환불 가능할까요?', 15, FALSE, 'COMPLETED', '일할 계산 후 잔여 금액이 환불됩니다.', '2026-07-20 11:15:00', '2026-07-20 09:30:00'),
('user02', '경차 할인은 자동 적용되나요?', '차량 등록을 따로 해야 하는지 문의합니다.', 8, FALSE, 'COMPLETED', '입차 시 번호판 인식으로 자동 감면됩니다.', '2026-07-21 16:05:20', '2026-07-21 14:10:00'),
('user03', '비밀글 테스트입니다.', '개인정보 관련 문의입니다.', 5, TRUE, 'WAITING', NULL, NULL, '2026-07-22 10:00:00'),
('user04', '영수증 합산 주차 할인 문의', '2개 매장 영수증 합산 가능한가요?', 22, FALSE, 'COMPLETED', '네, 최대 3시간까지 합산 가능합니다.', '2026-07-24 17:40:10', '2026-07-24 15:25:00'),
('user05', '전기차 충전 시 주차요금 무료인가요?', '충전기 이용 시간 동안 할인되는지 궁금합니다.', 30, FALSE, 'COMPLETED', '충전 시간 1시간 무료 적용됩니다.', '2026-07-25 14:20:00', '2026-07-25 11:40:00'),
('owner01', '점주용 주차 할인 등록 오류', '시스템에서 차량 번호 조회가 안 됩니다.', 12, TRUE, 'COMPLETED', '전산 재부팅 후 정상 처리되었습니다.', '2026-07-27 10:50:30', '2026-07-27 09:15:00'),
('user06', '주차장 출입구 높이 제한', '탑차가 들어갈 수 있는지 높이가 궁금합니다.', 7, FALSE, 'COMPLETED', '제한 높이는 2.3m 입니다.', '2026-07-28 17:30:15', '2026-07-28 16:00:00'),
('user01', '정산기 결제 오류로 이중 결제됨', '카드 결제 내역 확인 부탁드립니다.', 18, TRUE, 'WAITING', NULL, NULL, '2026-07-30 13:12:00'),
('user02', '발렛 파킹 서비스 제공 여부', '주차 대행 서비스가 있는지 문의합니다.', 9, FALSE, 'COMPLETED', '현재 발렛 서비스는 제공하지 않습니다.', '2026-07-31 11:50:00', '2026-07-31 10:45:00'),
('user03', '심야 주차 요금 문의', '밤샘 주차 시 일단 최대 요금이 적용되나요?', 14, FALSE, 'COMPLETED', '일일 최대 요금 30,000원이 적용됩니다.', '2026-08-01 15:35:10', '2026-08-01 14:00:00'),
('user04', '장애인 주차 구역 이용 절차', '등록증을 어디에 제출해야 하나요?', 6, FALSE, 'COMPLETED', '관리사무소에 방문하여 등록해 주세요.', '2026-08-03 10:10:00', '2026-08-03 09:20:00'),
('user05', '정기권 차량 변경 신청', '신차 구입으로 번호 변경 요청합니다.', 11, TRUE, 'COMPLETED', '마이페이지에서 신청서 작성이 필요합니다.', '2026-08-04 17:45:00', '2026-08-04 16:50:00'),
('user07', '전기차 충전 완속/급속 구분 문의', '충전기 종류가 궁금합니다.', 10, FALSE, 'WAITING', NULL, NULL, '2026-08-06 10:00:00'),
('user08', '장애인 주차구역 단속 요청', '불법 주차 차량 단속 부탁드립니다.', 14, FALSE, 'COMPLETED', '즉시 확인 후 조치하겠습니다.', '2026-08-08 11:20:00', '2026-08-07 09:00:00'),
('user09', '임산부 배려 주차구역 위치 문의', '가장 가까운 임산부 구역이 어디인가요?', 6, FALSE, 'COMPLETED', '1층, 2층 A-2 구역입니다.', '2026-08-10 09:15:00', '2026-08-09 10:00:00');

-- FAQ (faq)
INSERT INTO faq (title, content, id, wdate) VALUES 
('주차장 이용 요금이 어떻게 되나요?', '기본 30분에 1,000원이며, 이후 10분당 1,000원씩 추가 요금이 부과됩니다. 일일 최대 요금은 30,000원입니다.', 'admin', '2026-07-01 10:00:00'),
('상점 할인은 어떻게 적용받나요?', '입점 매장에서 결제하실 때 차량 번호를 말씀해 주시면 매장 직원이 즉시 무료 주차 시간을 등록해 드립니다.', 'admin', '2026-07-03 11:15:30'),
('무료 회차 시간이 따로 있나요?', '네, 입차 후 15분 이내에 출차하시는 차량은 주차 요금이 부과되지 않는 무료 회차 처리가 자동으로 적용됩니다.', 'admin', '2026-07-06 14:20:10'),
('할인 쿠폰은 중복 사용이 가능한가요?', '여러 매장을 이용하신 경우 각 매장에서 받은 무료 주차 시간이 누적 합산되어 최종 정산 금액에서 자동으로 차감됩니다.', 'admin', '2026-07-09 09:45:00'),
('무인 정산기에서 결제 후 몇 분 이내에 나가야 하나요?', '무인 정산기에서 요금 결제를 완료하신 후 15분 이내에 출차하셔야 추가 요금이 발생하지 않습니다.', 'admin', '2026-07-12 16:30:22'),
('전기차 충전기 위치가 어떻게 되나요?', '1층 A-2구역에 급속 충전기가 설치되어 있습니다.', 'admin', '2026-07-15 13:10:05'),
('주차 정기권 신청은 어디서 하나요?', '홈페이지 내 정기권 신청 메뉴 또는 1층 관리사무소에서 신청 가능합니다.', 'admin', '2026-07-18 10:05:40'),
('장애인/경차 할인은 어떻게 받나요?', '최초 1회 관리사무소에 등록해 주시면 이후 자동 정산 적용됩니다.', 'admin', '2026-07-21 15:25:12'),
('일일 최대 요금 기준 시간은 어떻게 되나요?', '입차 시간 기준으로 24시간당 최대 30,000원이 부과됩니다.', 'admin', '2026-07-24 11:40:00'),
('발렛 파킹도 가능한가요?', '죄송하지만 현재 발렛 파킹 서비스는 제공하지 않습니다.', 'admin', '2026-07-27 17:15:50'),
('영수증 재발급은 가능한가요?', '사전정산기 하단 영수증 출력 버튼 또는 출입구 관리실에서 발급 가능합니다.', 'admin', '2026-07-30 08:50:30'),
('주차 가능 구역 확인은 어떻게 하나요?', '상가 주차장 입구 전광판 및 각 층 입구 표지판에서 실시간 확인이 가능합니다.', 'admin', '2026-08-02 12:35:15'),
('반려동물과 함께 주차장 이용이 가능한가요?', '네, 반려동물 동반 이용 가능합니다. 다만 목줄 착용을 부탁드립니다.', 'admin', '2026-08-04 15:20:00'),
('주차 정산 후 재입차 시 요금이 다시 부과되나요?', '네, 출차 후 재입차는 신규 입차로 간주되어 요금이 별도로 부과됩니다.', 'admin', '2026-08-06 11:10:00'),
('정기권 차량도 무료 회차 시간이 적용되나요?', '정기권 차량은 지정된 기간 내 횟수 제한 없이 자유롭게 출입 가능합니다.', 'admin', '2026-08-08 09:30:00');

-- ==========================================
-- 5. 요금 정책 (fee_policies)
-- 주의: 이 테이블에는 시행일자/버전 컬럼이 없어 이력 관리가 불가능합니다.
-- 아래는 이력 형태로 15개를 채운 것이며, 실제 요금 계산에는
-- 가장 마지막(policyId=15, 최신) 값 기준으로 통일 적용했습니다.
-- ==========================================
INSERT INTO fee_policies (gracePeriod, baseTime, baseFee, extraTime, extraFee, dailyMax, id) VALUES
(10, 30, 500,  10, 500,  20000, 'admin'),
(10, 30, 600,  10, 600,  20000, 'admin'),
(10, 30, 700,  10, 700,  22000, 'admin'),
(15, 30, 700,  10, 700,  22000, 'admin'),
(15, 30, 800,  10, 800,  24000, 'admin'),
(15, 30, 800,  10, 900,  24000, 'admin'),
(15, 30, 900,  10, 900,  26000, 'admin'),
(15, 30, 900,  10, 1000, 26000, 'admin'),
(15, 30, 1000, 10, 1000, 28000, 'admin'),
(15, 30, 1000, 10, 1000, 28000, 'admin'),
(15, 30, 1000, 10, 1000, 30000, 'admin'),
(15, 30, 1000, 10, 1000, 30000, 'admin'),
(15, 30, 1000, 10, 1000, 30000, 'admin'),
(15, 30, 1000, 10, 1000, 30000, 'admin'),
(15, 30, 1000, 10, 1000, 30000, 'admin');

-- ==========================================
-- 6. 입출차 기록 (parking_records)
-- recordId 1~30, 삽입 순서대로 자동 채번됨 (SERIAL 순서 = 아래 순서 그대로)
-- 6월(1~10), 7월(11~20), 8월(21~30) / 비회원(guest, id=NULL) 10건 포함
-- 요금 계산식: grace<=15분 무료 / <=30분 1,000원 / 이후 10분당 +1,000원, 최대 30,000원
-- ==========================================
INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id) VALUES
-- 6월 (recordId 1~10)
('55마5555', '일반',   1, 'B-2', 'general',  '2026-06-03 08:00:00', '2026-06-03 09:10:00', 70,  5000,  3000, 2000, 'user01'),   -- 1: 할인 적용
('66바6666', '전기차', 1, 'A-3', 'ev',       '2026-06-05 07:30:00', '2026-06-05 08:00:00', 30,  1000,  0,    1000, 'user02'),   -- 2
('77사7777', '임산부', 1, 'A-2', 'pregnant', '2026-06-07 09:00:00', '2026-06-07 09:12:00', 12,  0,     0,    0,    'user03'),   -- 3: 무료회차
('88아8888', '장애인', 1, 'A-1', 'disabled', '2026-06-10 10:00:00', '2026-06-10 11:40:00', 100, 8000,  6000, 2000, 'user04'),   -- 4: 할인 적용
('11가1111', '일반',   2, 'B-1', 'general',  '2026-06-12 08:00:00', '2026-06-12 08:50:00', 50,  3000,  2000, 1000, 'owner01'),  -- 5: 할인 적용
('22나2222', '전기차', 2, 'A-3', 'ev',       '2026-06-15 07:00:00', '2026-06-15 09:00:00', 120, 10000, 6000, 4000, 'owner02'),  -- 6: 할인 적용
('33다3333', '임산부', 2, 'A-2', 'pregnant', '2026-06-18 09:00:00', '2026-06-18 09:20:00', 20,  1000,  1000, 0,    'owner03'),  -- 7: 할인 적용
('44라4444', '장애인', 2, 'A-1', 'disabled', '2026-06-20 10:00:00', '2026-06-20 12:00:00', 120, 10000, 3000, 7000, 'owner04'),  -- 8: 할인 적용
('12가3456', '일반',   1, 'B-3', 'general',  '2026-06-08 13:00:00', '2026-06-08 13:45:00', 45,  3000,  0,    3000, NULL),       -- 9: 비회원
('34나5678', '일반',   1, 'B-4', 'general',  '2026-06-22 15:00:00', '2026-06-22 15:10:00', 10,  0,     0,    0,    NULL),       -- 10: 비회원, 무료회차
-- 7월 (recordId 11~20)
('99자9999', '일반',   1, 'B-5', 'general',  '2026-07-02 08:00:00', '2026-07-02 09:30:00', 90,  7000,  3000, 4000, 'user05'),   -- 11: 할인 적용
('10차1010', '일반',   1, 'B-6', 'general',  '2026-07-05 09:00:00', '2026-07-05 09:25:00', 25,  1000,  1000, 0,    'user06'),   -- 12: 할인 적용
('21카2121', '전기차', 1, 'A-3', 'ev',       '2026-07-08 07:00:00', '2026-07-08 08:40:00', 100, 8000,  4000, 4000, 'user07'),   -- 13: 할인 적용
('32타3232', '일반',   2, 'B-2', 'general',  '2026-07-10 10:00:00', '2026-07-10 10:20:00', 20,  1000,  1000, 0,    'user08'),   -- 14: 할인 적용
('43파4343', '임산부', 2, 'A-2', 'pregnant', '2026-07-12 11:00:00', '2026-07-12 11:50:00', 50,  3000,  2000, 1000, 'user09'),   -- 15: 할인 적용
('54하5454', '장애인', 2, 'A-1', 'disabled', '2026-07-15 08:00:00', '2026-07-15 08:35:00', 35,  2000,  1000, 1000, 'user10'),   -- 16: 할인 적용
('12마1212', '일반',   1, 'B-1', 'general',  '2026-07-18 09:00:00', '2026-07-18 10:30:00', 90,  7000,  6000, 1000, 'owner05'),  -- 17: 할인 적용
('13바1313', '전기차', 1, 'A-3', 'ev',       '2026-07-20 07:00:00', '2026-07-20 07:20:00', 20,  1000,  1000, 0,    'owner06'),  -- 18: 할인 적용
('56다7890', '일반',   1, 'B-2', 'general',  '2026-07-14 12:00:00', '2026-07-14 12:50:00', 50,  3000,  0,    3000, NULL),       -- 19: 비회원
('78라9012', '일반',   2, 'B-3', 'general',  '2026-07-25 16:00:00', '2026-07-25 16:12:00', 12,  0,     0,    0,    NULL),       -- 20: 비회원, 무료회차
-- 8월 (recordId 21~30) - 오늘(8/10) 기준 3건은 아직 주차중(exitTime NULL)
('55마5555', '일반',   1, 'B-1', 'general',  '2026-08-01 08:00:00', '2026-08-01 09:00:00', 60,  4000,  3000, 1000, 'user01'),   -- 21: 할인 적용, 출차완료
('33다3333', '임산부', 2, 'A-2', 'pregnant', '2026-08-09 09:10:00', NULL, NULL, 0, 0, 0, 'owner03'),                            -- 22: 주차중 (exitTime NULL)
('21카2121', '전기차', 1, 'A-3', 'ev',       '2026-08-10 07:45:00', NULL, NULL, 0, 0, 0, 'user07'),                             -- 23: 주차중 (exitTime NULL)
('44라4444', '장애인', 2, 'A-1', 'disabled', '2026-08-10 08:20:00', NULL, NULL, 0, 0, 0, 'owner04'),                            -- 24: 주차중 (exitTime NULL)
('90마1234', '일반',   1, 'B-4', 'general',  '2026-08-02 09:00:00', '2026-08-02 09:40:00', 40,  2000, 0, 2000, NULL),           -- 25: 비회원, 출차완료
('13바5678', '일반',   1, 'B-5', 'general',  '2026-08-03 10:00:00', '2026-08-03 10:14:00', 14,  0,    0, 0,    NULL),           -- 26: 비회원, 무료회차
('24사6789', '일반',   2, 'B-2', 'general',  '2026-08-04 11:00:00', '2026-08-04 12:30:00', 90,  7000, 0, 7000, NULL),           -- 27: 비회원, 출차완료
('35아7890', '일반',   2, 'B-3', 'general',  '2026-08-05 13:00:00', '2026-08-05 13:20:00', 20,  1000, 0, 1000, NULL),           -- 28: 비회원, 출차완료
('46자8901', '일반',   1, 'B-6', 'general',  '2026-08-07 14:00:00', '2026-08-07 15:10:00', 70,  5000, 0, 5000, NULL),           -- 29: 비회원, 출차완료
('57차9012', '일반',   2, 'B-4', 'general',  '2026-08-08 15:30:00', '2026-08-08 15:45:00', 15,  0,    0, 0,    NULL);           -- 30: 비회원, 무료회차

-- ==========================================
-- 6-1. 3층 입출차 기록 추가 (parking_records)
-- 기존 데이터는 1~2층만 있었기에 3층 이용 내역을 신규로 채움
-- 완료 6건 + 현재 주차중 2건(spot 연결 포함, 7-1에서 처리)
-- ==========================================
INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id) VALUES
('88아8888', '장애인', 3, 'A-1', 'disabled', '2026-07-20 10:00:00', '2026-07-20 10:40:00', 40, 2000, 0, 2000, 'user04'),
('43파4343', '임산부', 3, 'A-2', 'pregnant', '2026-07-22 11:00:00', '2026-07-22 11:20:00', 20, 1000, 0, 1000, 'user09'),
('54하5454', '일반',   3, 'A-4', 'general',  '2026-08-01 09:00:00', '2026-08-01 10:30:00', 90, 7000, 0, 7000, 'user10'),
('68타1234', '일반',   3, 'A-5', 'general',  '2026-08-04 14:00:00', '2026-08-04 14:14:00', 14, 0,    0, 0,    NULL),
('76너7676', '일반',   3, 'B-1', 'general',  '2026-08-06 16:00:00', '2026-08-06 16:10:00', 10, 0,    0, 0,    'user12'),
('79더5678', '일반',   3, 'B-2', 'general',  '2026-08-08 13:00:00', '2026-08-08 13:50:00', 50, 3000, 0, 3000, NULL);

-- ==========================================
-- 7. 주차 공간 마스터 (parking_spots)
-- 중요: exitTime이 있는(=출차 완료된) 레코드는 절대 recordId로 연결하지 않음.
-- 오늘(8/10) 기준 실제로 "주차중"인 recordId 22, 23, 24만 연결.
-- ==========================================
-- 1층
INSERT INTO parking_spots (spotId, parkingFloor, section, parkingType, recordId) VALUES
('1F-A-1', 1, 'A-1', 'disabled', NULL),
('1F-A-2', 1, 'A-2', 'pregnant', NULL),
('1F-A-3', 1, 'A-3', 'ev',       23),   -- 현재 주차중 (user07)
('1F-A-4', 1, 'A-4', 'general',  NULL),
('1F-A-5', 1, 'A-5', 'general',  NULL),
('1F-A-6', 1, 'A-6', 'general',  NULL),
('1F-B-1', 1, 'B-1', 'general',  NULL),
('1F-B-2', 1, 'B-2', 'general',  NULL),
('1F-B-3', 1, 'B-3', 'general',  NULL),
('1F-B-4', 1, 'B-4', 'general',  NULL),
('1F-B-5', 1, 'B-5', 'general',  NULL),
('1F-B-6', 1, 'B-6', 'general',  NULL);

-- 2층
INSERT INTO parking_spots (spotId, parkingFloor, section, parkingType, recordId) VALUES
('2F-A-1', 2, 'A-1', 'disabled', 24),   -- 현재 주차중 (owner04)
('2F-A-2', 2, 'A-2', 'pregnant', 22),   -- 현재 주차중 (owner03)
('2F-A-3', 2, 'A-3', 'ev',       NULL),
('2F-A-4', 2, 'A-4', 'general',  NULL),
('2F-A-5', 2, 'A-5', 'general',  NULL),
('2F-A-6', 2, 'A-6', 'general',  NULL),
('2F-B-1', 2, 'B-1', 'general',  NULL),
('2F-B-2', 2, 'B-2', 'general',  NULL),
('2F-B-3', 2, 'B-3', 'general',  NULL),
('2F-B-4', 2, 'B-4', 'general',  NULL),
('2F-B-5', 2, 'B-5', 'general',  NULL),
('2F-B-6', 2, 'B-6', 'general',  NULL);

-- 3층
INSERT INTO parking_spots (spotId, parkingFloor, section, parkingType, recordId) VALUES
('3F-A-1', 3, 'A-1', 'disabled', NULL),
('3F-A-2', 3, 'A-2', 'pregnant', NULL),
('3F-A-3', 3, 'A-3', 'ev',       NULL),
('3F-A-4', 3, 'A-4', 'general',  NULL),
('3F-A-5', 3, 'A-5', 'general',  NULL),
('3F-A-6', 3, 'A-6', 'general',  NULL),
('3F-B-1', 3, 'B-1', 'general',  NULL),
('3F-B-2', 3, 'B-2', 'general',  NULL),
('3F-B-3', 3, 'B-3', 'general',  NULL),
('3F-B-4', 3, 'B-4', 'general',  NULL),
('3F-B-5', 3, 'B-5', 'general',  NULL),
('3F-B-6', 3, 'B-6', 'general',  NULL);

-- ==========================================
-- 7-1. 3층 현재 주차중 기록 → parking_spots 연결
-- (parking_spots 3F row가 위에서 먼저 생성된 뒤에 실행되어야 함)
-- ==========================================
WITH ins AS (
  INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id)
  VALUES ('13바1313', '전기차', 3, 'A-3', 'ev', '2026-08-10 09:20:00', NULL, NULL, 0, 0, 0, 'owner06')
  RETURNING recordId
)
UPDATE parking_spots SET recordId = (SELECT recordId FROM ins), updatedAt = NOW()
WHERE spotId = '3F-A-3';

WITH ins AS (
  INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id)
  VALUES ('65거6565', '일반', 3, 'A-6', 'general', '2026-08-10 10:05:00', NULL, NULL, 0, 0, 0, 'user11')
  RETURNING recordId
)
UPDATE parking_spots SET recordId = (SELECT recordId FROM ins), updatedAt = NOW()
WHERE spotId = '3F-A-6';

-- ==========================================
-- 8. 상가 할인 및 정기권
-- store_discounts의 freeMin 적용 결과는 위 parking_records의
-- rawFee/discountFee/finalFee 값에 이미 반영되어 있음 (정합성 일치)
-- store_discounts.id(할인 등록자)는 실제 해당 storeNum의 소유주(owner07~28)로 맞춤
-- ==========================================
INSERT INTO store_discounts (recordId, storeNum, freeMin, id, createdAt) VALUES
(1,  2,  30, 'owner02', '2026-06-03 09:15:00'),
(4,  5,  60, 'owner04', '2026-06-10 11:45:00'),
(5,  3,  30, 'owner03', '2026-06-12 08:55:00'),
(6,  4,  60, 'owner07', '2026-06-15 09:05:00'),
(7,  7,  15, 'owner09', '2026-06-18 09:25:00'),
(8,  8,  30, 'owner10', '2026-06-20 12:05:00'),
(11, 10, 30, 'owner12', '2026-07-02 09:35:00'),
(12, 11, 15, 'owner13', '2026-07-05 09:30:00'),
(13, 12, 45, 'owner14', '2026-07-08 08:45:00'),
(14, 13, 15, 'owner05', '2026-07-10 10:25:00'),
(15, 14, 30, 'owner06', '2026-07-12 11:55:00'),
(16, 24, 15, 'owner24', '2026-07-15 08:40:00'),
(17, 1,  60, 'owner01', '2026-07-18 10:35:00'),
(18, 2,  15, 'owner02', '2026-07-20 07:25:00'),
(21, 3,  30, 'owner03', '2026-08-01 09:05:00');

-- 정기권 가격: 일반 100,000원/월, 점주(tenant) 50,000원/월
-- 규칙: 신청(createdAt)한 날 바로 정기권이 시작(startDate)됨 → startDate = createdAt(날짜 기준 동일)
-- 신청일이 매번 1일로 몰리지 않도록 날짜를 분산, endDate는 startDate + 1개월(또는 1년, tenant) 기준
INSERT INTO prepaid (userId, carNum, ownerName, startDate, endDate, type, status, createdAt, price) VALUES
('user01', '55마5555', '홍길동',   '2026-08-03', '2026-09-02', 'monthly', 'approved',  '2026-08-03 09:10:00', 100000),
('user02', '66바6666', '강감찬',   '2026-08-05', '2026-09-04', 'monthly', 'approved',  '2026-08-05 10:05:00', 100000),
('user03', '77사7777', '신사임당', '2026-08-07', '2026-09-06', 'monthly', 'requested', '2026-08-07 11:30:00', 100000),
('user04', '88아8888', '유관순',   '2026-07-28', '2026-08-27', 'monthly', 'approved',  '2026-07-28 08:45:00', 100000),
('user05', '99자9999', '이순신',   '2026-08-10', '2026-09-09', 'monthly', 'requested', '2026-08-10 13:00:00', 100000),
('user06', '10차1010', '정약용',   '2026-08-02', '2026-09-01', 'monthly', 'rejected',  '2026-08-02 16:30:00', 100000),
('owner01','11가1111', '김베이커리','2026-01-05', '2027-01-04', 'monthly',  'approved',  '2026-01-05 09:00:00', 50000),
('owner02','22나2222', '이카페',   '2026-01-08', '2027-01-07', 'monthly',  'approved',  '2026-01-08 09:05:00', 50000),
('owner03','33다3333', '박식당',   '2026-01-10', '2027-01-09', 'monthly',  'approved',  '2026-01-10 09:10:00', 50000),
('owner04','44라4444', '최헤어',   '2026-01-12', '2027-01-11', 'monthly',  'approved',  '2026-01-12 09:15:00', 50000),
('user07', '21카2121', '김유신',   '2026-08-04', '2026-09-03', 'monthly', 'approved',  '2026-08-04 09:50:00', 100000),
('user08', '32타3232', '장영실',   '2026-07-12', '2026-08-11', 'monthly', 'approved',  '2026-07-12 15:20:00', 100000),
('user09', '43파4343', '허준',     '2026-08-09', '2026-09-08', 'monthly', 'requested', '2026-08-09 17:10:00', 100000),
('owner05','12마1212', '정과일',   '2026-01-15', '2027-01-14', 'monthly',  'approved',  '2026-01-15 09:20:00', 50000),
('owner06','13바1313', '한서점',   '2026-01-18', '2027-01-17', 'monthly',  'approved',  '2026-01-18 09:25:00', 50000);

-- ==========================================
-- 9. 1:1 질의응답 상태 최종 정리
-- ==========================================
UPDATE qna
SET status = 'COMPLETED'
WHERE status = 'ANSWERED';

-- ==========================================
-- 9-1. 추가 게스트 입차 기록 (주차중)
-- ==========================================
INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, id)
VALUES ('99호9999', '일반', 1, 'B-2', 'general', '2026-08-10 11:00:00', NULL, NULL);

-- ==========================================
-- 10. 공지사항 & 자유게시판(수다방) 상단 고정글 추가
-- notice: 기존 2건(ispinned=TRUE)에 이어 3건 추가 고정
-- board: 기존 15건은 전부 ispinned=FALSE였으므로 상단 고정글 3건 신규 추가
-- ==========================================
INSERT INTO notice (id, title, content, readcount, ispinned, wdate) VALUES
('admin', '[필독] 8월 주차장 이용수칙 개정 안내', '8월부터 무료 회차 시간 및 할인 정책 일부가 변경됩니다. 이용에 참고 바랍니다.', 340, TRUE, '2026-08-04 09:00:00'),
('admin', '[긴급] 오늘 밤 시스템 점검 예정', '오늘 밤 11시부터 자정까지 홈페이지 및 정산 시스템 접속이 일시 제한됩니다.', 190, TRUE, '2026-08-09 20:00:00'),
('admin', '[이벤트] 8월 상가 할인 이벤트 안내', '입점 매장 이용 후 영수증 지참 시 추첨을 통해 정기권 1개월 무료 혜택을 드립니다.', 260, TRUE, '2026-08-10 09:00:00');

INSERT INTO board (writerid, title, content, readcount, ispinned, wdate) VALUES
('admin', '[운영] 자유게시판(수다방) 이용규칙 안내', '비방, 광고성 게시글은 사전 통보 없이 삭제될 수 있습니다. 즐거운 수다방 되세요!', 420, TRUE, '2026-08-01 09:00:00'),
('admin', '[안내] 욕설 및 비방글 신고 방법', '불편한 게시글 발견 시 게시글 하단 신고 버튼을 이용해 주세요. 확인 후 조치합니다.', 175, TRUE, '2026-08-06 09:00:00'),
('admin', '[이벤트] 이달의 수다왕 뽑기 이벤트', '이번 달 게시글/댓글을 가장 많이 남겨주신 회원께 주차 정기권 1개월을 드립니다!', 305, TRUE, '2026-08-09 09:00:00');

-- ==========================================
-- 11. 신규 회원(user14~user22) 활동 더미
-- 주차 이용기록, 정기권, 게시글/댓글, Q&A (이 회원들은 상가를 소유하지 않는 순수 고객)
-- ==========================================

-- 11-1. 주차 이용기록 (완료된 방문 9건, 각자 차량번호로 입출차)
-- discountFee/finalFee는 아래 11-6에서 등록되는 매장 할인(무료회차 15분 + 기본30분 1,000원/추가10분당 1,000원 정책)까지 반영해 계산함
INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id) VALUES
('98나6789', '일반',   1, 'B-2', 'general',  '2026-08-02 09:00:00', '2026-08-02 09:35:00', 35, 2000, 1000, 1000, 'user14'),
('87다6543', '전기차', 1, 'A-3', 'ev',       '2026-08-03 10:00:00', '2026-08-03 10:20:00', 20, 1000, 1000, 0,    'user15'),
('76마2345', '임산부', 2, 'A-2', 'pregnant', '2026-08-04 11:00:00', '2026-08-04 11:15:00', 15, 0,    0,    0,    'user16'),
('65바5432', '장애인', 2, 'A-1', 'disabled', '2026-08-05 08:00:00', '2026-08-05 09:10:00', 70, 5000, 4000, 1000, 'user17'),
('54사6543', '일반',   3, 'B-3', 'general',  '2026-08-06 13:00:00', '2026-08-06 13:40:00', 40, 2000, 1000, 1000, 'user18'),
('43아3456', '전기차', 1, 'A-3', 'ev',       '2026-08-07 09:00:00', '2026-08-07 09:50:00', 50, 3000, 3000, 0,    'user19'),
('32자7654', '일반',   2, 'B-4', 'general',  '2026-08-08 14:00:00', '2026-08-08 14:25:00', 25, 1000, 0,    1000, 'user20'),
('21차8765', '임산부', 3, 'A-2', 'pregnant', '2026-08-09 10:00:00', '2026-08-09 10:10:00', 10, 0,    0,    0,    'user21'),
('10카9876', '장애인', 1, 'A-1', 'disabled', '2026-08-09 15:00:00', '2026-08-09 15:45:00', 45, 3000, 0,    3000, 'user22');

-- 11-2. 정기권 신청 (일반 회원용 월권, 100,000원/월)
INSERT INTO prepaid (userId, carNum, ownerName, startDate, endDate, type, status, createdAt, price) VALUES
('user14', '98나6789', '이황',     '2026-08-01', '2026-08-31', 'monthly', 'approved',  '2026-08-01 09:00:00', 100000),
('user15', '87다6543', '이이',     '2026-08-02', '2026-09-01', 'monthly', 'approved',  '2026-08-02 09:00:00', 100000),
('user16', '76마2345', '정몽주',   '2026-08-03', '2026-09-02', 'monthly', 'requested', '2026-08-03 09:00:00', 100000),
('user17', '65바5432', '최영',     '2026-08-04', '2026-09-03', 'monthly', 'approved',  '2026-08-04 09:00:00', 100000),
('user18', '54사6543', '을지문덕', '2026-08-05', '2026-09-04', 'monthly', 'approved',  '2026-08-05 09:00:00', 100000),
('user19', '43아3456', '연개소문', '2026-08-06', '2026-09-05', 'monthly', 'approved',  '2026-08-06 09:00:00', 100000),
('user20', '32자7654', '계백',     '2026-08-07', '2026-09-06', 'monthly', 'requested', '2026-08-07 09:00:00', 100000),
('user21', '21차8765', '광개토대왕','2026-08-08', '2026-09-07', 'monthly', 'approved',  '2026-08-08 09:00:00', 100000),
('user22', '10카9876', '세종대왕', '2026-08-09', '2026-09-08', 'monthly', 'approved',  '2026-08-09 09:00:00', 100000);

-- 11-3. 자유게시판 신규 오픈 홍보 글 (실제 매장 소유주인 owner 계정이 작성)
INSERT INTO board (writerid, title, content, readcount, wdate) VALUES
('owner18', '만화카페 신규 오픈했어요!', '5층에 만화카페 오픈했습니다. 편하게 놀러오세요~', 19, '2026-08-07 12:00:00'),
('owner24', '편의점 GS25 6층 입점 안내', '6층에 편의점 GS25가 새로 들어왔습니다. 24시간 운영합니다.', 25, '2026-08-08 08:00:00'),
('owner27', '7층 이벤트홀 대관 문의는 관리사무소로', '소규모 행사, 세미나 대관 가능합니다. 자세한 사항은 관리사무소로 문의해주세요.', 14, '2026-08-09 15:00:00');

-- 11-4. 위 게시글에 대한 댓글
INSERT INTO comments (board_seq, writerid, content, wdate) VALUES
(19, 'user01', '오픈 축하드려요! 조만간 방문할게요.', '2026-08-07 13:10:00'),
(20, 'admin',  '입점을 환영합니다. 편의점 이용시간 안내 감사합니다.', '2026-08-08 09:20:00');

-- 11-5. Q&A (매장 운영 관련 문의는 실제 점주 계정이 작성)
INSERT INTO qna (id, title, content, readcount, issecret, status, replycontent, replydate, wdate) VALUES
('owner13', '정기권 신청 후 승인까지 얼마나 걸리나요?', '점주 정기권 신청했는데 승인 소요 기간이 궁금합니다.', 4, FALSE, 'WAITING', NULL, NULL, '2026-08-01 10:00:00'),
('owner20', '점포 할인 등록은 어떻게 하나요?', '고객 방문 시 무료 주차 시간을 어떻게 등록하는지 안내 부탁드립니다.', 9, FALSE, 'COMPLETED', '매장 단말기에서 차량번호 입력 후 할인 시간을 등록하시면 됩니다.', '2026-08-05 11:30:00', '2026-08-04 15:00:00'),
('owner26', '매장 인테리어 공사 중 주차 할인 가능한가요?', '공사 업체 차량도 할인 등록이 가능한지 궁금합니다.', 5, FALSE, 'COMPLETED', '업체 차량도 동일하게 등록 가능합니다.', '2026-08-08 16:00:00', '2026-08-07 14:00:00');

-- 11-6. 매장 할인 등록 (위 11-1 고객 방문에 대해, 각 storeNum의 실제 소유주 owner 계정이 등록)
INSERT INTO store_discounts (recordId, storeNum, freeMin, id, createdAt)
SELECT pr.recordId, 17, 15, 'owner17', '2026-08-02 09:40:00'
FROM parking_records pr WHERE pr.carNum = '98나6789' AND pr.entryTime = '2026-08-02 09:00:00';

INSERT INTO store_discounts (recordId, storeNum, freeMin, id, createdAt)
SELECT pr.recordId, 20, 30, 'owner20', '2026-08-03 10:25:00'
FROM parking_records pr WHERE pr.carNum = '87다6543' AND pr.entryTime = '2026-08-03 10:00:00';

INSERT INTO store_discounts (recordId, storeNum, freeMin, id, createdAt)
SELECT pr.recordId, 23, 15, 'owner23', '2026-08-04 11:20:00'
FROM parking_records pr WHERE pr.carNum = '76마2345' AND pr.entryTime = '2026-08-04 11:00:00';

INSERT INTO store_discounts (recordId, storeNum, freeMin, id, createdAt)
SELECT pr.recordId, 26, 45, 'owner26', '2026-08-05 09:15:00'
FROM parking_records pr WHERE pr.carNum = '65바5432' AND pr.entryTime = '2026-08-05 08:00:00';

INSERT INTO store_discounts (recordId, storeNum, freeMin, id, createdAt)
SELECT pr.recordId, 27, 20, 'owner27', '2026-08-06 13:45:00'
FROM parking_records pr WHERE pr.carNum = '54사6543' AND pr.entryTime = '2026-08-06 13:00:00';

INSERT INTO store_discounts (recordId, storeNum, freeMin, id, createdAt)
SELECT pr.recordId, 28, 50, 'owner28', '2026-08-07 09:55:00'
FROM parking_records pr WHERE pr.carNum = '43아3456' AND pr.entryTime = '2026-08-07 09:00:00';

-- ==========================================
-- 12. 1~7월 입출차 기록 — 월마다 매출 600만~800만원 사이에서 변동
-- 12-1에서 8월은 별도로 몇십만원대(수십만원)로 소량만 추가.
-- 평균 요금이 약 14,500원이 되도록 주차시간 범위(20~300분)를 고정하고,
-- 월별 "건수"만 다르게 줘서 그 달의 매출이 정해진 범위 안에서 오르내리게 함.
-- 예상 매출(대략): 1월 640만 / 2월 710만 / 3월 680만 / 4월 760만 /
--                  5월 620만 / 6월 790만 / 7월 690만
-- (정확한 값은 파일 맨 아래 검증쿼리로 실행 후 확인, 오차는 자연스러운 변동으로 봐도 무방)
-- ==========================================
WITH month_cfg (month_num, record_count, min_lo, min_hi, day_mult) AS (
    VALUES
        (1, 441, 20, 300, 3),
        (2, 490, 20, 300, 5),
        (3, 469, 20, 300, 7),
        (4, 524, 20, 300, 4),
        (5, 428, 20, 300, 6),
        (6, 545, 20, 300, 9),
        (7, 476, 20, 300, 11)
)
INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id)
SELECT
    plate,
    ctype,
    floor_num,
    zone,
    ptype,
    entry_ts,
    entry_ts + (total_min || ' minutes')::interval,
    total_min,
    fee,
    0,
    fee,
    member_id
FROM (
    SELECT
        plate, ctype, floor_num, zone, ptype, entry_ts, total_min, member_id,
        CASE
            WHEN total_min <= 15 THEN 0
            WHEN total_min <= 30 THEN 1000
            ELSE LEAST(1000 + CEIL((total_min - 30) / 10.0)::int * 1000, 30000)
        END AS fee
    FROM (
        SELECT
            ('1' || mc.month_num::text || LPAD(s::text, 3, '0') || '가' || LPAD(((mc.month_num * 137 + s * 7) % 10000)::text, 4, '0')) AS plate,
            (ARRAY['일반', '전기차', '임산부', '장애인'])[1 + (s % 4)] AS ctype,
            (1 + (s % 3)) AS floor_num,
            (ARRAY['A-1', 'A-2', 'A-3', 'B-1', 'B-2', 'B-3'])[1 + (s % 6)] AS zone,
            (ARRAY['disabled', 'pregnant', 'ev', 'general', 'general', 'general'])[1 + (s % 6)] AS ptype,
            make_timestamp(2026, mc.month_num, 1 + ((s * mc.day_mult) % 27), 7 + (s % 12), (s * 7 % 60), 0) AS entry_ts,
            (mc.min_lo + (s * 53 % (mc.min_hi - mc.min_lo + 1))) AS total_min,
            (CASE WHEN s % 6 = 0 THEN NULL
                  ELSE (ARRAY['user01','user02','user03','user04','user05','user06','user07','user08','user09','user10','user11','user12','user13','owner01','owner02','owner03','owner04','owner05','owner06'])[1 + (s % 19)]
             END) AS member_id
        FROM month_cfg mc
        CROSS JOIN LATERAL generate_series(1, mc.record_count) AS s
    ) raw
) calc;

-- ==========================================
-- 12-1. 8월 추가 입출차 기록 — 몇십만원대(약 40~60만원)로 소량만 채움
-- 오늘(8/10) 기준 실제로 진행 중인 달이라 1~10일 사이 날짜로만 생성.
-- 위에서 만든 8월 기록(완료분 + 주차중)은 그대로 두고 이 45건만 추가.
-- ==========================================
INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id)
SELECT
    plate,
    ctype,
    floor_num,
    zone,
    ptype,
    entry_ts,
    entry_ts + (total_min || ' minutes')::interval,
    total_min,
    fee,
    0,
    fee,
    member_id
FROM (
    SELECT
        plate, ctype, floor_num, zone, ptype, entry_ts, total_min, member_id,
        CASE
            WHEN total_min <= 15 THEN 0
            WHEN total_min <= 30 THEN 1000
            ELSE LEAST(1000 + CEIL((total_min - 30) / 10.0)::int * 1000, 30000)
        END AS fee
    FROM (
        SELECT
            ('1' || '8' || LPAD(s::text, 3, '0') || '나' || LPAD(((8 * 137 + s * 7) % 10000)::text, 4, '0')) AS plate,
            (ARRAY['일반', '전기차', '임산부', '장애인'])[1 + (s % 4)] AS ctype,
            (1 + (s % 3)) AS floor_num,
            (ARRAY['A-1', 'A-2', 'A-3', 'B-1', 'B-2', 'B-3'])[1 + (s % 6)] AS zone,
            (ARRAY['disabled', 'pregnant', 'ev', 'general', 'general', 'general'])[1 + (s % 6)] AS ptype,
            make_timestamp(2026, 8, 1 + (s % 10), 7 + (s % 12), (s * 7 % 60), 0) AS entry_ts,
            (15 + (s * 53 % 186)) AS total_min,
            (CASE WHEN s % 6 = 0 THEN NULL
                  ELSE (ARRAY['user01','user02','user03','user04','user05','user06','user07','user08','user09','user10','user11','user12','user13','owner01','owner02','owner03','owner04','owner05','owner06'])[1 + (s % 19)]
             END) AS member_id
        FROM generate_series(1, 45) AS s
    ) raw
) calc;

-- 월별 매출 확인용 쿼리 (실행 후 검증)
-- SELECT date_trunc('month', exitTime) AS month, COUNT(*) AS 건수, SUM(finalFee) AS revenue
-- FROM parking_records
-- WHERE exitTime IS NOT NULL
-- GROUP BY 1 ORDER BY 1;

-- ==========================================
-- 13. 입출차 시간 모두 있는 추가 주차기록 10건
-- 요금 계산식 동일 적용 (무료회차 15분 / 기본30분 1,000원 / 추가10분당 1,000원)
-- ==========================================
INSERT INTO parking_records (carNum, carTypes, parkingFloor, parkingZone, parkingType, entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id) VALUES
('55마5555', '일반',   1, 'B-3', 'general',  '2026-08-02 07:30:00', '2026-08-02 08:10:00', 40, 2000, 0, 2000, 'user01'),
('99자9999', '일반',   2, 'A-4', 'general',  '2026-08-03 12:00:00', '2026-08-03 12:12:00', 12, 0,    0, 0,    'user05'),
('68바9012', '일반',   1, 'B-4', 'general',  '2026-08-04 09:15:00', '2026-08-04 09:50:00', 35, 2000, 0, 2000, NULL),
('32타3232', '일반',   3, 'A-5', 'general',  '2026-08-05 16:00:00', '2026-08-05 16:30:00', 30, 1000, 0, 1000, 'user08'),
('79라4567', '일반',   2, 'B-5', 'general',  '2026-08-05 19:00:00', '2026-08-05 19:08:00', 8,  0,    0, 0,    NULL),
('65거6565', '일반',   1, 'A-6', 'general',  '2026-08-06 11:20:00', '2026-08-06 12:35:00', 75, 6000, 0, 6000, 'user11'),
('87더8787', '전기차', 3, 'A-3', 'ev',       '2026-08-07 08:05:00', '2026-08-07 08:20:00', 15, 0,    0, 0,    'user13'),
('45차6789', '일반',   2, 'B-2', 'general',  '2026-08-07 14:40:00', '2026-08-07 16:10:00', 90, 7000, 0, 7000, NULL),
('10카9876', '장애인', 1, 'A-1', 'disabled', '2026-08-08 10:10:00', '2026-08-08 10:55:00', 45, 3000, 0, 3000, 'user22'),
('77사7777', '임산부', 3, 'A-2', 'pregnant', '2026-08-09 07:50:00', '2026-08-09 08:05:00', 15, 0,    0, 0,    'user03');

-- ==========================================
-- 14. 금일(2026-08-11) 일반회원 출차 완료 더미 10건
-- 일반회원(auth=3) + 차량유형 일반
-- 모두 금일 입차/출차 완료
-- ==========================================

-- ==========================================
-- 14. 금일(2026-08-11) 일반회원 출차 완료 더미 10건
-- 요금 기준
-- 15분 이하        → 무료
-- 16~30분          → 1,000원
-- 31~40분          → 2,000원
-- 41~50분          → 3,000원
-- 51~60분          → 4,000원
-- 이후 10분당       → 1,000원 추가
-- ==========================================

INSERT INTO parking_records
(carNum, carTypes, parkingFloor, parkingZone, parkingType,
 entryTime, exitTime, totalMin, rawFee, discountFee, finalFee, id)
VALUES
-- 1. 약 15분 경과 (무료회차 테스트)
('55마5555', '일반', 1, 'B-1', 'general',
 NOW() - INTERVAL '15 minutes', NULL, NULL, NULL, NULL, NULL, 'user01'),

-- 2. 약 20분 경과
('99자9999', '일반', 2, 'B-2', 'general',
 NOW() - INTERVAL '20 minutes', NULL, NULL, NULL, NULL, NULL, 'user05'),

-- 3. 약 30분 경과
('10차1010', '일반', 1, 'B-3', 'general',
 NOW() - INTERVAL '30 minutes', NULL, NULL, NULL, NULL, NULL, 'user06'),

-- 4. 약 35분 경과
('32타3232', '일반', 3, 'B-1', 'general',
 NOW() - INTERVAL '35 minutes', NULL, NULL, NULL, NULL, NULL, 'user08'),

-- 5. 약 40분 경과 (일반회원, user11)
('65거6565', '일반', 1, 'B-4', 'general',
 NOW() - INTERVAL '40 minutes', NULL, NULL, NULL, NULL, NULL, 'user11'),

-- 6. 약 45분 경과
('76너7676', '일반', 2, 'B-5', 'general',
 NOW() - INTERVAL '45 minutes', NULL, NULL, NULL, NULL, NULL, 'user12'),

-- 7. 약 4시간 27분 경과 (정기권회원, user14)
('98나6789', '일반', 1, 'B-6', 'general',
 NOW() - INTERVAL '267 minutes', NULL, NULL, NULL, NULL, NULL, 'user14'),

-- 8. 약 50분 경과
('54사6543', '일반', 3, 'B-2', 'general',
 NOW() - INTERVAL '50 minutes', NULL, NULL, NULL, NULL, NULL, 'user18'),

-- 9. 약 60분 경과
('32자7654', '일반', 2, 'B-3', 'general',
 NOW() - INTERVAL '60 minutes', NULL, NULL, NULL, NULL, NULL, 'user20'),

-- 10. 약 75분 경과
('10카9876', '일반', 1, 'B-4', 'general',
 NOW() - INTERVAL '75 minutes', NULL, NULL, NULL, NULL, NULL, 'user22');