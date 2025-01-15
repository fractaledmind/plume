SELECT * FROM u1 WHERE 123=(
SELECT x FROM u2 WHERE x=a AND f('two')
) AND f('three')=123