-- =========================================
-- ATENCIÓN: ELIMINACIÓN MASIVA DE TABLAS EN POSTGRESQL
-- Archivo: Postgres - DROP ALL TABLES.sql
-- Descripción: Este script elimina todas las tablas y su información de la base de datos actual.
-- ADVERTENCIA: Esta acción es irreversible. Úselo con extrema precaución.
-- =========================================

-- =========================================
-- BLOQUE ANÓNIMO PARA ELIMINAR TODAS LAS TABLAS DEL ESQUEMA 'public'
-- =========================================
DO $$ 
DECLARE 
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;
/