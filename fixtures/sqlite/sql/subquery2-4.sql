SELECT a FROM t1
WHERE b=(SELECT x+1 FROM (SELECT DISTINCT f/(a*a) AS x FROM t3));