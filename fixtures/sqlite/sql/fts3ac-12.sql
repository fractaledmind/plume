SELECT rowid, offsets(email) FROM email
WHERE subject MATCH 'gas reminder'