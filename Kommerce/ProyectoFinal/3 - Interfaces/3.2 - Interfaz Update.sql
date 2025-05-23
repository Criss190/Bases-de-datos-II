-- CLIENTE
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM CLIENTE;

DECLARE
    v_cod_cli   CLIENTE.COD_CLI%TYPE := 'C001'; -- Código del cliente a modificar (OBLIGATORIO)
    v_rso_cli   CLIENTE.RSO_CLI%TYPE;
    v_dir_cli   CLIENTE.DIR_CLI%TYPE;
    v_tlf_cli   CLIENTE.TLF_CLI%TYPE;
    v_ruc_cli   CLIENTE.RUC_CLI%TYPE;
    v_cod_dis   CLIENTE.COD_DIS%TYPE;
    v_fec_reg   CLIENTE.FEC_REG%TYPE;
    v_tip_cli   CLIENTE.TIP_CLI%TYPE;
    v_con_cli   CLIENTE.CON_CLI%TYPE;

    -- Variables para almacenar valores actuales
    v_rso_cli_actual   CLIENTE.RSO_CLI%TYPE;
    v_dir_cli_actual   CLIENTE.DIR_CLI%TYPE;
    v_tlf_cli_actual   CLIENTE.TLF_CLI%TYPE;
    v_ruc_cli_actual   CLIENTE.RUC_CLI%TYPE;
    v_cod_dis_actual   CLIENTE.COD_DIS%TYPE;
    v_fec_reg_actual   CLIENTE.FEC_REG%TYPE;
    v_tip_cli_actual   CLIENTE.TIP_CLI%TYPE;
    v_con_cli_actual   CLIENTE.CON_CLI%TYPE;

    -- Variables para entrada de nuevos valores
    v_rso_cli_nuevo   VARCHAR2(30);
    v_dir_cli_nuevo   VARCHAR2(100);
    v_tlf_cli_nuevo   VARCHAR2(9);
    v_ruc_cli_nuevo   VARCHAR2(11);
    v_cod_dis_nuevo   VARCHAR2(5);
    v_fec_reg_nuevo   VARCHAR2(10);     -- Para almacenar la fecha en formato DD-MM-YYYY
    v_tip_cli_nuevo   VARCHAR2(10);
    v_con_cli_nuevo   VARCHAR2(30);

    -- Variables para validación
    v_distrito_existe NUMBER;
    
    -- Excepciones personalizadas
    e_distrito_no_existe EXCEPTION;
    e_codigo_cliente_null EXCEPTION;
BEGIN
    -- Validar que se haya ingresado el código del cliente
    IF v_cod_cli IS NULL OR v_cod_cli = '' THEN
        RAISE e_codigo_cliente_null;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT RSO_CLI, DIR_CLI, TLF_CLI, RUC_CLI, COD_DIS, FEC_REG, TIP_CLI, CON_CLI
      INTO v_rso_cli_actual, v_dir_cli_actual, v_tlf_cli_actual, v_ruc_cli_actual, 
           v_cod_dis_actual, v_fec_reg_actual, v_tip_cli_actual, v_con_cli_actual
      FROM CLIENTE 
     WHERE COD_CLI = v_cod_cli;

    -- Solicitar nuevos valores
    v_rso_cli_nuevo := :RazonSocial_VARCHAR_30;
    v_dir_cli_nuevo := :Direccion_VARCHAR_100;
    v_tlf_cli_nuevo := :Telefono_CHAR_9;
    v_ruc_cli_nuevo := :RUC_CHAR_11;
    v_cod_dis_nuevo := :CodigoDistrito_D00;
    v_fec_reg_nuevo := :DD_MM_YYYY;
    v_tip_cli_nuevo := :TipoCliente_1_2;
    v_con_cli_nuevo := :Contacto_VARCHAR_30;
    
    -- Asignar valores por defecto si están vacíos
    v_rso_cli := NVL(NULLIF(TRIM(v_rso_cli_nuevo), ''), v_rso_cli_actual);
    v_dir_cli := NVL(NULLIF(TRIM(v_dir_cli_nuevo), ''), v_dir_cli_actual);
    v_tlf_cli := NVL(NULLIF(TRIM(v_tlf_cli_nuevo), ''), v_tlf_cli_actual);
    v_ruc_cli := NVL(NULLIF(TRIM(v_ruc_cli_nuevo), ''), v_ruc_cli_actual);
    v_cod_dis := NVL(NULLIF(TRIM(v_cod_dis_nuevo), ''), v_cod_dis_actual);
    v_fec_reg := NVL(TO_DATE(NULLIF(TRIM(v_fec_reg_nuevo), ''), 'DD-MM-YYYY'), v_fec_reg_actual);
    v_tip_cli := NVL(NULLIF(TRIM(v_tip_cli_nuevo), ''), v_tip_cli_actual);
    v_con_cli := NVL(NULLIF(TRIM(v_con_cli_nuevo), ''), v_con_cli_actual);

    -- Si se está cambiando el distrito, validar que exista
    IF TRIM(v_cod_dis) != TRIM(v_cod_dis_actual) AND TRIM(v_cod_dis) IS NOT NULL THEN
        SELECT COUNT(*) INTO v_distrito_existe
        FROM DISTRITO WHERE COD_DIS = TRIM(v_cod_dis);
        
        IF v_distrito_existe = 0 THEN
            RAISE e_distrito_no_existe;
        END IF;
    END IF;

    -- Actualizar el cliente
    UPDATE CLIENTE SET
        RSO_CLI = v_rso_cli,
        DIR_CLI = v_dir_cli,
        TLF_CLI = v_tlf_cli,
        RUC_CLI = v_ruc_cli,
        COD_DIS = v_cod_dis,
        FEC_REG = v_fec_reg,
        TIP_CLI = v_tip_cli,
        CON_CLI = v_con_cli
    WHERE COD_CLI = v_cod_cli;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cliente actualizado correctamente.');

