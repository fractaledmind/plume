SELECT DISTINCT
b.val,
CASE WHEN b.val = '1' THEN 'xyz' ELSE b.val END AS col1
FROM b;