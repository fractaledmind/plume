EXPLAIN QUERY PLAN
WITH
-- Find the country and min/max date
init(country, date, fin) AS (SELECT country, min(date), max(date)
FROM raw WHERE total > 0 GROUP BY country),

-- Generate the date stream for each country
src(country, date) AS (SELECT raw.country, raw.date
FROM raw JOIN init i on raw.country = i.country AND raw.date > i.date
ORDER BY raw.country, raw.date),

-- Generate the x & y for each entry in the country/date stream
vals(country, date, x, y) AS (SELECT src.country, src.date,
julianday(raw.date) - julianday(src.date), log(delta+1)
FROM src JOIN raw on raw.country = src.country
AND raw.date > date(src.date,'-7 days')
AND raw.date <= src.date AND delta >= 0),

-- Accumulate the data we need
sums(country, date, x2, x, n, xy, y) AS (SELECT country, date,
sum(x*x*1.0), sum(x*1.0), sum(1.0), sum(x*y*1.0), sum(y*1.0)
FROM vals GROUP BY 1, 2),

-- use these to calculate to divisor for the inverse matrix
mult(country, date, m) AS (SELECT country, date, 1.0/(x2 * n - x * x)
FROM sums),

-- Build the inverse matrix
inv(country, date, a,b,c,d) AS (SELECT mult.country, mult.date, n * m,
-x * m, -x * m, x2 * m
FROM mult JOIN sums on sums.country=mult.country
AND mult.date=sums.date),

-- Calculate the coefficients for the least squares fit
fit(country, date, a, b) AS (SELECT inv.country, inv.date,
a * xy + b * y, c * xy + d * y
FROM inv
JOIN mult on mult.country = inv.country AND mult.date = inv.date
JOIN sums on sums.country = mult.country AND sums.date = mult.date
)
SELECT *, nFin/nPrev - 1 AS growth, log(2)/log(nFin/nPrev) AS doubling
FROM (SELECT f.*, exp(b) - 1 AS nFin, exp(a* (-1) + b) - 1 AS nPrev
FROM fit f JOIN init i on i.country = f.country
AND f.date <= date(i.fin,'-3 days'))
WHERE nPrev > 0 AND nFin > 0;