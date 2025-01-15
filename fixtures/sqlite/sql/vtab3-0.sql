CREATE TABLE elephant(
name VARCHAR(32),
color VARCHAR(16),
age INTEGER,
UNIQUE(name, color)
);