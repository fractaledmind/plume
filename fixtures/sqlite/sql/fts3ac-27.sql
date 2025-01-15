DELETE FROM ft WHERE one = 'foo';
SELECT offsets(ft) FROM ft WHERE ft MATCH 'foo';