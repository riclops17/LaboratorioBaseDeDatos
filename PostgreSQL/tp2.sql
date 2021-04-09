-- TP2
-- Ejercicio 1

/*
a. Cree una vista llamada AlquilerLocal con el comando CREATE VIEW
y la opcion WITH LOCAL CHECK OPTION con datos de las solicitudes de
Alquileres realizados hasta el mes pasado (hasta 31/08/2020).
*/

CREATE VIEW alquilerLocal(id_alquiler,legajo,cuit,fecha_inicio,fecha_fin)
as
SELECT a.id_alquiler,a.legajo,a.cuit,a.fecha_inicio,a.fecha_fin
FROM alquiler a
WHERE fecha_inicio <'08/31/2020' WITH LOCAL CHECK OPTION;

/*
b. Cree una vista llamada AlquilerCASCADE con el comando CREATE VIEW
y la opcion WITH LOCAL CHECK OPTION y la misma informacion del inciso anterior.
*/

CREATE VIEW alquilerCascade(id_alquiler,legajo,cuit,fecha_inicio,fecha_fin)
as
SELECT a.id_alquiler,a.legajo,a.cuit,a.fecha_inicio,a.fecha_fin
FROM alquiler a
WHERE fecha_inicio <'08/31/2020' WITH CASCADED CHECK OPTION;

/*
c. Inserte dos tuplas a la vista AlquilerLocal,
una con fecha 01/01/2018 y la otra con fecha 04/09/2020.
¿Qué devuelve una consulta a la relación Alquiler y la vista AlquilerLocal
luego de realizar estas inserciones?
¿Cómo se comporta el comando "WITH LOCAL CHECK OPTION"?
*/
insert into alquilerLocal values('101','51','34176149118','09/04/2020','10/11/2020');
/*
la primera opcion me dio un error ya que se pasa del rango de fechas
ERROR:  new row violates check option for view "alquilerlocal"
DETAIL:  Failing row contains (900, 2020-09-04, 2020-10-11, 51, 34176149118).
SQL state: 44000
*/
insert into alquilerLocal values('101','51','34176149118','01/01/2018','10/11/2020');
      
/*
la segunda opcion me permitio insertar correctamente sobre la vista

La consulta en alquiler y en alquiler local nos devuelve exactamente lo mismo
*/

/*
d. Inserte otras dos tuplas (con los mismos requisitos que en c) a la vista AlquilerCascade.
¿Qué devuelve una consulta a la relación Alquiler y la vista AlquilerCascade
luego de realizar estas inserciones?
¿Cómo se comporta el comando "WITH CASCADED CHECK OPTION"?
*/
insert into alquilerCascade values('101','51','34176149118','09/04/2020','10/11/2020');
insert into alquilerCascade values('101','51','34176149118','01/01/2018','10/11/2020');

/*

lo mismo para el punto c se me permitio insertar siempre y cuando no se vaya de rango
en comparacion con local y cascade en este caso no hubo cambio alguno a la hora de consultar sobre los alquileres 
*/

/*
e. Cree una nueva vista llamada AlquilerLocal2 (WITH LOCAL CHECK OPTION) sobre la vista AlquilerLocal,
para aquellas solicitudes realizadas durante el 2020 previos al 31/08.
*/

CREATE VIEW alquilerLocal2(id_alquiler,legajo,cuit,fecha_inicio,fecha_fin)
as
SELECT a.id_alquiler,a.legajo,a.cuit,a.fecha_inicio,a.fecha_fin
FROM alquilerLocal a
WHERE fecha_inicio <'08/31/2020' WITH LOCAL CHECK OPTION;

/*
f. Cree una nueva vista AlquilerCascade2 (WITH CASCADED CHECK OPTION)
sobre la vista AlquilerCascade,
para aquellas solicitudes realizadas durante el 2020 previos al 31/08.
*/

CREATE VIEW alquilerCascade2(id_alquiler,legajo,cuit,fecha_inicio,fecha_fin)
as
SELECT a.id_alquiler,a.legajo,a.cuit,a.fecha_inicio,a.fecha_fin
FROM alquilerCascade a
WHERE fecha_inicio <'08/31/2020' WITH CASCADED CHECK OPTION;