EXCEPTION
    WHEN e_codigo_cliente_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el código del cliente a modificar');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe un cliente con el código ' || v_cod_cli);
    WHEN e_distrito_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: El distrito con código ' || v_cod_dis || ' no existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- DISTRITO
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM DISTRITO;

DECLARE
    v_cod_dis   DISTRITO.COD_DIS%TYPE := 'D01'; -- Código del distrito a modificar (OBLIGATORIO)
    v_nom_dis   DISTRITO.NOM_DIS%TYPE;

    -- Variables para almacenar valores actuales
    v_nom_dis_actual   DISTRITO.NOM_DIS%TYPE;

    -- Variables para entrada de nuevos valores
    v_nom_dis_nuevo   VARCHAR2(50);
    
    -- Excepciones personalizadas
    e_codigo_distrito_null EXCEPTION;
BEGIN
    -- Validar que se haya ingresado el código del distrito
    IF v_cod_dis IS NULL OR v_cod_dis = '' THEN
        RAISE e_codigo_distrito_null;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT NOM_DIS
      INTO v_nom_dis_actual
      FROM DISTRITO 
     WHERE COD_DIS = v_cod_dis;

    -- Solicitar nuevos valores
    v_nom_dis_nuevo := :NombreDistrito_VARCHAR_50;
    
    -- Asignar valores por defecto si están vacíos
    v_nom_dis := NVL(NULLIF(TRIM(v_nom_dis_nuevo), ''), v_nom_dis_actual);

    -- Actualizar el distrito
    UPDATE DISTRITO SET
        NOM_DIS = v_nom_dis
    WHERE COD_DIS = v_cod_dis;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Distrito actualizado correctamente.');

EXCEPTION
    WHEN e_codigo_distrito_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el código del distrito a modificar');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe un distrito con el código ' || v_cod_dis);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- PROVEEDOR
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM PROVEEDOR;

DECLARE
    v_cod_prv   PROVEEDOR.COD_PRV%TYPE := 'P001'; -- Código del proveedor a modificar (OBLIGATORIO)
    v_rso_prv   PROVEEDOR.RSO_PRV%TYPE;
    v_dir_prv   PROVEEDOR.DIR_PRV%TYPE;
    v_tel_prv   PROVEEDOR.TEL_PRV%TYPE;
    v_cod_dis   PROVEEDOR.COD_DIS%TYPE;
    v_rep_prv   PROVEEDOR.REP_PRV%TYPE;

    -- Variables para almacenar valores actuales
    v_rso_prv_actual   PROVEEDOR.RSO_PRV%TYPE;
    v_dir_prv_actual   PROVEEDOR.DIR_PRV%TYPE;
    v_tel_prv_actual   PROVEEDOR.TEL_PRV%TYPE;
    v_cod_dis_actual   PROVEEDOR.COD_DIS%TYPE;
    v_rep_prv_actual   PROVEEDOR.REP_PRV%TYPE;

    -- Variables para entrada de nuevos valores
    v_rso_prv_nuevo   VARCHAR2(30);
    v_dir_prv_nuevo   VARCHAR2(100);
    v_tel_prv_nuevo   VARCHAR2(15);
    v_cod_dis_nuevo   VARCHAR2(5);
    v_rep_prv_nuevo   VARCHAR2(80);

    -- Variables para validación
    v_distrito_existe NUMBER;
    
    -- Excepciones personalizadas
    e_distrito_no_existe EXCEPTION;
    e_codigo_proveedor_null EXCEPTION;
BEGIN
    -- Validar que se haya ingresado el código del proveedor
    IF v_cod_prv IS NULL OR v_cod_prv = '' THEN
        RAISE e_codigo_proveedor_null;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT RSO_PRV, DIR_PRV, TEL_PRV, COD_DIS, REP_PRV
      INTO v_rso_prv_actual, v_dir_prv_actual, v_tel_prv_actual, 
           v_cod_dis_actual, v_rep_prv_actual
      FROM PROVEEDOR 
     WHERE COD_PRV = v_cod_prv;

    -- Solicitar nuevos valores
    v_rso_prv_nuevo := :RazonSocial_VARCHAR_30;
    v_dir_prv_nuevo := :Direccion_VARCHAR_100;
    v_tel_prv_nuevo := :Telefono_CHAR_15;
    v_cod_dis_nuevo := :CodigoDistrito_D00;
    v_rep_prv_nuevo := :Representante_VARCHAR_80;
    
    -- Asignar valores por defecto si están vacíos
    v_rso_prv := NVL(NULLIF(TRIM(v_rso_prv_nuevo), ''), v_rso_prv_actual);
    v_dir_prv := NVL(NULLIF(TRIM(v_dir_prv_nuevo), ''), v_dir_prv_actual);
    v_tel_prv := NVL(NULLIF(TRIM(v_tel_prv_nuevo), ''), v_tel_prv_actual);
    v_cod_dis := NVL(NULLIF(TRIM(v_cod_dis_nuevo), ''), v_cod_dis_actual);
    v_rep_prv := NVL(NULLIF(TRIM(v_rep_prv_nuevo), ''), v_rep_prv_actual);

    -- Si se está cambiando el distrito, validar que exista
    IF TRIM(v_cod_dis) != TRIM(v_cod_dis_actual) AND TRIM(v_cod_dis) IS NOT NULL THEN
        SELECT COUNT(*) INTO v_distrito_existe
        FROM DISTRITO WHERE COD_DIS = TRIM(v_cod_dis);
        
        IF v_distrito_existe = 0 THEN
            RAISE e_distrito_no_existe;
        END IF;
    END IF;

    -- Actualizar el proveedor
    UPDATE PROVEEDOR SET
        RSO_PRV = v_rso_prv,
        DIR_PRV = v_dir_prv,
        TEL_PRV = v_tel_prv,
        COD_DIS = v_cod_dis,
        REP_PRV = v_rep_prv
    WHERE COD_PRV = v_cod_prv;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proveedor actualizado correctamente.');

