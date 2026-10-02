# AdoptAR

Plataforma web para publicar animales en adopción y llevar el seguimiento de cada uno hasta que consigue hogar.

Proyecto de la materia Trabajo Final de Programación. Integrantes: Mauro Ponce, Nidia Samaniego, Ignacio Roveres. Universidad Tecnológica Nacional (UTN), Tecnicatura Universitaria en Programación a distancia. 

---

## El problema

Los refugios y las áreas de zoonosis municipales manejan la información de los animales en papel, en planillas de Excel sueltas y en publicaciones de Facebook o Instagram.

Eso trae tres problemas concretos:

1. **La información se pierde.** Si el animal cambia de responsable, o pasa el tiempo, nadie sabe qué vacunas tiene puestas ni cuándo se las aplicaron.
2. **La gente no sabe qué hay disponible.** Las publicaciones quedan enterradas en el muro de la red social. Un animal publicado hace tres meses ya no lo ve nadie, aunque siga sin adoptar.
3. **No se sabe en qué estado está cada caso.** No hay forma rápida de responder "¿cuántos animales tenemos ahora mismo sin adoptar?".

AdoptAR resuelve eso con una base de datos y dos pantallas: una pública, donde cualquier persona ve los animales disponibles con sus fotos, y una privada, donde el personal del refugio carga los animales, registra las vacunas y marca cuándo alguno fue adoptado.

No busca reemplazar el trámite de adopción. Busca que la información esté en un solo lugar y sea consultable.

---

## Alcance de esta primera versión

Preferimos entregar poco y que funcione bien. Lo que entra en la primera versión es esto:

**Parte pública (sin login)**
- Listado de animales disponibles, con foto, nombre y datos básicos.
- Ficha de cada animal: descripción, especie, sexo, edad aproximada, tamaño y sus fotos.

**Parte de administración (con login)**
- Iniciar y cerrar sesión.
- Cargar un animal nuevo, editarlo y darlo de baja.
- Subir fotos de un animal.
- Registrar las vacunas aplicadas, con fecha.
- Cambiar el estado del animal: disponible, en proceso de adopción, adoptado, no disponible.

**Lo que NO entra en esta versión** (y por qué)

| Queda afuera | Motivo |
|---|---|
| Solicitudes de adopción online | Suma un circuito de estados y validaciones que duplica el trabajo. Por ahora el contacto se hace por teléfono, como ya lo hacen. |
| Varios municipios en el mismo sistema | El sistema se piensa para un refugio. Si después hace falta, se agrega. |
| Notificaciones por mail | No es necesario para que el sistema cumpla su función. |
| Reportes y estadísticas | Se pueden hacer después, cuando haya datos cargados de verdad. |
| Aplicación móvil nativa | La web se ve bien en el celular. Alcanza. |

Cada una de estas cosas puede sumarse más adelante como una tarea aparte. Están anotadas en `Docs/04-tareas.md`.

---

## Tecnologías

| Para qué | Qué usamos |
|---|---|
| Lenguaje | Java 17 |
| Framework | Spring Boot 3 |
| Vistas (HTML) | Thymeleaf |
| Base de datos | MySQL 8 |
| Acceso a datos | Spring Data JPA |
| Gestión del proyecto | Maven |
| Estilos | CSS propio (sin framework) |

Todo el proyecto es **una sola aplicación**. No hay un backend por un lado y un frontend por otro: el servidor arma el HTML y lo manda al navegador. Eso significa un solo repositorio, un solo comando para levantarlo y un solo lenguaje para todo el equipo.

El razonamiento completo de por qué elegimos esto, y qué otra opción evaluamos, está en `Docs/02-decisiones.md`.

---

## Estructura del repositorio

```
├── README.md              Este archivo
├── CONTRIBUTING.md        Cómo trabajar en el repo y subir cambios
├── schema.sql             Script que crea las tablas en MySQL
└── Docs/
    ├── 01-alcance.md      Qué hace y qué no hace el sistema, en detalle
    ├── 02-decisiones.md   Por qué elegimos cada tecnología
    ├── 03-modelo-datos.md Las tablas de la base y qué guarda cada una
    ├── 04-tareas.md       Lista de tareas repartidas entre los tres
    └── 05-arquitectura.md Cómo se organiza el código en carpetas y módulos
```

El código Java se va a organizar por dominio (`mascota`, `sanidad`, `adopcion`, `usuario`), con las capas controller / service / repository dentro de cada módulo. El detalle está en [`Docs/05-arquitectura.md`](Docs/05-arquitectura.md).

