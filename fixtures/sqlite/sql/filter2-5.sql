SELECT min(b) FILTER (WHERE a>19),
min(b) FILTER (WHERE a>0),
max(a+b) FILTER (WHERE a>19),
max(b+a) FILTER (WHERE a BETWEEN 10 AND 40)
FROM t1;