-- randexpr1.test
-- 
-- db eval {SELECT case when (a not in (t1.e,(+case when t1.b<=(abs(coalesce((select max(a+(select count(distinct (select max(((abs( -t1.d)/abs(a))) & t1.c)*min(t1.e) from t1)) from t1)) from t1 where +t1.f>e),17))/abs( - -17)) then 17 else t1.d end-t1.b-d) &  -f,c)) then 11-t1.f when ( -13<e) then t1.d else a end FROM t1 WHERE NOT (t1.c not between ~case when case when (select  - -abs( -case  -count(distinct c) when count(*) then max(c) else count(distinct 13) end) | min(c) from t1) in (t1.f,b+11,19*t1.d) then 19 else a end*t1.b>13 or t1.e in (select (count(*)) from t1 union select cast(avg(t1.e) AS integer) from t1) or 19>17 and 13 not between 19 and 17 then (t1.f) when not t1.b<>t1.f or d<>b then t1.e else a end and c)}
SELECT case when (a not in (t1.e,(+case when t1.b<=(abs(coalesce((select max(a+(select count(distinct (select max(((abs( -t1.d)/abs(a))) & t1.c)*min(t1.e) from t1)) from t1)) from t1 where +t1.f>e),17))/abs( - -17)) then 17 else t1.d end-t1.b-d) &  -f,c)) then 11-t1.f when ( -13<e) then t1.d else a end FROM t1 WHERE NOT (t1.c not between ~case when case when (select  - -abs( -case  -count(distinct c) when count(*) then max(c) else count(distinct 13) end) | min(c) from t1) in (t1.f,b+11,19*t1.d) then 19 else a end*t1.b>13 or t1.e in (select (count(*)) from t1 union select cast(avg(t1.e) AS integer) from t1) or 19>17 and 13 not between 19 and 17 then (t1.f) when not t1.b<>t1.f or d<>b then t1.e else a end and c)