------------------------------------------------------------------------------------
-- 1. Listado de los empleados cond omicilio ordenados por Código postal y nombre --
------------------------------------------------------------------------------------
CREATE VIEW vista1 AS
  (
  SELECT EMPLEADOS.Nombre, DOMICILIOS.Calle, DOMICILIOS."Código postal"
  FROM EMPLEADOS, DOMICILIOS
  WHERE EMPLEADOS.DNI = DOMICILIOS.DNI
  ORDER BY DOMICILIOS."Código postal", EMPLEADOS.Nombre
  );
  
--------------------------------------------------------------------------
-- 2. Listado de los empleados que tengan teléfono ordenados por nombre -- 
--------------------------------------------------------------------------
CREATE VIEW vista2 AS
  (
  SELECT Nombre, Empleados.DNI, Calle, "Código postal", Teléfono
  FROM Domicilios 
  RIGHT JOIN (Empleados INNER JOIN Teléfonos ON  Empleados.DNI = teléfonos.DNI) 
  ON  Domicilios.DNI = Empleados.DNI
  ORDER BY Empleados.Nombre
  );
  
-----------------------------------------------------------------------------------------------------------
-- 3. Listado de todos los empleados ordenados por nombre, tanto los que tienen teléfono como los que no --
-----------------------------------------------------------------------------------------------------------
CREATE VIEW vista3 AS
  (
  SELECT Nombre, Empleados.DNI, Calle, "Código postal", Teléfono
  FROM Domicilios 
  RIGHT JOIN (Empleados LEFT JOIN Teléfonos ON Empleados.DNI = teléfonos.DNI) 
  ON  Domicilios.DNI = Empleados.DNI
  ORDER BY Empleados.Nombre
  );

------------------------------------------------------------
-- 4. Listado de todos los empleados ordenados por nombre -- 
------------------------------------------------------------
CREATE VIEW vista4 AS
  (
  SELECT Empleados.Nombre, Empleados.DNI, Domicilios.Calle, Población, Provincia, Domicilios."Código postal", Teléfono
  FROM Teléfonos 
		FULL JOIN 
		(Empleados LEFT JOIN 
					(Domicilios FULL JOIN 
								   "Códigos postales" 
				ON Domicilios."Código postal" = "Códigos postales"."Código postal") 
			ON Empleados.DNI = Domicilios.DNI) 
		ON  Teléfonos.DNI = Empleados.DNI
  ORDER BY Empleados.Nombre;
  );

------------------------------------------------------------  
-- 5. Listado de todos los empleados ordenados por nombre --
------------------------------------------------------------
create view pr17 as 
	( 
	select Nombre, Empleados.DNI,Calle,"Código postal" 
	from Empleados 
	left outer join Domicilios 
	on Empleados.DNI = Domicilios.DNI 
	);
create view pr18 as 
	( 
	select Nombre, DNI, Calle, Población, Provincia,  "Códigos postales"."Código postal"   
	from pr17 
	left outer join "Códigos postales" 
	on pr17."Código postal" = "Códigos postales"."Código postal"
	);
create view pr19 as 
	( 
	select Nombre, pr18.DNI, Calle, Población, Provincia, "Código postal", Teléfono   
	from pr18 left outer join Teléfonos on pr18.DNI=Teléfonos.DNI
	);
create view vista5 as
	(
	select * from pr19 order by Nombre
	);
	
---------------------------------------------------------------------------------------------------
-- 6. Instrucción UPDATE: incremento del 10% del sueldo de todos los empleados sin superar 1900€ --
---------------------------------------------------------------------------------------------------
update Empleados set Sueldo = Sueldo*1.10 where Sueldo*1.10<=1900;

------------------------------------------------------
-- 7. Instrucción UPDATE: deshacer la instrucción 6 --
------------------------------------------------------
update Empleados set Sueldo = Sueldo/1.10 where Sueldo <= 1900;

