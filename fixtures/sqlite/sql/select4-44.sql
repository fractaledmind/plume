SELECT * FROM (SELECT 1 AS a, 2 AS b UNION ALL SELECT 3 AS e, 4 AS b)
WHERE b>0