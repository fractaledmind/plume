SELECT c+c*(abs(t1.c+coalesce((select case when 17 not in (t1.f,t1.e,t1.d) or (17<t1.d) then case d when t1.a then t1.f else 11 end else t1.e end*d from t1 where 19 in (select abs(~count(distinct a)) from t1 union select case cast(avg(t1.c) AS integer) when  -max(t1.b) then min(c) else min(f) end+ -max(t1.d) from t1)),t1.b)+t1.e)/abs(17))+t1.b+ -t1.f+17-t1.c FROM t1 WHERE (13)+19>=19