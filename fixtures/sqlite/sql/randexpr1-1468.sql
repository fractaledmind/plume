SELECT t1.e*~13-t1.a-~case when (abs(t1.a)/abs(coalesce((select max(t1.a) from t1 where e not between f and e-t1.b+13),case when (a in (select ( -c) from t1 union select 11 from t1) or exists(select 1 from t1 where 11 between f and t1.f)) then t1.b-a else  -t1.e end)+13*t1.f)) | 13<t1.a then t1.f when (t1.a in (select 19 from t1 union select c from t1)) then a else  -19 end FROM t1 WHERE NOT (exists(select 1 from t1 where t1.c*coalesce((select f from t1 where  - -f+b-(select min(t1.b) from t1) not in (c,17-t1.b*t1.a,t1.c)),case when (select abs(count(*)) from t1)<> -19-a then (a)-coalesce((select max(case when a in (13,t1.b,11) then t1.b else (13) end) from t1 where not exists(select 1 from t1 where t1.b>=b)),t1.c) else  -13 end)*(a)<17))