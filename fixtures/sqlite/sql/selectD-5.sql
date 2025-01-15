SELECT t3.*, t2.*
FROM t1 JOIN (t2 JOIN (t3 JOIN t4 ON t4.a=t3.a+111)
ON t3.a=t2.a+111)
ON t2.a=t1.a+111;