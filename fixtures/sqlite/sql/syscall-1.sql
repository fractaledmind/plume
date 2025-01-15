PRAGMA temp_store = file;

PRAGMA main.cache_size = 10;
PRAGMA temp.cache_size = 10;
CREATE TABLE temp.tt(a, b);
INSERT INTO tt VALUES(randomblob(500), randomblob(600));
INSERT INTO tt SELECT randomblob(500), randomblob(600) FROM tt;
INSERT INTO tt SELECT randomblob(500), randomblob(600) FROM tt;
INSERT INTO tt SELECT randomblob(500), randomblob(600) FROM tt;
INSERT INTO tt SELECT randomblob(500), randomblob(600) FROM tt;
INSERT INTO tt SELECT randomblob(500), randomblob(600) FROM tt;
INSERT INTO tt SELECT randomblob(500), randomblob(600) FROM tt;
INSERT INTO tt SELECT randomblob(500), randomblob(600) FROM tt;
INSERT INTO tt SELECT randomblob(500), randomblob(600) FROM tt;