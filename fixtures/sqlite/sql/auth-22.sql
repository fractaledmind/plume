SELECT name FROM (
SELECT * FROM sqlite_master UNION ALL SELECT * FROM temp.sqlite_master)
WHERE type='table'
ORDER BY name