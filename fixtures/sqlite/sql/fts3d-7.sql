PRAGMA encoding=UTF16le;
CREATE VIRTUAL TABLE fts USING fts3(a,b,c);
SELECT name FROM sqlite_master WHERE name GLOB '???_*' ORDER BY 1;