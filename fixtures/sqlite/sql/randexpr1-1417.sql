SELECT case when t1.d in (select case when exists(select 1 from t1 where 13>19) then  -d when ~c in (select min(e) from t1 union select cast(avg(case when c not between b and t1.a then b else 13-e+t1.e end) AS integer) from t1) then 13-coalesce((select max(coalesce((select max(19) from t1 where (17=a)),13)) from t1 where t1.a>=c),a) else t1.d end*(t1.c) from t1 union select (11) from t1) then a when b not in (e,t1.f,13) then t1.f else 13 end FROM t1 WHERE 13<>e or t1.a in (select f from t1 union select f from t1)