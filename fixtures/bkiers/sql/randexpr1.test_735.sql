-- randexpr1.test
-- 
-- db eval {SELECT case when t1.e not between e and 13 then (select count(*) from t1) when f>=case when c in (select a from t1 union select t1.e+coalesce((select 11 from t1 where (select count(distinct t1.b) from t1)+17 not in (b,t1.c,t1.f-(select ~count(distinct 17) from t1)+ -e)),13) from t1) or 19 between d and t1.f then (select min(19) from t1) when not (e not between c and a) then d else a end then d else (t1.c) end FROM t1 WHERE NOT (f not in (17,f+d | f+case when  -f=19 then (select max((select +abs(abs(max(((select ((max(t1.d))+count(distinct t1.e))-min(t1.a) from t1))+t1.e)-abs(count(distinct  -t1.b)-count(distinct 11)))*min(a)-count(*))-min(t1.a) from t1)) from t1) else t1.f end,c-a) and c<>11)}
SELECT case when t1.e not between e and 13 then (select count(*) from t1) when f>=case when c in (select a from t1 union select t1.e+coalesce((select 11 from t1 where (select count(distinct t1.b) from t1)+17 not in (b,t1.c,t1.f-(select ~count(distinct 17) from t1)+ -e)),13) from t1) or 19 between d and t1.f then (select min(19) from t1) when not (e not between c and a) then d else a end then d else (t1.c) end FROM t1 WHERE NOT (f not in (17,f+d | f+case when  -f=19 then (select max((select +abs(abs(max(((select ((max(t1.d))+count(distinct t1.e))-min(t1.a) from t1))+t1.e)-abs(count(distinct  -t1.b)-count(distinct 11)))*min(a)-count(*))-min(t1.a) from t1)) from t1) else t1.f end,c-a) and c<>11)