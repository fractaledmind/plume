SELECT case t1.c when t1.e then 19 else  -case when not exists(select 1 from t1 where t1.b in (select (t1.b) from t1 union select +13 from t1)) then coalesce((select max(c*t1.b) from t1 where 17>=19*e),coalesce((select (select abs(~min(coalesce((select max(t1.a) from t1 where  -19 in (f,a,13)),f)))+min(e) | ( -(min(13))) from t1) from t1 where f between  -a and t1.c),t1.e)) when 19<>a then 13 else c end end FROM t1 WHERE NOT (t1.e<>f)