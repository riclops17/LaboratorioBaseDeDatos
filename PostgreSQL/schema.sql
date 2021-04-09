  PRIMARY KEY (id_factura),
    FOREIGN KEY (cuit)
        REFERENCES empresa (cuit)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_alquiler)
        REFERENCES alquiler (id_alquiler)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ciudad (
    codigo_postal VARCHAR(10),
    nombre VARCHAR(255) NOT NULL,
    PRIMARY KEY (codigo_postal)
);

CREATE TABLE yacimiento (
    id_yacimiento SERIAL,
    descripcion VARCHAR(255),
    superficie REAL,
    codigo_postal VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_yacimiento),
    FOREIGN KEY (codigo_postal)
        REFERENCES ciudad (codigo_postal)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE campamento (
    id_campamento SERIAL,
    cant_banos INTEGER NOT NULL,
    nombre_responsable VARCHAR(255) NOT NULL,
    tel_responsable VARCHAR(20) NOT NULL,
    id_yacimiento INTEGER  NOT NULL,
    cuit VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_campamento),
    FOREIGN KEY (id_yacimiento)
        REFERENCES yacimiento (id_yacimiento)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (cuit)
        REFERENCES empresa (cuit)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE empresa_transporte (
    cuit VARCHAR(30),
    razon_social VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    PRIMARY KEY (cuit)
);

CREATE TABLE traslada (
    cuit VARCHAR(30),
    fecha DATE,
    id_planta INTEGER NOT NULL,
    PRIMARY KEY (fecha, id_planta),
    FOREIGN KEY (id_planta)
        REFERENCES planta (id_planta)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (cuit)
        REFERENCES empresa (cuit)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE contrato (
    id_contrato SERIAL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion VARCHAR(255),
    monto REAL NOT NULL,
    cuit VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_contrato),
    FOREIGN KEY (cuit)
        REFERENCES empresa_transporte (cuit)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE mantenimiento (
    id_mantenimiento SERIAL,
    fecha DATE NOT NULL,
    hora TIME,
    detalle VARCHAR(255),
    id_planta INTEGER NOT NULL,
    PRIMARY KEY (id_mantenimiento),
    FOREIGN KEY (id_planta)
        REFERENCES planta (id_planta)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE realiza (
    legajo_operador VARCHAR(10) NOT NULL,
    id_mantenimiento INTEGER NOT NULL,
    PRIMARY KEY (legajo_operador , id_mantenimiento),
    FOREIGN KEY (legajo_operador)
        REFERENCES operario (legajo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_mantenimiento)
        REFERENCES mantenimiento (id_mantenimiento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE tratamiento (
    id_tratamiento SERIAL,
    descripcion VARCHAR(255) ,
    duracion TIME,
    id_planta INTEGER NOT NULL,
    PRIMARY KEY (id_tratamiento),
    FOREIGN KEY (id_planta)
        REFERENCES planta (id_planta)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
CREATE TABLE analisis_bacteriologico (
    id_planta INTEGER,
    id_tratamiento INTEGER,
    numero INTEGER NOT NULL,
    fecha DATE NOT NULL,
    descripcion VARCHAR(255),
    PRIMARY KEY (id_planta , numero),
    FOREIGN KEY (id_planta)
        REFERENCES planta (id_planta)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_tratamiento)
        REFERENCES tratamiento (id_tratamiento)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
CREATE TABLE concreta (
    fecha DATE NOT NULL,
    id_planta INTEGER NOT NULL,
    id_tratamiento INTEGER NOT NULL,
    PRIMARY KEY (fecha , id_planta , id_tratamiento),
    FOREIGN KEY (id_planta)
        REFERENCES planta (id_planta)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_tratamiento)
        REFERENCES tratamiento (id_tratamiento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
CREATE TABLE quimico (
    tipo_quimico VARCHAR(255),
    id_tratamiento INTEGER,
    PRIMARY KEY (tipo_quimico , id_tratamiento),
    FOREIGN KEY (id_tratamiento)
        REFERENCES tratamiento (id_tratamiento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
CREATE TABLE aplica (
    fecha DATE NOT NULL,
    id_tratamiento INTEGER NOT NULL,
    legajo_operador VARCHAR(10) NOT NULL,
    PRIMARY KEY (fecha , id_tratamiento , legajo_operador),
    FOREIGN KEY (legajo_operador)
        REFERENCES operario (legajo)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_tratamiento)
        REFERENCES tratamiento (id_tratamiento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
CREATE TABLE se_ubica (
    fecha DATE,
    id_planta INTEGER NOT NULL,
    id_campamento INTEGER NOT NULL,
    PRIMARY KEY (fecha , id_planta),
    FOREIGN KEY (id_planta)
        REFERENCES planta (id_planta)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_campamento)
        REFERENCES campamento (id_campamento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
