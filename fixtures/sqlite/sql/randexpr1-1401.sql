SELECT coalesce((select max(19) from t1 where e-coalesce((select 13 from t1 where exists(select 1 from t1 where ((+(case when d*t1.b not in (t1.d,t1.f,e) then 11 else t1.c end))+19*11+e<=11))),19+t1.d) between t1.c and  -e and exists(select 1 from t1 where t1.d=c and exists(select 1 from t1 where exists(select 1 from t1 where t1.f=b and a in (19,t1.b,d) or t1.b=11) or t1.c>19) or t1.d=a)),19) FROM t1 WHERE t1.c not between f and d