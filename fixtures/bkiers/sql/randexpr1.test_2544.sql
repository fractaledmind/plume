-- randexpr1.test
-- 
-- db eval {SELECT case when f | c>t1.d-case when (abs(t1.b-t1.d*f)/abs(c))=t1.e then 17 when not exists(select 1 from t1 where t1.b=(11) or c not in (13,17,b)) or a<e then t1.f else 19 end+b-t1.f and t1.b between t1.b and t1.f and e in (t1.f,b,b) then (select cast(avg(e) AS integer)-~ -~count(*) from t1) else 11 end FROM t1 WHERE NOT (e<=case when (case when 17<>a then t1.c when not 11<(f) then case when t1.c= -b then c else 11 end else e end | f>=t1.b and b not between  -(t1.e) and f) then 17 when f in (select  -count(distinct t1.e) from t1 union select case min(f) when case cast(avg( -t1.b) AS integer) when cast(avg(e) AS integer) then  -max(e) else min(t1.b) end then count(*) else (cast(avg(t1.e) AS integer)) end from t1) then case c when e then t1.f else 13 end else t1.d end)}
SELECT case when f | c>t1.d-case when (abs(t1.b-t1.d*f)/abs(c))=t1.e then 17 when not exists(select 1 from t1 where t1.b=(11) or c not in (13,17,b)) or a<e then t1.f else 19 end+b-t1.f and t1.b between t1.b and t1.f and e in (t1.f,b,b) then (select cast(avg(e) AS integer)-~ -~count(*) from t1) else 11 end FROM t1 WHERE NOT (e<=case when (case when 17<>a then t1.c when not 11<(f) then case when t1.c= -b then c else 11 end else e end | f>=t1.b and b not between  -(t1.e) and f) then 17 when f in (select  -count(distinct t1.e) from t1 union select case min(f) when case cast(avg( -t1.b) AS integer) when cast(avg(e) AS integer) then  -max(e) else min(t1.b) end then count(*) else (cast(avg(t1.e) AS integer)) end from t1) then case c when e then t1.f else 13 end else t1.d end)