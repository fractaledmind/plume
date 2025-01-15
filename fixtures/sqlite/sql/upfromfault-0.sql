WITH data(k, v) AS (
VALUES(3, 'thirty'), (1, 'ten')
)
UPDATE t1 SET z=v FROM data WHERE x=k;