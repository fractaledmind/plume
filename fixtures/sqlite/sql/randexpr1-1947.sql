SELECT b-case when a not between t1.f and case when t1.d in (select count(*) from t1 union select cast(avg(coalesce((select +11*t1.e from t1 where e+b<case when 19 not in (t1.a & c,t1.a,f) then 13 when  -b<=17 then t1.e else a end),17)) AS integer) from t1) then 13 when not exists(select 1 from t1 where 13 between e and 17) or (a= -13) then t1.e else  -11 end then 11 else t1.a end FROM t1 WHERE not exists(select 1 from t1 where (e+17+t1.f)<=(case b when ~t1.f+(select +max(t1.f*case t1.b when +t1.f then t1.b else case when (not case when c=d then t1.c when t1.c<>b and t1.d between c and b then t1.d else t1.d end<t1.b) then t1.d when f<= -a then case when 17<c then a else a end else t1.e end end) from t1)*+t1.f then e else 17 end))