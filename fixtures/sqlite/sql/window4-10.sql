SELECT id, lead(b, -1) OVER (PARTITION BY a ORDER BY id) FROM t7;