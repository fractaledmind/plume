SELECT group_concat(CASE WHEN t1!='software' THEN null ELSE t1 END) FROM tbl1