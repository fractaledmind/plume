-- randexpr1.test
-- 
-- db eval {SELECT case t1.c & t1.b when t1.f-c then case when c<t1.c then t1.e when not t1.f in (select case when exists(select 1 from t1 where t1.e<=coalesce((select (select case count(distinct  -e*a) when ~( -min(11)) then count(*) else count(*) end from t1) from t1 where (b-d<= -t1.f)),t1.e) or exists(select 1 from t1 where t1.d>=11) or t1.c<=t1.e) then + - -b+11 else 13 end from t1 union select (t1.c) from t1) then 17 else 11 end else t1.a end FROM t1 WHERE t1.f | 13+coalesce((select max(11) from t1 where e>=(select ~case cast(avg(19*f+(c)) AS integer) when (min(c))-min(t1.a) then cast(avg(13) AS integer) else count(distinct e) end from t1)),t1.f)>=coalesce((select c from t1 where (exists(select 1 from t1 where t1.f>=f and (t1.d)<>t1.a))),c) or not exists(select 1 from t1 where not 11>=t1.d) or (b between c and 11 and 11< -t1.b and t1.e>=t1.b) or t1.c>e}
SELECT case t1.c & t1.b when t1.f-c then case when c<t1.c then t1.e when not t1.f in (select case when exists(select 1 from t1 where t1.e<=coalesce((select (select case count(distinct  -e*a) when ~( -min(11)) then count(*) else count(*) end from t1) from t1 where (b-d<= -t1.f)),t1.e) or exists(select 1 from t1 where t1.d>=11) or t1.c<=t1.e) then + - -b+11 else 13 end from t1 union select (t1.c) from t1) then 17 else 11 end else t1.a end FROM t1 WHERE t1.f | 13+coalesce((select max(11) from t1 where e>=(select ~case cast(avg(19*f+(c)) AS integer) when (min(c))-min(t1.a) then cast(avg(13) AS integer) else count(distinct e) end from t1)),t1.f)>=coalesce((select c from t1 where (exists(select 1 from t1 where t1.f>=f and (t1.d)<>t1.a))),c) or not exists(select 1 from t1 where not 11>=t1.d) or (b between c and 11 and 11< -t1.b and t1.e>=t1.b) or t1.c>e