SELECT 19*case when coalesce((select max(t1.e-c) from t1 where f=(abs(coalesce((select t1.c from t1 where not (not exists(select 1 from t1 where a in (select b from t1 union select c from t1)))),13))/abs(coalesce((select 13 from t1 where t1.b in (d,t1.d,a)), -t1.b)))),c) in (select ~min(t1.c) from t1 union select count(*) from t1) and  -f<>t1.c then t1.a-t1.e when not t1.a in (select cast(avg(a) AS integer) from t1 union select min(13) from t1) then  -19 else f end FROM t1 WHERE 11<>13