CREATE TABLE Autores(
	autor_id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(100),
	fecha_nacimiento DATE
);

CREATE TABLE Categorias(
	categoria_id INT PRIMARY KEY AUTO_INCREMENT,
	nombre_categoria VARCHAR(50)
);

CREATE TABLE Libros(
	libro_id INT PRIMARY KEY AUTO_INCREMENT,
	titulo VARCHAR(255),
	autor_id INT,
	categoria_id INT,
	fecha_publicacion DATE,
	isbn VARCHAR(20),
	cantidad_disponible INT,
	FOREIGN KEY (autor_id) REFERENCES Autores(autor_id),
	FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id)
);

CREATE TABLE Prestamos (
	prestamo_id INT PRIMARY KEY AUTO_INCREMENT,
	libro_id INT,
	fecha_prestamo DATE,
	fecha_devolucion DATE,
	usuario_nombre VARCHAR(100),
	FOREIGN KEY (libro_id) REFERENCES Libros(libro_id)
);

INSERT INTO Autores (nombre, fecha_nacimiento) VALUES
('Gabriel García Márquez', '1927-03-06'),
('Mario Vargas Llosa', '1936-03-28'),
('J.K. Rowling', '1965-07-31'),
('George Orwell', '1903-06-25'),
('Isabel Allende', '1942-08-02'),
('Haruki Murakami', '1949-01-12');

INSERT INTO Categorias (nombre_categoria) VALUES
('Ficción'),
('No Ficción'),
('Ciencia Ficción'),
('Misterio'),
('Romántico'),
('Fantasía');

INSERT INTO Libros (titulo, autor_id, categoria_id, fecha_publicacion, isbn, cantidad_disponible) VALUES
('Cien años de soledad', 1, 1, '1967-06-05', '978-3-16-148410-0', 10),
('La casa verde', 2, 1, '1966-03-17', '978-3-16-148411-7', 5),
('Harry Potter y la piedra filosofal', 3, 6, '1997-06-26', '978-3-16-148412-4', 8),
('1984', 4, 2, '1949-06-08', '978-3-16-148413-1', 12),
('La casa de los espíritus', 5, 1, '1982-06-01', '978-3-16-148414-8', 7),
('Kafka en la orilla', 6, 1, '2002-01-01', '978-3-16-148415-5', 9);

INSERT INTO Prestamos (libro_id,fecha_prestamo,fecha_devolucion,usuario_nombre) values 
(1, '2005-05-25', '2005-08-02', 'Marianita'),
(2, '2007-07-23', '2007-12-30', 'Juliancito'),
(3, '2008-02-16','2008-04-01', 'Briancito');
