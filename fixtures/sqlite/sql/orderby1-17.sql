EXPLAIN QUERY PLAN
SELECT name FROM album JOIN track USING (aid) ORDER BY title, aid, tn