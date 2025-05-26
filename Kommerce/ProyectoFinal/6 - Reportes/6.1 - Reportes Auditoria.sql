-- =========================================
-- REPORTE DE AUDITORÍA
-- Archivo: 6.1 - Reportes Auditoria.sql
-- Descripción: Consulta para obtener los registros de auditoría en un rango de fechas
-- =========================================

-- =========================================
-- CONSULTA DE AUDITORÍA POR RANGO DE FECHAS
-- =========================================
SELECT 
    ID_AUDITORIA,
    USUARIO,
    FECHA_HORA,
    TABLA_AFECTADA,
    TIPO_OPERACION,
    CLAVE_REGISTRO,
    DESCRIPCION
FROM AUDITORIA
WHERE FECHA_HORA BETWEEN TO_DATE(:FECHA_INICIO, 'DD-MM-YYYY') AND TO_DATE(:FECHA_FIN, 'DD-MM-YYYY') + 1
ORDER BY FECHA_HORA DESC;
/