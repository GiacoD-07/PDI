/* Este trabajo es la version hecha con ayuda de la inteligencia artificial,
 y entendemos la logica del mismo, en la mayoria del codigo, no lo usamos porque si, sino como
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