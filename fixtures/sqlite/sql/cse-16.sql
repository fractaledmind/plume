SELECT coalesce(b,c,d,e), a, b, c, d, e FROM t1 WHERE a=2
UNION ALL
SELECT coalesce(e,d,c,b), e, d, c, b, a FROM t1 WHERE a=1