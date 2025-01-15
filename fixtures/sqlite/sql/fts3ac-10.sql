SELECT rowid, offsets(email) FROM email
WHERE email MATCH 'subject:gas reminder'