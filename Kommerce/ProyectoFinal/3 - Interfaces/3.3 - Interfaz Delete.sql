-- =========================================
-- INTERFAZ DE ELIMINACIÓN DE DATOS
-- Archivo: 3.3 - Interfaz Delete.sql
-- Descripción: Bloques PL/SQL para eliminar registros y sus dependencias en las tablas principales
-- =========================================

-- =========================================
-- SECCIÓN: CLIENTE
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM CLIENTE;

-- SELECTs de verificación después de eliminados
SELECT * FROM FACTURA WHERE COD_CLI = 'X'; -- Cambia la X por el código del cliente
SELECT df.*
FROM DETALLE_FACTURA df
JOIN FACTURA f ON f.NUM_FAC = df.NUM_FAC
WHERE f.COD_CLI = 'X'; -- Cambia la X por el código del cliente

DECLARE
    v_cod_cli       CLIENTE.COD_CLI%TYPE;     -- Código del cliente a eliminar
    v_existe        NUMBER;                    -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                 -- Excepción personalizada para código no existente
BEGIN
    -- Captura el código del cliente a eliminar
    v_cod_cli := 'X'; -- <-- Cambia la X por el código del cliente que deseas verificar
    
    -- Verifica si el cliente existe
    SELECT COUNT(*) INTO v_existe
    FROM CLIENTE
    WHERE COD_CLI = v_cod_cli;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos los registros relacionados en orden
    -- Primero los detalles de factura
    DELETE FROM DETALLE_FACTURA 
    WHERE NUM_FAC IN (SELECT NUM_FAC FROM FACTURA WHERE COD_CLI = v_cod_cli);
    
    -- Luego las facturas
    DELETE FROM FACTURA 
    WHERE COD_CLI = v_cod_cli;
    
    -- Finalmente borramos el cliente
    DELETE FROM CLIENTE 
    WHERE COD_CLI = v_cod_cli;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cliente y sus registros relacionados eliminados correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El código de cliente ' || v_cod_cli || ' no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el cliente: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: DISTRITO
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM DISTRITO;

-- SELECTs de verificación después de eliminados
SELECT * FROM CLIENTE WHERE COD_DIS = 'X';
SELECT * FROM PROVEEDOR WHERE COD_DIS = 'X';
SELECT * FROM VENDEDOR WHERE COD_DIS = 'X';

DECLARE
    v_cod_dis       DISTRITO.COD_DIS%TYPE;    -- Código del distrito a eliminar
    v_existe        NUMBER;                    -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                 -- Excepción personalizada para código no existente
BEGIN
    -- Captura el código del distrito a eliminar
    v_cod_dis := :Código_de_distrito;
    
    -- Verifica si el distrito existe
    SELECT COUNT(*) INTO v_existe
    FROM DISTRITO
    WHERE COD_DIS = v_cod_dis;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos los registros relacionados en orden
    -- Primero borramos las facturas y sus detalles que están relacionadas con clientes del distrito
    DELETE FROM DETALLE_FACTURA 
    WHERE NUM_FAC IN (SELECT NUM_FAC FROM FACTURA WHERE COD_CLI IN 
                     (SELECT COD_CLI FROM CLIENTE WHERE COD_DIS = v_cod_dis));
    
    DELETE FROM FACTURA 
    WHERE COD_CLI IN (SELECT COD_CLI FROM CLIENTE WHERE COD_DIS = v_cod_dis);
    
    -- Borramos las facturas relacionadas con vendedores del distrito
    DELETE FROM DETALLE_FACTURA 
    WHERE NUM_FAC IN (SELECT NUM_FAC FROM FACTURA WHERE COD_VEN IN 
                     (SELECT COD_VEN FROM VENDEDOR WHERE COD_DIS = v_cod_dis));
    
    DELETE FROM FACTURA 
    WHERE COD_VEN IN (SELECT COD_VEN FROM VENDEDOR WHERE COD_DIS = v_cod_dis);
    
    -- Borramos órdenes de compra y sus detalles relacionados con proveedores del distrito
    DELETE FROM DETALLE_COMPRA 
    WHERE NUM_OCO IN (SELECT NUM_OCO FROM ORDEN_COMPRA WHERE COD_PRV IN 
                     (SELECT COD_PRV FROM PROVEEDOR WHERE COD_DIS = v_cod_dis));
    
    DELETE FROM ORDEN_COMPRA 
    WHERE COD_PRV IN (SELECT COD_PRV FROM PROVEEDOR WHERE COD_DIS = v_cod_dis);
    
    -- Borramos abastecimientos relacionados con proveedores del distrito
    DELETE FROM ABASTECIMIENTO 
    WHERE COD_PRV IN (SELECT COD_PRV FROM PROVEEDOR WHERE COD_DIS = v_cod_dis);
    
    -- Borramos las entidades principales que dependen del distrito
    DELETE FROM CLIENTE WHERE COD_DIS = v_cod_dis;
    DELETE FROM PROVEEDOR WHERE COD_DIS = v_cod_dis;
    DELETE FROM VENDEDOR WHERE COD_DIS = v_cod_dis;
    
    -- Finalmente borramos el distrito
    DELETE FROM DISTRITO WHERE COD_DIS = v_cod_dis;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Distrito y sus registros relacionados eliminados correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El código de distrito ' || v_cod_dis || ' no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el distrito: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: PROVEEDOR
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM PROVEEDOR;

