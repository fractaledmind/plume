SELECT (case t1.a when (select (count(distinct t1.f)) from t1)-e then 11 else t1.c+17-f*~f | f+~e-a*t1.b+13 end | 13) FROM t1 WHERE (coalesce((select max(f) from t1 where (c+t1.f | (select count(distinct t1.d) from t1)>=coalesce((select b+(abs(case when t1.f>=(select case max(f) when max(19) then cast(avg(t1.a) AS integer) else count(distinct 13) end from t1) | t1.b and (a in (select (b) from t1 union select t1.b from t1)) then (a)-b when not exists(select 1 from t1 where c between t1.c and t1.a) then a else t1.a end)/abs(t1.b))- -f from t1 where b not in (t1.b,t1.f,c)),t1.d)-t1.d)), -17) between 13 and t1.f)