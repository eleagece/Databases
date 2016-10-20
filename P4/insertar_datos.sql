-----------------------------------------------------------
-- Inserción en la tabla Empleados con datos de los .txt --
-----------------------------------------------------------
INSERT INTO Empleados(Nombre, DNI, Sueldo)
	VALUES ('Antonio Arjona','12345678A',5000);
INSERT INTO Empleados(Nombre, DNI, Sueldo)
	VALUES ('Carlota Cerezo','12345678C',1000);
INSERT INTO Empleados(Nombre, DNI, Sueldo)
	VALUES ('Laura López','12345678L',1500);
INSERT INTO Empleados(Nombre, DNI, Sueldo)
	VALUES ('Pedro Pérez','12345678P',2000);
SELECT * FROM Empleados;

--------------------------------------------------------------------
-- Inserción en la tabla "Códigos postales" con datos de los .txt --
--------------------------------------------------------------------
INSERT INTO "Códigos postales"("Código postal", Población, Provincia)
	VALUES ('08050','Parets','Barcelona');
INSERT INTO "Códigos postales"("Código postal", Población, Provincia)
	VALUES ('14200','Peñarroya','Córdoba');
INSERT INTO "Códigos postales"("Código postal", Población, Provincia)
	VALUES ('14900','Lucena','Córdoba');
INSERT INTO "Códigos postales"("Código postal", Población, Provincia)
	VALUES ('28040','Madrid','Madrid');
INSERT INTO "Códigos postales"("Código postal", Población, Provincia)
	VALUES ('50008','Zaragoza','Zaragoza');
INSERT INTO "Códigos postales"("Código postal", Población, Provincia)
	VALUES ('28004','Arganda','Madrid');
-- Esta da error de duplicación  ---------------------------------------
INSERT INTO "Códigos postales"("Código postal", Población, Provincia)
	VALUES ('28040','Madrid','Madrid');
------------------------------------------------------------------------
SELECT * FROM "Códigos postales";

------------------------------------------------------------
-- Inserción en la tabla Domicilios con datos de los .txt --
------------------------------------------------------------
INSERT INTO Domicilios(DNI, Calle, "Código postal")
	VALUES ('12345678A','Avda. Complutense','28040');
INSERT INTO Domicilios(DNI, Calle, "Código postal")
	VALUES ('12345678A','Cántaro','28004');
INSERT INTO Domicilios(DNI, Calle, "Código postal")
	VALUES ('12345678P','Diamante','14200');
INSERT INTO Domicilios(DNI, Calle, "Código postal")
	VALUES ('12345678P','Carbón','14900');
-- Esta no entra porque ese código postal no existe --
INSERT INTO Domicilios(DNI, Calle, "Código postal")
	VALUES ('12345678L','Diamante','15200');
------------------------------------------------------
-- Esta sería la versión corregida con CP 14200 ------
INSERT INTO Domicilios(DNI, Calle, "Código postal")
	VALUES ('12345678L','Diamante','14200');
------------------------------------------------------	
SELECT * FROM Domicilios;

-----------------------------------------------------------
-- Inserción en la tabla Teléfonos con datos de los .txt --
-----------------------------------------------------------
INSERT INTO Teléfonos(DNI, Teléfono)
	VALUES('12345678C','611111111');
INSERT INTO Teléfonos(DNI, Teléfono)
	VALUES('12345678C','931111111');
INSERT INTO Teléfonos(DNI, Teléfono)
	VALUES('12345678L','913333333');
-- Esta no entra porque ese DNI no existe --- 
INSERT INTO Teléfonos(DNI, Teléfono)
	VALUES('12345789P','913333333');
---------------------------------------------
-- Esta sería la versión con DNI 12345678P --
INSERT INTO Teléfonos(DNI, Teléfono)
	VALUES('12345678P','913333333');
---------------------------------------------
INSERT INTO Teléfonos(DNI, Teléfono)
	VALUES('12345678P','644444444');
SELECT * FROM Teléfonos;

------------------------------------------------
-- 1. Fila con clave primaria duplicada (DNI) --
------------------------------------------------
INSERT INTO Empleados(Nombre, DNI, Sueldo)
	VALUES ('Iván Campo','12345678A',4500);
