SELECT DISTINCT p.name
FROM persons p CROSS JOIN directors d
WHERE d.person_id=p.person_id
AND NOT EXISTS (
SELECT person_id FROM directors d1 WHERE d1.person_id=p.person_id
EXCEPT
SELECT person_id FROM writers w
);