EXCEPTION
    WHEN e_codigo_proveedor_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el código del proveedor a modificar');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe un proveedor con el código ' || v_cod_prv);
    WHEN e_distrito_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: El distrito con código ' || v_cod_dis || ' no existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- PRODUCTO
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM PRODUCTO;

DECLARE
    v_cod_pro   PRODUCTO.COD_PRO%TYPE := 'P001'; -- Código del producto a modificar (OBLIGATORIO)
    v_des_pro   PRODUCTO.DES_PRO%TYPE;
    v_pre_pro   PRODUCTO.PRE_PRO%TYPE;
    v_sac_pro   PRODUCTO.SAC_PRO%TYPE;
    v_sml_pro   PRODUCTO.SML_PRO%TYPE;
    v_unl_pro   PRODUCTO.UNL_PRO%TYPE;
    v_lin_pro   PRODUCTO.LIN_PRO%TYPE;
    v_imp_pro   PRODUCTO.IMP_PRO%TYPE;

    -- Variables para almacenar valores actuales
    v_des_pro_actual   PRODUCTO.DES_PRO%TYPE;
    v_pre_pro_actual   PRODUCTO.PRE_PRO%TYPE;
    v_sac_pro_actual   PRODUCTO.SAC_PRO%TYPE;
    v_sml_pro_actual   PRODUCTO.SML_PRO%TYPE;
    v_unl_pro_actual   PRODUCTO.UNL_PRO%TYPE;
    v_lin_pro_actual   PRODUCTO.LIN_PRO%TYPE;
    v_imp_pro_actual   PRODUCTO.IMP_PRO%TYPE;

    -- Variables para entrada de nuevos valores
    v_des_pro_nuevo   VARCHAR2(50);
    v_pre_pro_nuevo   VARCHAR2(20);    -- Para NUMERIC(10,2)
    v_sac_pro_nuevo   VARCHAR2(10);    -- Para INT
    v_sml_pro_nuevo   VARCHAR2(10);    -- Para INT
    v_unl_pro_nuevo   VARCHAR2(30);
    v_lin_pro_nuevo   VARCHAR2(30);
    v_imp_pro_nuevo   VARCHAR2(10);

    -- Excepciones personalizadas
    e_valor_numerico EXCEPTION;
    e_codigo_producto_null EXCEPTION;
BEGIN
    -- Validar que se haya ingresado el código del producto
    IF v_cod_pro IS NULL OR v_cod_pro = '' THEN
        RAISE e_codigo_producto_null;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT DES_PRO, PRE_PRO, SAC_PRO, SML_PRO, UNL_PRO, LIN_PRO, IMP_PRO
      INTO v_des_pro_actual, v_pre_pro_actual, v_sac_pro_actual, 
           v_sml_pro_actual, v_unl_pro_actual, v_lin_pro_actual, v_imp_pro_actual
      FROM PRODUCTO 
     WHERE COD_PRO = v_cod_pro;

    -- Solicitar nuevos valores
    v_des_pro_nuevo := :Descripcion_VARCHAR_50;
    v_pre_pro_nuevo := :Precio_NUMERIC_10_2;
    v_sac_pro_nuevo := :StockActual_INT;
    v_sml_pro_nuevo := :StockMinimo_INT;
    v_unl_pro_nuevo := :UnidadLote_VARCHAR_30;
    v_lin_pro_nuevo := :LineaProducto_VARCHAR_30;
    v_imp_pro_nuevo := :Impuesto_VARCHAR_10;
    
    -- Asignar valores por defecto si están vacíos
    v_des_pro := NVL(NULLIF(TRIM(v_des_pro_nuevo), ''), v_des_pro_actual);
    v_pre_pro := NVL(TO_NUMBER(NULLIF(TRIM(v_pre_pro_nuevo), '')), v_pre_pro_actual);
    v_sac_pro := NVL(TO_NUMBER(NULLIF(TRIM(v_sac_pro_nuevo), '')), v_sac_pro_actual);
    v_sml_pro := NVL(TO_NUMBER(NULLIF(TRIM(v_sml_pro_nuevo), '')), v_sml_pro_actual);
    v_unl_pro := NVL(NULLIF(TRIM(v_unl_pro_nuevo), ''), v_unl_pro_actual);
    v_lin_pro := NVL(NULLIF(TRIM(v_lin_pro_nuevo), ''), v_lin_pro_actual);
    v_imp_pro := NVL(NULLIF(TRIM(v_imp_pro_nuevo), ''), v_imp_pro_actual);

    -- Actualizar el producto
    UPDATE PRODUCTO SET
        DES_PRO = v_des_pro,
        PRE_PRO = v_pre_pro,
        SAC_PRO = v_sac_pro,
        SML_PRO = v_sml_pro,
        UNL_PRO = v_unl_pro,
        LIN_PRO = v_lin_pro,
        IMP_PRO = v_imp_pro
    WHERE COD_PRO = v_cod_pro;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Producto actualizado correctamente.');

