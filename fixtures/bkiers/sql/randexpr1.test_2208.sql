-- randexpr1.test
-- 
-- db eval {SELECT case when  -11-t1.b-f-t1.b>~c then t1.e else case when t1.d<>b*~17+t1.d*(select max(+(select count(distinct t1.a)+ -cast(avg(d) AS integer)*max(13) from t1)) from t1) or (abs(c)/abs(c)) not in (11,d,t1.c) then 13 when d in (select f from t1 union select b from t1) then t1.f else  -t1.a end+ -f end FROM t1 WHERE ~t1.b*19-d not between ~b and t1.f}
SELECT case when  -11-t1.b-f-t1.b>~c then t1.e else case when t1.d<>b*~17+t1.d*(select max(+(select count(distinct t1.a)+ -cast(avg(d) AS integer)*max(13) from t1)) from t1) or (abs(c)/abs(c)) not in (11,d,t1.c) then 13 when d in (select f from t1 union select b from t1) then t1.f else  -t1.a end+ -f end FROM t1 WHERE ~t1.b*19-d not between ~b and t1.f