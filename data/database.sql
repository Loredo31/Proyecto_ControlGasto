-- Base de datos de Control de gasto;

DROP DATABASE IF EXISTS ControlGasto;
CREATE DATABASE ControlGasto;
USE ControlGasto;

CREATE TABLE Usuario (
    IdUsuario INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    ApPaterno VARCHAR(50) NOT NULL,
    ApMaterno VARCHAR(50),
    NumTelefono CHAR(10),
    Correo VARCHAR(50) NOT NULL,
    FechaNacimiento DATETIME,
    Usuario CHAR(20) NOT NULL,
    Contrasena VARCHAR(30) NOT NULL
);

CREATE TABLE Presupuesto (
    IdUsuario INT PRIMARY KEY,
    PresupuestoTotal DECIMAL(10, 2),
    PresupuestoActual DECIMAL(10, 2),
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE Servicio (
    IdServicio INT PRIMARY KEY AUTO_INCREMENT,
    IdUsuario INT NOT NULL,
    Producto VARCHAR(100) NOT NULL,
    Cantidad INT NOT NULL,
    Cliente VARCHAR(50) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    FechaServicio DATETIME NOT NULL,
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE Ingreso (
    IdIngreso INT PRIMARY KEY AUTO_INCREMENT,
    IdUsuario INT NOT NULL,
    TipoIngreso VARCHAR(50) NOT NULL,
    OrigenIngreso VARCHAR(100) NOT NULL,
    Categoria VARCHAR(30) NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    FechaIngreso DATETIME NOT NULL,
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE Gasto (
    IdGasto INT PRIMARY KEY AUTO_INCREMENT,
    IdUsuario INT NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Categoria VARCHAR(30) NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    FechaTransaccion DATETIME NOT NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    Comprobante VARCHAR(100),
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);


-- Trigger que actualiza el presupuesto cuando se crea un usuario

DELIMITER //

CREATE TRIGGER after_usuario_insert
AFTER INSERT ON Usuario
FOR EACH ROW
BEGIN
    INSERT INTO Presupuesto (IdUsuario, PresupuestoTotal, PresupuestoActual)
    VALUES (NEW.IdUsuario, 0, 0);
END //

DELIMITER ;


-------------
-- Gastos --
-------------

-- Trigger que actualiza el presupuesto cuando se crea un gasto

DELIMITER //

CREATE TRIGGER after_gasto_insert
AFTER INSERT ON Gasto
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual - NEW.Monto
    WHERE IdUsuario = NEW.IdUsuario;
END //

DELIMITER ;


-- Trigger que actualiza el presupuesto cuando se edita un gasto

DELIMITER //

CREATE TRIGGER after_Gasto_update
AFTER UPDATE ON Gasto
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual + OLD.Monto
    WHERE IdUsuario = OLD.IdUsuario;

    -- Aplicar el nuevo monto
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual - NEW.Monto
    WHERE IdUsuario = NEW.IdUsuario;
END //

DELIMITER ;


-- Trigger que actualiza el presupuesto cuando se elimina un gasto

DELIMITER //

CREATE TRIGGER after_gasto_delete
AFTER DELETE ON Gasto
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual + OLD.Monto,
        PresupuestoTotal = PresupuestoTotal + OLD.Monto
    WHERE IdUsuario = OLD.IdUsuario;
END //

DELIMITER ;

---------------
-- Servicios --
---------------

-- Trigger que actualiza el presupuesto cuando se crea un servicio

DELIMITER //

CREATE TRIGGER after_servicio_insert
AFTER INSERT ON Servicio
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoTotal = PresupuestoTotal + NEW.Monto,
        PresupuestoActual = PresupuestoActual + NEW.Monto
    WHERE IdUsuario = NEW.IdUsuario;
END //

DELIMITER ;


-- Trigger que actualiza el presupuesto cuando se edita un servicio

DELIMITER //

CREATE TRIGGER after_Servicio_update
AFTER UPDATE ON Servicio
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual - OLD.Monto,
        PresupuestoTotal = PresupuestoTotal - OLD.Monto
    WHERE IdUsuario = OLD.IdUsuario;

    -- Aplicar el nuevo monto
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual + NEW.Monto,
        PresupuestoTotal = PresupuestoTotal + NEW.Monto
    WHERE IdUsuario = NEW.IdUsuario;
END //

DELIMITER ;


-- Trigger que actualiza el presupuesto cuando se elimina un servicio

DELIMITER //

CREATE TRIGGER after_servicio_delete
AFTER DELETE ON Servicio
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual - OLD.Monto,
        PresupuestoTotal = PresupuestoTotal - OLD.Monto
    WHERE IdUsuario = OLD.IdUsuario;
END //

DELIMITER ;


--------------
-- Ingresos --
--------------

-- Trigger que actualiza el presupuesto cuando se crea un ingreso

DELIMITER //

CREATE TRIGGER after_ingreso_insert
AFTER INSERT ON Ingreso
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoTotal = PresupuestoTotal + NEW.Monto,
        PresupuestoActual = PresupuestoActual + NEW.Monto
    WHERE IdUsuario = NEW.IdUsuario;
END //

DELIMITER ;


-- Trigger que actualiza el presupuesto cuando se edita un ingreso

DELIMITER //

CREATE TRIGGER after_Ingreso_update
AFTER UPDATE ON Ingreso
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual - OLD.Monto,
        PresupuestoTotal = PresupuestoTotal - OLD.Monto
    WHERE IdUsuario = OLD.IdUsuario;

    -- Aplicar el nuevo monto
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual + NEW.Monto,
        PresupuestoTotal = PresupuestoTotal - NEW.Monto
    WHERE IdUsuario = NEW.IdUsuario;
END //

DELIMITER ;


-- Trigger que actualiza el presupuesto cuando se elimina un ingreso

DELIMITER //

CREATE TRIGGER after_ingreso_delete
AFTER DELETE ON Ingreso
FOR EACH ROW
BEGIN
    UPDATE Presupuesto
    SET 
        PresupuestoActual = PresupuestoActual - OLD.Monto,
        PresupuestoTotal = PresupuestoTotal - OLD.Monto
    WHERE IdUsuario = OLD.IdUsuario;
END //

DELIMITER ;

------------------------------------------------
-- Eliminar datos relacionados con el usuario --
------------------------------------------------

DELIMITER //

CREATE TRIGGER before_usuario_delete
BEFORE DELETE ON Usuario
FOR EACH ROW
BEGIN
    DELETE FROM Gasto WHERE IdUsuario = OLD.IdUsuario;
    DELETE FROM Ingreso WHERE IdUsuario = OLD.IdUsuario;
    DELETE FROM Servicio WHERE IdUsuario = OLD.IdUsuario;
    DELETE FROM Presupuesto WHERE IdUsuario = OLD.IdUsuario;
END //

DELIMITER ;
