-- randexpr1.test
-- 
-- db eval {SELECT (abs( -c+b)/abs(case when ~11 in (select t1.c from t1 union select coalesce((select t1.f from t1 where coalesce((select max(17) from t1 where coalesce((select case  -t1.d when t1.e then a else b end-(t1.d) from t1 where t1.a not between  -a and t1.b or t1.f<t1.e and e<=a),t1.e)*t1.d not in (b,11,t1.f)),19)<19 and not exists(select 1 from t1 where t1.f>=t1.b) and (f)>= -13),t1.b) from t1) then t1.c when t1.b<=t1.f then 13 else t1.e end)) FROM t1 WHERE (d-coalesce((select max(case 11 when +13-17 | 13 | coalesce((select t1.b from t1 where ((abs(t1.b)/abs((abs(b)/abs(+(19)))*t1.c)) | a in ( -t1.c,t1.a,t1.b))),d)* -d then 13 else 11 end) from t1 where e not in (d,11,11) or t1.e>t1.e),17)+t1.a>b)}
SELECT (abs( -c+b)/abs(case when ~11 in (select t1.c from t1 union select coalesce((select t1.f from t1 where coalesce((select max(17) from t1 where coalesce((select case  -t1.d when t1.e then a else b end-(t1.d) from t1 where t1.a not between  -a and t1.b or t1.f<t1.e and e<=a),t1.e)*t1.d not in (b,11,t1.f)),19)<19 and not exists(select 1 from t1 where t1.f>=t1.b) and (f)>= -13),t1.b) from t1) then t1.c when t1.b<=t1.f then 13 else t1.e end)) FROM t1 WHERE (d-coalesce((select max(case 11 when +13-17 | 13 | coalesce((select t1.b from t1 where ((abs(t1.b)/abs((abs(b)/abs(+(19)))*t1.c)) | a in ( -t1.c,t1.a,t1.b))),d)* -d then 13 else 11 end) from t1 where e not in (d,11,11) or t1.e>t1.e),17)+t1.a>b)