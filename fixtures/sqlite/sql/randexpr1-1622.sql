SELECT coalesce((select case when coalesce((select max(coalesce((select max(e-c-coalesce((select max(c) from t1 where 19 between 13 and 13),(abs(case when c<=17 or f in (t1.a, -17,t1.f) then b else t1.c end)/abs(e))+t1.b)) from t1 where not exists(select 1 from t1 where t1.e>=b)),e)) from t1 where not exists(select 1 from t1 where 13<=t1.b or t1.f in (select d from t1 union select t1.d from t1))),17) in (select 11 from t1 union select t1.d from t1) then c else t1.e end from t1 where t1.c in (select b from t1 union select b from t1)),f) | t1.c FROM t1 WHERE NOT (c<=e)