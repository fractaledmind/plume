SELECT (select cast(avg(coalesce((select max(coalesce((select e from t1 where not ((coalesce((select b from t1 where coalesce((select max(11) from t1 where exists(select 1 from t1 where (a in (select count(*)+max(((t1.a))) from t1 union select cast(avg(a) AS integer) from t1)))),b)<=19), -b))*f<t1.b and not exists(select 1 from t1 where d>=t1.e) and 17<>11 and e in (t1.f,f,17)) or a not between  -a and (17)),+~b)-17*b) from t1 where t1.b>=b),t1.a)) AS integer) from t1) FROM t1 WHERE f in (select cast(avg(t1.e-f-t1.e) AS integer)+min(t1.d) from t1 union select max(case b when 11 then case case when f in (a,a,f) then t1.b when (t1.f)>d then  -19 else t1.a end when 11 then a else t1.e end else (t1.b) end*a)*cast(avg(a) AS integer)+ -+cast(avg(t1.e) AS integer)*case cast(avg(t1.e) AS integer) when (cast(avg( -t1.a) AS integer)) then count(*) else count(*) end*min(t1.d)*min(e) from t1) and (a between d and t1.f)