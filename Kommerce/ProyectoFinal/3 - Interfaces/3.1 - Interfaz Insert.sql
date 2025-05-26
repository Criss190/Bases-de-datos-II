-- =========================================
-- INTERFAZ DE INSERCIÓN DE DATOS
-- Archivo: 3.1 - Interfaz Insert.sql
-- Descripción: Bloques PL/SQL para insertar registros en las tablas principales
-- =========================================

-- =========================================
-- SECCIÓN: CLIENTE
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_DIS, NOM_DIS FROM DISTRITO;
DECLARE
    -- Declaración de variables para CLIENTE
    v_cod_cli   CLIENTE.COD_CLI%TYPE;
    v_rso_cli   CLIENTE.RSO_CLI%TYPE;
    v_dir_cli   CLIENTE.DIR_CLI%TYPE;
    v_tlf_cli   CLIENTE.TLF_CLI%TYPE;
    v_ruc_cli   CLIENTE.RUC_CLI%TYPE;
    v_cod_dis   CLIENTE.COD_DIS%TYPE;
    v_fec_reg   CLIENTE.FEC_REG%TYPE;
    v_tip_cli   CLIENTE.TIP_CLI%TYPE;
    v_con_cli   CLIENTE.CON_CLI%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    -- Asignación de valores (reemplazar por los datos reales)
    v_cod_cli := :Codigo_del_cliente;
    v_rso_cli := :Razon_social;
    v_dir_cli := :Direccion;
    v_tlf_cli := :Telefono;
    v_ruc_cli := :RUC;
    v_cod_dis := :Codigo_de_distrito;
    v_fec_reg := TO_DATE(:Fecha_de_registro, 'DD/MM/YYYY');
    v_tip_cli := :Tipo_de_cliente;
    v_con_cli := :Contacto;
    -- Validación de datos obligatorios
    IF v_cod_cli IS NULL OR v_rso_cli IS NULL OR v_dir_cli IS NULL OR v_tlf_cli IS NULL OR v_ruc_cli IS NULL OR v_cod_dis IS NULL OR v_fec_reg IS NULL OR v_tip_cli IS NULL OR v_con_cli IS NULL THEN
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO CLIENTE (COD_CLI, RSO_CLI, DIR_CLI, TLF_CLI, RUC_CLI, COD_DIS, FEC_REG, TIP_CLI, CON_CLI)
    VALUES (v_cod_cli, v_rso_cli, v_dir_cli, v_tlf_cli, v_ruc_cli, v_cod_dis, v_fec_reg, v_tip_cli, v_con_cli);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cliente insertado correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/

-- =========================================
-- SECCIÓN: DISTRITO
-- =========================================
DECLARE
    -- Declaración de variables para DISTRITO
    v_cod_dis DISTRITO.COD_DIS%TYPE;
    v_nom_dis DISTRITO.NOM_DIS%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    v_cod_dis := :Codigo_de_distrito;
    v_nom_dis := :Nombre_del_distrito;
    IF v_cod_dis IS NULL OR v_nom_dis IS NULL THEN
        -- Lanza excepción si falta un dato obligatorio
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO DISTRITO (COD_DIS, NOM_DIS) VALUES (v_cod_dis, v_nom_dis);
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Distrito insertado correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/

-- =========================================
-- SECCIÓN: PROVEEDOR
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_DIS, NOM_DIS FROM DISTRITO;
DECLARE
    -- Declaración de variables para PROVEEDOR
    v_cod_prv PROVEEDOR.COD_PRV%TYPE;
    v_rso_prv PROVEEDOR.RSO_PRV%TYPE;
    v_dir_prv PROVEEDOR.DIR_PRV%TYPE;
    v_tel_prv PROVEEDOR.TEL_PRV%TYPE;
    v_cod_dis PROVEEDOR.COD_DIS%TYPE;
    v_rep_prv PROVEEDOR.REP_PRV%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    -- Asignación de valores (reemplazar por los datos reales)
    v_cod_prv := :Codigo_de_proveedor;
    v_rso_prv := :Razon_social;
    v_dir_prv := :Direccion;
    v_tel_prv := :Telefono;
    v_cod_dis := :Codigo_de_distrito;
    v_rep_prv := :Representante;
    -- Validación de datos obligatorios
    IF v_cod_prv IS NULL OR v_rso_prv IS NULL OR v_dir_prv IS NULL OR v_tel_prv IS NULL OR v_cod_dis IS NULL OR v_rep_prv IS NULL THEN
        -- Lanza excepción si falta un dato obligatorio
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO PROVEEDOR (COD_PRV, RSO_PRV, DIR_PRV, TEL_PRV, COD_DIS, REP_PRV)
    VALUES (v_cod_prv, v_rso_prv, v_dir_prv, v_tel_prv, v_cod_dis, v_rep_prv);
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proveedor insertado correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/

