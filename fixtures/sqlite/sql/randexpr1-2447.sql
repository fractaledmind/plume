SELECT (t1.e)+t1.c-coalesce((select max((abs(coalesce((select case when f>=(abs(coalesce((select max(a) from t1 where 11*(t1.f)*a*t1.d=11),t1.b))/abs(t1.d))+t1.b then c when not exists(select 1 from t1 where t1.c<>b) then 13 else 11 end from t1 where (13 not in (f,t1.c,13))),b)+t1.d)/abs(t1.f))) from t1 where b<>t1.a),t1.a) & t1.d FROM t1 WHERE ~a<>a or d<>t1.e