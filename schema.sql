-- =================================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS - ADOPTAR (VERSIÓN FINAL MVP)
-- MATERIA: TRABAJO FINAL DE PROGRAMACIÓN (UTN)
-- INTEGRANTES: Ponce, Samaniego, Roveres
-- ENFOQUE: INTEGRIDAD DE DATOS, SEGURIDAD DE DOMINIO Y TRAZABILIDAD
-- =================================================================

-- Limpieza previa en orden seguro por restricciones de claves foráneas
DROP TABLE IF EXISTS adopcion;
DROP TABLE IF EXISTS foto;
DROP TABLE IF EXISTS vacuna;
DROP TABLE IF EXISTS mascota;
DROP TABLE IF EXISTS especie_dicc;
DROP TABLE IF EXISTS estado_dicc;
DROP TABLE IF EXISTS adoptante;
DROP TABLE IF EXISTS usuario;

-- =================================================================
-- 1. Tabla: USUARIO (Personal del Refugio)
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
-- 2. Tabla: ADOPTANTE (Personas de la Comunidad)
-- =================================================================
CREATE TABLE adoptante (
    id INT AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    dni VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(30) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- =================================================================
-- TABLAS MAESTRAS (Diccionarios de Control para Seguridad)
-- =================================================================
CREATE TABLE especie_dicc (
    nombre VARCHAR(20) PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE estado_dicc (
    nombre VARCHAR(30) PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserción obligatoria de valores permitidos inmutables del negocio
INSERT INTO especie_dicc (nombre) VALUES ('PERRO'), ('GATO');
INSERT INTO estado_dicc (nombre) VALUES ('DISPONIBLE'), ('EN_PROCESO'), ('ADOPTADO'), ('NO_DISPONIBLE');


-- =================================================================
-- 3. Tabla: MASCOTA (Con validaciones de integridad estrictas)
-- =================================================================
CREATE TABLE mascota (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    especie VARCHAR(20) NOT NULL, 
    sexo VARCHAR(10) NOT NULL,              
    tamanio VARCHAR(10) NOT NULL,           
    fecha_nacimiento_aprox DATE NULL,       
    fecha_ingreso DATE NOT NULL,
    descripcion TEXT NULL,
    estado VARCHAR(30) NOT NULL,            
    PRIMARY KEY (id),
    
    -- VALIDACIÓN DE SEGURIDAD 1: Integridad relacional contra tablas maestras
    CONSTRAINT fk_mascota_especie FOREIGN KEY (especie) REFERENCES especie_dicc(nombre),
    CONSTRAINT fk_mascota_estado FOREIGN KEY (estado) REFERENCES estado_dicc(nombre),
    
    -- VALIDACIÓN DE SEGURIDAD 2: Restricciones CHECK para datos estáticos
    CONSTRAINT chk_mascota_sexo CHECK (sexo IN ('MACHO', 'HEMBRA')),
    CONSTRAINT chk_mascota_tamanio CHECK (tamanio IN ('CHICO', 'MEDIANO', 'GRANDE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- =================================================================
-- 4. Tabla: VACUNA
-- =================================================================
CREATE TABLE vacuna (
    id INT AUTO_INCREMENT,
    mascota_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    proxima_dosis DATE NULL,                
    observaciones TEXT NULL,                
    PRIMARY KEY (id),
    CONSTRAINT fk_vacuna_mascota FOREIGN KEY (mascota_id) REFERENCES mascota(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- =================================================================
-- 5. Tabla: FOTO
-- =================================================================
CREATE TABLE foto (
    id INT AUTO_INCREMENT,
    mascota_id INT NOT NULL,
    archivo VARCHAR(255) NOT NULL,          
    principal BOOLEAN DEFAULT FALSE,        
    PRIMARY KEY (id),
    CONSTRAINT fk_foto_mascota FOREIGN KEY (mascota_id) REFERENCES mascota(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- =================================================================
-- 6. Tabla: ADOPCION (Unión entre Adoptante externo y Mascota)
-- =================================================================
CREATE TABLE adopcion (
    id INT AUTO_INCREMENT,
    adoptante_id INT NOT NULL,              
    mascota_id INT NOT NULL UNIQUE,         -- UNIQUE: Bloquea que un animal tenga dos adopciones paralelas
    fecha_adopcion DATE NOT NULL,
    notes_seguimiento TEXT NULL,            
    PRIMARY KEY (id),
    CONSTRAINT fk_adopcion_adoptante FOREIGN KEY (adoptante_id) REFERENCES adoptante(id)
        ON DELETE RESTRICT ON UPDATE CASCADE, -- RESTRICT: Impide borrar al adoptante si tiene un historial activo
    CONSTRAINT fk_adopcion_mascota FOREIGN KEY (mascota_id) REFERENCES mascota(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



