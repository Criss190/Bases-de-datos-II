DECLARE 
D NUMBER :=:DAY;
M NUMBER :=:MONTH;
A NUMBER :=:YEAR;
actualYear NUMBER;
actualMonth NUMBER;
actualDay NUMBER;
yearsDays NUMBER :=365;
monthDays NUMBER;
edadEnDias NUMBER;
BEGIN
    -- Calcular días del mes:
    IF (M>=1 AND M <=12) THEN
        IF (M = 2) THEN
            IF (D >=1 AND D <= 28) THEN
                SELECT 29 INTO monthDays FROM dual;
            ELSE 
                dbms_output.put_line('NO es un día válido');
            END IF;
        ELSIF (M = 1 OR M = 3 OR M = 5 OR M = 7 OR M = 8 OR M = 10 OR M = 12) THEN
            IF (D >=1 AND D <= 31) THEN
                SELECT 31 INTO monthDays FROM dual;
            ELSE
                dbms_output.put_line('NO es un día válido');
            END IF;
        ELSIF (M = 4 OR M = 6 OR M = 9 OR M = 11) THEN
            IF (D >=1 AND D <= 30) THEN
                SELECT 30 INTO monthDays FROM dual;
            ELSE
                dbms_output.put_line('NO es un día válido');
            END IF;
        END IF;
    ELSE 
        dbms_output.put_line(M || ' NO es un mes válido');
    END IF;

    -- Obtener fecha actual:
    SELECT TO_CHAR(sysdate, 'DD') INTO actualDay FROM dual; -- Obtener el día actual
    SELECT TO_CHAR(sysdate, 'MM') INTO actualMonth FROM dual; -- Obtener el mes actual
    SELECT TO_CHAR(sysdate, 'YYYY') INTO actualYear FROM dual; -- Obtener el año actual

    -- Calcular edad en días:
    SELECT (
        (actualYear-A) * yearsDays +
        (actualMonth-M) * monthDays +
        (actualDay-D)
    ) INTO edadEnDias FROM dual;

    dbms_output.put_line(edadEnDias);
END;