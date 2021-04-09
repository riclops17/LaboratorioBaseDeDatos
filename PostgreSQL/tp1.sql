-- TP1
-- Ejercicio 4

/*
Crear dos esquemas en PostgreSQL con dos nombres diferentes para la misma BD.
¿Se pueden crear esquemas en MySQL?

- En MySQL no es posible crear esquemas.
*/

CREATE SCHEMA esquema_1;
CREATE SCHEMA esquema_2;

-- TP1
-- Ejercicio 5

/*
En PostgreSQL, crear dentro de cada esquema los siguientes dominios:

a. CUIT
b. Códigos Postales CP4
c. Fecha de inicio de alquiler, que no permita que sea menor a la fecha de hoy.
*/

CREATE DOMAIN CUIT as VARCHAR(30) CHECK (VALUE ~ '^(20|23|27|30|33)([0-9]{9}|-[0-9]{8}-[0-9]{1})$');

CREATE DOMAIN CP4 as VARCHAR(4) CHECK (VALUE ~ '^\d{4}$');

CREATE DOMAIN fecha_inicio_alquiler as DATE NOT NULL CHECK (VALUE > current_date);
