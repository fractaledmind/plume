CREATE TABLE AAA (
aaa_id       INTEGER PRIMARY KEY AUTOINCREMENT
);
CREATE TABLE RRR (
rrr_id      INTEGER     PRIMARY KEY AUTOINCREMENT,
rrr_date    INTEGER     NOT NULL,
rrr_aaa     INTEGER
);
CREATE TABLE TTT (
ttt_id      INTEGER PRIMARY KEY AUTOINCREMENT,
target_aaa  INTEGER NOT NULL,
source_aaa  INTEGER NOT NULL
);
insert into AAA (aaa_id) values (2);
insert into TTT (ttt_id, target_aaa, source_aaa)
values (4469, 2, 2);
insert into TTT (ttt_id, target_aaa, source_aaa)
values (4476, 2, 1);
insert into RRR (rrr_id, rrr_date, rrr_aaa)
values (0, 0, NULL);
insert into RRR (rrr_id, rrr_date, rrr_aaa)
values (2, 4312, 2);
SELECT i.aaa_id,
(SELECT sum(CASE WHEN (t.source_aaa == i.aaa_id) THEN 1 ELSE 0 END)
FROM TTT t
) AS segfault
FROM
(SELECT curr.rrr_aaa as aaa_id
FROM RRR curr
-- you also can comment out the next line
-- it causes segfault to happen after one row is outputted
INNER JOIN AAA a ON (curr.rrr_aaa = aaa_id)
LEFT JOIN RRR r ON (r.rrr_id <> 0 AND r.rrr_date < curr.rrr_date)
GROUP BY curr.rrr_id
HAVING r.rrr_date IS NULL
) i;