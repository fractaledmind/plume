PRAGMA writable_schema = 1;
CREATE VIEW vvv AS
SELECT tbl,idx,neq,nlt,ndlt,test_extract(sample,0) AS sample
FROM sqlite_stat4;
PRAGMA writable_schema = 0;