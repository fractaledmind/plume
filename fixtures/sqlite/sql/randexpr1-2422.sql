SELECT +coalesce((select max(f+c) from t1 where t1.b in (select +max(b+t1.b) from t1 union select cast(avg(d-b | f-11-t1.b | coalesce((select ~t1.a from t1 where (t1.a=case when not exists(select 1 from t1 where 13 not in (t1.b,t1.e,t1.f)) then (abs(t1.d)/abs(c)) when c<>17 then c else 19 end)),t1.c)) AS integer) from t1) and t1.e not in (b,d,(13))),t1.b) FROM t1 WHERE (select cast(avg(~t1.f) AS integer) from t1) not in ( -c,17,11*c)