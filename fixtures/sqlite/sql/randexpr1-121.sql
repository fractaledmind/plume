SELECT 11+a*case t1.a*t1.e when 17 then coalesce((select +t1.b from t1 where t1.c<>t1.c and e between +(abs(case b+f*coalesce((select c from t1 where t1.d>17), -t1.c)+(19) when b then t1.f else t1.d end)/abs(t1.d)) and t1.c and t1.a>b or t1.f<t1.a),t1.c)*17 else  -t1.d end*t1.b FROM t1 WHERE  -19-~t1.b<(select ~count(*) from t1)+(abs(++coalesce((select max(t1.a-c) from t1 where t1.a=11),11))/abs(case when not not exists(select 1 from t1 where exists(select 1 from t1 where t1.a>c or t1.d | 11 in (select t1.e from t1 union select d from t1))) then 17 else (abs(coalesce((select max(f) from t1 where not (c)<t1.a),t1.b))/abs(d))+f end-t1.c))-t1.e-t1.e