CREATE TABLE nam(k TEXT, v TEXT);
INSERT INTO nam VALUES('testvar1', 'tv1');
INSERT INTO nam VALUES('testvar2', 'tv2');
INSERT INTO nam VALUES('testvar3', 'tv3');
UPDATE tclvar SET fullname = nam.v FROM nam WHERE name = nam.k;