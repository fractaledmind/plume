CREATE TABLE Items(
itemId integer primary key,
item str unique
);
INSERT INTO "Items" VALUES(0, 'ALL');
INSERT INTO "Items" VALUES(1, 'double:source');
INSERT INTO "Items" VALUES(2, 'double');
INSERT INTO "Items" VALUES(3, 'double:runtime');
INSERT INTO "Items" VALUES(4, '.*:runtime');

CREATE TABLE Labels(
labelId INTEGER PRIMARY KEY,
label STR UNIQUE
);
INSERT INTO "Labels" VALUES(0, 'ALL');
INSERT INTO "Labels" VALUES(1, 'localhost@rpl:linux');
INSERT INTO "Labels" VALUES(2, 'localhost@rpl:branch');

CREATE TABLE LabelMap(
itemId INTEGER,
labelId INTEGER,
branchId integer
);
INSERT INTO "LabelMap" VALUES(1, 1, 1);
INSERT INTO "LabelMap" VALUES(2, 1, 1);
INSERT INTO "LabelMap" VALUES(3, 1, 1);
INSERT INTO "LabelMap" VALUES(1, 2, 2);
INSERT INTO "LabelMap" VALUES(2, 2, 3);
INSERT INTO "LabelMap" VALUES(3, 2, 3);

CREATE TABLE Users (
userId INTEGER PRIMARY KEY,
user STRING UNIQUE,
salt BINARY,
password STRING
);
INSERT INTO "Users" VALUES(1, 'test', 'æ$d',
'43ba0f45014306bd6df529551ffdb3df');
INSERT INTO "Users" VALUES(2, 'limited', 'ª>S',
'cf07c8348fdf675cc1f7696b7d45191b');
CREATE TABLE UserGroups (
userGroupId INTEGER PRIMARY KEY,
userGroup STRING UNIQUE
);
INSERT INTO "UserGroups" VALUES(1, 'test');
INSERT INTO "UserGroups" VALUES(2, 'limited');

CREATE TABLE UserGroupMembers (
userGroupId INTEGER,
userId INTEGER
);
INSERT INTO "UserGroupMembers" VALUES(1, 1);
INSERT INTO "UserGroupMembers" VALUES(2, 2);

CREATE TABLE Permissions (
userGroupId INTEGER,
labelId INTEGER NOT NULL,
itemId INTEGER NOT NULL,
write INTEGER,
capped INTEGER,
admin INTEGER
);
INSERT INTO "Permissions" VALUES(1, 0, 0, 1, 0, 1);
INSERT INTO "Permissions" VALUES(2, 2, 4, 0, 0, 0);