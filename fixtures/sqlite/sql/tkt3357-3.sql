SELECT cc.id, cc.b_id, cc.myvalue
FROM (
SELECT DISTINCT a.id, a.b_id, a.myvalue
FROM a, b WHERE a.b_id = b.id
) cc
LEFT OUTER JOIN b dd ON cc.b_id = dd.id