-- Script de Backup de Datos de Base de Datos Kommerce (Oracle LIVE SQL)
-- IMPORTANTE: Para guardar el resultado:
-- 1. Ejecutar el script
-- 2. En el panel "DBMS Output", hacer clic en el botón "Download"
-- 3. Renombrar el archivo descargado con extensión .sql

SET SERVEROUTPUT ON;

DECLARE
    v_sql VARCHAR2(4000);
    v_count NUMBER;
    v_column_list VARCHAR2(4000);
    v_values_list VARCHAR2(4000);
    v_row user_tab_columns%ROWTYPE;
    v_dynamic_cursor SYS_REFCURSOR;
    v_column_values DBMS_SQL.VARCHAR2_TABLE;
    v_number_of_columns NUMBER;
    v_desc_tab DBMS_SQL.DESC_TAB;
    v_cursor_id NUMBER;
    v_col_val VARCHAR2(4000);
BEGIN
    -- Cabecera del backup
    DBMS_OUTPUT.PUT_LINE('-- Backup de Datos - Base de datos Kommerce');
    DBMS_OUTPUT.PUT_LINE('-- Generado el: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Array de tablas en orden de dependencia
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
        -- Imprimir encabezado de la tabla
        DBMS_OUTPUT.PUT_LINE('-- Datos de la tabla: ' || tabla.table_name);
        DBMS_OUTPUT.PUT_LINE('');
        
        -- Obtener la lista de columnas
        v_column_list := '';
        FOR col IN (
            SELECT column_name
            FROM user_tab_columns
            WHERE table_name = tabla.table_name
            ORDER BY column_id
        ) LOOP
            IF v_column_list IS NOT NULL THEN
                v_column_list := v_column_list || ', ';
            END IF;
            v_column_list := v_column_list || col.column_name;
        END LOOP;
        
        -- Preparar el cursor dinámico
        v_cursor_id := DBMS_SQL.OPEN_CURSOR;
        v_sql := 'SELECT * FROM ' || tabla.table_name;
        
        -- Parse y describir la consulta
        DBMS_SQL.PARSE(v_cursor_id, v_sql, DBMS_SQL.NATIVE);
        DBMS_SQL.DESCRIBE_COLUMNS(v_cursor_id, v_number_of_columns, v_desc_tab);
        
        -- Definir columnas
        FOR i IN 1..v_number_of_columns LOOP
            DBMS_SQL.DEFINE_COLUMN(v_cursor_id, i, v_col_val, 4000);
        END LOOP;
        
        -- Ejecutar la consulta
        v_count := DBMS_SQL.EXECUTE(v_cursor_id);
        
        -- Procesar las filas
        WHILE DBMS_SQL.FETCH_ROWS(v_cursor_id) > 0 LOOP
            v_values_list := '';
            
            -- Construir la lista de valores
            FOR i IN 1..v_number_of_columns LOOP
                DBMS_SQL.COLUMN_VALUE(v_cursor_id, i, v_col_val);
                
                IF i > 1 THEN
                    v_values_list := v_values_list || ', ';
                END IF;
                
                -- Manejar valores NULL y tipos de datos
                IF v_col_val IS NULL THEN
                    v_values_list := v_values_list || 'NULL';
                ELSIF v_desc_tab(i).col_type IN (1, 96) THEN -- VARCHAR2, CHAR
                    v_values_list := v_values_list || '''' || REPLACE(v_col_val, '''', '''''') || '''';
                ELSIF v_desc_tab(i).col_type = 12 THEN -- DATE
                    v_values_list := v_values_list || 'TO_DATE(''' || v_col_val || ''', ''DD-MON-RR'')';
                ELSE -- Números y otros tipos
                    v_values_list := v_values_list || v_col_val;
                END IF;
            END LOOP;
            
            -- Construir y imprimir el INSERT
            v_sql := 'INSERT INTO ' || tabla.table_name || 
                    ' (' || v_column_list || ') VALUES (' || 
                    v_values_list || ');';
            DBMS_OUTPUT.PUT_LINE(v_sql);
        END LOOP;
        
        -- Cerrar el cursor
        DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
        
        -- Separador entre tablas
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('COMMIT;');
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    -- Mensaje final
    DBMS_OUTPUT.PUT_LINE('-- Fin del backup de datos');
END;
/