-- SELECTs de verificación después de eliminados
SELECT * FROM ORDEN_COMPRA WHERE COD_PRV = 'X';
SELECT * FROM ABASTECIMIENTO WHERE COD_PRV = 'X';

DECLARE
    v_cod_prv       PROVEEDOR.COD_PRV%TYPE;   -- Código del proveedor a eliminar
    v_existe        NUMBER;                    -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                 -- Excepción personalizada para código no existente
BEGIN
    -- Captura el código del proveedor a eliminar
    v_cod_prv := :Código_de_proveedor;
    
    -- Verifica si el proveedor existe
    SELECT COUNT(*) INTO v_existe
    FROM PROVEEDOR
    WHERE COD_PRV = v_cod_prv;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos los registros relacionados en orden
    -- Primero los detalles de compra
    DELETE FROM DETALLE_COMPRA 
    WHERE NUM_OCO IN (SELECT NUM_OCO FROM ORDEN_COMPRA WHERE COD_PRV = v_cod_prv);
    
    -- Luego las órdenes de compra
    DELETE FROM ORDEN_COMPRA WHERE COD_PRV = v_cod_prv;
    
    -- Borramos los abastecimientos
    DELETE FROM ABASTECIMIENTO WHERE COD_PRV = v_cod_prv;
    
    -- Finalmente borramos el proveedor
    DELETE FROM PROVEEDOR WHERE COD_PRV = v_cod_prv;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proveedor y sus registros relacionados eliminados correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El código de proveedor ' || v_cod_prv || ' no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el proveedor: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: PRODUCTO
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM PRODUCTO;

-- SELECTs de verificación después de eliminados
SELECT * FROM DETALLE_FACTURA WHERE COD_PRO = 'X';
SELECT * FROM DETALLE_COMPRA WHERE COD_PRO = 'X';
SELECT * FROM ABASTECIMIENTO WHERE COD_PRO = 'X';

DECLARE
    v_cod_pro       PRODUCTO.COD_PRO%TYPE;    -- Código del producto a eliminar
    v_existe        NUMBER;                    -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                 -- Excepción personalizada para código no existente
BEGIN
    -- Captura el código del producto a eliminar
    v_cod_pro := :Código_de_producto;
    
    -- Verifica si el producto existe
    SELECT COUNT(*) INTO v_existe
    FROM PRODUCTO
    WHERE COD_PRO = v_cod_pro;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos los registros relacionados en orden
    -- Borramos los detalles de factura
    DELETE FROM DETALLE_FACTURA WHERE COD_PRO = v_cod_pro;
    
    -- Borramos los detalles de compra
    DELETE FROM DETALLE_COMPRA WHERE COD_PRO = v_cod_pro;
    
    -- Borramos los abastecimientos
    DELETE FROM ABASTECIMIENTO WHERE COD_PRO = v_cod_pro;
    
    -- Finalmente borramos el producto
    DELETE FROM PRODUCTO WHERE COD_PRO = v_cod_pro;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Producto y sus registros relacionados eliminados correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El código de producto ' || v_cod_pro || ' no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el producto: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: ABASTECIMIENTO
