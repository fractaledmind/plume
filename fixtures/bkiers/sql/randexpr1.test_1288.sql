-- randexpr1.test
-- 
-- db eval {SELECT case coalesce((select t1.e from t1 where 19 in (select 13 from t1 union select 11 | coalesce((select  -(t1.c) from t1 where t1.a<=t1.c),case when ~case when t1.e not between 11 and t1.e then d else 19 end+t1.a+f in (select  -(count(distinct  -c))-max(d)+count(distinct t1.d) from t1 union select cast(avg((b)) AS integer) from t1) then (t1.d) when not (t1.a not in ( -t1.e,t1.b,17) and 11<d) then e else b end) from t1)),11) when t1.c then a else a end-t1.b FROM t1 WHERE NOT (t1.d>=11*t1.d)}
SELECT case coalesce((select t1.e from t1 where 19 in (select 13 from t1 union select 11 | coalesce((select  -(t1.c) from t1 where t1.a<=t1.c),case when ~case when t1.e not between 11 and t1.e then d else 19 end+t1.a+f in (select  -(count(distinct  -c))-max(d)+count(distinct t1.d) from t1 union select cast(avg((b)) AS integer) from t1) then (t1.d) when not (t1.a not in ( -t1.e,t1.b,17) and 11<d) then e else b end) from t1)),11) when t1.c then a else a end-t1.b FROM t1 WHERE NOT (t1.d>=11*t1.d)