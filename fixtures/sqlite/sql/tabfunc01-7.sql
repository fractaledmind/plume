SELECT b FROM t600, carray(inttoptr($PTR5),5,'char*')
WHERE a=trim(value,'x');