SELECT c FROM collate2t1
WHERE NOT c IN (SELECT a FROM collate2t1 WHERE a IN ('aa', 'bb'));