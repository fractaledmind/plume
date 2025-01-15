SELECT writefile('test_unzip.zip',
( SELECT zipfile(name,mode,mtime,data,method) FROM zipfile($file) )
);