-- randexpr1.test
-- 
-- db eval {SELECT case when ((coalesce((select max((select ~cast(avg((~d*f)) AS integer) from t1)) from t1 where  - -t1.f<>d),e) in (select cast(avg(+13) AS integer)*~count(*) & case count(*) when  -abs(abs(max(f))) then cast(avg(e) AS integer) else (count(distinct b)) end from t1 union select count(*) from t1) and b>= -t1.d)) then (17) when b between 13 and t1.d then  -e+t1.a else t1.f end FROM t1 WHERE NOT ((case when +t1.f-(select abs(count(distinct d)) from t1)*case when c in (select min(b) from t1 union select max(c+f*case 11*t1.b when b then t1.c else c end | t1.a) from t1) then d else f end | t1.a*b in (t1.d,17,a) then  -t1.a else t1.d end) in (e,t1.c,f) and  -((t1.c)) in (11,t1.e,t1.c))}
SELECT case when ((coalesce((select max((select ~cast(avg((~d*f)) AS integer) from t1)) from t1 where  - -t1.f<>d),e) in (select cast(avg(+13) AS integer)*~count(*) & case count(*) when  -abs(abs(max(f))) then cast(avg(e) AS integer) else (count(distinct b)) end from t1 union select count(*) from t1) and b>= -t1.d)) then (17) when b between 13 and t1.d then  -e+t1.a else t1.f end FROM t1 WHERE NOT ((case when +t1.f-(select abs(count(distinct d)) from t1)*case when c in (select min(b) from t1 union select max(c+f*case 11*t1.b when b then t1.c else c end | t1.a) from t1) then d else f end | t1.a*b in (t1.d,17,a) then  -t1.a else t1.d end) in (e,t1.c,f) and  -((t1.c)) in (11,t1.e,t1.c))