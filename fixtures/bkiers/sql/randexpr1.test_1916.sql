-- randexpr1.test
-- 
-- db eval {SELECT (abs(case when 11<=case 17 when t1.d then t1.b+~19-~case when not t1.b not in (t1.a,b,coalesce((select a+(a) from t1 where t1.b>19),t1.b)) or ((t1.a>19)) or e<>19 then  -t1.e else  -13 end-b+t1.d else a end then 19 when d between b and t1.c then t1.e else e end)/abs(t1.a)) FROM t1 WHERE b | t1.b>b-case when a-f in (select 17 from t1 union select coalesce((select coalesce((select t1.e+t1.a+d+d from t1 where 13 not between t1.e+19 and 13),(select count(distinct t1.e) from t1)*11) from t1 where b not in (b,(t1.f),t1.a)),13) from t1) then b else c end+a-13-13*(13) | 11}
SELECT (abs(case when 11<=case 17 when t1.d then t1.b+~19-~case when not t1.b not in (t1.a,b,coalesce((select a+(a) from t1 where t1.b>19),t1.b)) or ((t1.a>19)) or e<>19 then  -t1.e else  -13 end-b+t1.d else a end then 19 when d between b and t1.c then t1.e else e end)/abs(t1.a)) FROM t1 WHERE b | t1.b>b-case when a-f in (select 17 from t1 union select coalesce((select coalesce((select t1.e+t1.a+d+d from t1 where 13 not between t1.e+19 and 13),(select count(distinct t1.e) from t1)*11) from t1 where b not in (b,(t1.f),t1.a)),13) from t1) then b else c end+a-13-13*(13) | 11