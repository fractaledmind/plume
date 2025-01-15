CREATE TABLE [t4"abc] AS SELECT count(*) as cnt, max(b+c) FROM [t3"xyz];
SELECT * FROM [t4"abc];