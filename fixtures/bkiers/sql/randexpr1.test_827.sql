-- randexpr1.test
-- 
-- db eval {SELECT (a+case when (exists(select 1 from t1 where not exists(select 1 from t1 where not t1.e*13=13-f or (e)=t1.c or  -d not between t1.b and t1.a or e not between 17 and (a) and 11 not in (a,(t1.f),a) or t1.e<>13 or t1.d between t1.e and t1.c or t1.d=17 or a>=b))) and a between t1.e and t1.b then case when e not between (17) and t1.d then ~c*coalesce((select t1.a | 13+d from t1 where t1.e not between b and 11),t1.a) else t1.f end else t1.f end-11) FROM t1 WHERE case when case case when case when  -(select +min(11) from t1)*(13)>11 then t1.e when 13<e then 19 else c end in (t1.a,a,t1.e) then 17 when c<>t1.a then t1.d else  -t1.e end when (a) then a else t1.e end>t1.a then 13 when t1.a not in (t1.f,t1.b,t1.a) then a else t1.c end in (select cast(avg(13) AS integer) from t1 union select (max(t1.e)+min(17)) from t1)}
SELECT (a+case when (exists(select 1 from t1 where not exists(select 1 from t1 where not t1.e*13=13-f or (e)=t1.c or  -d not between t1.b and t1.a or e not between 17 and (a) and 11 not in (a,(t1.f),a) or t1.e<>13 or t1.d between t1.e and t1.c or t1.d=17 or a>=b))) and a between t1.e and t1.b then case when e not between (17) and t1.d then ~c*coalesce((select t1.a | 13+d from t1 where t1.e not between b and 11),t1.a) else t1.f end else t1.f end-11) FROM t1 WHERE case when case case when case when  -(select +min(11) from t1)*(13)>11 then t1.e when 13<e then 19 else c end in (t1.a,a,t1.e) then 17 when c<>t1.a then t1.d else  -t1.e end when (a) then a else t1.e end>t1.a then 13 when t1.a not in (t1.f,t1.b,t1.a) then a else t1.c end in (select cast(avg(13) AS integer) from t1 union select (max(t1.e)+min(17)) from t1)