SELECT aa.value, bb.value, '|'
FROM carray(inttoptr($PTR4),5,'double') AS aa
JOIN carray(inttoptr($PTR5),5,'char*') AS bb ON aa.rowid=bb.rowid;