EXCEPTION
    WHEN e_codigo_producto_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el código del producto a modificar');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe un producto con el código ' || v_cod_pro);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Valor numérico inválido en precio, stock actual o stock mínimo.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ABASTECIMIENTO
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM ABASTECIMIENTO;

DECLARE
    v_cod_prv   ABASTECIMIENTO.COD_PRV%TYPE := 'PR01'; -- Código del proveedor a modificar (OBLIGATORIO)
    v_cod_pro   ABASTECIMIENTO.COD_PRO%TYPE := 'P003'; -- Código del producto a modificar (OBLIGATORIO)
    v_pre_aba   ABASTECIMIENTO.PRE_ABA%TYPE;

    -- Variables para almacenar valores actuales
    v_pre_aba_actual   ABASTECIMIENTO.PRE_ABA%TYPE;

    -- Variables para entrada de nuevos valores
    v_pre_aba_nuevo   VARCHAR2(20);    -- Para NUMERIC(10,2)

    -- Variables para validación
    v_abastecimiento_existe NUMBER;
    
    -- Excepciones personalizadas
    e_no_existe EXCEPTION;
    e_codigo_proveedor_null EXCEPTION;
    e_codigo_producto_null EXCEPTION;
BEGIN
    -- Validar que se hayan ingresado los códigos
    IF v_cod_prv IS NULL OR v_cod_prv = '' THEN
        RAISE e_codigo_proveedor_null;
    END IF;
    
    IF v_cod_pro IS NULL OR v_cod_pro = '' THEN
        RAISE e_codigo_producto_null;
    END IF;

    -- Verificar que exista el registro
    SELECT COUNT(*)
      INTO v_abastecimiento_existe
      FROM ABASTECIMIENTO 
     WHERE COD_PRV = v_cod_prv 
       AND COD_PRO = v_cod_pro;

    IF v_abastecimiento_existe = 0 THEN
        RAISE e_no_existe;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT PRE_ABA
      INTO v_pre_aba_actual
      FROM ABASTECIMIENTO 
     WHERE COD_PRV = v_cod_prv 
       AND COD_PRO = v_cod_pro;

    -- Solicitar nuevos valores
    v_pre_aba_nuevo := :PrecioAbastecimiento_NUMERIC_10_2;
    
    -- Asignar valores por defecto si están vacíos
    v_pre_aba := NVL(TO_NUMBER(NULLIF(TRIM(v_pre_aba_nuevo), '')), v_pre_aba_actual);

    -- Actualizar el abastecimiento
    UPDATE ABASTECIMIENTO SET
        PRE_ABA = v_pre_aba
    WHERE COD_PRV = v_cod_prv 
      AND COD_PRO = v_cod_pro;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Abastecimiento actualizado correctamente.');

EXCEPTION
    WHEN e_codigo_proveedor_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el código del proveedor a modificar');
    WHEN e_codigo_producto_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el código del producto a modificar');
    WHEN e_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe un registro de abastecimiento para el proveedor ' || 
                            v_cod_prv || ' y producto ' || v_cod_pro);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Valor numérico inválido en precio de abastecimiento.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- VENDEDOR
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM VENDEDOR;

DECLARE
    v_cod_ven   VENDEDOR.COD_VEN%TYPE := 'V01'; -- Código del vendedor a modificar (OBLIGATORIO)
    v_nom_ven   VENDEDOR.NOM_VEN%TYPE;
    v_ape_ven   VENDEDOR.APE_VEN%TYPE;
    v_sue_ven   VENDEDOR.SUE_VEN%TYPE;
    v_fin_ven   VENDEDOR.FIN_VEN%TYPE;
    v_tip_ven   VENDEDOR.TIP_VEN%TYPE;
    v_cod_dis   VENDEDOR.COD_DIS%TYPE;

    -- Variables para almacenar valores actuales
    v_nom_ven_actual   VENDEDOR.NOM_VEN%TYPE;
    v_ape_ven_actual   VENDEDOR.APE_VEN%TYPE;
    v_sue_ven_actual   VENDEDOR.SUE_VEN%TYPE;
    v_fin_ven_actual   VENDEDOR.FIN_VEN%TYPE;
    v_tip_ven_actual   VENDEDOR.TIP_VEN%TYPE;
    v_cod_dis_actual   VENDEDOR.COD_DIS%TYPE;

    -- Variables para entrada de nuevos valores
    v_nom_ven_nuevo   VARCHAR2(20);
    v_ape_ven_nuevo   VARCHAR2(20);
    v_sue_ven_nuevo   VARCHAR2(20);    -- Para NUMERIC(10,2)
    v_fin_ven_nuevo   VARCHAR2(10);    -- Para almacenar la fecha en formato DD-MM-YYYY
    v_tip_ven_nuevo   VARCHAR2(10);
    v_cod_dis_nuevo   VARCHAR2(5);

    -- Variables para validación
    v_distrito_existe NUMBER;
    
    -- Excepciones personalizadas
    e_distrito_no_existe EXCEPTION;
    e_codigo_vendedor_null EXCEPTION;
