-- randexpr1.test
-- 
-- db eval {SELECT case when (select +case  -+ -case min(t1.f) when cast(avg(t1.a) AS integer) then abs(~case (min(t1.a)) when (count(*)) then (min(e)) else count(*) end) else ( -cast(avg(b) AS integer)) end*count(*) | count(distinct 11) when  -cast(avg(13) AS integer) then  -min(13) else max(b) end+max(a) from t1) in ((abs(coalesce((select max(11*a) from t1 where t1.b>11-(select  -cast(avg(t1.d) AS integer) from t1)),case when exists(select 1 from t1 where t1.f<13) then a else e end))/abs(c)) | t1.f,f,f) then t1.e else a end FROM t1 WHERE (select case min(case when not 17<11 then (abs(+(d)*t1.c+e-f)/abs(13)) when b between a and 11 then e else b end) when abs(min(t1.b) | (+count(*))) | ~case ( -count(*))-cast(avg(a) AS integer) when count(distinct t1.a) then  -count(distinct f) else count(distinct 11) end then max( -t1.d) else  -max(f) end from t1)-~c*t1.a not in (t1.e,t1.c,t1.a)}
SELECT case when (select +case  -+ -case min(t1.f) when cast(avg(t1.a) AS integer) then abs(~case (min(t1.a)) when (count(*)) then (min(e)) else count(*) end) else ( -cast(avg(b) AS integer)) end*count(*) | count(distinct 11) when  -cast(avg(13) AS integer) then  -min(13) else max(b) end+max(a) from t1) in ((abs(coalesce((select max(11*a) from t1 where t1.b>11-(select  -cast(avg(t1.d) AS integer) from t1)),case when exists(select 1 from t1 where t1.f<13) then a else e end))/abs(c)) | t1.f,f,f) then t1.e else a end FROM t1 WHERE (select case min(case when not 17<11 then (abs(+(d)*t1.c+e-f)/abs(13)) when b between a and 11 then e else b end) when abs(min(t1.b) | (+count(*))) | ~case ( -count(*))-cast(avg(a) AS integer) when count(distinct t1.a) then  -count(distinct f) else count(distinct 11) end then max( -t1.d) else  -max(f) end from t1)-~c*t1.a not in (t1.e,t1.c,t1.a)