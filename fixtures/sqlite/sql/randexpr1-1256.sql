SELECT (abs(case when (t1.d*coalesce((select max(case coalesce((select max(e) from t1 where t1.a not in (coalesce((select (select count(distinct t1.e) from t1) from t1 where c>=t1.c),f),19,a)),t1.a) when t1.c then t1.a else b end-a) from t1 where c>t1.d),b)<= -11) then t1.a when not exists(select 1 from t1 where not (t1.d=e) or t1.f between t1.a and  -e and (t1.c)=f and a not in (t1.c,a,c)) then t1.a else t1.a end)/abs( -13))+e-d FROM t1 WHERE 17 not in (13,19,t1.c)