-- randexpr1.test
-- 
-- db eval {SELECT (coalesce((select 19 from t1 where  - -t1.d | t1.c+~(select max(11) |  -~count(*)+count(*)-cast(avg(case when t1.e in (select a from t1 union select f from t1) then c else 11 end) AS integer) from t1)*coalesce((select t1.b from t1 where ((abs(t1.b)/abs(coalesce((select (b)-f from t1 where t1.f not in ( -e, -t1.b, -t1.d) and t1.d>=a or 19 not in (a,13,t1.f)),b))))<t1.e),f)+b<t1.c),d)) FROM t1 WHERE t1.f | +19+f*t1.d+t1.b*d<case when (select min(t1.e) from t1) not in (t1.b,11, -b*case c when coalesce((select max(t1.b+b) from t1 where 19+13=t1.f),coalesce((select max(19*f) from t1 where t1.a=a),a)) then d else t1.f end) then t1.f when f=t1.c then a else 19 end}
SELECT (coalesce((select 19 from t1 where  - -t1.d | t1.c+~(select max(11) |  -~count(*)+count(*)-cast(avg(case when t1.e in (select a from t1 union select f from t1) then c else 11 end) AS integer) from t1)*coalesce((select t1.b from t1 where ((abs(t1.b)/abs(coalesce((select (b)-f from t1 where t1.f not in ( -e, -t1.b, -t1.d) and t1.d>=a or 19 not in (a,13,t1.f)),b))))<t1.e),f)+b<t1.c),d)) FROM t1 WHERE t1.f | +19+f*t1.d+t1.b*d<case when (select min(t1.e) from t1) not in (t1.b,11, -b*case c when coalesce((select max(t1.b+b) from t1 where 19+13=t1.f),coalesce((select max(19*f) from t1 where t1.a=a),a)) then d else t1.f end) then t1.f when f=t1.c then a else 19 end