SELECT a,b,a+b FROM (SELECT avg(x) as 'a', avg(y) as 'b' FROM t1)
WHERE a<10