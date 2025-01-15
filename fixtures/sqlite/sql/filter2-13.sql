SELECT
string_agg(CAST(b AS TEXT), '_') FILTER (WHERE b%2!=0),
string_agg(CAST(b AS TEXT), '_') FILTER (WHERE b%2!=1),
count(*) FILTER (WHERE b%2!=0),
count(*) FILTER (WHERE b%2!=1)
FROM t1;