-- =========================================
-- SECCIÓN: PRODUCTO
-- =========================================
DECLARE
    -- Declaración de variables para PRODUCTO
    v_cod_pro PRODUCTO.COD_PRO%TYPE;
    v_des_pro PRODUCTO.DES_PRO%TYPE;
    v_pre_pro PRODUCTO.PRE_PRO%TYPE;
    v_sac_pro PRODUCTO.SAC_PRO%TYPE;
    v_sml_pro PRODUCTO.SML_PRO%TYPE;
    v_unl_pro PRODUCTO.UNL_PRO%TYPE;
    v_lin_pro PRODUCTO.LIN_PRO%TYPE;
    v_imp_pro PRODUCTO.IMP_PRO%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    -- Asignación de valores (reemplazar por los datos reales)
    v_cod_pro := :Codigo_de_producto;
    v_des_pro := :Descripcion;
    v_pre_pro := :Precio;
    v_sac_pro := :Stock_actual;
    v_sml_pro := :Stock_minimo;
    v_unl_pro := :Unidad_de_lote;
    v_lin_pro := :Linea_de_producto;
    v_imp_pro := :Impuesto;
    -- Validación de datos obligatorios
    IF v_cod_pro IS NULL OR v_des_pro IS NULL OR v_pre_pro IS NULL OR v_sac_pro IS NULL OR v_sml_pro IS NULL OR v_unl_pro IS NULL OR v_lin_pro IS NULL OR v_imp_pro IS NULL THEN
        -- Lanza excepción si falta un dato obligatorio
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO PRODUCTO (COD_PRO, DES_PRO, PRE_PRO, SAC_PRO, SML_PRO, UNL_PRO, LIN_PRO, IMP_PRO)
    VALUES (v_cod_pro, v_des_pro, v_pre_pro, v_sac_pro, v_sml_pro, v_unl_pro, v_lin_pro, v_imp_pro);
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Producto insertado correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/

-- =========================================
-- SECCIÓN: ABASTECIMIENTO
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_PRV, RSO_PRV FROM PROVEEDOR;
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_PRO, DES_PRO FROM PRODUCTO;
DECLARE
    -- Declaración de variables para ABASTECIMIENTO
    v_cod_prv ABASTECIMIENTO.COD_PRV%TYPE;
    v_cod_pro ABASTECIMIENTO.COD_PRO%TYPE;
    v_pre_aba ABASTECIMIENTO.PRE_ABA%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    -- Asignación de valores (reemplazar por los datos reales)
    v_cod_prv := :Codigo_de_proveedor;
    v_cod_pro := :Codigo_de_producto;
    v_pre_aba := :Precio_de_abastecimiento;
    -- Validación de datos obligatorios
    IF v_cod_prv IS NULL OR v_cod_pro IS NULL OR v_pre_aba IS NULL THEN
        -- Lanza excepción si falta un dato obligatorio
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO ABASTECIMIENTO (COD_PRV, COD_PRO, PRE_ABA)
    VALUES (v_cod_prv, v_cod_pro, v_pre_aba);
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Abastecimiento insertado correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/

-- =========================================
-- SECCIÓN: VENDEDOR
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_DIS, NOM_DIS FROM DISTRITO;
DECLARE
    -- Declaración de variables para VENDEDOR
    v_cod_ven VENDEDOR.COD_VEN%TYPE;
    v_nom_ven VENDEDOR.NOM_VEN%TYPE;
    v_ape_ven VENDEDOR.APE_VEN%TYPE;
    v_sue_ven VENDEDOR.SUE_VEN%TYPE;
    v_fin_ven VENDEDOR.FIN_VEN%TYPE;
    v_tip_ven VENDEDOR.TIP_VEN%TYPE;
    v_cod_dis VENDEDOR.COD_DIS%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    -- Asignación de valores (reemplazar por los datos reales)
    v_cod_ven := :Codigo_de_vendedor;
    v_nom_ven := :Nombre;
    v_ape_ven := :Apellido;
    v_sue_ven := :Sueldo;
    v_fin_ven := TO_DATE(:Fecha_de_ingreso, 'DD/MM/YYYY');
    v_tip_ven := :Tipo_de_vendedor;
    v_cod_dis := :Codigo_de_distrito;
    -- Validación de datos obligatorios
    IF v_cod_ven IS NULL OR v_nom_ven IS NULL OR v_ape_ven IS NULL OR v_sue_ven IS NULL OR v_fin_ven IS NULL OR v_tip_ven IS NULL OR v_cod_dis IS NULL THEN
        -- Lanza excepción si falta un dato obligatorio
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO VENDEDOR (COD_VEN, NOM_VEN, APE_VEN, SUE_VEN, FIN_VEN, TIP_VEN, COD_DIS)
    VALUES (v_cod_ven, v_nom_ven, v_ape_ven, v_sue_ven, v_fin_ven, v_tip_ven, v_cod_dis);
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vendedor insertado correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/

