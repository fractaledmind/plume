-- randexpr1.test
-- 
-- db eval {SELECT case d*coalesce((select e from t1 where t1.f in (case when not exists(select 1 from t1 where 19>=(+f-13)) then case when not not exists(select 1 from t1 where 17>=t1.d-13) then f else d end else t1.c end,c,+(abs(e)/abs(19*d | case 19 when b then 17 else b end-b))) or e between 13 and a),19) when b then c else t1.b end FROM t1 WHERE NOT (t1.b<=coalesce((select coalesce((select t1.a from t1 where not t1.b*(select max(t1.d) from t1)<a),e)-b-~11+t1.d from t1 where c not in (((abs((select  -case  -case abs(+count(*)-(count(distinct a))) when min(a) then min(d) else cast(avg(t1.a) AS integer) end when min(19) then cast(avg(a) AS integer) else min(d) end from t1) | d)/abs(d)))+19,17,11-c)),t1.c))}
SELECT case d*coalesce((select e from t1 where t1.f in (case when not exists(select 1 from t1 where 19>=(+f-13)) then case when not not exists(select 1 from t1 where 17>=t1.d-13) then f else d end else t1.c end,c,+(abs(e)/abs(19*d | case 19 when b then 17 else b end-b))) or e between 13 and a),19) when b then c else t1.b end FROM t1 WHERE NOT (t1.b<=coalesce((select coalesce((select t1.a from t1 where not t1.b*(select max(t1.d) from t1)<a),e)-b-~11+t1.d from t1 where c not in (((abs((select  -case  -case abs(+count(*)-(count(distinct a))) when min(a) then min(d) else cast(avg(t1.a) AS integer) end when min(19) then cast(avg(a) AS integer) else min(d) end from t1) | d)/abs(d)))+19,17,11-c)),t1.c))