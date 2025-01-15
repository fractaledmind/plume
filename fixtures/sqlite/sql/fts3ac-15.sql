SELECT rowid, offsets(email) FROM email
WHERE body MATCH '"child product"'