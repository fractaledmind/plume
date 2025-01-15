PRAGMA case_sensitive_like=OFF;
DROP INDEX t11b;
CREATE INDEX t11bnc ON t11(b COLLATE nocase);