/*
g. Actualice dos tuplas a la vista AlquilerLocal2,
una realizada con fecha previa al 31/08  y la otra posterior al 31/08. 
¿Qué devuelve una consulta a la relación Alquiler, a la vista AlquilerLocal y  AlquilerLocal2?
si es posterior 
devuelve error
ERROR:  new row violates check option for view "alquilerlocal"
DETAIL:  Failing row contains (900, 2022-02-02, 2020-10-11, 51, 34176149118).
SQL state: 44000

¿Cómo se comporta el comando "WITH LOCAL CHECK OPTION" con vistas generadas desde otras vistas?
update alquilerLocal2 set fecha_inicio = '02/02/2018' where id_alquiler = '101';

*/

/*
h. Actualice otras dos tuplas (con los mismos requisitos que en g) a la vista  AlquilerCascade2.
¿Qué devuelve una consulta a la relación Alquiler y la vista  AlquilerCascade2 y AlquilerCascade?
¿Cómo se comporta el comando "WITH CASCADED CHECK OPTION" con vistas generadas desde otras vistas?
*/
/*
CONCLUSIONES:
WITH CASCADE CHECK OPTION se crea una relación de herencia
con todas las vistas que tengan por debajo, tomando de ellas todos sus datos y reglas.
Las modificaciones afectan a la vista superior
con LOCAL CHECK OPTION los cambios se hacen a nivel local y no en cascada 
*/
-- Ejercicio 2

CREATE VIEW punto3concheck(legajo, id_alquiler, fecha_inicio, fecha_fin, cuit) as 
SELECT * FROM alquiler a NATURAL JOIN administrador ad WITH CHECK OPTION;

-- Ejercicio 3
CREATE VIEW punto3sincheck(legajo, id_alquiler, fecha_inicio, fecha_fin, cuit) as 
SELECT * FROM alquiler a NATURAL JOIN administrador ad;
Posgree
ERROR:  WITH CHECK OPTION is supported only on automatically updatable views
HINT:  Views that do not select from a single table or view are not automatically updatable.
SQL state: 0A000

-- Ejercicio 4
Como la vista no fue creada entonces no se puede realizar este insert.


-- Ejercicio 5



-- TP2
-- Ejercicio 7

/*
Defina una AFIRMACION para garantizar que no pueda existir un contrato con
fecha de fin menor a la fecha de inicio.
*/

CREATE ASSERTION fechasValidas
CHECK (
	NOT EXISTS (
		SELECT fecha_inicio, fecha_fin FROM contrato WHERE fecha_fin < fecha_inicio
	)
);

-- TP2
-- Ejercicio 8

/*
Defina una AFIRMACION para garantizar que
no pueda existir una factura sin monto o con monto igual o menor a 0.
*/

CREATE ASSERTION montoValido
CHECK (
    NOT EXISTS (
        SELECT monto FROM factura WHERE monto is null OR monto <= 0 
    )
);

-- TP2
-- Ejercicios de TRIGGERS

/*
a. Alterar la tabla PLANTA para agregar un atributo cantidadDeAlquileres
de tipo entero con un valor por defecto de 0. 
*/

ALTER TABLE planta ADD COLUMN cantidadDeAlquileres INTEGER DEFAULT 0;

/* En la captura 'fig.(a)' correspondiente a este ejercicio se puede ver como a todas
las plantas que ya teníamos insertadas en  la base de datos, adoptan este nuevo atributo
con el valor '0' que le dimos por defecto y representa que hasta ahora las 
plantas no habrían estado alquiladas nunca
---------------------------------------------------------------------------------------
*/


/*
b. Crear un trigger que luego de agregar un registro en ALQUILER para una planta 
sume uno a la cantidadDeAlquileres.
*/

CREATE FUNCTION paratrigger1() RETURNS TRIGGER AS $$
BEGIN
        UPDATE planta SET cantidadDeAlquileres = cantidadDeAlquileres + 1
        WHERE ( new.id_planta = planta.id_planta );

        RETURN NULL;
