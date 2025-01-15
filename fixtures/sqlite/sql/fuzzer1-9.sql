SELECT DISTINCT streetname.n FROM f2, streetname
WHERE f2.word MATCH 'tayle'
AND f2.distance<=200
AND streetname.n>=f2.word AND streetname.n<=(f2.word || x'F7BFBFBF')