-- randexpr1.test
-- 
-- db eval {SELECT 13-(select cast(avg(t1.c-13) AS integer) from t1) | 11+t1.b | coalesce((select max(case when b in (select case  -case max(17) when ~cast(avg(13-t1.a) AS integer) then count(distinct 13) else  - -((cast(avg(e) AS integer))) end when cast(avg(t1.c) AS integer) then count(distinct d) else count(*) end from t1 union select count(*) from t1) then case when t1.d<>~13 then b when t1.c<>13 then t1.a else a end else t1.a end) from t1 where t1.f<>( -(17))),t1.e)+c FROM t1 WHERE (~coalesce((select (11+t1.d) from t1 where 17 in (select f+a from t1 union select case when 11>coalesce((select  -case when (11 not in (t1.f,(abs(t1.a)/abs((select count(distinct  -case when 13<=e then c when d between (t1.d) and t1.d then a else 11 end) from t1)-f)),c)) then f when (t1.f>t1.d) then 17 else 13 end from t1 where t1.e>a),17) then f else t1.b end from t1)),b)*13>e)}
SELECT 13-(select cast(avg(t1.c-13) AS integer) from t1) | 11+t1.b | coalesce((select max(case when b in (select case  -case max(17) when ~cast(avg(13-t1.a) AS integer) then count(distinct 13) else  - -((cast(avg(e) AS integer))) end when cast(avg(t1.c) AS integer) then count(distinct d) else count(*) end from t1 union select count(*) from t1) then case when t1.d<>~13 then b when t1.c<>13 then t1.a else a end else t1.a end) from t1 where t1.f<>( -(17))),t1.e)+c FROM t1 WHERE (~coalesce((select (11+t1.d) from t1 where 17 in (select f+a from t1 union select case when 11>coalesce((select  -case when (11 not in (t1.f,(abs(t1.a)/abs((select count(distinct  -case when 13<=e then c when d between (t1.d) and t1.d then a else 11 end) from t1)-f)),c)) then f when (t1.f>t1.d) then 17 else 13 end from t1 where t1.e>a),17) then f else t1.b end from t1)),b)*13>e)