---

## Cómo instalar y correr el proyecto

### 1. Requisitos

| Herramienta | Versión | Para comprobar |
|---|---|---|
| Java (JDK) | 17 o superior | `java -version` |
| MySQL Server | 8.0.16 o superior | `mysql --version` |
| Git | cualquiera | `git --version` |
| Maven | no hace falta instalarlo: el proyecto trae el *wrapper* `mvnw` | — |

MySQL Workbench es opcional, pero sirve para ver las tablas y correr el script con la interfaz gráfica.

### 2. Clonar el repositorio

```bash
git clone https://github.com/SyntAI-cmd/Trabajo_Final_Integrador_Nidia_Ignacio_Mauro_TUPAD.git
cd Trabajo_Final_Integrador_Nidia_Ignacio_Mauro_TUPAD
```

### 3. Crear la base de datos

Crear la base vacía y después correr `schema.sql` adentro:

```bash
mysql -u root -p -e "CREATE DATABASE adoptar CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;"
mysql -u root -p adoptar < schema.sql
```

En Windows con PowerShell el `<` no funciona; usar `cmd` o, desde MySQL Workbench: *File → Open SQL Script → schema.sql*, elegir la base `adoptar` y ejecutar (⚡).

> ⚠️ `schema.sql` empieza con `DROP TABLE`: **borra todas las tablas y sus datos**. Correrlo solo para crear la base de cero.

### 4. Crear el primer usuario del refugio

El script no crea usuarios, y sin uno no se puede entrar al panel. La contraseña se guarda encriptada con BCrypt, así que no se puede escribir tal cual. Este `INSERT` crea un usuario con la contraseña `admin123`:

```sql
USE adoptar;
INSERT INTO usuario (nombre, email, password, activo)
VALUES ('Administrador', 'admin@adoptar.local',
        '$2a$10$W9VqBy5GGfAbtv/3kghk2.43IBmFKN97duUuHjJFHAGPfeLryyV56', TRUE);
```

Cambiar esa contraseña apenas se pueda. Es solo para desarrollo.

### 5. Configurar la conexión

La aplicación lee los datos de conexión de variables de entorno, para que nadie suba su contraseña de MySQL al repositorio. En `src/main/resources/application.properties` está así:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/adoptar
spring.datasource.username=${DB_USER:root}
spring.datasource.password=${DB_PASSWORD:}
spring.jpa.hibernate.ddl-auto=validate
spring.sql.init.mode=never
app.uploads.dir=${UPLOADS_DIR:uploads}
```

Antes de correr, definir la contraseña en la terminal:

```bash
# Linux / macOS
export DB_PASSWORD=tu_contraseña

# Windows (PowerShell)
$env:DB_PASSWORD="tu_contraseña"
```

`ddl-auto=validate` hace que Hibernate **no toque** las tablas: solo verifica que coincidan con las entidades. Las tablas las crea `schema.sql`, no la aplicación. `spring.sql.init.mode=never` evita que Spring ejecute el script solo al arrancar (y con él, los `DROP TABLE`).

### 6. Levantar la aplicación

```bash
# Linux / macOS
./mvnw spring-boot:run

# Windows
mvnw.cmd spring-boot:run
```

Cuando en la consola aparece `Started AdoptarApplication`, abrir:

- Parte pública: <http://localhost:8080>
- Panel del refugio: <http://localhost:8080/login> (usuario `admin@adoptar.local`, contraseña `admin123`)

### 7. Correr las pruebas

```bash
./mvnw test
```

### Problemas comunes

| Error | Causa probable |
|---|---|
| `Access denied for user 'root'@'localhost'` | La variable `DB_PASSWORD` no está definida en esa terminal, o la contraseña es otra. |
| `Unknown database 'adoptar'` | Falta el paso 3. |
| `Schema-validation: missing table` / `missing column` | Una entidad no coincide con `schema.sql`. Revisar nombres de columnas (`@Column(name = ...)`). |
| `Port 8080 was already in use` | Hay otra aplicación usando ese puerto. Cerrarla o agregar `server.port=8081` en `application.properties`. |

---

## Estado del proyecto

Documentación, modelo de datos (`schema.sql`) y arquitectura definidos. Próximo paso: crear el proyecto Spring Boot con la estructura de `Docs/05-arquitectura.md` y conectarlo a la base. Los pasos 5 a 7 de la instalación quedan listos para cuando el proyecto esté subido.