SELECT name, strftime('%s', mtime, 'unixepoch', 'localtime')
FROM fsdir('test_unzip') WHERE name!='test_unzip'
ORDER BY name