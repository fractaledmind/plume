SELECT (SELECT group_concat(a1,b1) FROM t2) FROM t1;