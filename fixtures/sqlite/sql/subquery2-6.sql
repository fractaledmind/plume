SELECT a FROM t1
WHERE b=(SELECT x+1 FROM
(SELECT DISTINCT f/d AS x FROM t2 JOIN t3 ON d*a=f))