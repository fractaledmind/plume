SELECT coalesce((select max(coalesce((select max(13+f & c+a) from t1 where 17<t1.a),~case when 17 in (select count(distinct 11) from t1 union select ++cast(avg(a & 11) AS integer)-count(*) from t1) then t1.a else 17 end)) from t1 where case t1.d when 17 then t1.a else 17 end not between 13 and case t1.c when t1.b*case when t1.d<>d then 13 else c end-c then e else t1.e end),c) FROM t1 WHERE exists(select 1 from t1 where t1.a+( -case when exists(select 1 from t1 where exists(select 1 from t1 where b | c-c+t1.d not between 19 and 11)) then coalesce((select t1.c from t1 where c+17 in (f,13,c) or t1.e*coalesce((select case when (not exists(select 1 from t1 where 17>e)) then t1.d else ~t1.e end from t1 where (t1.f not in (19,a,t1.b) or c=f)),c)=c), -11) else e end)<=t1.b)