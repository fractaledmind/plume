-- fts2c.test
-- 
-- execsql {
--     SELECT snippet(email) FROM email
--      WHERE email MATCH 'chris is here'
-- }
SELECT snippet(email) FROM email
WHERE email MATCH 'chris is here'