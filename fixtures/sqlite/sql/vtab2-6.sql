SELECT name, value FROM vars
WHERE name MATCH 'tcl_*' AND arrayname = ''
ORDER BY name;