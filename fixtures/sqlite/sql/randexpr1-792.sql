SELECT (select  -max(d) from t1)+coalesce((select max(t1.e*t1.d*f) from t1 where t1.b-coalesce((select  -a*d from t1 where t1.c not in (t1.f,coalesce((select b+t1.b from t1 where t1.a not between f and t1.b),coalesce((select  -b from t1 where (t1.d>=t1.c) and 19<>t1.f),t1.a))-e*a,e)),(t1.a))+t1.f between 19 and e),t1.a)*a FROM t1 WHERE NOT (exists(select 1 from t1 where not exists(select 1 from t1 where case when t1.d-t1.b-t1.d*(case when t1.b>= -t1.d then c when t1.d not between c and t1.d then (19) else d end*e)+t1.d | 19>t1.c then e when exists(select 1 from t1 where t1.e not between d and t1.b or (17 in (t1.e, - -a,t1.d))) then t1.f else (e) end between 13 and e or 11>t1.b)))