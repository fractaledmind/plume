SELECT x FROM (SELECT x FROM t1 LIMIT -1) LIMIT 3;