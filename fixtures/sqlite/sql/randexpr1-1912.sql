SELECT case t1.c when (select abs( -max(t1.a*t1.f*t1.a*e)) from t1)*case when not exists(select 1 from t1 where (select cast(avg(c) AS integer) from t1) in (select case case when ( -case t1.f when 17 then t1.c else e end=17) then 19 else e end when e then c else  -a end*t1.d from t1 union select d from t1)) then e*t1.a else b end+e*t1.d+t1.b then t1.d else c end+t1.e FROM t1 WHERE NOT (13 in (select +abs(case count(distinct t1.e+(abs((abs(coalesce((select t1.b from t1 where coalesce((select max(case when (19<=t1.d) then (13) when a>=13 then 13 else t1.f end) from t1 where a in (t1.c,19,t1.b)),19)>13),d))/abs(f))+t1.a*t1.b)/abs(e))) when +cast(avg(c) AS integer) then ~~+max(f) | cast(avg(t1.c) AS integer) else count(distinct 13)+min(t1.b) | count(*) end)*max(t1.d)-count(*) from t1 union select count(*) from t1))