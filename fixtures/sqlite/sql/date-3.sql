SELECT a==b FROM (SELECT current_timestamp AS a,
sleeper(), current_timestamp AS b);