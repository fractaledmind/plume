-- randexpr1.test
-- 
-- db eval {SELECT t1.b-case when 13 not between 13 and (select +count(*) from t1) then t1.e when +11 in (coalesce((select t1.f from t1 where d-((f))*coalesce((select d from t1 where 17 between ~(select max(d) | count(*) | cast(avg(e) AS integer)+count(*) from t1) and case when c<13 or 17>13 then a else e end-t1.b),e)-t1.a<=(t1.e)),19),b,13) then e else b end-t1.b FROM t1 WHERE NOT (t1.b>=coalesce((select max(d-c) from t1 where exists(select 1 from t1 where (~a*(select  -count(distinct 11-d*13+d+19) from t1)* -b in (f,t1.d-c,a-(abs(c)/abs(case when (abs(13- -(19))/abs(t1.f)) in (select c from t1 union select  -a from t1) then t1.c when b<=c then t1.a else  -13 end)))))),19))}
SELECT t1.b-case when 13 not between 13 and (select +count(*) from t1) then t1.e when +11 in (coalesce((select t1.f from t1 where d-((f))*coalesce((select d from t1 where 17 between ~(select max(d) | count(*) | cast(avg(e) AS integer)+count(*) from t1) and case when c<13 or 17>13 then a else e end-t1.b),e)-t1.a<=(t1.e)),19),b,13) then e else b end-t1.b FROM t1 WHERE NOT (t1.b>=coalesce((select max(d-c) from t1 where exists(select 1 from t1 where (~a*(select  -count(distinct 11-d*13+d+19) from t1)* -b in (f,t1.d-c,a-(abs(c)/abs(case when (abs(13- -(19))/abs(t1.f)) in (select c from t1 union select  -a from t1) then t1.c when b<=c then t1.a else  -13 end)))))),19))