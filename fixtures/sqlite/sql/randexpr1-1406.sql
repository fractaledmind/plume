SELECT (select abs(min(case when d not between coalesce((select max(case case t1.e when e-t1.f-a then case when (not exists(select 1 from t1 where coalesce((select max(t1.f) from t1 where 19<>17 and e not between  -13 and t1.a),t1.c)>=t1.e)) then (select abs(cast(avg(17) AS integer)) from t1) when c between e and 17 then (select (count(*)) from t1) else 11 end else 11 end when e then 11 else a end) from t1 where t1.b>t1.b),t1.e) and 13 then t1.d else 17 end))*min(b) |  -count(distinct t1.f) from t1) FROM t1 WHERE NOT ((e) in (select +t1.f from t1 union select t1.f+coalesce((select t1.d+e from t1 where t1.f not in (t1.b,t1.f,e)),(19))*case when t1.a<=a and t1.e<=e then t1.d else t1.c end from t1) and (t1.c not between 11 and e) or d in (select count(*)-cast(avg(t1.a) AS integer) from t1 union select max(19) from t1) and not t1.a not in (11,t1.d,b) or 17>=t1.a)