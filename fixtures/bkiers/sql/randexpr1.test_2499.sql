-- randexpr1.test
-- 
-- db eval {SELECT case t1.d when e then t1.d else (abs(e-b)/abs(t1.c+a*a | 17+19*coalesce((select 17 from t1 where 11 between +(select abs(+cast(avg(13) AS integer)) from t1)*19 and t1.e),t1.e-11-t1.e+( -t1.e*13)*t1.e | e*t1.b)*f)) end FROM t1 WHERE (abs(t1.d)/abs(t1.c)) not between +13 and t1.c}
SELECT case t1.d when e then t1.d else (abs(e-b)/abs(t1.c+a*a | 17+19*coalesce((select 17 from t1 where 11 between +(select abs(+cast(avg(13) AS integer)) from t1)*19 and t1.e),t1.e-11-t1.e+( -t1.e*13)*t1.e | e*t1.b)*f)) end FROM t1 WHERE (abs(t1.d)/abs(t1.c)) not between +13 and t1.c