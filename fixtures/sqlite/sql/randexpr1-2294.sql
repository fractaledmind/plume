SELECT case t1.a when coalesce((select a from t1 where t1.b>19),b-case when +13>case when (coalesce((select b from t1 where coalesce((select max(t1.f) from t1 where 17<=case c when t1.e+f then d else case when 11<17 and t1.d<=t1.e then 13 when t1.d<>f then (t1.f) else c end end*t1.c),a) in (select 17 from t1 union select b from t1)),t1.c)>= -11) then (a)*t1.a else 19 end then 13 else 17 end*19) then d else (t1.a) end FROM t1 WHERE NOT (t1.d+t1.b not in (b,f,coalesce((select max(t1.b) from t1 where exists(select 1 from t1 where c-t1.b not between case when coalesce((select max(~t1.e) from t1 where f not in (t1.b,17,t1.a)),t1.e) not in (e,13,(t1.d)) then 11 when t1.d>=17 then t1.c else 11 end and (11) and (exists(select 1 from t1 where t1.b<>11))) or 13 in (select max(t1.d) from t1 union select max(b) from t1)),t1.b+19+a)))