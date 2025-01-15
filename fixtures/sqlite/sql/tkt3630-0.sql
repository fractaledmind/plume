CREATE TEMP TABLE temp1(a,b,c);
SELECT * FROM temp.sqlite_master WHERE sql GLOB '*TEMP*';