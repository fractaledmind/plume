-- randexpr1.test
-- 
-- db eval {SELECT ~t1.a*(case when not not exists(select 1 from t1 where coalesce((select max(t1.c) from t1 where (select count(distinct b | case 13 | case when  -11<>a then t1.a else b end when t1.e then t1.b else d end*t1.f) from t1)<>17 or t1.a not between c and t1.a),11) in (t1.e,c,c)) and  -11>f then t1.d else f end-17)+ -(t1.b) FROM t1 WHERE NOT ((13-coalesce((select  -case when 19+c=a then f else 11 end*(e) from t1 where (t1.b in (select t1.a from t1 union select 11 from t1))),(t1.f))*e+f*(t1.f)=a and not 17 in (select max(f) from t1 union select max(19) from t1) or 19<>t1.f) and 13 between f and f and d<>b)}
SELECT ~t1.a*(case when not not exists(select 1 from t1 where coalesce((select max(t1.c) from t1 where (select count(distinct b | case 13 | case when  -11<>a then t1.a else b end when t1.e then t1.b else d end*t1.f) from t1)<>17 or t1.a not between c and t1.a),11) in (t1.e,c,c)) and  -11>f then t1.d else f end-17)+ -(t1.b) FROM t1 WHERE NOT ((13-coalesce((select  -case when 19+c=a then f else 11 end*(e) from t1 where (t1.b in (select t1.a from t1 union select 11 from t1))),(t1.f))*e+f*(t1.f)=a and not 17 in (select max(f) from t1 union select max(19) from t1) or 19<>t1.f) and 13 between f and f and d<>b)