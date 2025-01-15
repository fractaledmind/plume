BEGIN;
UPDATE aux.ab SET b = 'def' WHERE a = 0;
UPDATE main.ab SET b = 'def' WHERE a = 0;
COMMIT;