CREATE VIRTUAL TABLE rt USING rtree(id, x1, x2);
INSERT INTO rt VALUES(1, 2 ,3);
SELECT * FROM rt;