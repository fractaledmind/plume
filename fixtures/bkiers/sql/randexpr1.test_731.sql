-- randexpr1.test
-- 
-- db eval {SELECT case when (19*b)+11*~f-coalesce((select max(11) from t1 where f<>case when case 17 when 11 then 17 else c end-11 in (t1.c,c,t1.e) and 19=t1.a or 17<=e or e<=19 then 19 | c when t1.b=t1.f then d else 19 end or t1.e not in (13,19,c)),b) |  -c not between  -e and  -a then (t1.c) else t1.d end FROM t1 WHERE c in (select case abs((count(*))) when  -max(t1.c) | abs(abs(+count(*)))-~case (case  -max(e) when max(11)- -count(*) then ((max(t1.e))) else count(*) end) when count(distinct t1.e) then cast(avg(f) AS integer) else cast(avg(t1.c) AS integer) end* -cast(avg(f) AS integer) then max(f) else (max(b)) end from t1 union select (max(13)) from t1) and not exists(select 1 from t1 where case when t1.e<=19-b then c else c end in (select c from t1 union select (select  -((count(distinct t1.d))) from t1)-t1.b from t1))}
SELECT case when (19*b)+11*~f-coalesce((select max(11) from t1 where f<>case when case 17 when 11 then 17 else c end-11 in (t1.c,c,t1.e) and 19=t1.a or 17<=e or e<=19 then 19 | c when t1.b=t1.f then d else 19 end or t1.e not in (13,19,c)),b) |  -c not between  -e and  -a then (t1.c) else t1.d end FROM t1 WHERE c in (select case abs((count(*))) when  -max(t1.c) | abs(abs(+count(*)))-~case (case  -max(e) when max(11)- -count(*) then ((max(t1.e))) else count(*) end) when count(distinct t1.e) then cast(avg(f) AS integer) else cast(avg(t1.c) AS integer) end* -cast(avg(f) AS integer) then max(f) else (max(b)) end from t1 union select (max(13)) from t1) and not exists(select 1 from t1 where case when t1.e<=19-b then c else c end in (select c from t1 union select (select  -((count(distinct t1.d))) from t1)-t1.b from t1))