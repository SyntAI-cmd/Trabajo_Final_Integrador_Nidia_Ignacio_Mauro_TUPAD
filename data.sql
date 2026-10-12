-- =================================================================
-- SCRIPT DE CARGA DE DATOS INICIALES Y PRUEBA - ADOPTAR
-- =================================================================

-- 1. Poblado de Diccionarios de Control Obligatorios (Tablas Maestras)
INSERT INTO especie_dicc (nombre) VALUES ('PERRO'), ('GATO');
INSERT INTO estado_dicc (nombre) VALUES ('DISPONIBLE'), ('EN_PROCESO'), ('ADOPTADO'), ('NO_DISPONIBLE');

-- 2. Registros Iniciales de Prueba para verificar el funcionamiento
INSERT INTO usuario (nombre, email, password, activo) 
VALUES ('Administrador Refugio', 'admin@adoptar.org', 'password_hash_seguro', TRUE);

INSERT INTO mascota (nombre, especie, sexo, tamanio, fecha_nacimiento_aprox, fecha_ingreso, descripcion, estado) 
VALUES ('Rocco', 'PERRO', 'MACHO', 'GRANDE', '2023-05-10', '2026-01-15', 'Perro rescatado muy amigable, ideal para familias.', 'DISPONIBLE');
