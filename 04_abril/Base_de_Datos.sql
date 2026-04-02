/*Este trabajo fue hecho en clase y 100% pensado a nuestra logica natural,sabemos que hay errores
*/
create database fabrica;
use fabrica;

create table recurso(
    id_nom VARCHAR(100),
    peso int,
    stock int,
    categoria int
    cantidad int FOREIGN KEY,
    );

create table puestoAvanzada(
    nombre varchar(100) primary key,
    especialidades varchar(100) FOREIGN KEY,
    coordenadas varchar(100),
    poblacion int;

    FOREIGN KEY (neoEnvio) REFERENCES envio(nroEnvio),
);

create table envio(
    fecha data time,
    nroEnvio int primary key FOREIGN KEY,
    fecha data time,
    estado varchar(100),
    peso 

    FOREIGN KEY (cantidad) REFERENCES recurso(cantidad)
);

create table etiquetasDeSeguridad(
    nroEnvio  
);

CREATE TABLE intercambio(
    id int,
    fechaHora data time,

    FOREIGN KEY (cantidad) REFERENCES recurso(cantidad)
);
