SELECT case when case (select max(t1.b)*min(case when (abs(t1.e)/abs(d)) in (select 19 from t1 union select +t1.d from t1) then t1.d when t1.d=d or 11 in (t1.c,b,t1.b) and 13 in (select max(b)-count(distinct b) from t1 union select count(distinct  -t1.c) from t1) then f else 17 end) from t1) when t1.a then 11 else t1.d end+t1.a>c or t1.c between 13 and a then f when (t1.b)>=t1.a then d else b end FROM t1 WHERE (not exists(select 1 from t1 where coalesce((select max(e) from t1 where  -b+a-(abs(c)/abs(b))-( -t1.a)-t1.c>=d),d) in (select count(distinct a) from t1 union select cast(avg(t1.b) AS integer) from t1) and exists(select 1 from t1 where not t1.d<>f) and t1.a in (select min(t1.a)+max(a)*max(19)*count(distinct c) from t1 union select ((count(distinct 11))) from t1) or t1.c>(13) and a between (t1.f) and 13))