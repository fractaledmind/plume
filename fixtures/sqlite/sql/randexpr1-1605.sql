SELECT (case when e not between 19 and t1.a then case coalesce((select t1.e from t1 where (exists(select 1 from t1 where c in (select case count(distinct t1.b) when max(b) then min((t1.d)) else count(distinct 11) end+ -count(*) |  - -count(distinct t1.e) from t1 union select min(f) from t1))) or (select min(17) from t1) not between 13 and b and  - -c<e),t1.a)+f when (select cast(avg(a) AS integer) from t1) then 19 else 19 end when not 13>=17 and 17 between t1.e and 13 or 13>d or 11>= -t1.d then a else 13 end)+t1.f FROM t1 WHERE b<=13