-- =========================================
-- Se debe correr estos SELECTs antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM ABASTECIMIENTO;
SELECT * FROM PROVEEDOR;
SELECT * FROM PRODUCTO;

DECLARE
    v_cod_prv       ABASTECIMIENTO.COD_PRV%TYPE;  -- Código del proveedor del abastecimiento
    v_cod_pro       ABASTECIMIENTO.COD_PRO%TYPE;  -- Código del producto del abastecimiento
    v_existe        NUMBER;                        -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                     -- Excepción personalizada para código no existente
BEGIN
    -- Captura los códigos de proveedor y producto a eliminar
    v_cod_prv := :Código_de_proveedor;
    v_cod_pro := :Código_de_producto;
    
    -- Verifica si el abastecimiento existe
    SELECT COUNT(*) INTO v_existe
    FROM ABASTECIMIENTO
    WHERE COD_PRV = v_cod_prv 
    AND COD_PRO = v_cod_pro;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos el abastecimiento
    DELETE FROM ABASTECIMIENTO 
    WHERE COD_PRV = v_cod_prv 
    AND COD_PRO = v_cod_pro;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Abastecimiento eliminado correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El abastecimiento no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el abastecimiento: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: VENDEDOR
-- =========================================
-- Se debe correr estos SELECTs antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM VENDEDOR;
SELECT * FROM FACTURA;

-- SELECTs de verificación después de eliminados
SELECT * FROM FACTURA WHERE COD_VEN = 'X';

DECLARE
    v_cod_ven       VENDEDOR.COD_VEN%TYPE;    -- Código del vendedor a eliminar
    v_existe        NUMBER;                    -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                 -- Excepción personalizada para código no existente
BEGIN
    -- Captura el código del vendedor a eliminar
    v_cod_ven := :Código_de_vendedor;
    
    -- Verifica si el vendedor existe
    SELECT COUNT(*) INTO v_existe
    FROM VENDEDOR
    WHERE COD_VEN = v_cod_ven;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos los registros relacionados en orden
    -- Primero los detalles de factura
    DELETE FROM DETALLE_FACTURA 
    WHERE NUM_FAC IN (SELECT NUM_FAC FROM FACTURA WHERE COD_VEN = v_cod_ven);
    
    -- Luego las facturas
    DELETE FROM FACTURA WHERE COD_VEN = v_cod_ven;
    
    -- Finalmente borramos el vendedor
    DELETE FROM VENDEDOR WHERE COD_VEN = v_cod_ven;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vendedor y sus registros relacionados eliminados correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El código de vendedor ' || v_cod_ven || ' no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el vendedor: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: FACTURA
-- =========================================
-- Se debe correr estos SELECTs antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM FACTURA;
SELECT * FROM DETALLE_FACTURA;

-- SELECTs de verificación después de eliminados
SELECT * FROM DETALLE_FACTURA WHERE NUM_FAC = 'X';

DECLARE
    v_num_fac       FACTURA.NUM_FAC%TYPE;     -- Número de factura a eliminar
    v_existe        NUMBER;                    -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                 -- Excepción personalizada para código no existente
BEGIN
    -- Captura el número de factura a eliminar
    v_num_fac := :Número_de_factura;
    
    -- Verifica si la factura existe
    SELECT COUNT(*) INTO v_existe
    FROM FACTURA
    WHERE NUM_FAC = v_num_fac;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos los registros relacionados en orden
    -- Primero los detalles de factura
    DELETE FROM DETALLE_FACTURA WHERE NUM_FAC = v_num_fac;
    
    -- Finalmente borramos la factura
    DELETE FROM FACTURA WHERE NUM_FAC = v_num_fac;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Factura y sus detalles eliminados correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El número de factura ' || v_num_fac || ' no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar la factura: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: DETALLE_FACTURA
-- =========================================
-- Se debe correr estos SELECTs antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM DETALLE_FACTURA;
SELECT * FROM PRODUCTO;

-- SELECTs de verificación después de eliminados
SELECT * FROM PRODUCTO WHERE COD_PRO = 'X';
SELECT * FROM DETALLE_FACTURA WHERE NUM_FAC = 'X';

