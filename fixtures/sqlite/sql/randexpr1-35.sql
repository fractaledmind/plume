SELECT case when t1.d not in (t1.d,coalesce((select max(11) from t1 where f not between 13 and c-coalesce((select max(d) from t1 where 19 not in ((t1.f),f,11)),t1.d)*t1.e | a),13), -(t1.e)) then t1.b when t1.f=t1.a and exists(select 1 from t1 where b in (select c from t1 union select 11 from t1) and t1.c=b and not  -d in (t1.d,t1.d,t1.b) and d between 11 and c) or d<=17 or a not in (e,19,(t1.b)) then 17 else 11 end FROM t1 WHERE a<>f+f