SELECT json_extract( zipfile_cds(z), '$.version-made-by' )
FROM zipfile('test.zip')