SELECT case when case when not exists(select 1 from t1 where not exists(select 1 from t1 where (case when (select  -min(t1.e) from t1) in (select f from t1 union select d from t1) then +e else d end | t1.e not between t1.a and t1.b))) and not exists(select 1 from t1 where a>=t1.e) and b=e then 13 else coalesce((select 19 from t1 where t1.d>=t1.e),13) end<11*t1.b then 17 when 17 in (19,t1.e, -t1.c) or 17<f then t1.d else t1.b end FROM t1 WHERE exists(select 1 from t1 where f<=19)