END;$$
LANGUAGE 'plpgsql';

CREATE TRIGGER agregarRegistro AFTER INSERT ON tiene
FOR EACH ROW EXECUTE PROCEDURE paratrigger1();

INSERT INTO tiene values ('01/01/2020','51','100');
 
SELECT id_planta, cantidadDeAlquileres FROM planta WHERE id_planta = 51;

/*
La función paratrigger1() va a actualizar la cantidad de alquileres que tuvo una planta
y los va a aumentar en 1 una unidad, esto va a pasar cada vez que se lance el trigger
agregarRegistro cuando se inserta una tupla a la relación 'tiene'.
para las pruebas insertamos una nueva tupla en 'tiene' que referencien a una planta y
alquiler ya existentes y luego corroboramos de que efectivamente después de agregar la
tupla en tiene, se haya sumado 1 alquiler al contador que tiene esa planta. 
---------------------------------------------------------------------------------------
*/

/*
c. Crear un trigger que permita eliminar una EMPRESA DE TRANSPORTE,
violando la restricción de integridad referencial definida.
Es decir, deben eliminar primero los datos en otras tablas para luego poder eliminar EMPRESA TRANSPORTE.
*/

CREATE FUNCTION eliminarEmpTransp() RETURNS TRIGGER AS $$
BEGIN
        DELETE FROM traslada WHERE traslada.cuit = old.cuit;
        DELETE FROM contrato WHERE contrato.cuit = old.cuit;
        
        RETURN NULL;
END;$$ LANGUAGE 'plpgsql';


CREATE TRIGGER triggerEliminarEmpTransp BEFORE DELETE ON empresa_transporte 
FOR EACH ROW EXECUTE PROCEDURE eliminarEmpTransp();


DELETE FROM planta WHERE id_planta = '51';

/*
la funcion eliminarEmpTransp() se encarga de eliminar las tuplas de las tablas traslada 
y contrato que contienen como foráneas empresas de transporte que podrían haberse eliminado,
entonces cada vez que se quiere eliminar una empresa de transporte antes con un trigger que llame 
a la función eliminamos a los contratos y traslados que realizo dicha empresa para poder violar la 
restricción de integridad referencial.
-------------------------------------------------------------------------------------------
*/

/*
d. Crear una nueva tabla llamada LOG_FACTURA que contenga como atributos,
número de comando (de autoincremento) y comando (como un varchar(10)), 
*/

CREATE TABLE LOG_FACTURA (
    numero_comando SERIAL,
    comando varchar(10),
    PRIMARY KEY (numero_comando)
);


/*
e. Crear un trigger para que cada vez que se inserte, elimine o actualice una FACTURA,
inserte una tupla en el log con el número y el comando ejecutado.
Por ejemplo, (1,’UPDATE’) si se actualiza una factura.
Esta inserción debe hacerla una sola vez
por más que se efectúen muchas operaciones al mismo tiempo.
*/

CREATE FUNCTION LogsFactura() RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$ BEGIN
INSERT INTO LOG_FACTURA (comando) VALUES (TG_OP);
RETURN NEW;
END; 
$$
/*-----------------------------------------------------------------------------*/
CREATE TRIGGER OperacionesEnFactura AFTER DELETE OR UPDATE OR INSERT ON factura
FOR EACH STATEMENT EXECUTE PROCEDURE LogsFactura;

INSERT into factura (id_factura, fecha, monto, cuit, id_alquiler)
VALUES (150, '2020-01-10', 30469.21, '34871965724', 100);

UPDATE factura SET fecha = '2020-09-11' WHERE id_factura = 150 ;

DELETE FROM factura where id_factura = 150;

SELECT * FROM log_factura;