BEGIN
    -- Validar que se haya ingresado el código del vendedor
    IF v_cod_ven IS NULL OR v_cod_ven = '' THEN
        RAISE e_codigo_vendedor_null;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT NOM_VEN, APE_VEN, SUE_VEN, FIN_VEN, TIP_VEN, COD_DIS
      INTO v_nom_ven_actual, v_ape_ven_actual, v_sue_ven_actual,
           v_fin_ven_actual, v_tip_ven_actual, v_cod_dis_actual
      FROM VENDEDOR 
     WHERE COD_VEN = v_cod_ven;

    -- Solicitar nuevos valores
    v_nom_ven_nuevo := :Nombre_VARCHAR_20;
    v_ape_ven_nuevo := :Apellido_VARCHAR_20;
    v_sue_ven_nuevo := :Sueldo_NUMERIC_10_2;
    v_fin_ven_nuevo := :FechaIngreso_DD_MM_YYYY;
    v_tip_ven_nuevo := :TipoVendedor_VARCHAR_10;
    v_cod_dis_nuevo := :CodigoDistrito_CHAR_5;
    
    -- Asignar valores por defecto si están vacíos
    v_nom_ven := NVL(NULLIF(TRIM(v_nom_ven_nuevo), ''), v_nom_ven_actual);
    v_ape_ven := NVL(NULLIF(TRIM(v_ape_ven_nuevo), ''), v_ape_ven_actual);
    v_sue_ven := NVL(TO_NUMBER(NULLIF(TRIM(v_sue_ven_nuevo), '')), v_sue_ven_actual);
    v_fin_ven := NVL(TO_DATE(NULLIF(TRIM(v_fin_ven_nuevo), ''), 'DD-MM-YYYY'), v_fin_ven_actual);
    v_tip_ven := NVL(NULLIF(TRIM(v_tip_ven_nuevo), ''), v_tip_ven_actual);
    v_cod_dis := NVL(NULLIF(TRIM(v_cod_dis_nuevo), ''), v_cod_dis_actual);

    -- Si se está cambiando el distrito, validar que exista
    IF TRIM(v_cod_dis) != TRIM(v_cod_dis_actual) AND TRIM(v_cod_dis) IS NOT NULL THEN
        SELECT COUNT(*) INTO v_distrito_existe
        FROM DISTRITO WHERE COD_DIS = TRIM(v_cod_dis);
        
        IF v_distrito_existe = 0 THEN
            RAISE e_distrito_no_existe;
        END IF;
    END IF;

    -- Actualizar el vendedor
    UPDATE VENDEDOR SET
        NOM_VEN = v_nom_ven,
        APE_VEN = v_ape_ven,
        SUE_VEN = v_sue_ven,
        FIN_VEN = v_fin_ven,
        TIP_VEN = v_tip_ven,
        COD_DIS = v_cod_dis
    WHERE COD_VEN = v_cod_ven;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vendedor actualizado correctamente.');

EXCEPTION
    WHEN e_codigo_vendedor_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el código del vendedor a modificar');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe un vendedor con el código ' || v_cod_ven);
    WHEN e_distrito_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: El distrito con código ' || v_cod_dis || ' no existe.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Valor numérico inválido en sueldo o formato de fecha incorrecto.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- FACTURA
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM FACTURA;
SELECT COD_CLI, RSO_CLI FROM CLIENTE;
SELECT COD_VEN, NOM_VEN, APE_VEN FROM VENDEDOR;

DECLARE
    v_num_fac   FACTURA.NUM_FAC%TYPE := 'FA001'; -- Número de factura a modificar (OBLIGATORIO)
    v_fec_fac   FACTURA.FEC_FAC%TYPE;
    v_cod_cli   FACTURA.COD_CLI%TYPE;
    v_fec_can   FACTURA.FEC_CAN%TYPE;
    v_est_fac   FACTURA.EST_FAC%TYPE;
    v_cod_ven   FACTURA.COD_VEN%TYPE;
    v_por_jgv   FACTURA.POR_JGV%TYPE;

    -- Variables para almacenar valores actuales
    v_fec_fac_actual   FACTURA.FEC_FAC%TYPE;
    v_cod_cli_actual   FACTURA.COD_CLI%TYPE;
    v_fec_can_actual   FACTURA.FEC_CAN%TYPE;
    v_est_fac_actual   FACTURA.EST_FAC%TYPE;
    v_cod_ven_actual   FACTURA.COD_VEN%TYPE;
    v_por_jgv_actual   FACTURA.POR_JGV%TYPE;

    -- Variables para entrada de nuevos valores
    v_fec_fac_nuevo   VARCHAR2(10);    -- Para almacenar la fecha en formato DD-MM-YYYY
    v_cod_cli_nuevo   VARCHAR2(5);
    v_fec_can_nuevo   VARCHAR2(10);    -- Para almacenar la fecha en formato DD-MM-YYYY
    v_est_fac_nuevo   VARCHAR2(10);
    v_cod_ven_nuevo   VARCHAR2(3);
    v_por_jgv_nuevo   VARCHAR2(20);    -- Para NUMERIC(18,0)

    -- Variables para validación
    v_cliente_existe NUMBER;
    v_vendedor_existe NUMBER;
    
    -- Excepciones personalizadas
    e_cliente_no_existe EXCEPTION;
    e_vendedor_no_existe EXCEPTION;
    e_numero_factura_null EXCEPTION;
