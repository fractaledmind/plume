-- randexpr1.test
-- 
-- db eval {SELECT coalesce((select 17 from t1 where not exists(select 1 from t1 where (t1.b- -b+(select +case max(b)-~count(distinct e*(select case max(c) when abs((count(*))) then max(t1.f) else max(t1.c) end+cast(avg(t1.b) AS integer) from t1)) when abs(count(distinct e*19)) then max(b) else max(t1.c) end | count(distinct t1.e) from t1)-b*+t1.b not in ((11),17,13)))),t1.e) FROM t1 WHERE t1.c in (select min(coalesce((select 17 from t1 where t1.c | 17>=(abs(t1.a)/abs(case when t1.e not in (19,t1.d,19) then a when 13<=case when not exists(select 1 from t1 where (abs(e)/abs(t1.c)) in (select 19 from t1 union select d from t1) and t1.c>=17 or 19=t1.a) then f else a end then t1.d else e end))-f),e))*min(f) | ++min(a) from t1 union select cast(avg(f) AS integer) from t1)}
SELECT coalesce((select 17 from t1 where not exists(select 1 from t1 where (t1.b- -b+(select +case max(b)-~count(distinct e*(select case max(c) when abs((count(*))) then max(t1.f) else max(t1.c) end+cast(avg(t1.b) AS integer) from t1)) when abs(count(distinct e*19)) then max(b) else max(t1.c) end | count(distinct t1.e) from t1)-b*+t1.b not in ((11),17,13)))),t1.e) FROM t1 WHERE t1.c in (select min(coalesce((select 17 from t1 where t1.c | 17>=(abs(t1.a)/abs(case when t1.e not in (19,t1.d,19) then a when 13<=case when not exists(select 1 from t1 where (abs(e)/abs(t1.c)) in (select 19 from t1 union select d from t1) and t1.c>=17 or 19=t1.a) then f else a end then t1.d else e end))-f),e))*min(f) | ++min(a) from t1 union select cast(avg(f) AS integer) from t1)