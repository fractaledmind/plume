SELECT a, b FROM collate5t2 EXCEPT select a, b FROM collate5t1
where a != 'a';