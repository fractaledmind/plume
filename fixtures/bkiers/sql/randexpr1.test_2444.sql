-- randexpr1.test
-- 
-- db eval {SELECT coalesce((select d-(abs(case when +coalesce((select 19 from t1 where not exists(select 1 from t1 where d | f in (select ~case count(distinct f) when ( -(cast(avg((( -19))) AS integer))) then (count(*)) else count(distinct 17) end*(max(t1.d)) from t1 union select min(b) from t1))),13) | t1.b+t1.e in (13,(t1.b),t1.a) then t1.a when a in (select t1.f from t1 union select t1.b from t1) then t1.e else a end)/abs(f))-t1.e from t1 where not exists(select 1 from t1 where not 19 in (select t1.b from t1 union select t1.f from t1) or 13 in (select e from t1 union select e from t1))),f) FROM t1 WHERE NOT (not exists(select 1 from t1 where case when not exists(select 1 from t1 where a<+case c when (abs(t1.b)/abs(e))+t1.b-b-t1.b then (t1.d)*t1.c else t1.d end) then b else 19 end in (select  -count(distinct c)*(max(f)) | ~+case min(t1.a) when cast(avg(c) AS integer) then cast(avg(t1.a) AS integer) | count(distinct t1.d)* -count(distinct t1.e) else ( -count(*)) end |  -cast(avg(t1.d) AS integer)+min(a)*count(distinct b) from t1 union select max(13) from t1)))}
SELECT coalesce((select d-(abs(case when +coalesce((select 19 from t1 where not exists(select 1 from t1 where d | f in (select ~case count(distinct f) when ( -(cast(avg((( -19))) AS integer))) then (count(*)) else count(distinct 17) end*(max(t1.d)) from t1 union select min(b) from t1))),13) | t1.b+t1.e in (13,(t1.b),t1.a) then t1.a when a in (select t1.f from t1 union select t1.b from t1) then t1.e else a end)/abs(f))-t1.e from t1 where not exists(select 1 from t1 where not 19 in (select t1.b from t1 union select t1.f from t1) or 13 in (select e from t1 union select e from t1))),f) FROM t1 WHERE NOT (not exists(select 1 from t1 where case when not exists(select 1 from t1 where a<+case c when (abs(t1.b)/abs(e))+t1.b-b-t1.b then (t1.d)*t1.c else t1.d end) then b else 19 end in (select  -count(distinct c)*(max(f)) | ~+case min(t1.a) when cast(avg(c) AS integer) then cast(avg(t1.a) AS integer) | count(distinct t1.d)* -count(distinct t1.e) else ( -count(*)) end |  -cast(avg(t1.d) AS integer)+min(a)*count(distinct b) from t1 union select max(13) from t1)))