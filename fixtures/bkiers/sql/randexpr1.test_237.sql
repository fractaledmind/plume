-- randexpr1.test
-- 
-- db eval {SELECT (coalesce((select max(case when t1.e>= -e & 13-19*d then case when c not in (+(select count(*) from t1),coalesce((select max(t1.a) from t1 where 13 in (select case count(distinct t1.a) & count(*) when cast(avg(t1.b) AS integer) then count(distinct a) else min(11) end from t1 union select count(*) from t1)),19),t1.a) then t1.c else c end when t1.f in (select t1.f from t1 union select t1.e from t1) then t1.e else  -t1.e end) from t1 where (17 in (e,d,a))),t1.d)* -19) FROM t1 WHERE NOT ((((abs(t1.f)/abs(d)) in (select case (case max(coalesce((select max(e*(t1.d*13+t1.b)-t1.b) from t1 where t1.a=13),(t1.c))) when (case max(t1.a) when  -abs(max(17))-count(distinct 19) then cast(avg(t1.d) AS integer) else max(13) end)*count(distinct t1.c) then (max((t1.b))) else min(19) end) when max(f) then  -(count(distinct t1.f)) else min(t1.b) end from t1 union select cast(avg(13) AS integer) from t1) and (13 in (select ((min(b))) from t1 union select  - -count(*) from t1)))))}
SELECT (coalesce((select max(case when t1.e>= -e & 13-19*d then case when c not in (+(select count(*) from t1),coalesce((select max(t1.a) from t1 where 13 in (select case count(distinct t1.a) & count(*) when cast(avg(t1.b) AS integer) then count(distinct a) else min(11) end from t1 union select count(*) from t1)),19),t1.a) then t1.c else c end when t1.f in (select t1.f from t1 union select t1.e from t1) then t1.e else  -t1.e end) from t1 where (17 in (e,d,a))),t1.d)* -19) FROM t1 WHERE NOT ((((abs(t1.f)/abs(d)) in (select case (case max(coalesce((select max(e*(t1.d*13+t1.b)-t1.b) from t1 where t1.a=13),(t1.c))) when (case max(t1.a) when  -abs(max(17))-count(distinct 19) then cast(avg(t1.d) AS integer) else max(13) end)*count(distinct t1.c) then (max((t1.b))) else min(19) end) when max(f) then  -(count(distinct t1.f)) else min(t1.b) end from t1 union select cast(avg(13) AS integer) from t1) and (13 in (select ((min(b))) from t1 union select  - -count(*) from t1)))))