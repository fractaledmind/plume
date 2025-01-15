INSERT INTO x1(x1) VALUES('merge=4,4');
SELECT level, end_block, length(root) FROM x1_segdir;