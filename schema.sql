-- =================================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS - ADOPTAR
-- MATERIA: TRABAJO FINAL DE PROGRAMACIÓN (UTN)
-- INTEGRANTES: Ponce, Samaniego, Roveres
-- =================================================================

DROP TABLE IF EXISTS historial_vacunacion;
DROP TABLE IF EXISTS animales;
DROP TABLE IF EXISTS estados;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE estados (
    id_estado INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    PRIMARY KEY (id_estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE animales (
    id_animal INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    sexo VARCHAR(10) NOT NULL,
    edad_aproximada VARCHAR(50),
    tamaño VARCHAR(20),
    descripcion TEXT,
    foto_url VARCHAR(255),
    fecha_ingreso DATE NOT NULL,
    id_estado INT NOT NULL,
    PRIMARY KEY (id_animal),
    CONSTRAINT fk_animales_estados 
        FOREIGN KEY (id_estado) REFERENCES estados(id_estado)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE historial_vacunacion (
    id_vacunacion INT AUTO_INCREMENT,
    id_animal INT NOT NULL,
    nombre_vacuna VARCHAR(100) NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    observaciones VARCHAR(255),
    PRIMARY KEY (id_vacunacion),
    CONSTRAINT fk_historial_animales 
        FOREIGN KEY (id_animal) REFERENCES animales(id_animal)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO estados (nombre, descripcion) VALUES 
('Disponible', 'El animal está listo para ser adoptado y visible al público.'),
('En proceso de adopción', 'Hay una familia interesada en evaluación.'),
('Adoptado', 'El animal ya consiguió un hogar.'),
('No disponible', 'El animal está bajo tratamiento médico o retirado temporalmente.');
