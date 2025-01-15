SELECT DISTINCT lower(lindex(test_decode(sample), 0))
FROM sqlite_stat4 WHERE idx='t1v' ORDER BY 1