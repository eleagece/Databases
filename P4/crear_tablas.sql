---------------------------
-- Crear tabla Empleados --
---------------------------
create table Empleados
	(
	Nombre CHAR(50) NOT NULL, 
	DNI CHAR(9) PRIMARY KEY, 
	Sueldo Number(6,2), 
	CHECK (Sueldo BETWEEN 645.30 AND 5000)
	);
-- Respuesta:
-- Table EMPLEADOS creado.

------------------------------------
-- Crear tabla "Códigos postales" --
------------------------------------
create table "Códigos postales"
	(
	"Código postal" Char(5) PRIMARY KEY, 
	Población Char(50) NOT NULL,
	Provincia Char(50) NOT NULL
	);
-- Respuesta:
-- Table "Códigos postales" creado.

----------------------------
-- Crear tabla Domicilios --
----------------------------
create table Domicilios
	(
	DNI Char(9), 
	Calle Char(50), 
	"Código postal" Char(5),
	FOREIGN KEY (DNI) 
		REFERENCES Empleados(DNI) 
		ON DELETE CASCADE, -- Elimina las entradas de Domicilio correspondientes al Empleado eliminado 
	FOREIGN KEY ("Código postal") 
		REFERENCES "Códigos postales"("Código postal")  -- No permite borrar el CP si sigue existiendo
	);
-- Respuesta:
-- Table DOMICILIOS creado.

---------------------------
-- Crear tabla Teléfonos --
---------------------------
create table Teléfonos
	(
	DNI Char(9), 
	Teléfono Char(9), 
	FOREIGN KEY (DNI) 
		REFERENCES Empleados(DNI) 
		ON DELETE CASCADE -- Elimina las entradas de Teléfono correspondientes al Empleado eliminado 
		-- ON DELETE SET NULL -- Pone a "null" las entradas de Teléfono correspondientes al Empleado eliminado
	);
-- Respuesta:
-- Table TELÉFONOS creado.