-- randexpr1.test
-- 
-- db eval {SELECT (abs(case when +a*t1.e+(abs(t1.e & 11+coalesce((select max(d) from t1 where (not not b<coalesce((select e from t1 where e<>19),17)) and t1.b>13 and d=t1.a and 13 in (d,t1.a,11)),t1.e)*d)/abs(11+t1.a-19))=c or b<>c then t1.e when b<>19 then 17 else b end)/abs(11)) FROM t1 WHERE (coalesce((select max(case when exists(select 1 from t1 where coalesce((select a from t1 where not 19-~(coalesce((select t1.d from t1 where d between e and 17),t1.a)-t1.a-17) in (t1.d,t1.e,19)),19)*11*d in (select d from t1 union select t1.b from t1)) then c when d between t1.a and  -19 then t1.e else 19 end-d*c) from t1 where (t1.f>=t1.c)),11)) not in (17,17,a)}
SELECT (abs(case when +a*t1.e+(abs(t1.e & 11+coalesce((select max(d) from t1 where (not not b<coalesce((select e from t1 where e<>19),17)) and t1.b>13 and d=t1.a and 13 in (d,t1.a,11)),t1.e)*d)/abs(11+t1.a-19))=c or b<>c then t1.e when b<>19 then 17 else b end)/abs(11)) FROM t1 WHERE (coalesce((select max(case when exists(select 1 from t1 where coalesce((select a from t1 where not 19-~(coalesce((select t1.d from t1 where d between e and 17),t1.a)-t1.a-17) in (t1.d,t1.e,19)),19)*11*d in (select d from t1 union select t1.b from t1)) then c when d between t1.a and  -19 then t1.e else 19 end-d*c) from t1 where (t1.f>=t1.c)),11)) not in (17,17,a)