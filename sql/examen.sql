CREATE DATABASE IF NOT EXISTS TomasJK CHARACTER SET = 'utf8mb4' COLLATE = 'utf8mb4_unicode_ci';
USE TomasJK;

CREATE TABLE IF NOT EXISTS Cliente (
    id_cliente BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(255),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Producto (
    id_producto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipo_producto ENUM('PIZZA','PANZAROTTI','BEBIDA','POSTRE','OTRO') NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Ingrediente (
    id_ingrediente BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB;

CREATE TABLE ProductoIngrediente (
    id_producto BIGINT NOT NULL,
    id_ingrediente BIGINT NOT NULL,
    cantidad VARCHAR(50),
    PRIMARY KEY (id_producto, id_ingrediente),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES Ingrediente(id_ingrediente) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Adicion (
    id_adicion BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_adicion DECIMAL(10,2) NOT NULL,
    descripcion TEXT
) ENGINE=InnoDB;

CREATE TABLE ProductoAdicion (
    id_producto BIGINT NOT NULL,
    id_adicion BIGINT NOT NULL,
    PRIMARY KEY (id_producto, id_adicion),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_adicion) REFERENCES Adicion(id_adicion) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Combo (
    id_combo BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_combo DECIMAL(10,2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE ComboProducto (
    id_combo BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    cantidad SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_combo, id_producto),
    FOREIGN KEY (id_combo) REFERENCES Combo(id_combo) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Pedido (
    id_pedido BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_cliente BIGINT NULL,
    tipo_pedido ENUM('EN_LOCAL','RECOGER') NOT NULL,
    fecha_hora_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('PENDIENTE','EN_PREPARACION','LISTO','ENTREGADO','CANCELADO') 
        NOT NULL DEFAULT 'PENDIENTE',
    total DECIMAL(12,2) DEFAULT 0.00,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE SET NULL
) ENGINE=InnoDB;


CREATE TABLE PedidoProducto (
    id_pedido BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    cantidad SMALLINT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PedidoCombo (
    id_pedido BIGINT NOT NULL,
    id_combo BIGINT NOT NULL,
    cantidad SMALLINT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_combo),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_combo) REFERENCES Combo(id_combo) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PedidoAdicion (
    id_pedido BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    id_adicion BIGINT NOT NULL,
    cantidad SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_pedido, id_producto, id_adicion),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_adicion) REFERENCES Adicion(id_adicion) ON DELETE CASCADE
) ENGINE=InnoDB;


CREATE INDEX idx_producto_tipo_activo ON Producto (tipo_producto, activo);
CREATE INDEX idx_pedido_fecha_estado ON Pedido (fecha_hora_pedido, estado);
CREATE INDEX idx_combo_activo ON Combo (activo);


INSERT INTO Cliente (nombre, telefono, correo, direccion) VALUES
('Juan Pérez', '123456789', 'juan.perez@example.com', 'Av. Siempre Viva 123'),
('María Gómez', '987654321', 'maria.gomez@example.com', 'Calle Falsa 456'),
('Carlos López', '555555555', 'carlos.lopez@example.com', 'Calle Real 789'),
('Laura Sánchez', '777777777', 'laura.sanchez@example.com', 'Avenida Libertad 101'),
('Pedro Martínez', '888888888', 'pedro.martinez@example.com', 'Calle Mayor 202');

INSERT INTO Producto (nombre, descripcion, tipo_producto, precio_base) VALUES
('Pizza Margarita', 'Pizza con salsa de tomate, queso mozzarella y albahaca', 'PIZZA', 10.50),
('Panzarotti de Carne', 'Panzarotti relleno de carne, tomate y queso', 'PANZAROTTI', 7.50),
('Coca Cola', 'Bebida gaseosa de cola', 'BEBIDA', 2.00),
('Tiramisu', 'Postre italiano con café y crema de mascarpone', 'POSTRE', 3.00),
('Agua Mineral', 'Agua sin gas', 'BEBIDA', 1.00);

INSERT INTO Ingrediente (nombre, descripcion) VALUES
('Queso Mozzarella', 'Queso de origen italiano, usado en pizzas y otros platos'),
('Jamón', 'Jamón cocido, utilizado en pizzas y bocadillos'),
('Tomate', 'Tomate fresco, usado en pizzas y salsas'),
('Aceitunas', 'Aceitunas verdes, usadas como ingrediente en pizzas'),
('Espinaca', 'Hojas de espinaca fresca, usada en pizzas o ensaladas');

INSERT INTO Adicion (nombre, precio_adicion, descripcion) VALUES
('Extra Queso', 1.50, 'Añade queso extra a tu pizza'),
('Salsa BBQ', 0.75, 'Añade salsa barbacoa a tu pizza'),
('Aceitunas', 0.50, 'Añade aceitunas a tu pizza'),
('Pimiento', 0.30, 'Añade pimientos a tu pizza'),
('Champiñones', 0.90, 'Añade champiñones frescos a tu pizza');

INSERT INTO Combo (nombre, descripcion, precio_combo) VALUES
('Combo Familiar', '1 Pizza Grande, 2 bebidas y 1 postre', 19.99),
('Combo 2 Personas', '2 Pizzas medianas y 1 bebida', 15.99),
('Combo Pizza y Panzarotti', '1 Pizza y 1 Panzarotti con bebida', 13.99),
('Combo Solo Pizza', '2 Pizzas y 1 bebida', 14.99),
('Combo Pizza y Tiramisu', '1 Pizza y 1 Tiramisu', 12.99);

INSERT INTO Pedido (id_cliente, tipo_pedido, estado, total)
VALUES
(1, 'EN_LOCAL', 'ENTREGADO', 25.00),
(2, 'RECOGER', 'ENTREGADO', 18.50),
(3, 'EN_LOCAL', 'ENTREGADO', 30.00),
(4, 'RECOGER', 'ENTREGADO', 12.00),
(5, 'EN_LOCAL', 'PENDIENTE', 9.50);
INSERT INTO PedidoProducto (id_pedido, id_producto, cantidad, precio_unitario)
VALUES
(1, 1, 2, 10.50),  
(1, 3, 2, 2.00),   
(2, 2, 1, 7.50),   
(2, 4, 2, 3.00),   
(3, 1, 1, 10.50),
(3, 5, 1, 1.00),
(4, 2, 1, 7.50),
(5, 1, 1, 10.50);
INSERT INTO PedidoAdicion (id_pedido, id_producto, id_adicion, cantidad)
VALUES
(1, 1, 1, 1), 
(2, 2, 2, 1), 
(3, 1, 3, 2),  
(3, 1, 1, 1),  
(4, 2, 5, 1);  
-- Primera Consulta
SELECT p.tipo_producto, p.nombre, SUM(pp.cantidad) AS total_vendido
FROM PedidoProducto pp
JOIN Producto p ON pp.id_producto = p.id_producto
GROUP BY p.id_producto, p.tipo_producto
ORDER BY total_vendido DESC;
-- Segunada Consulta -- 
SELECT c.nombre AS combo, SUM(pc.cantidad * pc.precio_unitario) AS total_ingresos
FROM PedidoCombo pc
JOIN Combo c ON pc.id_combo = c.id_combo
JOIN Pedido p ON pc.id_pedido = p.id_pedido
WHERE p.estado = 'ENTREGADO'
GROUP BY c.id_combo
ORDER BY total_ingresos DESC;
-- Tercera Consulta
SELECT tipo_pedido, COUNT(*) AS cantidad
FROM Pedido
GROUP BY tipo_pedido;
-- Cuarta Consulta
SELECT a.nombre, SUM(pa.cantidad) AS total
FROM PedidoAdicion pa
JOIN Adicion a ON pa.id_adicion = a.id_adicion
GROUP BY a.id_adicion
ORDER BY total DESC;
-- Quinta Consulta
SELECT p.tipo_producto, SUM(pp.cantidad) AS total_vendido
FROM PedidoProducto pp
JOIN Producto p ON pp.id_producto = p.id_producto
GROUP BY p.tipo_producto;
-- Sexta Consulta -- 
SELECT c.nombre, AVG(pp.cantidad) AS promedio_pizzas
FROM PedidoProducto pp
JOIN Pedido pe ON pp.id_pedido = pe.id_pedido
JOIN Cliente c ON pe.id_cliente = c.id_cliente
JOIN Producto p ON pp.id_producto = p.id_producto
WHERE p.tipo_producto = 'PIZZA'
GROUP BY c.id_cliente;
-- Septima-
SELECT DAYNAME(fecha_hora_pedido) AS dia, SUM(total) AS total_ventas
FROM Pedido
GROUP BY dia;
-- Octava
SELECT SUM(pa.cantidad) AS total_panzarotti_extra_queso
FROM PedidoAdicion pa
JOIN Adicion a ON pa.id_adicion = a.id_adicion
JOIN Producto p ON pa.id_producto = p.id_producto
WHERE p.tipo_producto = 'PANZAROTTI' AND a.nombre = 'Extra Queso';
-- Novena -- 
SELECT DISTINCT pc.id_pedido
FROM PedidoCombo pc
JOIN ComboProducto cp ON pc.id_combo = cp.id_combo
JOIN Producto p ON cp.id_producto = p.id_producto
WHERE p.tipo_producto = 'BEBIDA';

-- dECIMO -- 
SELECT c.id_cliente, c.nombre, COUNT(p.id_pedido) AS total_pedidos
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id_cliente
WHERE p.fecha_hora_pedido >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY c.id_cliente
HAVING total_pedidos > 5;
-- Once
SELECT 
    SUM(pp.cantidad * pp.precio_unitario) AS ingresos_no_elaborados
FROM PedidoProducto pp
JOIN Producto pr ON pp.id_producto = pr.id_producto
WHERE pr.tipo_producto IN ('BEBIDA', 'POSTRE', 'OTRO');
-- DOCE
SELECT 
    AVG(sub.total_adiciones) AS promedio_adiciones_por_pedido
FROM (
    SELECT id_pedido, SUM(cantidad) AS total_adiciones
    FROM PedidoAdicion
    GROUP BY id_pedido
) AS sub;
-- TRECE
SELECT 
    SUM(pc.cantidad) AS total_combos_vendidos
FROM PedidoCombo pc
JOIN Pedido p ON pc.id_pedido = p.id_pedido
WHERE p.fecha_hora_pedido >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
-- CATORCE 
SELECT c.id_cliente, c.nombre
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente
HAVING 
    SUM(p.tipo_pedido = 'RECOGER') > 0
    AND SUM(p.tipo_pedido = 'EN_LOCAL') > 0;
-- QUINCE
SELECT COUNT(DISTINCT pa.id_producto) AS total_productos_personalizados
FROM PedidoAdicion pa;
-- DIECISEIS
SELECT p.id_pedido, COUNT(DISTINCT pp.id_producto) AS cantidad_diferentes
FROM PedidoProducto pp
JOIN Pedido p ON pp.id_pedido = p.id_pedido
GROUP BY p.id_pedido
HAVING cantidad_diferentes > 3;
-- Diecisiete
SELECT 
    ROUND(AVG(total_diario), 2) AS promedio_ingresos_por_dia
FROM (
    SELECT DATE(fecha_hora_pedido) AS fecha, SUM(total) AS total_diario
    FROM Pedido
    WHERE estado != 'CANCELADO'
    GROUP BY DATE(fecha_hora_pedido)
) AS sub;
-- Dieciocho
SELECT c.id_cliente, c.nombre
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
LEFT JOIN PedidoAdicion pa ON pa.id_pedido = p.id_pedido
LEFT JOIN Producto pr ON pa.id_producto = pr.id_producto
GROUP BY c.id_cliente
HAVING 
    SUM(CASE WHEN pr.tipo_producto = 'PIZZA' AND pa.id_adicion IS NOT NULL THEN 1 ELSE 0 END)
    / COUNT(p.id_pedido) > 0.5;
-- Diecinueve
SELECT 
    ROUND(
        SUM(CASE WHEN pr.tipo_producto IN ('BEBIDA','POSTRE','OTRO') 
                 THEN pp.cantidad * pp.precio_unitario ELSE 0 END)
        / SUM(pp.cantidad * pp.precio_unitario) * 100, 2
    ) AS porcentaje_no_elaborados
FROM PedidoProducto pp
JOIN Producto pr ON pp.id_producto = pr.id_producto;
-- veinte
SELECT 
    DAYNAME(fecha_hora_pedido) AS dia_semana,
    COUNT(*) AS total_pedidos
FROM Pedido
WHERE tipo_pedido = 'RECOGER'
GROUP BY dia_semana
ORDER BY total_pedidos DESC
LIMIT 1;