DECLARE
    v_num_fac       DETALLE_FACTURA.NUM_FAC%TYPE;  -- Número de factura del detalle a eliminar
    v_cod_pro       DETALLE_FACTURA.COD_PRO%TYPE;  -- Código del producto del detalle a eliminar
    v_existe        NUMBER;                         -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                      -- Excepción personalizada para código no existente
BEGIN
    -- Captura el número de factura y código de producto a eliminar
    v_num_fac := :Número_de_factura;
    v_cod_pro := :Código_de_producto;
    
    -- Verifica si el detalle existe
    SELECT COUNT(*) INTO v_existe
    FROM DETALLE_FACTURA
    WHERE NUM_FAC = v_num_fac 
    AND COD_PRO = v_cod_pro;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos el detalle de factura
    DELETE FROM DETALLE_FACTURA 
    WHERE NUM_FAC = v_num_fac 
    AND COD_PRO = v_cod_pro;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de factura eliminado correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El detalle de factura no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el detalle de factura: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: ORDEN_COMPRA
-- =========================================
-- Se debe correr estos SELECTs antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM ORDEN_COMPRA;
SELECT * FROM DETALLE_COMPRA;

-- SELECTs de verificación después de eliminados
SELECT * FROM DETALLE_COMPRA WHERE NUM_OCO = 'X';

DECLARE
    v_num_oco       ORDEN_COMPRA.NUM_OCO%TYPE;  -- Número de orden de compra a eliminar
    v_existe        NUMBER;                      -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                   -- Excepción personalizada para código no existente
BEGIN
    -- Captura el número de orden de compra a eliminar
    v_num_oco := :Número_de_orden_de_compra;
    
    -- Verifica si la orden existe
    SELECT COUNT(*) INTO v_existe
    FROM ORDEN_COMPRA
    WHERE NUM_OCO = v_num_oco;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos los registros relacionados en orden
    -- Primero los detalles de compra
    DELETE FROM DETALLE_COMPRA WHERE NUM_OCO = v_num_oco;
    
    -- Finalmente borramos la orden de compra
    DELETE FROM ORDEN_COMPRA WHERE NUM_OCO = v_num_oco;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Orden de compra y sus detalles eliminados correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El número de orden de compra ' || v_num_oco || ' no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar la orden de compra: ' || SQLERRM);
END;
/

-- =========================================
-- SECCIÓN: DETALLE_COMPRA
-- =========================================
-- Se debe correr estos SELECTs antes de ejecutar el bloque PL/SQL correspondiente
SELECT * FROM DETALLE_COMPRA;
SELECT * FROM PRODUCTO;

-- SELECTs de verificación después de eliminados
SELECT * FROM PRODUCTO WHERE COD_PRO = 'X';

DECLARE
    v_num_oco       DETALLE_COMPRA.NUM_OCO%TYPE;  -- Número de orden de compra del detalle a eliminar
    v_cod_pro       DETALLE_COMPRA.COD_PRO%TYPE;  -- Código del producto del detalle a eliminar
    v_existe        NUMBER;                        -- Flag para verificar si existe el registro (1=existe, 0=no existe)
    e_cod_no_existe EXCEPTION;                     -- Excepción personalizada para código no existente
BEGIN
    -- Captura el número de orden de compra y código de producto a eliminar
    v_num_oco := :Número_de_orden_de_compra;
    v_cod_pro := :Código_de_producto;
    
    -- Verifica si el detalle existe
    SELECT COUNT(*) INTO v_existe
    FROM DETALLE_COMPRA
    WHERE NUM_OCO = v_num_oco 
    AND COD_PRO = v_cod_pro;
    
    IF v_existe = 0 THEN
        RAISE e_cod_no_existe;
    END IF;
    
    -- Borramos el detalle de compra
    DELETE FROM DETALLE_COMPRA 
    WHERE NUM_OCO = v_num_oco 
    AND COD_PRO = v_cod_pro;
    
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de compra eliminado correctamente.');
EXCEPTION
    WHEN e_cod_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El detalle de compra no existe.');
    WHEN OTHERS THEN
        -- Hacer rollback en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el detalle de compra: ' || SQLERRM);
END;
/