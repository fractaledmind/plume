-- randexpr1.test
-- 
-- db eval {SELECT ((abs(13)/abs( -b | coalesce((select 17 | t1.e from t1 where (d in (select coalesce((select 17 | (a) | c*case when case when t1.c in (select max(13) | cast(avg(t1.b) AS integer) from t1 union select count(*) from t1) then t1.c when 13>=17 then (11) else t1.e end>t1.d and t1.b>=t1.f then 13 when 11 not in (t1.d, -f,13) then f else 11 end from t1 where b<>11),d) from t1 union select t1.e from t1) or b not in (t1.e,b,e))),t1.e)))) FROM t1 WHERE NOT (11<=coalesce((select max(t1.d) from t1 where coalesce((select ~d+t1.d-case when c not in (t1.b-f,19+~coalesce((select t1.a from t1 where t1.f<=b),case when not (e not between f and t1.e) then (t1.e)-d else b end), -t1.d) then 17 when t1.d not between 13 and t1.d then d else (c) end from t1 where c>t1.a),t1.b)<d),t1.c))}
SELECT ((abs(13)/abs( -b | coalesce((select 17 | t1.e from t1 where (d in (select coalesce((select 17 | (a) | c*case when case when t1.c in (select max(13) | cast(avg(t1.b) AS integer) from t1 union select count(*) from t1) then t1.c when 13>=17 then (11) else t1.e end>t1.d and t1.b>=t1.f then 13 when 11 not in (t1.d, -f,13) then f else 11 end from t1 where b<>11),d) from t1 union select t1.e from t1) or b not in (t1.e,b,e))),t1.e)))) FROM t1 WHERE NOT (11<=coalesce((select max(t1.d) from t1 where coalesce((select ~d+t1.d-case when c not in (t1.b-f,19+~coalesce((select t1.a from t1 where t1.f<=b),case when not (e not between f and t1.e) then (t1.e)-d else b end), -t1.d) then 17 when t1.d not between 13 and t1.d then d else (c) end from t1 where c>t1.a),t1.b)<d),t1.c))