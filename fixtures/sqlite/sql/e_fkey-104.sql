UPDATE pA SET x = X'8765' WHERE rowid = 4;
SELECT quote(x) FROM pA ORDER BY rowid;