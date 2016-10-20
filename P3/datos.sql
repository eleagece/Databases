/abolish
create table programadores(dni string primary key, nombre string, direccion string, telefono string);
insert into programadores values('1','Jacinto','Jazmín 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create table analistas(dni string primary key, nombre string, direccion string, telefono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','Júpiter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plutón 3',null);

create table distribucion(codigoPr string, dniEmp string, horas int, primary key (codigoPr, dniEmp));
insert into distribucion values('P1','1',10);
insert into distribucion values('P1','2',40);
insert into distribucion values('P1','4',5);
insert into distribucion values('P2','4',10);
insert into distribucion values('P3','1',10);
insert into distribucion values('P3','3',40);
insert into distribucion values('P3','4',5);
insert into distribucion values('P3','5',30);
insert into distribucion values('P4','4',20);
insert into distribucion values('P4','5',10);

create table proyectos(codigo string primary key, descripcion string, dniDir string);
insert into proyectos values('P1','Nómina','4');
insert into proyectos values('P2','Contabilidad','4');
insert into proyectos values('P3','Producción','5');
insert into proyectos values('P4','Clientes','5');
insert into proyectos values('P5','Ventas','6');

--DNI DE TODOS LOS EMPLEADOS.	

create view vista1 as (select dni from programadores union all select dni from analistas);

--DNI DE LOS EMPLEADOS PROGRAMADORES Y ANALISTAS
create view vista2 as (select programadores.dni from programadores, analistas where programadores.dni=analistas.dni);

--DNI EMPLEADOS SIN TRABAJO
create view vista3 as (select * from vista1 except (select dniEmp from distribucion union all select dniDir from proyectos)) ;

--CÓDIGO DE PROYECTOS SIN ANALISTAS
create view vista4 as (select codigo from proyectos except select codigoPr from distribucion,analistas where distribucion.dniEmp = analistas.dni);

--DNI analistas que dirijen proyectos pero no son programadores.
create view vista5 as (select dniDir from proyectos except select dni from programadores);

--Descripción de proyectos con nombre de  los programadores y horas asignados a ellos. Descripción,nombre,horas
create view vista6 as (select proyectos.descripcion, programadores.nombre, distribucion.horas from distribucion, proyectos, programadores where (programadores.dni=distribucion.dniEmp and distribucion.codigoPr=proyectos.codigo));

--Listado de teléfonos compartidos por empleados.
create view vista71 as (select * from programadores union all select * from analistas);
create view vista7 as (select telefono from vista71 group by telefono having count(*) > 1);

--DNI empleados que son programadores y analistas usando JOIN
create view vista8 as (select dni from programadores natural join analistas);

--Número de horas por dni.
create view vista9 as (select dniEmp, sum(horas) as horas from distribucion group by dniEmp);

--Dni,nombre y proyecto.
create view vista101 as (select dniEmp, codigoPr from distribucion);
create view vista10 as (select dni, nombre, codigoPr from vista71 left outer join vista101 on dni=dniEmp);

--Dni, nombre empleado sin telefono usando isnull
create view vista11 as (select dni, nombre from vista71 where telefono is null);

--Dni empleados cuyo total de horas dividido entre el número de proyectos en que trabaja es menor que la media del total de horas por proyecto dividido ente su número de empleados.
	-- dniEmp horas totales por cada empleado
create view vista121 as (select dniEmp, sum(horas) as horast from distribucion group by dniEmp);
	-- dniEmp proy numero de proyectos en los que trabaja cada empleado
create view vista122 as (select dniEmp, count(codigoPr) as proy from distribucion group by dniEmp);
	--proyectos media de horas
create view vista123 as (select codigoPr, avg(horas) as media from distribucion group by codigoPr);
	--proyectos numero de empleados que trabajan en él
create view vista124 as (select codigoPr, count(dniEmp) as numemp from distribucion group by codigoPr);




create view vista125 as (select * from distribucion natural join (vista121 natural join vista122));
create view vista126 as (select dniEmp from vista125 natural join(vista123 natural join vista124) where (horast/proy)<(media/numemp));

--probamos otra forma
create view vista127 as (select codigoPr, sum(horas) as mediaa from distribucion group by codigoPr);

create view mediaaaa as (select avg(mediaa) as cc from vista127);

create view vista129 as (select * from vista123, mediaaaa);

create view vista128 as (select dniEmp from vista125 natural join vista129 where (horast/proy)<(cc/numemp));


--create view vista14 as (select dni from distribución, vista121, vista122, vista123, vista124 where (vista121.horas/vista122.proy)<(vista123.media/vista124.numemp));

--Dni empleados que trabajan en los mismos proyectos que Evaristo
create view vista131 as (select dniEmp, codigoPr from distribucion where distribucion.dniEmp= (select dni from analistas where nombre='Evaristo') );
create view vista132 as (select dniEmp, codigoPr from distribucion);
create view vista13 as (select dniEmp, codigoPr from vista132 where exists (select * from vista131 where vista132.codigoPr=vista131.codigoPr));

--13 pero sin division
create view vista141 as (select codigoPr from vista132);
create view vista142 as (select dniEmp from distribucion);
create view vista143 as (select * from distribucion);
create view vista144 as (select dniEmp from vista143);
create view vista145 as (select * from vista144, vista141);
create view vista146 as (select * from vista145 where vista143 not in vista145);

--create view vista145 as (select dniEmp from );


--horas de cada empleado que no trabaja con evaristo x20% codigoPr,dni,horas

create view vista151 as (select dniEmp, codigoPr from vista132 where exists (select * from vista131 where vista132.codigoPr=vista131.codigoPr));

create view vista15 as (select codigoPr, dniEmp, (horas*(1.2)) from distribucion where not exists (select dniEmp from vista151 where vista151.dniEmp=distribucion.dniEmp));



select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista7;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
--select * from vista12;
select * from vista13;
select * from vista15;
