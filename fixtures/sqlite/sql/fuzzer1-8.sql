SELECT n, distance FROM f2, streetname
WHERE f2.word MATCH 'testledown'
AND f2.distance<=150
AND f2.word=streetname.n