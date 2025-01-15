SELECT t1.*, t2.*, t3.*, t4.b
FROM (t1 LEFT JOIN t2 USING(a)) JOIN (t3 LEFT JOIN t4 USING(a))
ON t1.a=t3.a-111;