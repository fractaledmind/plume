-- randexpr1.test
-- 
-- db eval {SELECT (abs(+coalesce((select t1.f from t1 where not exists(select 1 from t1 where (((c)<=t1.a)))),f+(select count(distinct t1.b) from t1)*t1.b+case when case (select count(*) from t1) when coalesce((select max(t1.f-e+13) from t1 where (t1.e>a and 19 not in (13,b,19))),t1.c)+e then t1.b else t1.b end in (select  -c from t1 union select c from t1) then f when t1.a>t1.e then t1.c else d end+ -13))/abs((t1.f))) FROM t1 WHERE coalesce((select t1.f from t1 where a>=e),13) between  -c and t1.a}
SELECT (abs(+coalesce((select t1.f from t1 where not exists(select 1 from t1 where (((c)<=t1.a)))),f+(select count(distinct t1.b) from t1)*t1.b+case when case (select count(*) from t1) when coalesce((select max(t1.f-e+13) from t1 where (t1.e>a and 19 not in (13,b,19))),t1.c)+e then t1.b else t1.b end in (select  -c from t1 union select c from t1) then f when t1.a>t1.e then t1.c else d end+ -13))/abs((t1.f))) FROM t1 WHERE coalesce((select t1.f from t1 where a>=e),13) between  -c and t1.a