UPDATE t4 SET a=333;
SELECT *
FROM (t1 LEFT JOIN t2 USING(a)) JOIN (t3 LEFT JOIN t4 USING(a))
ON t1.a=t3.a-111;