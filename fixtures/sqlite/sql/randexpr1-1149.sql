SELECT (abs(t1.d+b)/abs(~t1.f+case when t1.f=t1.c or exists(select 1 from t1 where c>=+~t1.c*17) or exists(select 1 from t1 where (select  -cast(avg(case when 19<>t1.f then  -c when c<>b then t1.e else t1.d end) AS integer) from t1) in (d-t1.f,b,19)) then d+b when 11<b then t1.c else d end* -t1.a-19)) FROM t1 WHERE t1.a-(select cast(avg(a) AS integer) from t1) in (select t1.c from t1 union select 19 from t1) and not exists(select 1 from t1 where coalesce((select max(11) from t1 where case when not d>(19) then c else  -case when 11>b or t1.c<=c then f when t1.f>t1.a then t1.a else t1.e end*d-11 end+d*t1.b>t1.e),d)>t1.b and c<>d and not exists(select 1 from t1 where 17>=(t1.f)) and t1.e not in (f,t1.b,t1.b))