CREATE TABLE t1(a,b,c,d,e,f);
CREATE INDEX t1abc ON t1(refcnt(a+b+c));