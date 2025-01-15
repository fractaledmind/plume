SELECT min(b),
min(b),
max(a+b),
max(b+a)
FROM t1
GROUP BY (a%10)
ORDER BY 1, 2, 3, 4;