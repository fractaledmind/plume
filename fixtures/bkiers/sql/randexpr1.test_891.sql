-- randexpr1.test
-- 
-- db eval {SELECT t1.c-t1.f-coalesce((select max(a) from t1 where e in ((abs(a)/abs(t1.d))*coalesce((select max((abs(case when e>=+t1.b then f when t1.c+f<a or e<>13 then t1.d else t1.a end)/abs(t1.d))) from t1 where t1.c not between t1.c and 11 and e>d),f)*t1.e+d,a,13)),e) | t1.b FROM t1 WHERE NOT ((abs(+(+t1.a)+case a-case when c>=d then 13 when t1.c not in (17,17,e) then a else t1.d end when c then  -f else b end*d)/abs(17))<=11 and 11 in (select cast(avg(17) AS integer) from t1 union select min( -19)+(case max(a) when abs(count(*)) then  -abs(count(*)*min(t1.e)+max(11)) else min(c) end) from t1))}
SELECT t1.c-t1.f-coalesce((select max(a) from t1 where e in ((abs(a)/abs(t1.d))*coalesce((select max((abs(case when e>=+t1.b then f when t1.c+f<a or e<>13 then t1.d else t1.a end)/abs(t1.d))) from t1 where t1.c not between t1.c and 11 and e>d),f)*t1.e+d,a,13)),e) | t1.b FROM t1 WHERE NOT ((abs(+(+t1.a)+case a-case when c>=d then 13 when t1.c not in (17,17,e) then a else t1.d end when c then  -f else b end*d)/abs(17))<=11 and 11 in (select cast(avg(17) AS integer) from t1 union select min( -19)+(case max(a) when abs(count(*)) then  -abs(count(*)*min(t1.e)+max(11)) else min(c) end) from t1))