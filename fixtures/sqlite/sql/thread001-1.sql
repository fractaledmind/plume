SELECT
(SELECT md5sum(a, b) FROM ab WHERE a < (SELECT max(a) FROM ab)) ==
(SELECT b FROM ab WHERE a = (SELECT max(a) FROM ab))