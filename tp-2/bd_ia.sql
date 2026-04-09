/* Este trabajo es la version hecha con ayuda de la inteligencia artificial,
 y entendemos la lógica del mismo, en la mayoria del código, no lo usamos porque si, sino como
 una herramienta */
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
//Datos para cada tabla 
 --Categorías 
 INSERT INTO categorias (nombre) VALUES 
('Alimentos'),
('Materiales de construcción'),
('Herramientas'),
('Medicamentos'),
('Equipamiento');

-- Recursos
INSERT INTO recursos (nombre, stock, id_categoria) VALUES
('Harina de trigo', 500, 1),
('Arroz', 300, 1),
('Ladrillos', 2000, 2),
('Cemento', 1500, 2),
('Martillos', 50, 3),
('Destornilladores', 70, 3),
('Analgésicos', 200, 4),
('Antibióticos', 150, 4),
('Generadores eléctricos', 10, 5),
('Tiendas de campaña', 30, 5);

--Puestoa de avanzada
INSERT INTO puestos (nombre, latitud, longitud, poblacion) VALUES
('Puesto Norte', -12.345678, -76.543210, 120),
('Puesto Sur', -13.456789, -77.654321, 90),
('Puesto Este', -11.234567, -75.432109, 150),
('Puesto Oeste', -12.567890, -78.765432, 80),
('Puesto Central', -12.123456, -76.987654, 200);

--Envíos
INSERT INTO envios (estado, fecha, id_puesto) VALUES
('En camino', '2023-05-10 08:30:00', 1),
('Entregado', '2023-05-08 14:15:00', 2),
('Pendiente', '2023-05-12 10:00:00', 3),
('En camino', '2023-05-11 09:45:00', 4),
('Entregado', '2023-05-09 16:20:00', 5);

--Detalles de envío
INSERT INTO detalle_envio (id_envio, id_recurso, cantidad, peso_unitario) VALUES
(1, 1, 50, 1.5),
(1, 3, 100, 2.3),
(2, 5, 10, 0.8),
(2, 7, 30, 0.1),
(3, 2, 40, 1.0),
(3, 4, 80, 25.0),
(4, 6, 15, 0.3),
(4, 9, 2, 50.0),
(5, 8, 25, 0.2),
(5, 10, 5, 15.0);

--Intercambio entre puestos
INSERT INTO intercambios (fecha, id_recurso, cantidad, id_puesto_origen, id_puesto_destino) VALUES
('2023-05-07 11:30:00', 1, 20, 1, 2),
('2023-05-08 15:45:00', 3, 50, 5, 3),
('2023-05-09 09:20:00', 5, 5, 2, 4),
('2023-05-10 14:10:00', 7, 15, 3, 1),
('2023-05-11 10:30:00', 9, 1, 4, 5);

//consultas
-- Medicamentos con bajo stock
SELECT r.nombre, r.stock
FROM recursos r
JOIN categorias c ON r.id_categoria = c.id_categoria
WHERE c.nombre = 'Medicamentos'
AND r.stock < 100;

-- Envíos pendientes con peso total
SELECT e.id_envio, 
       e.estado,
       SUM(d.cantidad * d.peso_unitario) AS peso_total,
       p.latitud,
       p.longitud
FROM envios e
JOIN detalle_envio d ON e.id_envio = d.id_envio
JOIN puestos p ON e.id_puesto = p.id_puesto
WHERE e.estado = 'Pendiente'
GROUP BY e.id_envio, e.estado, p.latitud, p.longitud;

-- Intercambios entre puestos
SELECT i.fecha,
       i.cantidad,
       r.nombre AS recurso,
       p1.nombre AS puesto_origen,
       p2.nombre AS puesto_destino
FROM intercambios i
JOIN recursos r ON i.id_recurso = r.id_recurso
JOIN puestos p1 ON i.id_puesto_origen = p1.id_puesto
JOIN puestos p2 ON i.id_puesto_destino = p2.id_puesto;

-- Puestos que acaparan recursos
SELECT p.nombre
FROM puestos p
JOIN envios e ON p.id_puesto = e.id_puesto
JOIN detalle_envio d ON e.id_envio = d.id_envio
GROUP BY p.id_puesto, p.nombre
HAVING SUM(d.cantidad) > (
    SELECT AVG(total)
    FROM (
        SELECT SUM(d2.cantidad) AS total
        FROM envios e2
        JOIN detalle_envio d2 ON e2.id_envio = d2.id_envio
        GROUP BY e2.id_puesto
    ) AS subconsulta
);

-- Puestos olvidados (sin envíos en 7 días)
SELECT p.nombre, p.latitud, p.longitud
FROM puestos p
WHERE NOT EXISTS (
    SELECT 1
    FROM envios e
    JOIN detalle_envio d ON e.id_envio = d.id_envio
    JOIN recursos r ON d.id_recurso = r.id_recurso
    JOIN categorias c ON r.id_categoria = c.id_categoria
    WHERE e.id_puesto = p.id_puesto
    AND c.nombre IN ('Medicamentos', 'Alimentos')
    AND e.estado = 'Entregado'
    AND e.id_envio IN (
        SELECT id_envio
        FROM envios
        WHERE NOW() - INTERVAL 7 DAY <= NOW()
    )
)
ORDER BY p.poblacion DESC;
