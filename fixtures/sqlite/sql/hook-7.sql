INSERT INTO t1w VALUES(4, 'four');
DELETE FROM t1w WHERE b = 'two';
UPDATE t1w SET b = '' WHERE a = 1 OR a = 3;
DELETE FROM t1w WHERE 1; -- Avoid the truncate optimization (for now)