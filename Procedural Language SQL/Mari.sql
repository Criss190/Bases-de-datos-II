DECLARE
D NUMBER := :DAY;
M NUMBER := :MONTH;
A NUMBER := :YEAR; 
BEGIN
IF (M>=4 AND D>9) OR (M>=4) THEN
dbms_output.put_line('Su edad en años es de '||(2024-A));
ELSE
dbms_output.put_line('Su edad en años es de '||(2025-A));
END IF;
END;