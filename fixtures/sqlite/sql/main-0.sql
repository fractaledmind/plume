create table T1(X REAL);  /* C-style comments allowed */
insert into T1 values(0.5);
insert into T1 values(0.5e2);
insert into T1 values(0.5e-002);
insert into T1 values(5e-002);
insert into T1 values(-5.0e-2);
insert into T1 values(-5.1e-2);
insert into T1 values(0.5e2);
insert into T1 values(0.5E+02);
insert into T1 values(5E+02);
insert into T1 values(5.0E+03);
select x*10 from T1 order by x*5;