-- 1 ¿Cuáles son los títulos de los libros de la categoría 'Ficción’?
SELECT titulo 
FROM Libros l
JOIN Categorias c
ON l.categoria_id = c.categoria_id
WHERE nombre_categoria = 'Ficción';

-- 2 ¿Cuántos libros están disponibles de cada autor?
SELECT DISTINCT nombre, cantidad_disponible
FROM Libros l
JOIN Autores a
ON l.autor_id = a.autor_id;

-- 3 ¿Qué libros fueron publicados después del año 2000?
SELECT titulo
FROM Libros
WHERE fecha_publicacion > '2000-01-01';

-- 4 ¿Cuántos préstamos se han realizado de cada libro?
SELECT COUNT(prestamo_id)
FROM Prestamos;

-- 5 ¿Quiénes han prestado libros de la categoría 'Ciencia Ficción'?
SELECT usuario_nombre
FROM Prestamos p
JOIN Libros l 
ON p.libro_id = l.libro_id
JOIN Categorias c 
ON l.categoria_id = c.categoria_id
WHERE c.nombre_categoria = "Ciencia Ficción";

-- 6  ¿Cuál es el autor que tiene la mayor cantidad de libros disponibles en total?
SELECT nombre, cantidad_disponible
FROM Autores a
JOIN Libros l
ON a.autor_id = l.autor_id
WHERE cantidad_disponible = (SELECT MAX(cantidad_disponible) FROM Libros);

-- 7 ¿Qué libros han sido prestados más de 5 veces y tienen más de 3 copias disponibles?
SELECT l.titulo, COUNT(p.prestamo_id) AS total_prestamos, l.cantidad_disponible 
FROM libros l
JOIN prestamos p 
ON l.libro_id = p.libro_id
GROUP BY l.libro_id, l.titulo, l.cantidad_disponible
HAVING COUNT(p.prestamo_id) > 5 AND l.cantidad_disponible = 3;

-- 8 ¿Cuál es el libro más reciente de cada categoría?
SELECT titulo, fecha_publicacion
FROM Libros l
WHERE l.fecha_publicacion = (SELECT MAX(fecha_publicacion) FROM Libros l);

-- 9 ¿Qué autores tienen libros que fueron publicados antes de 1990 y tienen al menos un libro disponible?
SELECT nombre, fecha_publicacion, cantidad_disponible
FROM Autores a
JOIN Libros l
ON a.autor_id = l.autor_id
WHERE fecha_publicacion < "1990-01-01" AND cantidad_disponible >= 1;

-- 10 ¿Cuántos libros de cada autor han sido prestados más de 3 veces en total, y cuántos están disponibles actualmente?
SELECT l.titulo, a.nombre, COUNT(p.prestamo_id) AS total_prestamos, l.cantidad_disponible 
FROM Autores a 
JOIN libros l
ON a.autor_id = l.autor_id 
JOIN prestamos p 
ON l.libro_id = p.libro_id
GROUP BY l.libro_id, l.titulo, a.nombre, l.cantidad_disponible
HAVING COUNT(p.prestamo_id) > 3;