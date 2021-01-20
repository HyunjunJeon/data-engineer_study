-- STEP 1. 조인 테이블 생성(timestamp는 월별로 묶기위해 to_char를 이용해 월로 변환하여 생성)
DROP TABLE tmp_week2_1;
CREATE TABLE tmp_week2_1 AS (
SELECT 
	T10.userid, 
    T10.channel, 
    T10.sessionid, 
    to_char(T11.ts, 'YYYY-MM') as ts
FROM 
	raw_data.user_session_channel T10, raw_data.session_timestamp T11
WHERE 
	T10.sessionid = T11.sessionid
)

-- STEP 2. 원하는 데이터 형식에 맞게끔 월별로 묶어서 중복을 제외한 실 사용자수 카운트
/*
    <데이터 예시>
    2019-05: 400
    2019-06: 500
    2019-07: 600
*/
/* 
    <실제 쿼리 작성 후 조회한 데이터>
    2019-05	281
    2019-06	459
    2019-07	623
    2019-09	639
    2019-10	763
    2019-08	662
    2019-11	721
*/
SELECT ts, count(distinct(userid))
FROM tmp_week2_1 
GROUP BY ts