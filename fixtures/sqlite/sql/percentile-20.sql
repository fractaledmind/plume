UPDATE t1 SET x=NULL;
SELECT ifnull(percentile(x, 50),'NULL') FROM t1