-- randexpr1.test
-- 
-- db eval {SELECT (case when (select count(*) from t1)++t1.d+b*t1.e | t1.a+coalesce((select max(t1.d) from t1 where d-19<>c),t1.a)+t1.f in (select coalesce((select max(b) from t1 where t1.c-case when t1.c in (select c from t1 union select t1.f from t1) then f when t1.c not in ( -e,t1.e,11) then (t1.e) else 13 end in (f,t1.e,t1.f) or t1.a not between 19 and 17),t1.c) from t1 union select e from t1) then  -t1.e else t1.a end) FROM t1 WHERE NOT (11*b+~ -coalesce((select t1.e from t1 where not exists(select 1 from t1 where 19=t1.f)),t1.d+(abs( -a)/abs(t1.d)))-t1.d-19<=11)}
SELECT (case when (select count(*) from t1)++t1.d+b*t1.e | t1.a+coalesce((select max(t1.d) from t1 where d-19<>c),t1.a)+t1.f in (select coalesce((select max(b) from t1 where t1.c-case when t1.c in (select c from t1 union select t1.f from t1) then f when t1.c not in ( -e,t1.e,11) then (t1.e) else 13 end in (f,t1.e,t1.f) or t1.a not between 19 and 17),t1.c) from t1 union select e from t1) then  -t1.e else t1.a end) FROM t1 WHERE NOT (11*b+~ -coalesce((select t1.e from t1 where not exists(select 1 from t1 where 19=t1.f)),t1.d+(abs( -a)/abs(t1.d)))-t1.d-19<=11)