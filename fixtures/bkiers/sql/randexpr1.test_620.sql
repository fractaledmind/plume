-- randexpr1.test
-- 
-- db eval {SELECT case when 13<11 then 19 when  -(abs(f)/abs(13))*17-13 | case t1.b when ~((select (count(*)-abs(case cast(avg(19) AS integer) when count(distinct 19)*(count(*))-count(*) then count(distinct t1.d) else  -count(distinct 17) end)+max(17)) from t1)) then t1.c else d end+11*t1.e*t1.a | e>(t1.c) then t1.d else t1.d end FROM t1 WHERE NOT (case when 17-t1.f in (select case  -~max(c-~e+19)*max(c)*count(*)+~count(distinct f)+case count(distinct d) when max(t1.b) then cast(avg(t1.d) AS integer) else count(distinct d) end-count(distinct d)*max(f)+ -count(distinct 13) when count(*) then ( -min(t1.c)) else min(( -d)) end from t1 union select  -min(c) from t1) then 13 else case t1.c when t1.c then f else d end end-e-(17) in (select c from t1 union select c from t1))}
SELECT case when 13<11 then 19 when  -(abs(f)/abs(13))*17-13 | case t1.b when ~((select (count(*)-abs(case cast(avg(19) AS integer) when count(distinct 19)*(count(*))-count(*) then count(distinct t1.d) else  -count(distinct 17) end)+max(17)) from t1)) then t1.c else d end+11*t1.e*t1.a | e>(t1.c) then t1.d else t1.d end FROM t1 WHERE NOT (case when 17-t1.f in (select case  -~max(c-~e+19)*max(c)*count(*)+~count(distinct f)+case count(distinct d) when max(t1.b) then cast(avg(t1.d) AS integer) else count(distinct d) end-count(distinct d)*max(f)+ -count(distinct 13) when count(*) then ( -min(t1.c)) else min(( -d)) end from t1 union select  -min(c) from t1) then 13 else case t1.c when t1.c then f else d end end-e-(17) in (select c from t1 union select c from t1))