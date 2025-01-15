INSERT INTO t1(b) VALUES(65) RETURNING (
SELECT * FROM sqlite_temp_schema
) AS aaa;