BEGIN
    -- Validar que se haya ingresado el número de factura
    IF v_num_fac IS NULL OR v_num_fac = '' THEN
        RAISE e_numero_factura_null;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT FEC_FAC, COD_CLI, FEC_CAN, EST_FAC, COD_VEN, POR_JGV
      INTO v_fec_fac_actual, v_cod_cli_actual, v_fec_can_actual,
           v_est_fac_actual, v_cod_ven_actual, v_por_jgv_actual
      FROM FACTURA 
     WHERE NUM_FAC = v_num_fac;

    -- Solicitar nuevos valores
    v_fec_fac_nuevo := :FechaFactura_DD_MM_YYYY;
    v_cod_cli_nuevo := :CodigoCliente_CHAR_5;
    v_fec_can_nuevo := :FechaCancelacion_DD_MM_YYYY;
    v_est_fac_nuevo := :EstadoFactura_VARCHAR_10;
    v_cod_ven_nuevo := :CodigoVendedor_CHAR_3;
    v_por_jgv_nuevo := :PorcentajeJGV_NUMERIC_18_0;
    
    -- Asignar valores por defecto si están vacíos
    v_fec_fac := NVL(TO_DATE(NULLIF(TRIM(v_fec_fac_nuevo), ''), 'DD-MM-YYYY'), v_fec_fac_actual);
    v_cod_cli := NVL(NULLIF(TRIM(v_cod_cli_nuevo), ''), v_cod_cli_actual);
    v_fec_can := NVL(TO_DATE(NULLIF(TRIM(v_fec_can_nuevo), ''), 'DD-MM-YYYY'), v_fec_can_actual);
    v_est_fac := NVL(NULLIF(TRIM(v_est_fac_nuevo), ''), v_est_fac_actual);
    v_cod_ven := NVL(NULLIF(TRIM(v_cod_ven_nuevo), ''), v_cod_ven_actual);
    v_por_jgv := NVL(TO_NUMBER(NULLIF(TRIM(v_por_jgv_nuevo), '')), v_por_jgv_actual);

    -- Si se está cambiando el cliente, validar que exista
    IF TRIM(v_cod_cli) != TRIM(v_cod_cli_actual) AND TRIM(v_cod_cli) IS NOT NULL THEN
        SELECT COUNT(*) INTO v_cliente_existe
        FROM CLIENTE WHERE COD_CLI = TRIM(v_cod_cli);
        
        IF v_cliente_existe = 0 THEN
            RAISE e_cliente_no_existe;
        END IF;
    END IF;

    -- Si se está cambiando el vendedor, validar que exista
    IF TRIM(v_cod_ven) != TRIM(v_cod_ven_actual) AND TRIM(v_cod_ven) IS NOT NULL THEN
        SELECT COUNT(*) INTO v_vendedor_existe
        FROM VENDEDOR WHERE COD_VEN = TRIM(v_cod_ven);
        
        IF v_vendedor_existe = 0 THEN
            RAISE e_vendedor_no_existe;
        END IF;
    END IF;

    -- Actualizar la factura
    UPDATE FACTURA SET
        FEC_FAC = v_fec_fac,
        COD_CLI = v_cod_cli,
        FEC_CAN = v_fec_can,
        EST_FAC = v_est_fac,
        COD_VEN = v_cod_ven,
        POR_JGV = v_por_jgv
    WHERE NUM_FAC = v_num_fac;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Factura actualizada correctamente.');

EXCEPTION
    WHEN e_numero_factura_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el número de factura a modificar');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe una factura con el número ' || v_num_fac);
    WHEN e_cliente_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: El cliente con código ' || v_cod_cli || ' no existe.');
    WHEN e_vendedor_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: El vendedor con código ' || v_cod_ven || ' no existe.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Valor numérico inválido o formato de fecha incorrecto.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- DETALLE_FACTURA
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM DETALLE_FACTURA;

DECLARE
    v_num_fac   DETALLE_FACTURA.NUM_FAC%TYPE := 'FA001'; -- Número de factura a modificar (OBLIGATORIO)
    v_cod_pro   DETALLE_FACTURA.COD_PRO%TYPE := 'P007'; -- Código del producto a modificar (OBLIGATORIO)
    v_can_pro   DETALLE_FACTURA.CAN_PRO%TYPE;
    v_pre_uni   DETALLE_FACTURA.PRE_UNI%TYPE;
    v_mon_item  DETALLE_FACTURA.MON_ITEM%TYPE;

    -- Variables para almacenar valores actuales
    v_can_pro_actual   DETALLE_FACTURA.CAN_PRO%TYPE;
    v_pre_uni_actual   DETALLE_FACTURA.PRE_UNI%TYPE;
    v_mon_item_actual  DETALLE_FACTURA.MON_ITEM%TYPE;

    -- Variables para entrada de nuevos valores
    v_can_pro_nuevo   VARCHAR2(10);    -- Para INT
    v_pre_uni_nuevo   VARCHAR2(20);    -- Para NUMERIC(10,2)
    v_mon_item_nuevo  VARCHAR2(20);    -- Para NUMERIC(10,2)

    -- Variables para validación
    v_detalle_existe NUMBER;
    
    -- Excepciones personalizadas
    e_no_existe EXCEPTION;
    e_codigo_detalle_null EXCEPTION;
