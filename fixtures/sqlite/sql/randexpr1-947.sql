SELECT case when (e)- -((select case min(case when e in (select coalesce((select max(d) from t1 where 13<>(t1.d-e)),e) from t1 union select c from t1) then d else  -11 end+a) when count(distinct  -f) then count(*) else  -(case cast(avg(17) AS integer)- -count(distinct t1.c)+cast(avg(b) AS integer) when  -max(11) then count(*) else cast(avg(t1.e) AS integer) end+max(t1.f)) end from t1))<=t1.b & t1.e then t1.d when not exists(select 1 from t1 where c<>13) then 11 else d end FROM t1 WHERE NOT ((select max(t1.a*case f when b then ~case when not exists(select 1 from t1 where f-d>(select abs(cast(avg(~17+b+d) AS integer)) from t1) or f-e in (select b from t1 union select t1.d from t1) or exists(select 1 from t1 where 13<>b)) then (abs(a)/abs( -d)) when (d<t1.a) then e else t1.e end else t1.a end) from t1)*t1.e in (select t1.f from t1 union select t1.b from t1))