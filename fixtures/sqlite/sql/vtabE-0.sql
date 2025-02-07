CREATE VIRTUAL TABLE t1 USING tclvar;
CREATE VIRTUAL TABLE t2 USING tclvar;
CREATE TABLE t3(a INTEGER PRIMARY KEY, b);
SELECT t1.name, t1.arrayname, t1.value,
t2.name, t2.arrayname, t2.value,
abs(t3.b + abs(t2.value + abs(t1.value)))
FROM t1 LEFT JOIN t2 ON t2.name = t1.arrayname
LEFT JOIN t3 ON t3.a=t2.value
WHERE t1.name = 'vtabE'
ORDER BY t1.value, t2.value;