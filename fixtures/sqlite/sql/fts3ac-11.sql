SELECT rowid, offsets(email) FROM email
WHERE email MATCH 'body:gas reminder'