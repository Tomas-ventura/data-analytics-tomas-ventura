USE Ventas_Tech_DB

/*=========Consulta 1 — Resumen ejecutivo mensual ======*/

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS totalfacturado,
    COUNT(*) AS cantidadpedidos,
    AVG(cantidad * precio_unitario) AS ticketpromedio
FROM dbo.ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta);

/*=========Consulta 2 — Ranking de productos ======*/


SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidadesvendidas,
    SUM(cantidad * precio_unitario) AS totalfacturado
FROM ventas
GROUP BY id_producto
ORDER BY id_producto DESC;

/*=========Consulta 3 — Clientes recurrentes ======*/

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

/*=========Consulta 4 — Meses por encima/por debajo del promedio ======*/


WITH FacturacionMensual AS (
    SELECT 
        MONTH(fecha_venta) AS Mes,
        SUM(cantidad * precio_unitario) AS TotalFacturado
    FROM Ventas
    GROUP BY 
        MONTH(fecha_venta)
)
SELECT 
    Mes,
    TotalFacturado,
    AVG(TotalFacturado) OVER() AS PromedioGeneral,
    CASE 
        WHEN TotalFacturado >= AVG(TotalFacturado) OVER() THEN 'Por encima'
        ELSE 'Por debajo'
    END AS EstadoPromedio
FROM FacturacionMensual
ORDER BY 
    Mes ASC;

   -- Bloque de cierre,1) Podemos ver segun la tabla de cargas que el mes con mayor facturacion --
   --es el 3/marzo (el unico jaja),--
    -- 2) El producto 2 es el que mas se vendio,--
    -- Pero el que menor facturacion total genera-- 
    -- 3) Los pedidos de clientes son parejos (todos 2 en total) pero los clientes--
    -- que mas gastan son el 1 y el 5--
























