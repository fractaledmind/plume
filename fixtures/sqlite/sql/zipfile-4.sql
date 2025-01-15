SELECT name, mtime
FROM fsdir('test_unzip') WHERE name!='test_unzip'
ORDER BY name