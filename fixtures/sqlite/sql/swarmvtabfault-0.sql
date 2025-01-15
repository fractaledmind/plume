CREATE VIRTUAL TABLE temp.xyz USING swarmvtab(
'VALUES
("test.db1", "t1", 1, 10),
("test.db2", "t1", 11, 20)
', 'fetch_db'
);