-- randexpr1.test
-- 
-- db eval {SELECT (select min(coalesce((select max(t1.c-case t1.e | (abs(coalesce((select max(t1.b) from t1 where 19<f-13 or exists(select 1 from t1 where  -case coalesce((select max( -17-19) from t1 where (e>c)),f)+t1.b when 13 then t1.c else t1.b end<>a) or t1.a=a),e+t1.e))/abs((f))) when a then e else f end) from t1 where t1.a>t1.d),19)) from t1) FROM t1 WHERE 19*~case when (case when t1.f<>t1.a*17*(abs(t1.e)/abs(a))*a*(select case +min(11)*cast(avg(b) AS integer)*cast(avg(19) AS integer) when count(distinct t1.f) then max( -t1.e) else cast(avg( -f) AS integer) end from t1)*(select min(t1.b) from t1)*t1.d then coalesce((select max(11) from t1 where t1.a between t1.d and 17 and 19 not between 17 and a),17) else 17 end in (select t1.f from t1 union select 17 from t1)) then ~t1.b else t1.d end<=b}
SELECT (select min(coalesce((select max(t1.c-case t1.e | (abs(coalesce((select max(t1.b) from t1 where 19<f-13 or exists(select 1 from t1 where  -case coalesce((select max( -17-19) from t1 where (e>c)),f)+t1.b when 13 then t1.c else t1.b end<>a) or t1.a=a),e+t1.e))/abs((f))) when a then e else f end) from t1 where t1.a>t1.d),19)) from t1) FROM t1 WHERE 19*~case when (case when t1.f<>t1.a*17*(abs(t1.e)/abs(a))*a*(select case +min(11)*cast(avg(b) AS integer)*cast(avg(19) AS integer) when count(distinct t1.f) then max( -t1.e) else cast(avg( -f) AS integer) end from t1)*(select min(t1.b) from t1)*t1.d then coalesce((select max(11) from t1 where t1.a between t1.d and 17 and 19 not between 17 and a),17) else 17 end in (select t1.f from t1 union select 17 from t1)) then ~t1.b else t1.d end<=b