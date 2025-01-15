CREATE VIRTUAL TABLE vars USING tclvar;
SELECT name, arrayname, value FROM vars WHERE name='abc';