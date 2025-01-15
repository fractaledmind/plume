CREATE INDEX i10 ON indexed(x);
SELECT * FROM indexed indexed by i10 where x>0;