SELECT case when t1.e not between (select +max(17) from t1)*t1.f and d then t1.c+case when e+f<=coalesce((select max((19)) from t1 where t1.e not in ((abs( -17-17)/abs(t1.e)),(c),(t1.b))),d) and 13 in (select d from t1 union select c from t1) then 19 else c end-19 when exists(select 1 from t1 where t1.a in (select t1.a from t1 union select 13 from t1)) and not exists(select 1 from t1 where a<19) then b else t1.b end FROM t1 WHERE not t1.d=b