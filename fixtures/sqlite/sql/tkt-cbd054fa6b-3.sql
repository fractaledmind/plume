SELECT tbl,idx,string_agg(s(sample),' ')
FROM vvv
WHERE idx = 't1_x'
GROUP BY tbl,idx