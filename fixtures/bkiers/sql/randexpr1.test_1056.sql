-- randexpr1.test
-- 
-- db eval {SELECT  -13-case when (not d<=11-t1.c*t1.e+t1.b) then case when t1.f | coalesce((select +d from t1 where t1.d= -c),(t1.a)) not between b and t1.a then t1.f+a when t1.a<11 and exists(select 1 from t1 where t1.f in (t1.b,17,11)) then b else 19 end when (t1.b between t1.d and e) then b else  -t1.c end FROM t1 WHERE NOT (case when b between case when coalesce((select t1.c-t1.c from t1 where 13*(select case min(11) when cast(avg(t1.c) AS integer) then (count(*)) else count(distinct 11) end+cast(avg( -f) AS integer) from t1)>=t1.a),t1.c) in ( -t1.c,d,b) then t1.e when f in (select e from t1 union select t1.d from t1) then f else c end and a and 13<>c and exists(select 1 from t1 where f<>c) then case when c in (11,b, -11) then t1.e else e end else 13 end<=t1.c)}
SELECT  -13-case when (not d<=11-t1.c*t1.e+t1.b) then case when t1.f | coalesce((select +d from t1 where t1.d= -c),(t1.a)) not between b and t1.a then t1.f+a when t1.a<11 and exists(select 1 from t1 where t1.f in (t1.b,17,11)) then b else 19 end when (t1.b between t1.d and e) then b else  -t1.c end FROM t1 WHERE NOT (case when b between case when coalesce((select t1.c-t1.c from t1 where 13*(select case min(11) when cast(avg(t1.c) AS integer) then (count(*)) else count(distinct 11) end+cast(avg( -f) AS integer) from t1)>=t1.a),t1.c) in ( -t1.c,d,b) then t1.e when f in (select e from t1 union select t1.d from t1) then f else c end and a and 13<>c and exists(select 1 from t1 where f<>c) then case when c in (11,b, -11) then t1.e else e end else 13 end<=t1.c)