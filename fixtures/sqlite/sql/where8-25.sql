SELECT a, d
FROM t1, t2
WHERE (a = 2 OR b = 'three') AND (d = a OR e = 'sixteen')
ORDER BY t1.rowid