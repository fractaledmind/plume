CREATE TABLE table2 (key TEXT, x TEXT);
CREATE TABLE list (key TEXT, value TEXT);

INSERT INTO table2 VALUES ("a", "alist");
INSERT INTO table2 VALUES ("b", "blist");
INSERT INTO list VALUES ("a", 1);
INSERT INTO list VALUES ("a", 2);
INSERT INTO list VALUES ("a", 3);
INSERT INTO list VALUES ("b", 4);
INSERT INTO list VALUES ("b", 5);
INSERT INTO list VALUES ("b", 6);

SELECT
table2.x,
(SELECT group_concat(list.value)
FROM list
WHERE list.key = table2.key)
FROM table2;