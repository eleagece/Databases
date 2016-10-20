LOAD DATA
INFILE 'Domicilios.txt'
APPEND
INTO TABLE Domicilios
FIELDS TERMINATED BY ';'
(DNI,Calle,"Código postal")