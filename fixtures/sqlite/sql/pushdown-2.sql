SELECT * FROM u1 WHERE f('one')=123 AND 123=(
SELECT x FROM u2 WHERE x=a AND f('two')
)