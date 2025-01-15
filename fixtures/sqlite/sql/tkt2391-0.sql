CREATE TABLE folders(folderid, parentid, foldername COLLATE binary);
INSERT INTO folders VALUES(1, 3, 'FolderA');
INSERT INTO folders VALUES(1, 3, 'folderB');
INSERT INTO folders VALUES(4, 0, 'FolderC');