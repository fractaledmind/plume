SELECT rowid, offsets(email) FROM email
WHERE body MATCH 'gas reminder'