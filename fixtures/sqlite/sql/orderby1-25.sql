SELECT name FROM album CROSS JOIN track USING (aid) ORDER BY title DESC, tn