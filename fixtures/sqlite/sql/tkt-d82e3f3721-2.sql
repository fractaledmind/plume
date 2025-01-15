SELECT 'main', * FROM main.sqlite_sequence
UNION ALL
SELECT 'temp', * FROM temp.sqlite_sequence
ORDER BY 2