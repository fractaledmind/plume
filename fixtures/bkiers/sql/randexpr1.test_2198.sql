-- randexpr1.test
-- 
-- db eval {SELECT (select abs(abs( -case case ~count(distinct t1.f+(t1.f)+coalesce((select (abs(t1.e+(b)+a)/abs(11))+b from t1 where exists(select 1 from t1 where t1.f not in (t1.b,(b),e) and not (t1.b)>c)),f)) when ~count(*)-min(t1.f) then +(count(*))*( -count(*)-max(t1.a)) else min(11) end when count(distinct (f)) then  -count(distinct a) else count(*) end | count(distinct 13))) from t1) FROM t1 WHERE exists(select 1 from t1 where case when t1.f>(abs(b)/abs(a)) then ~case when t1.e+13-b<=(coalesce((select max(11) from t1 where (select abs(min(11)) from t1) in (select case d when f then 17 else t1.f end from t1 union select t1.f from t1)),b)*13)-19 then 11 when not 19 between t1.c and t1.b then a else e end-t1.a when (t1.a) not between b and t1.f then t1.a else c end=t1.e)}
SELECT (select abs(abs( -case case ~count(distinct t1.f+(t1.f)+coalesce((select (abs(t1.e+(b)+a)/abs(11))+b from t1 where exists(select 1 from t1 where t1.f not in (t1.b,(b),e) and not (t1.b)>c)),f)) when ~count(*)-min(t1.f) then +(count(*))*( -count(*)-max(t1.a)) else min(11) end when count(distinct (f)) then  -count(distinct a) else count(*) end | count(distinct 13))) from t1) FROM t1 WHERE exists(select 1 from t1 where case when t1.f>(abs(b)/abs(a)) then ~case when t1.e+13-b<=(coalesce((select max(11) from t1 where (select abs(min(11)) from t1) in (select case d when f then 17 else t1.f end from t1 union select t1.f from t1)),b)*13)-19 then 11 when not 19 between t1.c and t1.b then a else e end-t1.a when (t1.a) not between b and t1.f then t1.a else c end=t1.e)