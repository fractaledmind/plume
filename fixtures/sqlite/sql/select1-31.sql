INSERT INTO abc SELECT a+(select max(a) FROM abc),
b+(select max(a) FROM abc), c+(select max(a) FROM abc) FROM abc;