-- =========================================
-- TRIGGERS DE AUDITORÍA PARA KOMMERCE
-- Archivo: 5.1 - Triggers Auditoria.sql
-- Descripción: Triggers para auditar operaciones en tablas principales
-- =========================================

-- =========================================
-- TRIGGER: CLIENTE
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_CLIENTE
AFTER INSERT OR UPDATE OR DELETE ON CLIENTE
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertado cliente: ' || :NEW.COD_CLI || ', ' || :NEW.RSO_CLI;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizado cliente: ' || :OLD.COD_CLI;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminado cliente: ' || :OLD.COD_CLI;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'CLIENTE', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: DISTRITO
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_DISTRITO
AFTER INSERT OR UPDATE OR DELETE ON DISTRITO
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertado distrito: ' || :NEW.COD_DIS || ', ' || :NEW.NOM_DIS;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizado distrito: ' || :OLD.COD_DIS;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminado distrito: ' || :OLD.COD_DIS;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'DISTRITO', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: PROVEEDOR
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_PROVEEDOR
AFTER INSERT OR UPDATE OR DELETE ON PROVEEDOR
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertado proveedor: ' || :NEW.COD_PRV || ', ' || :NEW.RSO_PRV;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizado proveedor: ' || :OLD.COD_PRV;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminado proveedor: ' || :OLD.COD_PRV;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'PROVEEDOR', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: PRODUCTO
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_PRODUCTO
AFTER INSERT OR UPDATE OR DELETE ON PRODUCTO
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertado producto: ' || :NEW.COD_PRO || ', ' || :NEW.DES_PRO;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizado producto: ' || :OLD.COD_PRO;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminado producto: ' || :OLD.COD_PRO;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'PRODUCTO', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: ABASTECIMIENTO
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_ABASTECIMIENTO
AFTER INSERT OR UPDATE OR DELETE ON ABASTECIMIENTO
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
    v_clave VARCHAR2(100);
BEGIN
    v_clave := NVL(:NEW.COD_PRV, :OLD.COD_PRV) || '-' || NVL(:NEW.COD_PRO, :OLD.COD_PRO);

    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertado abastecimiento para proveedor ' || :NEW.COD_PRV || ' y producto ' || :NEW.COD_PRO;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizado abastecimiento para ' || v_clave;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminado abastecimiento para ' || v_clave;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'ABASTECIMIENTO', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: VENDEDOR
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_VENDEDOR
AFTER INSERT OR UPDATE OR DELETE ON VENDEDOR
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertado vendedor: ' || :NEW.COD_VEN || ', ' || :NEW.NOM_VEN;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizado vendedor: ' || :OLD.COD_VEN;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminado vendedor: ' || :OLD.COD_VEN;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'VENDEDOR', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: FACTURA
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_FACTURA
AFTER INSERT OR UPDATE OR DELETE ON FACTURA
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertada factura: ' || :NEW.NUM_FAC;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizada factura: ' || :OLD.NUM_FAC;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminada factura: ' || :OLD.NUM_FAC;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'FACTURA', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: DETALLE_FACTURA
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_DETALLE_FACTURA
AFTER INSERT OR UPDATE OR DELETE ON DETALLE_FACTURA
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
    v_clave VARCHAR2(100);
BEGIN
    v_clave := NVL(:NEW.NUM_FAC, :OLD.NUM_FAC) || '-' || NVL(:NEW.COD_PRO, :OLD.COD_PRO);

    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertado detalle de factura: ' || v_clave;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizado detalle de factura: ' || v_clave;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminado detalle de factura: ' || v_clave;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'DETALLE_FACTURA', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: ORDEN_COMPRA
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_ORDEN_COMPRA
AFTER INSERT OR UPDATE OR DELETE ON ORDEN_COMPRA
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertada orden de compra: ' || :NEW.NUM_OCO;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizada orden de compra: ' || :OLD.NUM_OCO;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminada orden de compra: ' || :OLD.NUM_OCO;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'ORDEN_COMPRA', v_op, v_desc);
END;
/

-- =========================================
-- TRIGGER: DETALLE_COMPRA
-- =========================================
CREATE OR REPLACE TRIGGER AUDIT_DETALLE_COMPRA
AFTER INSERT OR UPDATE OR DELETE ON DETALLE_COMPRA
FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
    v_desc VARCHAR2(4000);
    v_clave VARCHAR2(100);
BEGIN
    v_clave := NVL(:NEW.NUM_OCO, :OLD.NUM_OCO) || '-' || NVL(:NEW.COD_PRO, :OLD.COD_PRO);

    IF INSERTING THEN
        v_op := 'INSERT';
        v_desc := 'Insertado detalle de compra: ' || v_clave;
    ELSIF UPDATING THEN
        v_op := 'UPDATE';
        v_desc := 'Actualizado detalle de compra: ' || v_clave;
    ELSIF DELETING THEN
        v_op := 'DELETE';
        v_desc := 'Eliminado detalle de compra: ' || v_clave;
    END IF;

    INSERT INTO AUDITORIA (USUARIO, TABLA_AFECTADA, TIPO_OPERACION, DESCRIPCION)
    VALUES (USER, 'DETALLE_COMPRA', v_op, v_desc);
END;
/