----------------------------------
-- 3. Crear espacio para tablas --
----------------------------------
CREATE TABLESPACE GII_EMPRESA_DIAZGONZALEZ DATAFILE
'D:\oracle\GII_EMPRESA_DIAZGONZALEZ' SIZE 5M AUTOEXTEND OFF;
-- Respuesta:
-- tablespace GII_EMPRESA_DIAZGONZALEZ creado.

----------------------
-- 4. Crear usuario --
----------------------
CREATE USER USU_GII_DIAZGONZALEZ IDENTIFIED BY USU_GII_DIAZGONZALEZ DEFAULT
TABLESPACE GII_EMPRESA_DIAZGONZALEZ TEMPORARY TABLESPACE TEMP QUOTA
UNLIMITED ON GII_EMPRESA_DIAZGONZALEZ;
-- Respuesta:
-- user USU_GII_DIAZGONZALEZ creado.

------------------------------------
-- 5. Asignar permisos al usuario --
------------------------------------
GRANT CREATE SESSION, CREATE TABLE, DELETE ANY TABLE, SELECT ANY 
DICTIONARY, CREATE ANY SEQUENCE TO USU_GII_DIAZGONZALEZ;
-- Respuesta:
-- GRANT correcto.

------------------------------------------------------------
-- 6. Cambiar la contraseña al usuario. Usamos 'BBDD1516' --
------------------------------------------------------------
-- Respuesta:
-- user "USU_GII_DIAZGONZALEZ" alterado.
-- user "USU_GII_DIAZGONZALEZ" alterado.