-- randexpr1.test
-- 
-- db eval {SELECT coalesce((select t1.c from t1 where  -a in (select e from t1 union select 13 from t1)),(select count(distinct coalesce((select max((17)) from t1 where c not between case 19-t1.b when a then ~+(abs((select count(distinct (t1.a)) from t1)+(t1.b))/abs((t1.a)*a+13 & t1.d & t1.a)) else a end and 13 or d in (a,a,t1.f)),d)) from t1) & t1.d) FROM t1 WHERE e<d or case case when  -t1.a between coalesce((select coalesce((select d from t1 where (t1.f=~coalesce((select max(t1.d) from t1 where t1.d<=t1.e),f)*19)),17) from t1 where (t1.f in ( -11,t1.f,a)) or 19<=13),t1.b) and c then t1.f when t1.d=f then t1.f else f end when t1.d then 11 else 17 end*t1.e not in (t1.a,t1.f,e)}
SELECT coalesce((select t1.c from t1 where  -a in (select e from t1 union select 13 from t1)),(select count(distinct coalesce((select max((17)) from t1 where c not between case 19-t1.b when a then ~+(abs((select count(distinct (t1.a)) from t1)+(t1.b))/abs((t1.a)*a+13 & t1.d & t1.a)) else a end and 13 or d in (a,a,t1.f)),d)) from t1) & t1.d) FROM t1 WHERE e<d or case case when  -t1.a between coalesce((select coalesce((select d from t1 where (t1.f=~coalesce((select max(t1.d) from t1 where t1.d<=t1.e),f)*19)),17) from t1 where (t1.f in ( -11,t1.f,a)) or 19<=13),t1.b) and c then t1.f when t1.d=f then t1.f else f end when t1.d then 11 else 17 end*t1.e not in (t1.a,t1.f,e)