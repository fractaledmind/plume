SELECT case when t1.a-coalesce((select t1.b from t1 where (d<=~a)),t1.b+t1.d & 19+13)-t1.a & ~coalesce((select ~17 from t1 where not exists(select 1 from t1 where ~case when 13 in (select +(cast(avg(b) AS integer)) from t1 union select count(*) from t1) then 17 when 11 not in (c,t1.a,t1.a) then e else e end*a not between 11 and c)),t1.c) in (11,t1.a,e) then t1.f when 19 in (select ~count(distinct d) from t1 union select cast(avg(19) AS integer) from t1) then t1.d else 19 end FROM t1 WHERE NOT (not exists(select 1 from t1 where (select count(*) from t1)+coalesce((select max(a) from t1 where t1.a between (abs(case when exists(select 1 from t1 where case when t1.e=case when 19 between 11 and e then t1.f else a end then t1.e else t1.b end in (select count(distinct d) | max(11)*abs(case count(*) when max(f) then cast(avg(e) AS integer) else count(distinct t1.e) end) from t1 union select  -cast(avg(c) AS integer) from t1)) then (select  -min(e) from t1) when (c>e) then t1.d else f end)/abs(b)) and (17)),e) not between t1.a and d))