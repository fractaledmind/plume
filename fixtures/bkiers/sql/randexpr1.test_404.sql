-- randexpr1.test
-- 
-- db eval {SELECT case when d=c-(select (~max(t1.f*t1.c-11)) from t1) then coalesce((select max(19) from t1 where 13<coalesce((select case when (select count(distinct t1.f+13) from t1)>d then t1.e when not not exists(select 1 from t1 where t1.c not in (a,a,t1.d) and d not between b and 19) then t1.a else 11 end*f-f from t1 where t1.f between e and e and d between 19 and t1.e or 11<>t1.a),t1.c)),d) else 17 end FROM t1 WHERE NOT ((t1.e=11))}
SELECT case when d=c-(select (~max(t1.f*t1.c-11)) from t1) then coalesce((select max(19) from t1 where 13<coalesce((select case when (select count(distinct t1.f+13) from t1)>d then t1.e when not not exists(select 1 from t1 where t1.c not in (a,a,t1.d) and d not between b and 19) then t1.a else 11 end*f-f from t1 where t1.f between e and e and d between 19 and t1.e or 11<>t1.a),t1.c)),d) else 17 end FROM t1 WHERE NOT ((t1.e=11))