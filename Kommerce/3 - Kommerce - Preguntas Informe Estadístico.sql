--1.
SELECT COUNT(*)
FROM abastecimiento a ;

SELECT COUNT(*)
FROM cliente c ;

SELECT COUNT(*)
FROM detalle_compra dc ;

SELECT COUNT(*)
FROM detalle_factura df ;

SELECT COUNT(*)
FROM distrito d ;

SELECT COUNT(*)
FROM factura f ;

SELECT COUNT(*)
FROM orden_compra oc ;

SELECT COUNT(*)
FROM producto p ;

SELECT COUNT(*)
FROM proveedor p ;

SELECT COUNT(*)
FROM vendedor v ;

-- 2. muestra promedio de precios.
SELECT AVG(p.pre_pro) AS "Promedio de Precios"
FROM producto p;

-- 3. muestra productos mayores al promedio.
SELECT p.des_pro, p.pre_pro
FROM producto p
WHERE p.pre_pro >= (
	SELECT AVG(p.pre_pro) AS "Promedio de Precios"
FROM producto p);

-- 4. muestra los productos más comprados
SELECT p.des_pro, sum(df.can_ven) AS total_vendido, p.pre_pro
FROM producto p
JOIN detalle_factura df ON
	p.cod_pro = df.cod_pro
GROUP BY
	p.des_pro, p.pre_pro
ORDER BY
	total_vendido DESC;

-- muestra los proveedores más frecuentes.
SELECT p.rso_prv, p.rep_prv, count(oc.cod_prv)
FROM proveedor p
JOIN orden_compra oc  ON
p.cod_prv = oc.cod_prv
GROUP BY
	p.rso_prv, p.rep_prv, oc.cod_prv
ORDER BY count(oc.cod_prv) desc;

--5.
SELECT p.des_pro, SUM(df.can_ven * df.pre_ven) AS ingresos_totales
FROM detalle_factura df
JOIN producto p ON df.cod_pro = p.cod_pro
GROUP BY p.des_pro
ORDER BY ingresos_totales DESC;

--6.
SELECT c.con_cli , COUNT(f.num_fac) AS total_compras
FROM factura f
JOIN cliente c ON f.cod_cli = c.cod_cli
GROUP BY c.con_cli
ORDER BY total_compras DESC
LIMIT 10;

--7.
SELECT v.nom_ven, v.ape_ven, COUNT(f.num_fac) AS total_ventas
FROM factura f
JOIN vendedor v ON f.cod_ven = v.cod_ven
GROUP BY v.nom_ven, v.ape_ven
ORDER BY total_ventas DESC;

--8.
SELECT pr.rso_prv, COUNT(a.cod_pro) AS total_productos
FROM abastecimiento a
JOIN proveedor pr ON a.cod_prv = pr.cod_prv
GROUP BY pr.rso_prv
ORDER BY total_productos DESC;

--9.
SELECT est_oco, COUNT(num_oco) AS total_ordenes
FROM orden_compra
GROUP BY est_oco;

--10.
SELECT d.nom_dis, SUM(df.can_ven * df.pre_ven) AS total_ventas
FROM detalle_factura df
JOIN factura f ON df.num_fac = f.num_fac
JOIN cliente c ON f.cod_cli = c.cod_cli
JOIN distrito d ON c.cod_dis = d.cod_dis
GROUP BY d.nom_dis
ORDER BY total_ventas DESC;