-- Respuesta:
-- Informe de error -
-- Error SQL: ORA-00001: unique constraint (NUEVOUSUARIO.SYS_C007041) violated
-- 00001. 00000 -  "unique constraint (%s.%s) violated"
-- *Cause:    An UPDATE or INSERT statement attempted to insert a duplicate key.
--            For Trusted Oracle configured in DBMS MAC mode, you may see
--            this message if a duplicate entry exists at a different level.
-- *Action:   Either remove the unique restriction or do not insert the key.

-------------------------------------------------------------------
-- 2. Fila que no incluya todas las columnas que requieren valor --
-------------------------------------------------------------------
INSERT INTO Empleados(Nombre, DNI, Sueldo)
	VALUES ('','12345678Z',4700);
-- Respuesta:
-- Informe de error -
-- Error SQL: ORA-01400: cannot insert NULL into ("NUEVOUSUARIO"."EMPLEADOS"."NOMBRE")
-- 01400. 00000 -  "cannot insert NULL into (%s)"
-- *Cause:    An attempt was made to insert NULL into previously listed objects.
-- *Action:   These objects cannot accept NULL values.

---------------------------------------------------------
-- 3. Fila que no verifica las restricciones del CHECK --
---------------------------------------------------------
INSERT INTO Empleados(Nombre, DNI, Sueldo)
	VALUES ('Borja Galán','12345678L',14700);
-- Respuesta:
-- Informe de error -
-- Error SQL: ORA-01438: value larger than specified precision allowed for this column
-- 01438. 00000 -  "value larger than specified precision allowed for this column"
-- *Cause:    When inserting or updating records, a numeric value was entered
--            that exceeded the precision defined for the column.
-- *Action:   Enter a value that complies with the numeric column's precision,
--            or use the MODIFY option with the ALTER TABLE command to expand
--            the precision.

------------------------------------------------------------
-- 4. Fila que no respeta regla de integridad referencial --
------------------------------------------------------------
INSERT INTO Teléfonos(DNI, Teléfono)
	VALUES('12345678O','644444444');
-- Respuesta:
-- Informe de error -
-- Error SQL: ORA-02291: integrity constraint (NUEVOUSUARIO.SYS_C007049) violated - parent key not found
-- 02291. 00000 - "integrity constraint (%s.%s) violated - parent key not found"
-- *Cause:    A foreign key value has no matching primary key value.
-- *Action:   Delete the foreign key or add a matching primary key

----------------------------------------------------------------------------------
-- 5. Borrado en tabla padre con filas dependientes donde FK no tiene ON DELETE --
----------------------------------------------------------------------------------
DELETE FROM "Códigos postales" WHERE Provincia='Madrid';
-- Respuesta:
-- Informe de error -
-- Error SQL: ORA-02292: integrity constraint (NUEVOUSUARIO.SYS_C007130) violated - child record found
-- 02292. 00000 - "integrity constraint (%s.%s) violated - child record found"
-- *Cause:    attempted to delete a parent key value that had a foreign
--            dependency.
-- *Action:   delete dependencies first then parent or disable constraint.

------------------------------------------------------------------------------------
-- 6. Borrado en tabla padre con filas dependientes donde FK ON DELETE es CASCADE --
------------------------------------------------------------------------------------
DELETE FROM Empleados WHERE SUELDO='5000'; -- Se borran las referencias al empleado borrado
-- Respuesta:
-- 1 fila eliminado
SELECT * FROM Domicilios;
-- Respuesta:
-- DNI       CALLE                                              Códig
-- --------- -------------------------------------------------- -----
-- 12345678P Diamante                                           14200
-- 12345678P Carbón                                             14900
-- 12345678L Diamante                                           14200

-------------------------------------------------------------------------------------
-- 7. Borrado en tabla padre con filas dependientes donde FK ON DELETE es SET NULL --
-------------------------------------------------------------------------------------
-- Antes de hacer esto hay que borrar las tablas y volver a crearlas con ON DELETE 
-- SET NULL para el DNI en Teléfonos e insertar los datos de nuevo. 
DELETE FROM Empleados WHERE DNI='12345678C'; -- Se ponen a null las referencias al empleado borrado
-- Respuesta:
-- 1 fila eliminado
SELECT * FROM Teléfonos;
-- Respuesta:
-- DNI       TELÉFONO
-- --------- ---------
--           611111111
--           931111111
-- 12345678L 913333333
-- 12345678P 913333333
-- 12345678P 644444444