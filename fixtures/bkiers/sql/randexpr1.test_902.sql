-- randexpr1.test
-- 
-- db eval {SELECT coalesce((select max(a) from t1 where t1.b<t1.b),13 |  -(coalesce((select max((abs(~t1.a | (abs(11)/abs((abs(t1.e)/abs(coalesce((select max(t1.e) from t1 where not exists(select 1 from t1 where exists(select 1 from t1 where (t1.d)<>e) and not exists(select 1 from t1 where (19)=t1.e))),19*t1.e)-t1.c)) | 17))*t1.b)/abs(17))) from t1 where (t1.b) between d and t1.b),t1.c)) | t1.f-c-d) FROM t1 WHERE 13 not in (f,t1.c+11*c,coalesce((select e from t1 where case t1.b when c- -case (select cast(avg(+t1.c*t1.f) AS integer) from t1) when 13*case when not case when  -17 in (select (t1.c) from t1 union select t1.c from t1) or t1.f in (t1.b,t1.d,t1.b) then t1.a when 11<>t1.c then e else a end>=(11) and a=d or  -t1.f between c and b then e else t1.f end then 19 else t1.d end then t1.c else t1.b end<>13),d))}
SELECT coalesce((select max(a) from t1 where t1.b<t1.b),13 |  -(coalesce((select max((abs(~t1.a | (abs(11)/abs((abs(t1.e)/abs(coalesce((select max(t1.e) from t1 where not exists(select 1 from t1 where exists(select 1 from t1 where (t1.d)<>e) and not exists(select 1 from t1 where (19)=t1.e))),19*t1.e)-t1.c)) | 17))*t1.b)/abs(17))) from t1 where (t1.b) between d and t1.b),t1.c)) | t1.f-c-d) FROM t1 WHERE 13 not in (f,t1.c+11*c,coalesce((select e from t1 where case t1.b when c- -case (select cast(avg(+t1.c*t1.f) AS integer) from t1) when 13*case when not case when  -17 in (select (t1.c) from t1 union select t1.c from t1) or t1.f in (t1.b,t1.d,t1.b) then t1.a when 11<>t1.c then e else a end>=(11) and a=d or  -t1.f between c and b then e else t1.f end then 19 else t1.d end then t1.c else t1.b end<>13),d))