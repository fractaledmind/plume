SELECT coalesce((select t1.b from t1 where not (t1.c>19) and 11<=+(abs(t1.b-19)/abs(a))+case when ((coalesce((select 13 from t1 where c in (b,t1.b,t1.d)),e))<>13) or f in ((t1.b),t1.e, -b) then 11+(c) else b end or b<>d),t1.f+t1.f+13) |  - -a FROM t1 WHERE 13 between t1.c and 13+~19+c+(select min(f-(abs(17)/abs((t1.e)))) from t1)