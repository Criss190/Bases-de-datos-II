-- PRINT RECEAPT --

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