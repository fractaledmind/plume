SELECT +coalesce((select max(11) from t1 where not case d+t1.c*coalesce((select max(coalesce((select d | e from t1 where 17 not between coalesce((select (t1.d) from t1 where t1.a between (select max(t1.b+d+t1.a) from t1)-t1.e and 17),t1.a) and 11),19)) from t1 where t1.d<t1.b),d)+t1.e when t1.f then t1.d else t1.f end not in (e,t1.c,t1.c)),c) | c FROM t1 WHERE exists(select 1 from t1 where c in (t1.a,(select count(distinct  -t1.d) from t1),t1.b)) or (~d=t1.e)