-- randexpr1.test
-- 
-- db eval {SELECT c*(select (count(distinct (abs(case when t1.c<>e then e else 19 end)/abs(case when case when +case when a | t1.e+t1.e in (select  -count(*) from t1 union select (max(case when 11 not in (t1.f,11,f) then c when c not in (d,t1.f,t1.f) then  -t1.a else 13 end)) from t1) then 17 else 13 end>=t1.e then  -11 when (t1.f)>c then 11 else 11 end<=11 and not exists(select 1 from t1 where t1.a between t1.e and e) then 19 else (17) end)))) from t1) FROM t1 WHERE ((select  -case min(a-13*17+c*coalesce((select 19 from t1 where 19>=t1.d),(t1.b))+t1.e) when +(min(17)) then min(17) else +min(b) end* -cast(avg(19) AS integer)*count(*) from t1) not between a and d) and +c in (c,t1.d,d) or d<>t1.f}
SELECT c*(select (count(distinct (abs(case when t1.c<>e then e else 19 end)/abs(case when case when +case when a | t1.e+t1.e in (select  -count(*) from t1 union select (max(case when 11 not in (t1.f,11,f) then c when c not in (d,t1.f,t1.f) then  -t1.a else 13 end)) from t1) then 17 else 13 end>=t1.e then  -11 when (t1.f)>c then 11 else 11 end<=11 and not exists(select 1 from t1 where t1.a between t1.e and e) then 19 else (17) end)))) from t1) FROM t1 WHERE ((select  -case min(a-13*17+c*coalesce((select 19 from t1 where 19>=t1.d),(t1.b))+t1.e) when +(min(17)) then min(17) else +min(b) end* -cast(avg(19) AS integer)*count(*) from t1) not between a and d) and +c in (c,t1.d,d) or d<>t1.f