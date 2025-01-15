SELECT rowid, offsets(email) FROM email
WHERE body MATCH 'child product' AND +rowid=32