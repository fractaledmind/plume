SELECT docid, weight FROM t1, t2
WHERE t1 MATCH 'this' AND t1.docid = t2.id ORDER BY weight;