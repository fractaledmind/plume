-- randexpr1.test
-- 
-- db eval {SELECT 11-coalesce((select max(coalesce((select max((select abs(case +max((e)) when abs(abs( -count(distinct e))) then +cast(avg(f) AS integer) else count(*) end+count(*)+min( -e)) from t1)) from t1 where t1.b in (select count(distinct (17 & case case when e in (13,t1.a,e) or t1.d>=t1.e then 17 else a end when t1.e then 17 else t1.d end*t1.c)) from t1 union select cast(avg(t1.a) AS integer) from t1)),17)) from t1 where t1.c in (select ~cast(avg(t1.b) AS integer) from t1 union select  -(cast(avg(t1.c) AS integer)) from t1)),(t1.c)) FROM t1 WHERE t1.b not in (case when 11 in (select case +min(t1.f) when (+cast(avg((case t1.c when a then f else a end-f)) AS integer)) then +count(distinct (t1.f))-count(distinct t1.f) else count(*) end-count(*) | count(*) from t1 union select min(e) from t1) then (abs(b | 13-f | c)/abs(t1.f)) else t1.c end,f,t1.b) or not  -t1.a<t1.f or t1.f>=11}
SELECT 11-coalesce((select max(coalesce((select max((select abs(case +max((e)) when abs(abs( -count(distinct e))) then +cast(avg(f) AS integer) else count(*) end+count(*)+min( -e)) from t1)) from t1 where t1.b in (select count(distinct (17 & case case when e in (13,t1.a,e) or t1.d>=t1.e then 17 else a end when t1.e then 17 else t1.d end*t1.c)) from t1 union select cast(avg(t1.a) AS integer) from t1)),17)) from t1 where t1.c in (select ~cast(avg(t1.b) AS integer) from t1 union select  -(cast(avg(t1.c) AS integer)) from t1)),(t1.c)) FROM t1 WHERE t1.b not in (case when 11 in (select case +min(t1.f) when (+cast(avg((case t1.c when a then f else a end-f)) AS integer)) then +count(distinct (t1.f))-count(distinct t1.f) else count(*) end-count(*) | count(*) from t1 union select min(e) from t1) then (abs(b | 13-f | c)/abs(t1.f)) else t1.c end,f,t1.b) or not  -t1.a<t1.f or t1.f>=11