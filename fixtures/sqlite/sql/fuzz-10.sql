SELECT 'A' FROM (SELECT 'B') ORDER BY EXISTS (
SELECT 'C' FROM (SELECT 'D' LIMIT 0)
)