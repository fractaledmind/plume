SELECT +(abs(case t1.a when coalesce((select max(13) from t1 where d<=case when t1.b=(select abs(count(distinct t1.e)) from t1) and (select  -count(distinct e) from t1) not in ( -11,e,13) then 13 else t1.e end and (not exists(select 1 from t1 where t1.d in (select count(*) from t1 union select max(f) from t1))) and 19<f and t1.f>=13 or  -e=17),coalesce((select (abs(17)/abs(b))-t1.b from t1 where (19)<=t1.f),t1.d))*t1.b then 17 else 13 end)/abs(19)) FROM t1 WHERE NOT (a in (select case max(13)-~cast(avg(case when t1.d>13 or exists(select 1 from t1 where not (( -c<=e)) and (b)*t1.a in (select count(*) from t1 union select cast(avg(t1.c) AS integer)+max(f) from t1)) then t1.a else t1.c end) AS integer) when abs(count(distinct t1.d)) then count(distinct (~t1.a)) else count(distinct c)-cast(avg(e) AS integer) end from t1 union select abs(count(distinct a)*max(t1.d)) from t1))