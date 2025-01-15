SELECT *, b.rowid
FROM schema a LEFT JOIN schema b ON a.dflt_value IS b.dflt_value
AND a.dflt_value IS NOT NULL
WHERE a.rowid=1