SELECT coalesce((select max(case when f<=(17-coalesce((select ~t1.e+11 from t1 where t1.f in (select c from t1 union select b from t1)),f)) then  -case when e>case when 17+ -t1.b in (select cast(avg(f) AS integer) from t1 union select min(c-17+a) from t1) then  -17 else t1.d end then a when 19<11 then t1.a else t1.b end | t1.f else a end) from t1 where e between a and d),19) FROM t1 WHERE case 19 when ((select max(f) from t1)) then 13 else t1.d end-t1.c>a-b-t1.d