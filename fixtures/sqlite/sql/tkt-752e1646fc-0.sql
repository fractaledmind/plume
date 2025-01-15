CREATE TABLE "test" ("letter" VARCHAR(1) PRIMARY KEY, "number" INTEGER NOT NULL);
INSERT INTO "test" ("letter", "number") VALUES('b', 1);
INSERT INTO "test" ("letter", "number") VALUES('a', 2);
INSERT INTO "test" ("letter", "number") VALUES('c', 2);
SELECT DISTINCT "number" FROM (SELECT "letter", "number" FROM "test" ORDER BY "letter", "number" LIMIT 1) AS "test";