SELECT coalesce((select max(~t1.b) from t1 where b in (select count(distinct b) from t1 union select max(case coalesce((select max(b) from t1 where d in (select t1.f from t1 union select d from t1) and t1.a=d),t1.a) when  -t1.a then d*t1.e+t1.c-11+b & e-t1.a+e+t1.f else c end) from t1)),t1.a) FROM t1 WHERE (e<t1.f*case 17 when t1.a then t1.d else +coalesce((select max(17) from t1 where not 13<>~a-11),t1.f) end)