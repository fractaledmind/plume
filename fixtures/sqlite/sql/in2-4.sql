SELECT 1 IN (SELECT a FROM a WHERE (i < $::ii) OR (i >= $::N))