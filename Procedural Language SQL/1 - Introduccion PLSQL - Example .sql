-- DECLARE: Es la sección donde se declaran variables, constantes y tipos de datos que se usarán en el bloque PL/SQL
-- BEGIN: Marca el inicio del bloque de código ejecutable
-- END: Marca el final del bloque de código ejecutable
-- SELECT INTO: Permite recuperar datos de una consulta y almacenarlos en variables PL/SQL
-- dbms_output.put_line: Es un procedimiento que permite imprimir mensajes en la salida del programa

-- Ejemplo 1: Obtener la fecha actual
DECLARE -- Inicio de la sección declarativa
fecha timestamp;
BEGIN -- Inicio del bloque ejecutable
    SELECT sysdate INTO fecha FROM dual; -- Guarda el resultado de sysdate en la variable fecha
    dbms_output.put_line('La fecha es: ' || fecha); -- Imprime el mensaje con el valor de fecha
END; -- Fin del bloque ejecutable

-- Ejemplo 2: Inserción de datos
BEGIN -- Solo bloque ejecutable (no necesita declaración de variables)
    INSERT INTO paises VALUES(1,'Colombia', 'America');
    INSERT INTO paises VALUES(2,'Venezuela', 'America');
    INSERT INTO paises VALUES(3,'Italia', 'Europa');
    INSERT INTO paises VALUES(4,'Francia', 'Europa');
    INSERT INTO paises VALUES(5,'Peru', 'America');
END;

-- Ejemplo 3: Consulta con variable usando %TYPE
DECLARE -- Define una variable con el mismo tipo de dato que la columna nom_pais
    nombre paises.nom_pais%TYPE;
BEGIN
    SELECT nom_pais INTO nombre FROM paises WHERE cod_pais=3; -- Guarda el resultado en la variable nombre
    dbms_output.put_line('El nombre del país es: ' || nombre); -- Imprime el resultado
END;

-- Ejemplo 4: Consulta usando %ROWTYPE
DECLARE -- Define una variable que puede almacenar una fila completa de la tabla paises
    registrodepaises paises%ROWTYPE;
BEGIN
    SELECT * INTO registrodepaises FROM paises WHERE cod_pais=3; -- Guarda toda la fila en la variable
    dbms_output.put_line(registrodepaises.cod_pais ||' ---> ' || registrodepaises.nom_pais); -- Imprime campos específicos
END;