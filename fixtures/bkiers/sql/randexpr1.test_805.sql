-- randexpr1.test
-- 
-- db eval {SELECT case when 19=(select ( -count(*)* -(cast(avg(t1.e) AS integer))+count(distinct 13)*min(t1.f)) | cast(avg(t1.e) AS integer) |  -cast(avg(13) AS integer)-(min(d)) from t1) then 13*a when t1.a+((select min((t1.d)) from t1)) in (select t1.b from t1 union select 11 from t1) or not exists(select 1 from t1 where not exists(select 1 from t1 where  - -e in (select t1.e from t1 union select t1.d from t1) or t1.d in (select count(distinct t1.a) from t1 union select count(*) from t1)) or  -b=(19) and 11<c) then b else t1.c end*a FROM t1 WHERE NOT (17-case 19 when t1.f-+(t1.d)-t1.a*t1.a then ~t1.d | e*coalesce((select b from t1 where 17< -17), -f)-17 else 19 end-case when (~t1.d)*17<f then f when t1.c in (f,a,t1.e) then t1.f else 17 end not in (t1.c,e,t1.d))}
SELECT case when 19=(select ( -count(*)* -(cast(avg(t1.e) AS integer))+count(distinct 13)*min(t1.f)) | cast(avg(t1.e) AS integer) |  -cast(avg(13) AS integer)-(min(d)) from t1) then 13*a when t1.a+((select min((t1.d)) from t1)) in (select t1.b from t1 union select 11 from t1) or not exists(select 1 from t1 where not exists(select 1 from t1 where  - -e in (select t1.e from t1 union select t1.d from t1) or t1.d in (select count(distinct t1.a) from t1 union select count(*) from t1)) or  -b=(19) and 11<c) then b else t1.c end*a FROM t1 WHERE NOT (17-case 19 when t1.f-+(t1.d)-t1.a*t1.a then ~t1.d | e*coalesce((select b from t1 where 17< -17), -f)-17 else 19 end-case when (~t1.d)*17<f then f when t1.c in (f,a,t1.e) then t1.f else 17 end not in (t1.c,e,t1.d))