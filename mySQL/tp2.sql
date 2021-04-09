-- TP2
-- Ejercicio 2
El funcionamiento en MySql y Postgres es el mismo con respecto a la implementación de las vistas del punto anterior.

-- Ejercicio 3
CREATE VIEW punto3concheck(legajo, id_alquiler, fecha_inicio, fecha_fin, cuit) as 
SELECT * FROM alquiler a NATURAL JOIN administrador ad WITH CHECK OPTION;

-- Ejercicio 4
CREATE VIEW punto3sincheck(legajo, id_alquiler, fecha_inicio, fecha_fin, cuit) as 
SELECT * FROM alquiler a NATURAL JOIN administrador ad;

-- Ejercicio 5 
-- En MySql esta inserción siempre falla
INSERT INTO punto3concheck (legajo, id_alquiler, fecha_inicio, fecha_fin, cuit) VALUES (100, 1, "2016-03-21", "2020-08-04", "30-80160237-5");


-- En MySql esta inserción es válida.
INSERT INTO punto3sincheck (legajo, id_alquiler, fecha_inicio, fecha_fin, cuit) VALUES (91, 151112, "2020-08-04", "2020-09-02", "30-80160237-5");

-- TP2
-- Ejercicios de TRIGGERS

/*
A)
*/
ALTER TABLE planta ADD COLUMN cantidadDeAlquileres INTEGER DEFAULT 0;
/*
--------------------------------------------------------------------------------------------------

B)
*/

Create TRIGGER agregarRegistro AFTER INSERT ON tiene
FOR EACH ROW
UPDATE planta SET cantidadDeAlquileres = cantidadDeAlquileres + 1
where new.id_planta = planta.id_planta;
--------------------------------
insert into tiene values ('01/01/2020','51','100');
 
select id_planta , cantidadDeAlquileres from planta  where id_planta = 51 ;

/* La conclusión es la misma que en el punto realizado con postgres, 
solo que en mysql no necesitamos de una función aparte para definir el trigger 
--------------------------------------------------------------------------------*/

/* 
c)
NO LA PODEMOS DEFINIR SIN UN PROCEDURE YA QUE REQUIERE DE REALIZAR VARIAS 
SENTENCIAS SQL DENTRO DEL MISMO TRIGGER, AL TENER QUE ELIMINAR TODAS LAS TUPLAS 
DONDE ESTE REFERENCIADA LA EMPRESA DE TRANSPORTE*/

/*
D)
*/
    CREATE TABLE LOG_FACTURA (
    numero_comando integer AUTO_INCREMENT,
    comando varchar(10),
    PRIMARY KEY (numero_comando));

/*
--------------------------------------------------------------------------------------
*/

/*
E)
*/

CREATE TRIGGER LogFacturaInsert AFTER INSERT on factura 
FOR EACH ROW 
insert into LOG_FACTURA (comando) values("INSERT");

CREATE TRIGGER LogFacturaInsert2 AFTER UPDATE on factura 
FOR EACH ROW 
insert into LOG_FACTURA (comando) values("UPDATE");

CREATE TRIGGER LogFacturaInsert3 AFTER DELETE on factura 
FOR EACH ROW 
insert into LOG_FACTURA (comando) values("DELETE");


/*
mysql no permite anidar acciones por ejemplo en la primera linea 
'CREATE TRIGGER LogFacturaInsert AFTER INSERT AND UPDATE AND DELETE on factura '
por lo que a diferencia de postgres se tuvieron que armar 3 trigger separados.
tampoco pudimos encontrar la forma de que se inserte la ultima operación realizada asi 
que la tuvimos que insertar de forma manual.
otra nota es que no nos anduvo el 'STATEMENT' asi que tuvimos que usar ROW en este caso
aunque no es lo indicado ya que insertaría por cada accion realizada.
------------------------------------------------------------------------------------------*/

/*
F)
NO LA PODEMOS DEFINIR SIN UN PROCEDURE YA QUE REQUIERE DE REALIZAR VARIAS 
SENTENCIAS SQL DENTRO DEL MISMO TRIGGER, POR EJEMPLO AL TENER QUE BORRAR LA PERSONA
QUE REFERENCIABA A UN ADMINISTRADOR U OPERARIO TAMBIEN TENEMOS QUE BORRAR SU TELEFONO
Y SIN UN PROCEDURE NO NOS DEJA
--------------------------------------------------------------------------------------------
*/

/*
G)
UN TRIGGER EN MYSQL SIN LLAMAR A UNA FUNCION/PROCEDURE NO NOS DEJO LANZAR UNA EXCEPCIÓN PARA 
EVITAR ELIMINAR UNA TUPLA DE CONTRATO.
-----------------------------------------------------------------------------------------------
*/

/*
H)
*/
DROP TRIGGER eliminarPlanta ON planta;
