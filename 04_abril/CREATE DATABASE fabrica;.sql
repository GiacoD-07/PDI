CREATE DATABASE fabrica;
USE fabrica;

-- Categorías
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- Recursos
CREATE TABLE recursos (
    id_recurso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    stock INT,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Puestos de avanzada
CREATE TABLE puestos (
    id_puesto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    latitud DECIMAL(10,6),
    longitud DECIMAL(10,6),
    poblacion INT
);

-- Envíos
CREATE TABLE envios (
    id_envio INT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50),
    fecha DATETIME,
    id_puesto INT,
    FOREIGN KEY (id_puesto) REFERENCES puestos(id_puesto)
);

-- Detalle de envío
CREATE TABLE detalle_envio (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_envio INT,
    id_recurso INT,
    cantidad INT,
    peso_unitario DECIMAL(10,2),
    FOREIGN KEY (id_envio) REFERENCES envios(id_envio),
    FOREIGN KEY (id_recurso) REFERENCES recursos(id_recurso)
);

-- Intercambios entre puestos
CREATE TABLE intercambios (
    id_intercambio INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME,
    id_recurso INT,
    cantidad INT,
    id_puesto_origen INT,
    id_puesto_destino INT,
    FOREIGN KEY (id_recurso) REFERENCES recursos(id_recurso),
    FOREIGN KEY (id_puesto_origen) REFERENCES puestos(id_puesto),
    FOREIGN KEY (id_puesto_destino) REFERENCES puestos(id_puesto)
);