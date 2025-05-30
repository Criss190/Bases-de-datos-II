-- =========================================
-- REPORTE DE EMPLEADOS CON MENOR VENTA
-- Archivo: 6.2 - Reporte Empleados.sql
-- Descripción: Consulta para obtener los 3 empleados con menor monto total de ventas
-- =========================================

-- =========================================
-- CONSULTA: TOP 3 EMPLEADOS CON MENOR VENTA
-- =========================================
SELECT * FROM (
    SELECT 
        v.COD_VEN,
        v.NOM_VEN || ' ' || v.APE_VEN AS NOMBRE_EMPLEADO,
        NVL(SUM(df.CAN_VEN * df.PRE_VEN), 0) AS TOTAL_VENTAS
    FROM VENDEDOR v
    LEFT JOIN FACTURA f ON f.COD_VEN = v.COD_VEN
    LEFT JOIN DETALLE_FACTURA df ON df.NUM_FAC = f.NUM_FAC
    GROUP BY v.COD_VEN, v.NOM_VEN, v.APE_VEN
    ORDER BY TOTAL_VENTAS ASC
)
WHERE ROWNUM <= 3;
/