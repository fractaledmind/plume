-- randexpr1.test
-- 
-- db eval {SELECT case when case when t1.a<>t1.d then d*t1.a*11-e-(+11+d)-e else (select case  -count(distinct t1.e) when cast(avg(b) AS integer) then count(distinct t1.d) else cast(avg(13) AS integer) end*cast(avg(19) AS integer) from t1) end<>case e when e then t1.e else (t1.f) end or not exists(select 1 from t1 where 19=f) and  -t1.d>t1.e then t1.e+e*e when 11=t1.c then e else c end FROM t1 WHERE ~c>(case when t1.e<=e then case when case when 17+f in (d,t1.d | t1.c,t1.b) and 13<>19 or not t1.c<f then coalesce((select max(b) from t1 where c not between b and t1.c),c)+(17) when d<=t1.c then t1.b else t1.c end-b not in (a,f,11) then c else 17 end else f end)}
SELECT case when case when t1.a<>t1.d then d*t1.a*11-e-(+11+d)-e else (select case  -count(distinct t1.e) when cast(avg(b) AS integer) then count(distinct t1.d) else cast(avg(13) AS integer) end*cast(avg(19) AS integer) from t1) end<>case e when e then t1.e else (t1.f) end or not exists(select 1 from t1 where 19=f) and  -t1.d>t1.e then t1.e+e*e when 11=t1.c then e else c end FROM t1 WHERE ~c>(case when t1.e<=e then case when case when 17+f in (d,t1.d | t1.c,t1.b) and 13<>19 or not t1.c<f then coalesce((select max(b) from t1 where c not between b and t1.c),c)+(17) when d<=t1.c then t1.b else t1.c end-b not in (a,f,11) then c else 17 end else f end)