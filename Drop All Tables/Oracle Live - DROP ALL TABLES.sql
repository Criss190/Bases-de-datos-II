-- O J O --

-- ESTE SCRIPT BORRA TODAS LAS TABLAS E INFORMACIÓN DE LA BASE DE DATOS ACTUAL --
-- NO SE PUEDE DESHACER / NO EXISTE CTRL Z QUE VALGA --

BEGIN
    FOR t IN (SELECT TABLE_NAME FROM USER_TABLES) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE "' || t.TABLE_NAME || '" CASCADE CONSTRAINTS PURGE';
    END LOOP;
END;