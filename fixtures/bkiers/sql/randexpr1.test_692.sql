-- randexpr1.test
-- 
-- db eval {SELECT  -d+t1.d-t1.a-+t1.c-(select +min((abs(+(case when b>=case when b not between  -t1.f and c then e else f end or a<=11 or t1.e between a and 11 or t1.d not in (b,d,d) then case when f>=c then t1.c else 19 end when t1.e=a then e else t1.e end) & f)/abs(t1.a))) from t1)+e* -t1.a+f+d FROM t1 WHERE NOT (t1.b<=t1.c+ -(abs(t1.b)/abs(case t1.b+t1.e when 11 then t1.c else 17 end))*coalesce((select coalesce((select coalesce((select 13 from t1 where b=t1.b),f) | t1.f-11 from t1 where (t1.c) in (select +min(19)*(~max(b)-max(11))*max(11) from t1 union select min(f) from t1)),t1.f) from t1 where f in (select case count(distinct 19) when max(t1.b) then  -cast(avg(t1.e) AS integer) else cast(avg(b) AS integer) end from t1 union select count(*) from t1)),t1.a))}
SELECT  -d+t1.d-t1.a-+t1.c-(select +min((abs(+(case when b>=case when b not between  -t1.f and c then e else f end or a<=11 or t1.e between a and 11 or t1.d not in (b,d,d) then case when f>=c then t1.c else 19 end when t1.e=a then e else t1.e end) & f)/abs(t1.a))) from t1)+e* -t1.a+f+d FROM t1 WHERE NOT (t1.b<=t1.c+ -(abs(t1.b)/abs(case t1.b+t1.e when 11 then t1.c else 17 end))*coalesce((select coalesce((select coalesce((select 13 from t1 where b=t1.b),f) | t1.f-11 from t1 where (t1.c) in (select +min(19)*(~max(b)-max(11))*max(11) from t1 union select min(f) from t1)),t1.f) from t1 where f in (select case count(distinct 19) when max(t1.b) then  -cast(avg(t1.e) AS integer) else cast(avg(b) AS integer) end from t1 union select count(*) from t1)),t1.a))