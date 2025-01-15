SELECT
(SELECT string_agg(a1,'x') || '-' || string_agg(b1,'y') FROM t2)
FROM t1;