SELECT sum(one), two, four FROM agger
GROUP BY two, four ORDER BY sum(one) desc