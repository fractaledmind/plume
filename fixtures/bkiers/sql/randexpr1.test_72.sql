-- randexpr1.test
-- 
-- db eval {SELECT case when t1.e in (select abs(max(case a+case when t1.a>=e+ -c then a else t1.b end+t1.a when t1.f then 19 else  -19 end)+abs( -count(distinct t1.c))+~(count(distinct t1.b)))-min(b) from t1 union select max(f) from t1) and case t1.e when  -t1.c then 19 else b end<t1.d then e+(d) when exists(select 1 from t1 where 19 not between t1.e and (19)) then  -19 else t1.c end FROM t1 WHERE (exists(select 1 from t1 where t1.e between t1.c-t1.d and (t1.a)) and ((not case 19 when 11 then e else ~d | t1.a*19 end*((b))>=t1.e))) or c in (select f from t1 union select 13 from t1) and (b)< -t1.c and f in (select max(13) from t1 union select ~+abs(count(distinct e)*abs(((count(*)))*((max(f))))) from t1)}
SELECT case when t1.e in (select abs(max(case a+case when t1.a>=e+ -c then a else t1.b end+t1.a when t1.f then 19 else  -19 end)+abs( -count(distinct t1.c))+~(count(distinct t1.b)))-min(b) from t1 union select max(f) from t1) and case t1.e when  -t1.c then 19 else b end<t1.d then e+(d) when exists(select 1 from t1 where 19 not between t1.e and (19)) then  -19 else t1.c end FROM t1 WHERE (exists(select 1 from t1 where t1.e between t1.c-t1.d and (t1.a)) and ((not case 19 when 11 then e else ~d | t1.a*19 end*((b))>=t1.e))) or c in (select f from t1 union select 13 from t1) and (b)< -t1.c and f in (select max(13) from t1 union select ~+abs(count(distinct e)*abs(((count(*)))*((max(f))))) from t1)