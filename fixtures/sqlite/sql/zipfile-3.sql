SELECT sum(name LIKE '%/a.txt')
FROM (VALUES(1),(2),(3)) CROSS JOIN fsdir('test_unzip')