BEGIN
    -- Validar que se hayan ingresado los códigos
    IF v_num_fac IS NULL OR v_num_fac = '' OR v_cod_pro IS NULL OR v_cod_pro = '' THEN
        RAISE e_codigo_detalle_null;
    END IF;

    -- Verificar que exista el registro
    SELECT COUNT(*)
      INTO v_detalle_existe
      FROM DETALLE_FACTURA 
     WHERE NUM_FAC = v_num_fac 
       AND COD_PRO = v_cod_pro;

    IF v_detalle_existe = 0 THEN
        RAISE e_no_existe;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT CAN_PRO, PRE_UNI, MON_ITEM
      INTO v_can_pro_actual, v_pre_uni_actual, v_mon_item_actual
      FROM DETALLE_FACTURA 
     WHERE NUM_FAC = v_num_fac 
       AND COD_PRO = v_cod_pro;

    -- Solicitar nuevos valores
    v_can_pro_nuevo := :CantidadProducto_INT;
    v_pre_uni_nuevo := :PrecioUnitario_NUMERIC_10_2;
    v_mon_item_nuevo := :MontoItem_NUMERIC_10_2;
    
    -- Asignar valores por defecto si están vacíos
    v_can_pro := NVL(TO_NUMBER(NULLIF(TRIM(v_can_pro_nuevo), '')), v_can_pro_actual);
    v_pre_uni := NVL(TO_NUMBER(NULLIF(TRIM(v_pre_uni_nuevo), '')), v_pre_uni_actual);
    v_mon_item := NVL(TO_NUMBER(NULLIF(TRIM(v_mon_item_nuevo), '')), v_mon_item_actual);

    -- Actualizar el detalle de factura
    UPDATE DETALLE_FACTURA SET
        CAN_PRO = v_can_pro,
        PRE_UNI = v_pre_uni,
        MON_ITEM = v_mon_item
    WHERE NUM_FAC = v_num_fac 
      AND COD_PRO = v_cod_pro;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de factura actualizado correctamente.');

EXCEPTION
    WHEN e_codigo_detalle_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el número de factura y código del producto a modificar');
    WHEN e_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe un detalle de factura para la factura ' || 
                            v_num_fac || ' y producto ' || v_cod_pro);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Valor numérico inválido en cantidad, precio unitario o monto.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ORDEN_COMPRA
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM ORDEN_COMPRA; -- ESTA TABLA NO TIENE REGISTROS

DECLARE
    v_num_oco   ORDEN_COMPRA.NUM_OCO%TYPE := 'OC001'; -- Número de orden de compra a modificar (OBLIGATORIO)
    v_fec_oco   ORDEN_COMPRA.FEC_OCO%TYPE;
    v_cod_prv   ORDEN_COMPRA.COD_PRV%TYPE;
    v_fat_oco   ORDEN_COMPRA.FAT_OCO%TYPE;
    v_est_oco   ORDEN_COMPRA.EST_OCO%TYPE;

    -- Variables para almacenar valores actuales
    v_fec_oco_actual   ORDEN_COMPRA.FEC_OCO%TYPE;
    v_cod_prv_actual   ORDEN_COMPRA.COD_PRV%TYPE;
    v_fat_oco_actual   ORDEN_COMPRA.FAT_OCO%TYPE;
    v_est_oco_actual   ORDEN_COMPRA.EST_OCO%TYPE;

    -- Variables para entrada de nuevos valores
    v_fec_oco_nuevo   VARCHAR2(10);    -- Para almacenar la fecha en formato DD-MM-YYYY
    v_cod_prv_nuevo   VARCHAR2(5);
    v_fat_oco_nuevo   VARCHAR2(10);    -- Para almacenar la fecha en formato DD-MM-YYYY
    v_est_oco_nuevo   VARCHAR2(1);

    -- Variables para validación
    v_proveedor_existe NUMBER;
    
    -- Excepciones personalizadas
    e_proveedor_no_existe EXCEPTION;
    e_numero_orden_null EXCEPTION;
BEGIN
    -- Validar que se haya ingresado el número de orden de compra
    IF v_num_oco IS NULL OR v_num_oco = '' THEN
        RAISE e_numero_orden_null;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT FEC_OCO, COD_PRV, FAT_OCO, EST_OCO
      INTO v_fec_oco_actual, v_cod_prv_actual, v_fat_oco_actual, v_est_oco_actual
      FROM ORDEN_COMPRA 
     WHERE NUM_OCO = v_num_oco;

    -- Solicitar nuevos valores
    v_fec_oco_nuevo := :FechaOrdenCompra_DD_MM_YYYY;
    v_cod_prv_nuevo := :CodigoProveedor_CHAR_5;
    v_fat_oco_nuevo := :FechaAtencion_DD_MM_YYYY;
    v_est_oco_nuevo := :EstadoOrdenCompra_CHAR_1;
    
    -- Asignar valores por defecto si están vacíos
    v_fec_oco := NVL(TO_DATE(NULLIF(TRIM(v_fec_oco_nuevo), ''), 'DD-MM-YYYY'), v_fec_oco_actual);
    v_cod_prv := NVL(NULLIF(TRIM(v_cod_prv_nuevo), ''), v_cod_prv_actual);
    v_fat_oco := NVL(TO_DATE(NULLIF(TRIM(v_fat_oco_nuevo), ''), 'DD-MM-YYYY'), v_fat_oco_actual);
    v_est_oco := NVL(NULLIF(TRIM(v_est_oco_nuevo), ''), v_est_oco_actual);

    -- Si se está cambiando el proveedor, validar que exista
    IF TRIM(v_cod_prv) != TRIM(v_cod_prv_actual) AND TRIM(v_cod_prv) IS NOT NULL THEN
        SELECT COUNT(*) INTO v_proveedor_existe
        FROM PROVEEDOR WHERE COD_PRV = TRIM(v_cod_prv);
        
        IF v_proveedor_existe = 0 THEN
            RAISE e_proveedor_no_existe;
        END IF;
    END IF;

    -- Actualizar la orden de compra
    UPDATE ORDEN_COMPRA SET
        FEC_OCO = v_fec_oco,
        COD_PRV = v_cod_prv,
        FAT_OCO = v_fat_oco,
        EST_OCO = v_est_oco
    WHERE NUM_OCO = v_num_oco;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Orden de compra actualizada correctamente.');

