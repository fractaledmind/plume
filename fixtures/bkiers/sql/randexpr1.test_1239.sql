-- randexpr1.test
-- 
-- db eval {SELECT ((select min(e+case when b not between coalesce((select t1.d & b from t1 where not exists(select 1 from t1 where 17>11)), -c) and (t1.a) or e<t1.b and (11)<>d then a when 19>11 then  -13 else t1.b end+13)+count(distinct d)+count(*)* -count(distinct t1.f)-((count(distinct t1.c)))+min(a) & max(c) from t1)*t1.e*19*11) FROM t1 WHERE b<>(select count(distinct f) from t1)}
SELECT ((select min(e+case when b not between coalesce((select t1.d & b from t1 where not exists(select 1 from t1 where 17>11)), -c) and (t1.a) or e<t1.b and (11)<>d then a when 19>11 then  -13 else t1.b end+13)+count(distinct d)+count(*)* -count(distinct t1.f)-((count(distinct t1.c)))+min(a) & max(c) from t1)*t1.e*19*11) FROM t1 WHERE b<>(select count(distinct f) from t1)