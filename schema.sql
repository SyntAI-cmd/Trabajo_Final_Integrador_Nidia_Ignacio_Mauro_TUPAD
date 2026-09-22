-- =================================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS - ADOPTAR (VERSIÓN MVP)
-- MATERIA: TRABAJO FINAL DE PROGRAMACIÓN (UTN)
-- INTEGRANTES: Ponce, Samaniego, Roveres
-- =================================================================

-- Limpieza previa en orden seguro por restricciones de claves foráneas
DROP TABLE IF EXISTS foto;
DROP TABLE IF EXISTS vacuna;
DROP TABLE IF EXISTS mascota;
DROP TABLE IF EXISTS usuario;

-- =================================================================
-- 1. Tabla: USUARIO
-- =================================================================
CREATE TABLE usuario (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =================================================================
-- 2. Tabla: MASCOTA
-- =================================================================
CREATE TABLE mascota (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    especie VARCHAR(10) NOT NULL,           -- Valores esperados: PERRO, GATO
    sexo VARCHAR(10) NOT NULL,              -- Valores esperados: MACHO, HEMBRA
    tamanio VARCHAR(10) NOT NULL,           -- Valores esperados: CHICO, MEDIANO, GRANDE
    fecha_nacimiento_aprox DATE NULL,       -- Puede ser nula según justificación técnica
    fecha_ingreso DATE NOT NULL,
    descripcion TEXT NULL,
    estado VARCHAR(20) NOT NULL,            -- Valores esperados: DISPONIBLE, EN_PROCESO, ADOPTADO, NO_DISPONIBLE
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =================================================================
-- 3. Tabla: VACUNA
-- =================================================================
CREATE TABLE vacuna (
    id INT AUTO_INCREMENT,
    mascota_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    proxima_dosis DATE NULL,                -- Puede estar vacía
    observaciones TEXT NULL,                -- Notas del veterinario
    PRIMARY KEY (id),
    CONSTRAINT fk_vacuna_mascota 
        FOREIGN KEY (mascota_id) REFERENCES mascota(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =================================================================
-- 4. Tabla: FOTO
-- =================================================================
CREATE TABLE foto (
    id INT AUTO_INCREMENT,
    mascota_id INT NOT NULL,
    archivo VARCHAR(255) NOT NULL,          -- Nombre de referencia en el servidor
    principal BOOLEAN DEFAULT FALSE,        -- Define la foto de portada del listado
    PRIMARY KEY (id),
    CONSTRAINT fk_foto_mascota 
        FOREIGN KEY (mascota_id) REFERENCES mascota(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

