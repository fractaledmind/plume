SELECT docid, mit(matchinfo(t1, 'pcxnal')) FROM t1
WHERE t1 MATCH 'joseph died in egypt'
ORDER BY docid;