UPDATE sqlite_dbpage SET data = (
SELECT data FROM sqlite_dbpage WHERE pgno=($pgno-1)
) WHERE pgno = $pgno;