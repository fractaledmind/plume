CREATE TEMP TABLE t2(
a t1 PRIMARY KEY default 27,
b default(current_timestamp),
d TEXT UNIQUE DEFAULT 'ch`arlie',
c TEXT UNIQUE DEFAULT 084,
UNIQUE(c,b,b,a,b)
) WITHOUT ROWID;