EXCEPTION
    WHEN e_numero_orden_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el número de orden de compra a modificar');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe una orden de compra con el número ' || v_num_oco);
    WHEN e_proveedor_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: El proveedor con código ' || v_cod_prv || ' no existe.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Formato de fecha incorrecto.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- DETALLE_COMPRA
-- Se debe correr estos SELECT antes de ejecutar el bloque PL/SQL correspondiente para ver los datos
SELECT * FROM DETALLE_COMPRA; -- ESTA TABLA NO TIENE REGISTROS

DECLARE
    v_num_oc    DETALLE_COMPRA.NUM_OC%TYPE := 'OC001'; -- Número de orden de compra a modificar (OBLIGATORIO)
    v_cod_pro   DETALLE_COMPRA.COD_PRO%TYPE := 'PR001'; -- Código del producto a modificar (OBLIGATORIO)
    v_can_pro   DETALLE_COMPRA.CAN_PRO%TYPE;
    v_pre_uni   DETALLE_COMPRA.PRE_UNI%TYPE;
    v_mon_item  DETALLE_COMPRA.MON_ITEM%TYPE;

    -- Variables para almacenar valores actuales
    v_can_pro_actual   DETALLE_COMPRA.CAN_PRO%TYPE;
    v_pre_uni_actual   DETALLE_COMPRA.PRE_UNI%TYPE;
    v_mon_item_actual  DETALLE_COMPRA.MON_ITEM%TYPE;

    -- Variables para entrada de nuevos valores
    v_can_pro_nuevo   VARCHAR2(10);    -- Para INT
    v_pre_uni_nuevo   VARCHAR2(20);    -- Para NUMERIC(10,2)
    v_mon_item_nuevo  VARCHAR2(20);    -- Para NUMERIC(10,2)

    -- Variables para validación
    v_detalle_existe NUMBER;
    
    -- Excepciones personalizadas
    e_no_existe EXCEPTION;
    e_numero_orden_null EXCEPTION;
    e_codigo_producto_null EXCEPTION;
    
BEGIN
    -- Validar que se hayan ingresado los códigos
    IF v_num_oc IS NULL OR v_num_oc = '' THEN
        RAISE e_numero_orden_null;
    END IF;
    
    IF v_cod_pro IS NULL OR v_cod_pro = '' THEN
        RAISE e_codigo_producto_null;
    END IF;

    -- Verificar que exista el registro
    SELECT COUNT(*)
      INTO v_detalle_existe
      FROM DETALLE_COMPRA 
     WHERE NUM_OC = v_num_oc 
       AND COD_PRO = v_cod_pro;

    IF v_detalle_existe = 0 THEN
        RAISE e_no_existe;
    END IF;

    -- Obtener los datos actuales en variables auxiliares
    SELECT CAN_PRO, PRE_UNI, MON_ITEM
      INTO v_can_pro_actual, v_pre_uni_actual, v_mon_item_actual
      FROM DETALLE_COMPRA 
     WHERE NUM_OC = v_num_oc 
       AND COD_PRO = v_cod_pro;

    -- Solicitar nuevos valores
    v_can_pro_nuevo := :CantidadProducto_INT;
    v_pre_uni_nuevo := :PrecioUnitario_NUMERIC_10_2;
    v_mon_item_nuevo := :MontoItem_NUMERIC_10_2;
    
    -- Asignar valores por defecto si están vacíos
    v_can_pro := NVL(TO_NUMBER(NULLIF(TRIM(v_can_pro_nuevo), '')), v_can_pro_actual);
    v_pre_uni := NVL(TO_NUMBER(NULLIF(TRIM(v_pre_uni_nuevo), '')), v_pre_uni_actual);
    v_mon_item := NVL(TO_NUMBER(NULLIF(TRIM(v_mon_item_nuevo), '')), v_mon_item_actual);

    -- Actualizar el detalle de compra
    UPDATE DETALLE_COMPRA SET
        CAN_PRO = v_can_pro,
        PRE_UNI = v_pre_uni,
        MON_ITEM = v_mon_item
    WHERE NUM_OC = v_num_oc 
      AND COD_PRO = v_cod_pro;

    -- Confirmar los cambios
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de orden de compra actualizado correctamente.');

EXCEPTION
    WHEN e_numero_orden_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el número de orden de compra a modificar');
    WHEN e_codigo_producto_null THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Debe ingresar el código del producto a modificar');
    WHEN e_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: No existe un detalle de compra para la orden ' || 
                            v_num_oc || ' y producto ' || v_cod_pro);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: Valor numérico inválido en cantidad, precio unitario o monto.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('No se realizaron cambios -> Error: ' || SQLERRM);
        ROLLBACK;
END;
/
