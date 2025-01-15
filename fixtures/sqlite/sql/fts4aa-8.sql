DROP TABLE t1;
CREATE VIRTUAL TABLE t1 USING fts3(words, tokenize porter);