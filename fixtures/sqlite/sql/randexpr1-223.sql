SELECT  -+(select count(distinct case when (case ~c & coalesce((select max(t1.e-f+t1.d) from t1 where b-coalesce((select max(b) from t1 where t1.c in (select max(t1.d) from t1 union select min(a) from t1)),t1.f) in (select t1.a from t1 union select e from t1)),c) when e then  -c else  -t1.b end in ( -19, -d,b)) then d when t1.e in (19,d,19) and (t1.b between c and t1.a) then t1.d else 17 end-d) from t1) FROM t1 WHERE NOT (f<= -b)