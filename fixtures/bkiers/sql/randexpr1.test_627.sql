-- randexpr1.test
-- 
-- db eval {SELECT case case when (not exists(select 1 from t1 where  -e in (select t1.c from t1 union select b from t1))) then coalesce((select max(t1.d) from t1 where (17+~t1.c in (select min(t1.b) from t1 union select min(13) from t1))),t1.d)*t1.a+d when not a=a and t1.b not in (b,13,d) or d<13 or t1.f not between t1.c and f or t1.c<>c then t1.e else t1.d end when t1.c then (t1.d) else  -f end FROM t1 WHERE (abs(case when (t1.e in (17,19+t1.b,t1.a)) or (t1.d-19)+(t1.d)+t1.d in (select t1.f from t1 union select t1.e from t1) and 13 in (select t1.c from t1 union select c from t1) or 11 not between e and 17 then  -17-a else d end*13)/abs((b)))*d-f-13 between t1.d and (b)}
SELECT case case when (not exists(select 1 from t1 where  -e in (select t1.c from t1 union select b from t1))) then coalesce((select max(t1.d) from t1 where (17+~t1.c in (select min(t1.b) from t1 union select min(13) from t1))),t1.d)*t1.a+d when not a=a and t1.b not in (b,13,d) or d<13 or t1.f not between t1.c and f or t1.c<>c then t1.e else t1.d end when t1.c then (t1.d) else  -f end FROM t1 WHERE (abs(case when (t1.e in (17,19+t1.b,t1.a)) or (t1.d-19)+(t1.d)+t1.d in (select t1.f from t1 union select t1.e from t1) and 13 in (select t1.c from t1 union select c from t1) or 11 not between e and 17 then  -17-a else d end*13)/abs((b)))*d-f-13 between t1.d and (b)