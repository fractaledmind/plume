CREATE TABLE aux.t1(a PRIMARY KEY, b REFERENCES t1);
CREATE TABLE aux.t2(a PRIMARY KEY, b REFERENCES t1, c REFERENCES t2);
CREATE TABLE aux.t3(a REFERENCES t1, b REFERENCES t2, c REFERENCES t1);