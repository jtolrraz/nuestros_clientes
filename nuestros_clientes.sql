-- Database: Respaldo_unidad2

-- DROP DATABASE IF EXISTS "Respaldo_unidad2";

CREATE DATABASE "Respaldo_unidad2";

-- 1. Cargar el respaldo de la base de datos unidad2.sql. (2 Puntos)


psql -U postgres Respaldo_unidad2 < D:\Downloads\unidad2.sql


--2. El cliente usuario01 ha realizado la siguiente compra:
-- producto: producto9.
-- cantidad: 5.
-- fecha: fecha del sistema.
--Mediante el uso de transacciones, realiza las consultas correspondientes para este
--requerimiento y luego consulta la tabla producto para validar si fue efectivamente
--descontado en el stock. (3 Puntos)

--busco las id en compra y detalle_compra
SELECT * FROM compra;
--id 33
SELECT * FROM detalle_compra;
--id 43
BEGIN TRANSACTION;
    INSERT INTO compra(id, cliente_id, fecha)
    VALUES(33, 2, '2022-04-10');
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
    VALUES(43, 9, 33, 5);
    UPDATE producto SET stock = stock -5 WHERE id = 9;
COMMIT;

--3. El cliente usuario02 ha realizado la siguiente compra:
-- producto: producto1, producto 2, producto 8.
-- cantidad: 3 de cada producto.
-- fecha: fecha del sistema.
--Mediante el uso de transacciones, realiza las consultas correspondientes para este
--requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
--se queda sin stock, no se realice la compra. (3 Puntos)

--busco las id en compra y detalle_compra
SELECT * FROM compra;
--id 34
SELECT * FROM detalle_compra;
--id 44


BEGIN TRANSACTION;
    INSERT INTO compra(id, cliente_id, fecha)
    VALUES(34, 8, '2022-04-10');
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
    VALUES(44, 1, 34, 3);
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
    VALUES(45, 2, 34, 3);
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
    VALUES(46, 8, 34, 3);

    UPDATE producto SET stock = stock - 3 WHERE id = 1;
    UPDATE producto SET stock = stock - 3 WHERE id = 2;
    UPDATE producto SET stock = stock - 3 WHERE id = 8;
COMMIT;
-- acá nos arroja el error del stock negativo

--4. Realizar las siguientes consultas (2 Puntos):
--a. Deshabilitar el AUTOCOMMIT .
\set autocommit off 
\echo :autocommit  --ver estado 

--b. Insertar un nuevo cliente.

BEGIN TRANSACTION;
    SAVEPOINT antes_nuevo_cliente;
    INSERT INTO cliente(id, nombre, email)
    VALUES(11, 'usuario011', 'usuario011@correo.com');

--c. Confirmar que fue agregado en la tabla cliente.
    SELECT * FROM cliente;
--d. Realizar un ROLLBACK.
    ROLLBACK TO antes_nuevo_cliente;
--e. Confirmar que se restauró la información, sin considerar la inserción del punto b.
    SELECT * FROM cliente;
    COMMIT;
--f. Habilitar de nuevo el AUTOCOMMIT.
\set autocommit on 
\echo :autocommit  --ver estado 