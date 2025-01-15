SELECT typeof(group_concat(x,''))
FROM (SELECT '' AS x UNION ALL SELECT '');