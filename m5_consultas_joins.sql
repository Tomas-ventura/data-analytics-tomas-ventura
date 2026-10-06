USE Ventas_Tech_DB

--consulta 1-- 

CREATE TABLE dbo.geografia (
    id_geografia INT PRIMARY KEY IDENTITY(1,1),
    ciudad VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL
);

INSERT INTO dbo.geografia (ciudad, provincia, region) 
VALUES 
    ('Córdoba', 'Córdoba', 'Centro'),
    ('Rosario', 'Santa Fe', 'Litoral'),
    ('Mendoza', 'Mendoza', 'Cuyo');

ALTER TABLE dbo.clientes 
ADD segmento VARCHAR(50) NULL,
    id_geografia INT NULL FOREIGN KEY REFERENCES dbo.geografia(id_geografia);
GO

UPDATE dbo.clientes SET segmento = 'Corporativo', id_geografia = 1 WHERE id_cliente = 1;
UPDATE dbo.clientes SET segmento = 'Pyme', id_geografia = 2 WHERE id_cliente = 2;
UPDATE dbo.clientes SET segmento = 'Final', id_geografia = 3 WHERE id_cliente = 3;
GO


SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,    
    c.segmento,
    g.ciudad,                        
    g.provincia,                     
    g.region,                        
    p.nombre_producto AS descripcion_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM dbo.ventas v
INNER JOIN dbo.clientes c 
    ON v.id_cliente = c.id_cliente
INNER JOIN dbo.geografia g 
    ON c.id_geografia = g.id_geografia 
INNER JOIN dbo.productos p 
    ON v.id_producto = p.id_producto
INNER JOIN dbo.categorias cat 
    ON p.id_categoria = cat.id_categoria;


    --consulta 2-- 
    SELECT 
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM dbo.clientes c
LEFT JOIN dbo.ventas v 
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;



    --consulta 3-- 
    SELECT 
    p.nombre_producto AS nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM dbo.productos p
INNER JOIN dbo.categorias cat 
    ON p.id_categoria = cat.id_categoria
LEFT JOIN dbo.ventas v 
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;



    --consulta 4-- 
   SELECT 
    canal, 
    SUM(total) AS total_canal
FROM (
   
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Online' AS canal
    FROM dbo.ventas 
    WHERE id_venta <= 2  

    UNION ALL

    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Presencial' AS canal
    FROM dbo.ventas 
    WHERE id_venta !> 2 
) AS consolidado
GROUP BY canal;




