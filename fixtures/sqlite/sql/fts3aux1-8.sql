SELECT term, documents, occurrences FROM terms
WHERE rec('cnt', term) AND term BETWEEN 'brags' AND 'brain'