-- =========================================
-- SECCIÓN: FACTURA
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_CLI, RSO_CLI FROM CLIENTE;
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_VEN, NOM_VEN FROM VENDEDOR;
DECLARE
    -- Declaración de variables para FACTURA
    v_num_fac FACTURA.NUM_FAC%TYPE;
    v_fec_fac FACTURA.FEC_FAC%TYPE;
    v_cod_cli FACTURA.COD_CLI%TYPE;
    v_fec_can FACTURA.FEC_CAN%TYPE;
    v_est_fac FACTURA.EST_FAC%TYPE;
    v_cod_ven FACTURA.COD_VEN%TYPE;
    v_por_jgv FACTURA.POR_JGV%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    -- Asignación de valores (reemplazar por los datos reales)
    v_num_fac := :Numero_de_factura;
    v_fec_fac := TO_DATE(:Fecha_de_factura, 'DD/MM/YYYY');
    v_cod_cli := :Codigo_de_cliente;
    v_fec_can := TO_DATE(:Fecha_de_cancelacion, 'DD/MM/YYYY');
    v_est_fac := :Estado_de_factura;
    v_cod_ven := :Codigo_de_vendedor;
    v_por_jgv := :Porcentaje_JGV;
    -- Validación de datos obligatorios
    IF v_num_fac IS NULL OR v_fec_fac IS NULL OR v_cod_cli IS NULL OR v_fec_can IS NULL OR v_est_fac IS NULL OR v_cod_ven IS NULL OR v_por_jgv IS NULL THEN
        -- Lanza excepción si falta un dato obligatorio
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO FACTURA (NUM_FAC, FEC_FAC, COD_CLI, FEC_CAN, EST_FAC, COD_VEN, POR_JGV)
    VALUES (v_num_fac, v_fec_fac, v_cod_cli, v_fec_can, v_est_fac, v_cod_ven, v_por_jgv);
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Factura insertada correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/

-- =========================================
-- SECCIÓN: DETALLE_FACTURA
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_PRO, DES_PRO FROM PRODUCTO;
DECLARE
    -- Declaración de variables para DETALLE_FACTURA
    v_num_fac DETALLE_FACTURA.NUM_FAC%TYPE;
    v_cod_pro DETALLE_FACTURA.COD_PRO%TYPE;
    v_can_ven DETALLE_FACTURA.CAN_VEN%TYPE;
    v_pre_ven DETALLE_FACTURA.PRE_VEN%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    -- Asignación de valores (reemplazar por los datos reales)
    v_num_fac := :Numero_de_factura;
    v_cod_pro := :Codigo_de_producto;
    v_can_ven := :Cantidad_vendida;
    v_pre_ven := :Precio_de_venta;
    -- Validación de datos obligatorios
    IF v_num_fac IS NULL OR v_cod_pro IS NULL OR v_can_ven IS NULL OR v_pre_ven IS NULL THEN
        -- Lanza excepción si falta un dato obligatorio
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO DETALLE_FACTURA (NUM_FAC, COD_PRO, CAN_VEN, PRE_VEN)
    VALUES (v_num_fac, v_cod_pro, v_can_ven, v_pre_ven);
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de factura insertado correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/

-- =========================================
-- SECCIÓN: DETALLE_COMPRA
-- =========================================
-- Se debe correr este SELECT antes de ejecutar el bloque PL/SQL correspondiente
SELECT COD_PRO, DES_PRO FROM PRODUCTO;
DECLARE
    v_num_oco DETALLE_COMPRA.NUM_OCO%TYPE;
    v_cod_pro DETALLE_COMPRA.COD_PRO%TYPE;
    v_can_det DETALLE_COMPRA.CAN_DET%TYPE;
    e_dato_faltante EXCEPTION;
BEGIN
    v_num_oco := :Numero_de_orden_de_compra;
    v_cod_pro := :Codigo_de_producto;
    v_can_det := :Cantidad_comprada;
    IF v_num_oco IS NULL OR v_cod_pro IS NULL OR v_can_det IS NULL THEN
        -- Lanza excepción si falta un dato obligatorio
        RAISE e_dato_faltante;
    END IF;
    INSERT INTO DETALLE_COMPRA (NUM_OCO, COD_PRO, CAN_DET)
    VALUES (v_num_oco, v_cod_pro, v_can_det);
    -- Guarda los cambios de forma permanente
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de compra insertado correctamente.');
EXCEPTION
    WHEN e_dato_faltante THEN
        DBMS_OUTPUT.PUT_LINE('Error: Debe ingresar todos los datos. No se realizó la inserción.');
END;
/