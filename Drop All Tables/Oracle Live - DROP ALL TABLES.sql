-- =========================================
-- ATENCIÓN: ELIMINACIÓN MASIVA DE TABLAS EN ORACLE
-- Archivo: Oracle Live - DROP ALL TABLES.sql
-- Descripción: Este script elimina todas las tablas y su información de la base de datos actual.
-- ADVERTENCIA: Esta acción es irreversible. Úselo con extrema precaución.
-- =========================================

-- =========================================
-- BLOQUE ANÓNIMO PARA ELIMINAR TODAS LAS TABLAS DEL USUARIO ACTUAL
-- =========================================
BEGIN
    FOR t IN (SELECT TABLE_NAME FROM USER_TABLES) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE "' || t.TABLE_NAME || '" CASCADE CONSTRAINTS PURGE';
    END LOOP;
END;
/