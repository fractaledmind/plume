SELECT (select case count(distinct ~case when (abs(coalesce((select t1.e from t1 where (not exists(select 1 from t1 where a & e between c and coalesce((select (t1.d) from t1 where (t1.a=t1.a)), -(c))))),b+19))/abs(d))>11 then b else t1.d end) when count(distinct 17) then ~min((t1.d))-case  -(case  -cast(avg(t1.b) AS integer) when  -max(13) then (min(t1.d)) else count(distinct t1.b) end+(min(t1.e)))*(cast(avg( -17) AS integer)) when  -count(distinct 19) then count(*) else max(t1.c) end else count(distinct f) end from t1) FROM t1 WHERE NOT (t1.e=t1.d)