/*
La Funcion LogsFactura() va a ser la encargada de insertar una nueva tupla en la entidad
'LOG_FACTURA' que tendrá un identificador auto-incremental y se le agregara el tipo 
de operación que haya ocurrido antes de que llamen a la función con el trigger.
El trigger llamara a la función descripta anteriormente cuando se borre, actualice
inserte sobre una factura o varias a la vez
Para corroborar su funcionamiento insertamos, actualizamos y eliminamos una nueva
factura, luego visualizamos todas las tuplas de la entidad 'LOG_FACTURA' y nos fijamos
que se hayan insertado 3 nuevas que contengan las operaciones que acabábamos de realizar
---------------------------------------------------------------------------------------
*/

/*
f. Crear los triggers necesarios para simular la generalización/especialización
total y disjunta definida en PERSONA.

*/

CREATE FUNCTION funCrearPersona() RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
insert into persona (legajo, nombre, apellido, email, direccion) 
    values (new.legajo, new.nombre,new.apellido,new.email, new.direccion);
RETURN NEW;
END; 
$$

CREATE FUNCTION funEliminarPersona() RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
DELETE FROM telefono where old.legajo = telefono.legajo;
DELETE FROM persona where old.legajo = persona.legajo;
RETURN NEW;
END; 
$$


/*----------------------------------------------------------------------------*/

CREATE TRIGGER crearPersona BEFORE INSERT ON administrador
FOR EACH ROW
EXECUTE PROCEDURE funCrearPersona();

CREATE TRIGGER crearPersona2 BEFORE INSERT ON operario
FOR EACH ROW
EXECUTE PROCEDURE funCrearPersona();

CREATE TRIGGER eliminarPersona AFTER DELETE ON administrador
FOR EACH ROW
EXECUTE PROCEDURE funEliminarPersona();

CREATE TRIGGER eliminarPersona2 AFTER DELETE ON operario
FOR EACH ROW
EXECUTE PROCEDURE funEliminarPersona();

insert into operario (legajo, nombre, apellido, email, direccion, actividad )
values (111, 'Hardy', 'Struttman', 'hstruttman1d@google.es', '128 Lakeland Road', 'Teacher');
insert into administrador (legajo, nombre, apellido, email, direccion)
values (110, 'Edan', 'Greathead', 'egreathead1e@weibo.com', '804 Utah Circle');

select * from persona p where p.legajo like '111' or p.legajo like '110'; 

delete from administrador a where a.legajo like '110'

/*
Acá lo que buscamos con la creación de varios triggers es respetar la generalización
es decir que cada vez que insertamos un operario y un administrador, se inserte la 
persona correspondiente, y de manera inversa si se borra uno de estos.
esto puede ser muy útil ya que nos permite no estar insertando otra vez a una persona
correr el riesgo de cargar algún dato mal haciendo que no se cumpla la generalización.
Para probarlo insertamos un operario y administrador, luego nos fijamos que existan
personas con ese mismo dni y sean efectivamente las mismas pero sin los atributos 
característicos de administrador u operario. luego las borramos y nos fijamos que esto 
también ocurra en la persona.
--------------------------------------------------------------------------------------
*/

/*
g. Crear un trigger para que no se permita eliminar en la tabla CONTRATO. 
*/

CREATE FUNCTION protege() RETURNS trigger AS $ptg$
    BEGIN            
            RAISE EXCEPTION 'NO ES POSIBLE ELIMINAR CONTRATOS, SON MUY IMPORTANTES';
    END;
$ptg$ LANGUAGE plpgsql;


CREATE TRIGGER protegerContrato BEFORE DELETE ON contrato
FOR EACH ROW
EXECUTE PROCEDURE protege();

/*
Aca la función protege() se va a encargar de tirar una excepción cuando 
se la llame diciendo que no se puede eliminar contratos porque son muy 
importantes.
A esta función la llama el trigger antes de intentar eliminar un contrato 
ya que esto no lo tenemos que permitir.
en la 'fig (6)' vemos que probamos eliminar un contrato y al hacerlo nos
responde  con una excepción y el mensaje predeterminado por nosotros.
*/


/*
h. Eliminar con el comando específico, el trigger definido en el inciso b
*/

DROP TRIGGER eliminarPlanta ON planta;
