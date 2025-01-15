DELETE FROM result2;
CREATE TRIGGER r3u INSTEAD OF UPDATE ON v3 BEGIN
INSERT INTO result2(a,b) VALUES(old.c1, new.c1);
END;
UPDATE v3 SET c1 = c1 || '-extra' WHERE c1 BETWEEN '8' and 'eight';
SELECT * FROM result2 ORDER BY a;