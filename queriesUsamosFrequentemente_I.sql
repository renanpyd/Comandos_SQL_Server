-- Criação de tabela para executar os exemplos:

drop table CONVENTION;
create table CONVENTION ( 
    ssn     varchar2(6) not null 
    , name_lf   varchar2(30) not null 
    , ph        varchar2(7) not null 
    , em        varchar(15) not null 
    , company   varchar(15) not null 
);
insert into CONVENTION values ('A1A1A1', 'Amjit, Anush', '1111111', '111@example.com', 'Apple');
insert into CONVENTION values ('B2B2B2', 'Borges, Benita', '2222222', '222@example.com', 'Boiron');
insert into CONVENTION values ('C3C3C3', 'Combs, Cathy', '3333333', '333@example.com', 'CVS');
insert into CONVENTION values ('D4D4D4', 'Daher, Darweesh', '4444444', '444@example.com', 'Dell');
insert into CONVENTION values ('E5E5E5', 'Ellis, Ezra', '5555555', '555@example.com', 'EDF');
insert into CONVENTION values ('F6F6F6', 'Fulvia, Frances', '6666666', '666@example.com', 'Firestone');
drop table RESTAURANT;
create table RESTAURANT ( 
    social      varchar2(6) not null 
    , name_fl   varchar2(30) not null 
    , phone     varchar2(7) not null 
    , email     varchar2(15) not null 
    , fav_food  varchar2(10) not null 
    , age       int not null 
);
insert into RESTAURANT values ('C3C3C3', 'Cathy Combs', '3333333', 'ccc@example.com', 'Carrots', 33);
insert into RESTAURANT values ('D4D4D4', 'Darweesh Daher', '4444444', '444@example.com', 'Doritos', 44);
insert into RESTAURANT values ('E5E5E5', 'Ezra Ellis', '5555555', '555@example.com', 'Endives', 55);
insert into RESTAURANT values ('FFF666', 'Frances Fulvia', '6666666', '666@example.com', 'Fries', 66);
insert into RESTAURANT values ('G7G7G7', 'Grace Gao', '7777777', '777@example.com', 'Garlic', 77);
insert into RESTAURANT values ('H8H8H8', 'Helen Hopper', '8888888', '888@example.com', 'Hummus', 88);

--===================================================================================================================
-- LEFT OUTER JOIN

select 
	  A.name_lf
	, A.company
	, B.name_fl
	, B.fav_food
from 
	CONVENTION A
	left outer join RESTAURANT B on A.ssn = B.social;

--===================================================================================================================
-- NOT IN

select 
	  A.name_lf
	, A.company
from 
	CONVENTION A
where 
	A.ssn not in ( select B.social from RESTAURANT B );

--===================================================================================================================
-- <> ALL

select 
	  A.name_lf
	, A.company
from 
	CONVENTION A
where 
	A.ssn <> all ( select B.social from RESTAURANT B );

--===================================================================================================================
-- MINUS

select 
	A.ssn
from 
	CONVENTION A
minus
select 
	B.social
from 
	RESTAURANT B;

--===================================================================================================================
-- NOT EXISTS

SELECT 
	  A.name_lf
	, A.company
FROM 
	CONVENTION A
WHERE 
	NOT EXISTS (
		SELECT NULL
    		FROM RESTAURANT B
  		WHERE A.ph = B.phone and A.em = B.email
	);

--===================================================================================================================
-- LEFT OUTER JOIN ... B.... IS NULL

select 
	  A.name_lf
	, A.company
from 
	CONVENTION A
		left outer join RESTAURANT B on A.ph = B.phone and A.em = B.email
where 
	B.phone is null
    and B.email is null;

























