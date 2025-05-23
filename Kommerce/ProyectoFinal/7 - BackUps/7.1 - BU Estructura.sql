-- Script de Backup de Estructura de Base de Datos Kommerce (Oracle LIVE SQL)
-- IMPORTANTE: Para guardar el resultado:
-- 1. Ejecutar el script
-- 2. En el panel "DBMS Output", hacer clic en el botón "Download"
-- 3. Renombrar el archivo descargado con extensión .sql

SET SERVEROUTPUT ON;

DECLARE
    v_ddl CLOB;
    v_output CLOB;
BEGIN
    -- Configurar DBMS_METADATA para un output más limpio
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'EMIT_SCHEMA', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);

    -- Cabecera del backup
    DBMS_OUTPUT.PUT_LINE('-- Backup de Estructura - Base de datos Kommerce');
    DBMS_OUTPUT.PUT_LINE('-- Generado el: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('');

    -- Generar DDL para cada tabla en el orden correcto
    FOR tabla IN (
        SELECT table_name
        FROM user_tables 
        WHERE table_name IN (
            'DISTRITO', 'CLIENTE', 'PROVEEDOR', 'PRODUCTO',
            'ABASTECIMIENTO', 'VENDEDOR', 'FACTURA', 
            'DETALLE_FACTURA', 'ORDEN_COMPRA', 'DETALLE_COMPRA'
        )
        ORDER BY 
            CASE table_name 
                WHEN 'DISTRITO' THEN 1
                WHEN 'CLIENTE' THEN 2
                WHEN 'PROVEEDOR' THEN 3
                WHEN 'PRODUCTO' THEN 4
                WHEN 'ABASTECIMIENTO' THEN 5
                WHEN 'VENDEDOR' THEN 6
                WHEN 'FACTURA' THEN 7
                WHEN 'DETALLE_FACTURA' THEN 8
                WHEN 'ORDEN_COMPRA' THEN 9
                WHEN 'DETALLE_COMPRA' THEN 10
            END
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('-- Tabla: ' || tabla.table_name);
        DBMS_OUTPUT.PUT_LINE('');
        
        -- Obtener y limpiar el DDL
        v_ddl := REPLACE(
            REPLACE(
                DBMS_METADATA.GET_DDL('TABLE', tabla.table_name),
                '"', ''
            ),
            'COLLATE "USING_NLS_COMP"', ''
        );
        
        -- Eliminar espacios extras y DEFAULT COLLATION
        v_ddl := REGEXP_REPLACE(v_ddl, 'DEFAULT COLLATION.*?;', ';');
        v_ddl := TRIM(v_ddl);
        
        DBMS_OUTPUT.PUT_LINE(v_ddl);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
