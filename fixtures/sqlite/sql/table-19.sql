ANALYZE;
DROP TABLE IF EXISTS sqlite_stat1;
DROP TABLE IF EXISTS sqlite_stat2;
DROP TABLE IF EXISTS sqlite_stat3;
DROP TABLE IF EXISTS sqlite_stat4;
SELECT name FROM sqlite_master WHERE name GLOB 'sqlite_stat*';