-------------------------------------------------------------------------------------------------------------
-- 8. Se modifica el Sueldo de 1500 que no se había aumentado, pero en este caso se ha decrementado un 10% --
-------------------------------------------------------------------------------------------------------------
update Empleados set Sueldo = Sueldo*1.10 where Sueldo*1.10<=1600;
update Empleados set Sueldo = Sueldo/1.10 where Sueldo <= 1600;

-----------------------------------------------------------------
-- 9. Número total de empleados, sueldo mínimo, máximo y medio --
-----------------------------------------------------------------
create view vista9 as
	(
	SELECT  COUNT(*) AS Empleados, MIN(Sueldo) AS "Sueldo mínimo", MAX(Sueldo) AS "Sueldo máximo", AVG(Sueldo) AS "Sueldo medio" 
	FROM EMPLEADOS
	);

---------------------------------------------------------------------------------------------
-- 10. Muestra el sueldo medio por población y número de empleados, ordenado por población --
---------------------------------------------------------------------------------------------
create view pr1 as 
	( 
	select Nombre,Sueldo,Empleados.DNI, Calle, "Código postal" 
	from EMPLEADOS, DOMICILIOS 
	where Empleados.DNI=DOMICILIOS.DNI 
	);
create view pr2 as 
	( 
	select Nombre,Sueldo,DNI,Población 
	from pr1, "Códigos postales" 
	where pr1."Código postal" =  "Códigos postales"."Código postal" 
	);
create view pr3 as 
	( 
	select Población,count(Nombre) as numEmpleados 
	from pr2 
	group by Población 
	) ;
create view pr4 as 
	( 
	select Población, avg(Sueldo) as "Sueldo Medio" 
	from pr2 
	group by Población 
	);
create view pr5 as 
	( 
	select "Sueldo Medio",numEmpleados ,pr3.Población 
	from pr3,pr4 
	where pr3.Población=pr4.Población 
	) ;
create view vista10 as
	(
	select * from pr5
	);
	
---------------------------------------------------------------	
-- 11. Empleados con más de un teléfono ordenados por nombre --
---------------------------------------------------------------
create view pr6 as 
	( 
	select count(*) as numeroTel, DNI 
	from Teléfonos 
	group by DNI 
	);
create view pr7 as 
	( 
	select Nombre, Empleados.DNI, Teléfono 
	from Empleados, pr6, Teléfonos 
	where pr6."DNI"=Teléfonos."DNI" and Teléfonos.DNI=Empleados.DNI and pr6.NUMEROTEL>1 
	);
create view vista11 as
	(
	select * from pr7
	);
	
---------------------------------------------------------------------------
-- 12. Listado de provincias con códigos postales ordenado por población --
---------------------------------------------------------------------------
create view pr9 as ( select Población,"Código postal" as Barcelona from "Códigos postales" where Provincia='Barcelona');
create view pr10 as ( select Población,"Código postal" as Córdoba from "Códigos postales" where Provincia='Córdoba');
create view pr11 as ( select Población,"Código postal" as Madrid from "Códigos postales" where Provincia='Madrid');
create view pr12 as ( select Población,"Código postal" as Zaragoza from "Códigos postales" where Provincia='Zaragoza');
create view pr13 as ( select "Códigos postales".Población,pr9.BARCELONA from "Códigos postales" left outer join pr9 on  "Códigos postales".Población=pr9."POBLACIÓN");
create view pr14 as ( select "Códigos postales".Población,pr10.Córdoba from "Códigos postales" left outer join pr10 on  "Códigos postales".Población=pr10."POBLACIÓN");
create view pr15 as ( select "Códigos postales".Población,pr11.MADRID from "Códigos postales" left outer join pr11 on  "Códigos postales".Población=pr11."POBLACIÓN");
create view pr16 as ( select "Códigos postales".Población,pr12.ZARAGOZA from "Códigos postales" left outer join pr12 on  "Códigos postales".Población=pr12."POBLACIÓN");
create view vista12 as
	(
	select Población,pr9.BARCELONA,pr10.Córdoba,pr11.Madrid,pr12.Zaragoza 
	from (((("Códigos postales" natural full outer join pr9)natural full outer join pr10) natural full outer join pr11)natural full outer join pr12) order by Población 
	);