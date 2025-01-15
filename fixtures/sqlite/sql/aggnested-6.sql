SELECT
(SELECT sum(value2==xyz) FROM t2)
FROM
(SELECT curr.value1 as xyz
FROM t1 AS other RIGHT JOIN t1 AS curr
GROUP BY curr.id1);