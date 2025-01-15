SELECT
a/5,
sum(b) FILTER (WHERE a%5=0),
sum(b) FILTER (WHERE a%5=1),
sum(b) FILTER (WHERE a%5=2),
sum(b) FILTER (WHERE a%5=3),
sum(b) FILTER (WHERE a%5=4)
FROM t1 GROUP BY (a/5) ORDER BY 1;