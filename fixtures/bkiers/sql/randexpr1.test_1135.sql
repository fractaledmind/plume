-- randexpr1.test
-- 
-- db eval {SELECT ( -19-f+coalesce((select max( -~case when case 11 when ~coalesce((select max(13) from t1 where not (e)<>(t1.c)),19)+11 &  -19-f then  -13 else t1.c end-e<=t1.a then 11 when not exists(select 1 from t1 where (not t1.c<19) and not (13<>17)) then  -e else f end) from t1 where (b)<=t1.e),t1.d)+ -t1.c) & b FROM t1 WHERE (~(select (max(f)-count(distinct c)) from t1) | case when e>=t1.c then t1.b+(select abs(count(*)+max(c)*abs(count(distinct e)+max(t1.f))+cast(avg(c) AS integer)) | cast(avg(t1.d) AS integer)*min(11) from t1)-t1.c else c end in (select case  -t1.b when 17 then 17 else  -case when not t1.c not in (17,t1.d,17) then 19 else a end end from t1 union select a from t1)) or (11)<=t1.b}
SELECT ( -19-f+coalesce((select max( -~case when case 11 when ~coalesce((select max(13) from t1 where not (e)<>(t1.c)),19)+11 &  -19-f then  -13 else t1.c end-e<=t1.a then 11 when not exists(select 1 from t1 where (not t1.c<19) and not (13<>17)) then  -e else f end) from t1 where (b)<=t1.e),t1.d)+ -t1.c) & b FROM t1 WHERE (~(select (max(f)-count(distinct c)) from t1) | case when e>=t1.c then t1.b+(select abs(count(*)+max(c)*abs(count(distinct e)+max(t1.f))+cast(avg(c) AS integer)) | cast(avg(t1.d) AS integer)*min(11) from t1)-t1.c else c end in (select case  -t1.b when 17 then 17 else  -case when not t1.c not in (17,t1.d,17) then 19 else a end end from t1 union select a from t1)) or (11)<=t1.b