-- randexpr1.test
-- 
-- db eval {SELECT t1.f+coalesce((select t1.b-13-(coalesce((select 17 from t1 where b>a),13)*11)-t1.c from t1 where 11 between t1.a and  -13+t1.f*~coalesce((select max(b-f) from t1 where t1.a<=13 or a not in (13,f,17)),b) or (t1.d<19 or b> -t1.c)),b) FROM t1 WHERE NOT (11 not between d and coalesce((select  -(select (cast(avg(d) AS integer)) from t1) from t1 where case when 17<t1.a then t1.b else coalesce((select max(f) from t1 where t1.d-+case when (d<=t1.f) and t1.e not in (17,t1.d,t1.a) and 11 in (13,t1.e, -t1.a) and t1.c<13 then  -b else case when a>13 then e when 19 between t1.a and t1.b then b else b end end*13<=c),t1.c) end in (select t1.e from t1 union select d from t1)),t1.b))}
SELECT t1.f+coalesce((select t1.b-13-(coalesce((select 17 from t1 where b>a),13)*11)-t1.c from t1 where 11 between t1.a and  -13+t1.f*~coalesce((select max(b-f) from t1 where t1.a<=13 or a not in (13,f,17)),b) or (t1.d<19 or b> -t1.c)),b) FROM t1 WHERE NOT (11 not between d and coalesce((select  -(select (cast(avg(d) AS integer)) from t1) from t1 where case when 17<t1.a then t1.b else coalesce((select max(f) from t1 where t1.d-+case when (d<=t1.f) and t1.e not in (17,t1.d,t1.a) and 11 in (13,t1.e, -t1.a) and t1.c<13 then  -b else case when a>13 then e when 19 between t1.a and t1.b then b else b end end*13<=c),t1.c) end in (select t1.e from t1 union select d from t1)),t1.b))