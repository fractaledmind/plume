DROP TABLE t6b;
CREATE TABLE t6b(x CHECK( x COLLATE nocase <>'abc' ));