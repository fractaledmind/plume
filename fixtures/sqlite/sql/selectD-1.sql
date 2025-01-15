SELECT *
FROM (t1), (t2), (t3), (t4)
WHERE t4.a=t3.a+111
AND t3.a=t2.a+111
AND t2.a=t1.a+111;