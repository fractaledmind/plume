SELECT case 17 when (select ~count(distinct t1.d) from t1) then e else case when not not exists(select 1 from t1 where (abs(~coalesce((select (coalesce((select max(13) from t1 where e>a),19)) from t1 where (not exists(select 1 from t1 where t1.c in (f,b,c)))),c)*t1.c | 17-(e))/abs(t1.f)) | 17*17*a in (select e from t1 union select f from t1)) then 13 when t1.a not between (b) and t1.c then (abs(17)/abs(17)) else t1.d end*f end FROM t1 WHERE NOT (t1.a>t1.c-19)