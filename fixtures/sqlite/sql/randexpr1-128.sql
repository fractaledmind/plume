SELECT coalesce((select max(~d-t1.f+b-13) from t1 where t1.c not between case when +f=t1.b then 13 when ~f not in (~t1.a,coalesce((select max(t1.b) from t1 where b between c-t1.c+e and (t1.b)),coalesce((select max(t1.d) from t1 where not e in (select 17 from t1 union select t1.c+e & a from t1)),b)),t1.e) then t1.b else a end and c),t1.a) FROM t1 WHERE NOT ((select (++ -count(*) | cast(avg(t1.b) AS integer) | ++(max(t1.d))+count(*)+max(t1.b)-count(distinct t1.e)-+abs( -+~max((abs(t1.c)/abs((select min(a) from t1)))))+count(distinct t1.a-t1.b)) from t1) between e and c)