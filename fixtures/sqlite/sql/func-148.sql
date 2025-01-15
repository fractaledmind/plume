SELECT group_concat(CASE t1 WHEN 'this' THEN ''
WHEN 'program' THEN null ELSE t1 END) FROM tbl1