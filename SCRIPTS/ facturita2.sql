INSERT INTO Factura (numeroFactura, idVendedor, idCliente, tipoFactura, fecha, 
subTotal, impuestoLSV, totalFactura, fechaEntrega, estadoEntrega)
VALUES(
00254, 1, 1, "Contado", "2007-10-16", 2501.50, 300.18, 2801.68, "2007-10-16", "Entregado"
);

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(1, 00254, 10, (SELECT valorUnitario * 10 FROM producto WHERE codigoProducto = 1 LIMIT 1));

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(2, 00254, 3, (SELECT valorUnitario * 3 FROM producto WHERE codigoProducto = 2 LIMIT 1));

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(3, 00254, 10, (SELECT valorUnitario * 10 FROM producto WHERE codigoProducto = 3 LIMIT 1));

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(4, 00254, 25, (SELECT valorUnitario * 25 FROM producto WHERE codigoProducto = 4 LIMIT 1));

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(5, 00254, 75, (SELECT valorUnitario * 75 FROM producto WHERE codigoProducto = 5 LIMIT 1));

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(6, 00254, 10, (SELECT valorUnitario * 10 FROM producto WHERE codigoProducto = 6 LIMIT 1));

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(7, 00254, 2, (SELECT valorUnitario * 2 FROM producto WHERE codigoProducto = 7 LIMIT 1));

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(8, 00254, 30, (SELECT valorUnitario * 30 FROM producto WHERE codigoProducto = 8 LIMIT 1));

INSERT INTO detallefactura (codigoProducto, numeroFactura, cantidadProducto, totalProducto)
VALUES(9, 00254, 10, (SELECT valorUnitario * 10 FROM producto WHERE codigoProducto = 9 LIMIT 1));



----------------------------------------------------------------------------------------------------------------
-- IMPRESIÓN DE LA FACTURA: --

SELECT numeroFactura, v.idVendedor, nombreVendedor, c.idCliente, nombreCliente, tipoFactura, fecha, fechaEntrega, subTotal, 
impuestoLSV, f.totalFactura, f.estadoEntrega
FROM factura f
JOIN vendedor v
ON f.idVendedor = v.idVendedor
JOIN cliente c 
ON f.idCliente = c.idCliente;

SELECT d.codigoProducto, description, valorUnitario, cantidadProducto, totalProducto
FROM detallefactura d
JOIN producto p 
ON d.codigoProducto = p.codigoProducto;


