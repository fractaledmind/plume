-- randexpr1.test
-- 
-- db eval {SELECT case when 13>=~t1.a or (exists(select 1 from t1 where 11 not in (17,t1.f,17))) then f when not exists(select 1 from t1 where exists(select 1 from t1 where 13 not between e and ~+case b when t1.f then case  -case f when 11 then  -17 else 19 end+17 when b then b else 13 end else 13 end- -t1.a and t1.c not in (t1.f,a,c) or t1.f<11)) then t1.c else 11 end FROM t1 WHERE NOT (+t1.e in (select cast(avg(t1.c*t1.a*(abs(13)/abs(t1.e))) AS integer) from t1 union select min(c+13) from t1))}
SELECT case when 13>=~t1.a or (exists(select 1 from t1 where 11 not in (17,t1.f,17))) then f when not exists(select 1 from t1 where exists(select 1 from t1 where 13 not between e and ~+case b when t1.f then case  -case f when 11 then  -17 else 19 end+17 when b then b else 13 end else 13 end- -t1.a and t1.c not in (t1.f,a,c) or t1.f<11)) then t1.c else 11 end FROM t1 WHERE NOT (+t1.e in (select cast(avg(t1.c*t1.a*(abs(13)/abs(t1.e))) AS integer) from t1 union select min(c+13) from t1))