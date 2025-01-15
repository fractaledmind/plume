CREATE TABLE Folders(
folderid INTEGER PRIMARY KEY,
parentid INTEGER,
rootid INTEGER,
path VARCHAR(255)
);