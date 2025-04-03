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