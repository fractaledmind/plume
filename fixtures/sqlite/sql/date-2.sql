SELECT c - a FROM (SELECT julianday('now') AS a,
sleeper(), julianday('now') AS c);