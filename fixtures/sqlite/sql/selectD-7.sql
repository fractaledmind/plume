SELECT *
FROM t1 JOIN (t2 JOIN (main.t4 AS x JOIN aux1.t4 ON aux1.t4.a=x.a+111)
ON x.a=t2.a+222)
ON t2.a=t1.a+111;