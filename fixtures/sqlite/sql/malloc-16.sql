SELECT t1.z, a002.m
FROM t1 JOIN a002 ON t1.y=a002.m
WHERE t1.x IN (1,2,3);