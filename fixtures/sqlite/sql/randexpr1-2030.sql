SELECT coalesce((select max(b-case when exists(select 1 from t1 where case when t1.c>t1.b then t1.c*19 else coalesce((select max((abs(t1.a)/abs(~(select +max(t1.c)*max(a)*cast(avg(t1.d) AS integer) from t1)+case when e=t1.c or t1.c between e and b then +a else 13 end))) from t1 where 17=b),t1.a) end not between f and t1.c) then c else e end+ - -d-17) from t1 where t1.e<d),17) FROM t1 WHERE  -a>=(select cast(avg(d) AS integer) from t1)