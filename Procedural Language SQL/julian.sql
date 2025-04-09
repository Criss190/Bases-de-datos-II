DECLARE
    D NUMBER := :DIA;
    M NUMBER := :MES;
    A NUMBER := :AÑO;
    Y NUMBER := 0;
    X NUMBER := 0;
BEGIN
    dbms_output.put_line(D || ' ES SU DIA DE CUMPLEAÑOS');
    dbms_output.put_line(M || ' ES SU MES DE CUMPLEAÑOS');
    dbms_output.put_line(A || ' ES SU AÑO DE CUMPLEAÑOS');

    X := A / 12;
    
    IF (D >= 25 AND D <= 30) OR D = 31 THEN
        X := X + 1; 
    ELSE 
        dbms_output.put_line(' ' || X || ' meses');
        dbms_output.put_line('y ' || D || ' dias ');
    END IF;
END;
