-- randexpr1.test
-- 
-- db eval {SELECT +coalesce((select case when coalesce((select f+t1.e from t1 where b not in (case when not exists(select 1 from t1 where (f not in (t1.f-t1.b,t1.d,t1.d))) then t1.a when t1.f*t1.c*17>+(t1.e*(d))-t1.d then t1.f else 11 end,17,f)),e) & 19-13<d then t1.a else t1.d end from t1 where d not between c and e),19) FROM t1 WHERE NOT (not exists(select 1 from t1 where ((t1.c not between case d-c+(t1.b) when d then 17 else 13 end+f and coalesce((select t1.f from t1 where ((t1.f*case when not exists(select 1 from t1 where t1.f>=t1.b) then (select max(11)-(count(distinct f)) from t1) else t1.a end+c in (t1.d,e,f) or e in (11,11,11)))),b)*t1.b*11))) and t1.b>=a)}
SELECT +coalesce((select case when coalesce((select f+t1.e from t1 where b not in (case when not exists(select 1 from t1 where (f not in (t1.f-t1.b,t1.d,t1.d))) then t1.a when t1.f*t1.c*17>+(t1.e*(d))-t1.d then t1.f else 11 end,17,f)),e) & 19-13<d then t1.a else t1.d end from t1 where d not between c and e),19) FROM t1 WHERE NOT (not exists(select 1 from t1 where ((t1.c not between case d-c+(t1.b) when d then 17 else 13 end+f and coalesce((select t1.f from t1 where ((t1.f*case when not exists(select 1 from t1 where t1.f>=t1.b) then (select max(11)-(count(distinct f)) from t1) else t1.a end+c in (t1.d,e,f) or e in (11,11,11)))),b)*t1.b*11))) and t1.b>=a)