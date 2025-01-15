CREATE INDEX f_i ON folders(foldername);
SELECT count(*) FROM folders WHERE foldername < 'FolderC' COLLATE nocase;