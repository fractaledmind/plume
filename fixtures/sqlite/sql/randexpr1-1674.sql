SELECT coalesce((select (11) from t1 where not e in (select  -min(d*13) from t1 union select count(distinct f) from t1)),t1.f*t1.d | t1.f) FROM t1 WHERE  -t1.c*d>case d when ~coalesce((select max(e) from t1 where exists(select 1 from t1 where not exists(select 1 from t1 where not e=c))),+coalesce((select +t1.e from t1 where not exists(select 1 from t1 where c>=t1.b)),(abs( -t1.c+case t1.c when ~~t1.c+a-t1.c then coalesce((select max(case when t1.b<=c then 19 else f end) from t1 where 13<b),d) else t1.d end)/abs(a))*(d))) then  -t1.e else (13) end