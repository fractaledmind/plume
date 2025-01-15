SELECT docid, mit(matchinfo(t1, 'pcxnal')) FROM t1
WHERE t1 MATCH 'spake hebrew'
ORDER BY docid;