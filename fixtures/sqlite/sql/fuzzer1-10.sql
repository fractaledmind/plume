SELECT DISTINCT streetname.n
FROM f2 JOIN streetname
ON (streetname.n>=f2.word AND streetname.n<=(f2.word || 'zzzzzz'))
WHERE f2.word MATCH 'duck'
AND f2.distance<150
AND f2.ruleset=3
ORDER BY 1