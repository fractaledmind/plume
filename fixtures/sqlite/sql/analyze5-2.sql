CREATE INDEX t1t ON t1(t);  -- 0.5, 1.5, 2.5, and 3.5
CREATE INDEX t1u ON t1(u);  -- text
CREATE INDEX t1v ON t1(v);  -- mixed case text
CREATE INDEX t1w ON t1(w);  -- integers 0, 1, 2 and a few NULLs
CREATE INDEX t1x ON t1(x);  -- integers 1, 2, 3 and many NULLs
CREATE INDEX t1y ON t1(y);  -- integers 0 and very few 1s
CREATE INDEX t1z ON t1(z);  -- integers 0, 1, 2, and 3
ANALYZE;