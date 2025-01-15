SELECT tbl,idx,group_concat(s(sample),' ')
FROM vvv
WHERE idx = 't1_x'
GROUP BY tbl,idx