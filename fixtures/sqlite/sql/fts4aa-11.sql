DROP TABLE t1;
CREATE VIRTUAL TABLE t1 USING fts4(words, tokenize porter);