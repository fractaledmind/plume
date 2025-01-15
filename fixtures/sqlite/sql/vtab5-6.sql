CREATE VIRTUAL TABLE echo_strings USING echo(strings);
SELECT str FROM echo_strings ORDER BY 1;