SELECT *, b.rowid
FROM schema a LEFT JOIN schema b ON a.dflt_value=b.dflt_value
WHERE a.rowid=1