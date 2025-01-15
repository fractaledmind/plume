CREATE TABLE test_table(
one INT NOT NULL DEFAULT -1,
two text,
three VARCHAR(45, 65) DEFAULT 'abcde',
four REAL DEFAULT X'abcdef',
five DEFAULT CURRENT_TIME
);