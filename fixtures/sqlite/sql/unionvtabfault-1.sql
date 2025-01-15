CREATE VIRTUAL TABLE temp.uuu USING unionvtab(
"VALUES(NULL, 't1', 1, 9),  ('main', 't2', 10, 19), ('aux', 't3', 20, 29)"
);