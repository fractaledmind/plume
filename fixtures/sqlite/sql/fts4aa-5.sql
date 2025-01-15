SELECT docid, mit(matchinfo(t1, 'pcxnal')) FROM t1
WHERE t1 MATCH 'laban overtook jacob'
ORDER BY docid;