SELECT b IN (SELECT a FROM collate2t1 WHERE a IN ('aa', 'bb'))
FROM collate2t1;