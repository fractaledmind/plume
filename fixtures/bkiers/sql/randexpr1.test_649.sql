-- randexpr1.test
-- 
-- db eval {SELECT case when 19<=19 then d when not exists(select 1 from t1 where case case when case when (select  -min(((t1.f)))*((cast(avg(t1.d) AS integer))) from t1) in (select t1.a-b from t1 union select 17 from t1) then f when (19 not between t1.c and 13 and f>13) then d else a end | b-t1.b in (t1.e,t1.f, -d) then t1.e when c<t1.e then ( -b) else (c) end-t1.e | (17)+17 when 13 then t1.a else d end+19>=17) then t1.e else t1.e end FROM t1 WHERE coalesce((select +a- -t1.d*b*coalesce((select t1.c from t1 where t1.a in (select (abs(11)/abs(case when not exists(select 1 from t1 where +e=t1.e) then case t1.b when a-c then b else b end when (not exists(select 1 from t1 where 19 in (select 13 from t1 union select t1.b from t1))) and e in (t1.e, -f,e) then 19 else t1.a end)) from t1 union select b from t1)),17)*d from t1 where t1.f not in (t1.a,(t1.b),t1.d)),13)<=(13)}
SELECT case when 19<=19 then d when not exists(select 1 from t1 where case case when case when (select  -min(((t1.f)))*((cast(avg(t1.d) AS integer))) from t1) in (select t1.a-b from t1 union select 17 from t1) then f when (19 not between t1.c and 13 and f>13) then d else a end | b-t1.b in (t1.e,t1.f, -d) then t1.e when c<t1.e then ( -b) else (c) end-t1.e | (17)+17 when 13 then t1.a else d end+19>=17) then t1.e else t1.e end FROM t1 WHERE coalesce((select +a- -t1.d*b*coalesce((select t1.c from t1 where t1.a in (select (abs(11)/abs(case when not exists(select 1 from t1 where +e=t1.e) then case t1.b when a-c then b else b end when (not exists(select 1 from t1 where 19 in (select 13 from t1 union select t1.b from t1))) and e in (t1.e, -f,e) then 19 else t1.a end)) from t1 union select b from t1)),17)*d from t1 where t1.f not in (t1.a,(t1.b),t1.d)),13)<=(13)