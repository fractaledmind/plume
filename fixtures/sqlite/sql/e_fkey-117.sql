BEGIN;
UPDATE parent SET a = '' WHERE a = 'oNe';
SELECT * FROM child;