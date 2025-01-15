SELECT (a%5),
sum(b) FILTER (WHERE b<20) AS bbb,
count(distinct b) FILTER (WHERE b<20 OR a=13) AS ccc
FROM t1 GROUP BY (a%5)
ORDER BY 2