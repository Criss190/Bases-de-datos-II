-- BLOQUES

[DECLARE |IS |AS]
    /* Declaración de variables y constantes */
BEGIN
    /* Bloque ejecutable */
[EXCEPTION]
    /* Manejo de excepciones */
END;

DECLARE
X NUMBER :=:DATO;
BEGIN
    IF (X=4) THEN -- condicional
        dbms_output.put_line('El valor de X es ' || X);
    ELSE 
        dbms_output.put_line(X ||' es diferente a 4');
    END IF;
END;


DECLARE
D NUMBER :=:DATO;
M NUMBER :=:DATO;
BEGIN
    IF (M>=1 AND M <=12) THEN
        IF (M = 2) THEN
            IF (D >=1 AND D <= 28) THEN
                dbms_output.put_line(D || ' Es un día válido');
            ELSE
                dbms_output.put_line('NO es un día válido');
            END IF;
        ELSIF (M = 1 OR M = 3 OR M = 5 OR M = 7 OR M = 8 OR M = 10 OR M = 12) THEN
            IF (D >=1 AND D <= 31) THEN
                dbms_output.put_line(D || ' Es un día válido');
            ELSE
                dbms_output.put_line('NO es un día válido');
            END IF;
        ELSIF (M = 4 OR M = 6 OR M = 9 OR M = 11) THEN
            IF (D >=1 AND D <= 30) THEN
                dbms_output.put_line(D || ' Es un día válido');
            ELSE
                dbms_output.put_line('NO es un día válido');
            END IF;
        END IF;
    ELSE 
        dbms_output.put_line(M || ' No es un mes válido');
    END IF;
END;

DECLARE
D NUMBER :=:DAY;
M NUMBER :=:MES;
BEGIN
    IF ((D >= 22 AND M = 12) OR (D<=19 AND M =1)) THEN
        dbms_output.put_line('CAPRICORNIO');
    END IF;
    IF ((D >= 20 AND M = 1) OR (D<=18 AND M =2)) THEN
        dbms_output.put_line('ACUARIO');
    END IF;
    IF ((D >= 19 AND M = 2) OR (D<=20 AND M =3)) THEN
        dbms_output.put_line('PISCIS');
    END IF;
    IF ((D >= 21 AND M = 3) OR (D<=19 AND M =4)) THEN
        dbms_output.put_line('ARIES');
    END IF;
    IF ((D >= 20 AND M = 4) OR (D<=20 AND M =5)) THEN
        dbms_output.put_line('TAURO');
    END IF;
    IF ((D >= 21 AND M = 5) OR (D<=20 AND M =6)) THEN
        dbms_output.put_line('GEMINIS');
    END IF;
    IF ((D >= 21 AND M = 6) OR (D<=22 AND M =7)) THEN
        dbms_output.put_line('CANCER');
    END IF;
    IF ((D >= 23 AND M = 7) OR (D<=22 AND M =8)) THEN
        dbms_output.put_line('LEO');
    END IF;
    IF ((D >= 23 AND M = 8) OR (D<=22 AND M =9)) THEN
        dbms_output.put_line('VIRGO');
    END IF;
    IF ((D >= 23 AND M = 9) OR (D<=22 AND M =10)) THEN
        dbms_output.put_line('LIBRA');
    END IF;
    IF ((D >= 23 AND M = 10) OR (D<=21 AND M =11)) THEN
        dbms_output.put_line('ESCORPIO');
    END IF;
    IF ((D >= 22 AND M = 11) OR (D<=21 AND M =12)) THEN
        dbms_output.put_line('SAGITARIO');
    END IF;
END;

