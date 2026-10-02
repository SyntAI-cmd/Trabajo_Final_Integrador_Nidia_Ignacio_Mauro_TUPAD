# Arquitectura

Este documento define cómo se organiza el código de AdoptAR: en qué carpetas va cada cosa y quién puede usar a quién. La idea es que cuando alguien de los tres cree una clase nueva, no tenga que preguntar dónde ponerla.

---

## La decisión: paquetes por dominio, con capas adentro

Evaluamos tres opciones:

| Opción | Cómo se ve | Por qué sí o por qué no |
|---|---|---|
| **Por capas** | `controller/`, `service/`, `repository/`, `entity/` en la raíz | Es lo que más vimos en la carrera. El problema es que con el tiempo cada carpeta junta clases de todos los temas: para tocar "vacunas" hay que abrir cuatro carpetas distintas y buscar entre clases que no tienen nada que ver. |
| **Monolito modular estricto** | Módulos con una API pública y el resto oculto, verificado por una herramienta (por ejemplo Spring Modulith) | Es la versión más prolija, pero suma reglas y herramientas que no vimos. Para seis tablas y tres personas es más estructura de la que necesitamos. Va contra el criterio de `02-decisiones.md`: si no lo vimos en la carrera, no va. |
| **Por dominio con capas adentro** ✅ | Un paquete por tema del negocio (`mascota`, `sanidad`, `adopcion`, `usuario`) y adentro de cada uno las capas de siempre | Mantiene las capas que ya conocemos, pero agrupadas por tema. Todo lo de vacunas está en un solo lugar. Cada integrante trabaja mayormente en "su" paquete y se pisan menos los cambios. |

**Elegimos la tercera.** En la práctica es un *monolito modular liviano*: una sola aplicación, un solo despliegue, pero con el código separado por tema. Las reglas de dependencia (más abajo) las controlamos en la revisión de los pull requests, no con una herramienta.

Si el proyecto creciera mucho, este esquema es el paso previo natural a un monolito modular estricto: los módulos ya estarían separados, solo faltaría hacer cumplir las fronteras con una herramienta.

---

## Estructura de carpetas

```
src/
├── main/
│   ├── java/ar/edu/utn/adoptar/
│   │   ├── AdoptarApplication.java      Punto de entrada de Spring Boot
│   │   │
│   │   ├── mascota/                     El animal: alta, edición, estado, fotos
│   │   │   ├── Mascota.java             Entidad JPA
│   │   │   ├── Foto.java                Entidad JPA
│   │   │   ├── Especie.java             enum PERRO, GATO
│   │   │   ├── Sexo.java                enum MACHO, HEMBRA
│   │   │   ├── Tamanio.java             enum CHICO, MEDIANO, GRANDE
│   │   │   ├── EstadoMascota.java       enum DISPONIBLE, EN_PROCESO, ADOPTADO, NO_DISPONIBLE
│   │   │   ├── MascotaRepository.java
│   │   │   ├── FotoRepository.java
│   │   │   ├── MascotaService.java
│   │   │   ├── FotoService.java         Guarda el archivo en disco y la referencia en la base
│   │   │   ├── MascotaPublicaController.java   Listado y ficha pública (sin login)
│   │   │   └── MascotaAdminController.java     Panel de administración (con login)
│   │   │
│   │   ├── sanidad/                     Registro de vacunas
│   │   │   ├── Vacuna.java
│   │   │   ├── VacunaRepository.java
│   │   │   ├── VacunaService.java
│   │   │   └── VacunaController.java
│   │   │
│   │   ├── adopcion/                    Adoptantes y adopciones
│   │   │   ├── Adoptante.java
│   │   │   ├── Adopcion.java
│   │   │   ├── AdoptanteRepository.java
│   │   │   ├── AdopcionRepository.java
│   │   │   ├── AdopcionService.java
│   │   │   └── AdopcionController.java
│   │   │
│   │   ├── usuario/                     Personal del refugio y login
│   │   │   ├── Usuario.java
│   │   │   ├── UsuarioRepository.java
│   │   │   ├── UsuarioDetailsService.java   Adaptador para Spring Security
│   │   │   └── LoginController.java
│   │   │
│   │   └── config/                      Configuración técnica transversal
│   │       ├── SecurityConfig.java      Qué rutas son públicas y cuáles piden login
│   │       └── WebConfig.java           Carpeta de imágenes subidas, etc.
│   │
│   └── resources/
│       ├── application.properties
│       ├── templates/                   Vistas Thymeleaf, una carpeta por módulo
│       │   ├── publico/                 listado.html, ficha.html
│       │   ├── admin/                   mascotas.html, mascota-form.html, vacunas.html, adopcion-form.html
│       │   ├── login.html
│       │   └── fragments/               layout.html, header.html (partes comunes)
│       └── static/
│           ├── css/estilos.css
│           └── img/                     Imágenes fijas del sitio (logo, placeholder)
│
└── test/java/ar/edu/utn/adoptar/        Mismos paquetes que main
    ├── mascota/
    ├── sanidad/
    └── adopcion/

db/
└── schema.sql                           Script de creación de la base (hoy en la raíz)

uploads/                                 Fotos subidas por los operadores (NO se sube a git)
```

> El nombre del paquete raíz (`ar.edu.utn.adoptar`) es una propuesta; lo define quien crea el proyecto Spring Boot. Lo importante es lo que va adentro.

### ¿Por qué `Foto` está en `mascota` y `Vacuna` en un módulo aparte?

La foto no tiene sentido sin la mascota: solo sirve para mostrarla. La vacuna, en cambio, es un registro sanitario con reglas propias (próxima dosis, observaciones del veterinario) y es la base de una mejora futura ya anotada (aviso de próxima dosis). Tenerla aparte deja ese crecimiento ordenado.

---

## Las capas dentro de cada módulo

Cada módulo repite las mismas cuatro piezas. La regla es que **las llamadas van siempre hacia abajo**:

```
Controller   Recibe el pedido HTTP, valida el formulario y elige la vista Thymeleaf.
    │        No tiene lógica de negocio.
    ▼
Service      Las reglas: "solo se listan las DISPONIBLE", "una sola foto principal",
    │        "al registrar una adopción la mascota pasa a ADOPTADO". Maneja @Transactional.
    ▼
Repository   Interfaz de Spring Data JPA. Solo consultas.
    │
    ▼
Entidad      La clase @Entity que representa la tabla.
```

Reglas concretas:

1. **Un controller nunca usa un repository directamente.** Siempre pasa por el service, aunque el service solo delegue. Así, cuando aparezca una regla nueva, ya hay un lugar donde ponerla.
2. **Las entidades no se mandan tal cual a formularios de edición** cuando el formulario tiene menos campos que la entidad: se usa una clase `...Form` en el mismo paquete. Para los listados y fichas de solo lectura se puede pasar la entidad.
3. **Ninguna vista pública muestra datos de `Adoptante`** (DNI, teléfono, dirección). Son datos personales.

---

## Relaciones entre módulos

```
                 ┌────────────┐
                 │  usuario   │   (solo lo usa config/ para el login)
                 └────────────┘

 ┌────────────┐        ┌────────────┐        ┌────────────┐
 │  sanidad   │ ─────▶ │  mascota   │ ◀───── │  adopcion  │
 └────────────┘        └────────────┘        └────────────┘
```

- `mascota` es el centro y **no depende de nadie**.
- `sanidad` y `adopcion` dependen de `mascota` (una vacuna y una adopción siempre pertenecen a una mascota).
- `sanidad` y `adopcion` **no se conocen entre sí**.
- Cuando un módulo necesita algo de otro, **llama a su service, no a su repository**. Ejemplo: `AdopcionService` usa `MascotaService.cambiarEstado(...)` para pasar la mascota a `ADOPTADO`; no toca `MascotaRepository`.
- `config/` puede usar cualquier módulo; ningún módulo depende de `config/`.

Esto es lo que mira la persona que revisa un pull request en el punto **Fronteras de módulo** de `CONTRIBUTING.md`.

### Mapeo JPA de las relaciones

| Relación | Dónde se mapea | Cómo |
|---|---|---|
| Mascota → Fotos | `Foto` | `@ManyToOne Mascota mascota` (y opcionalmente `@OneToMany(mappedBy)` en `Mascota`, porque viven en el mismo módulo) |
| Vacuna → Mascota | `Vacuna` | `@ManyToOne Mascota mascota`. `Mascota` **no** tiene una lista de vacunas, para no depender de `sanidad`. Las vacunas de una mascota se piden con `VacunaService.listarPorMascota(id)`. |
| Adopción → Mascota | `Adopcion` | `@OneToOne Mascota mascota` (la columna es `UNIQUE`). |
| Adopción → Adoptante | `Adopcion` | `@ManyToOne Adoptante adoptante`. |

Los enums se guardan con `@Enumerated(EnumType.STRING)` para que en la base quede `DISPONIBLE` y no un número.

---

## Qué queda afuera de esta arquitectura

- **No hay API REST separada.** El servidor arma el HTML con Thymeleaf (ver `02-decisiones.md`, decisión 2). Si en el futuro hace falta, se agrega un `...ApiController` dentro de cada módulo.
- **No hay capa de DTOs para todo.** Solo se crean clases `...Form` donde el formulario lo necesita.
- **No hay interfaces para los services** (`MascotaService` + `MascotaServiceImpl`). Con una sola implementación por service, la interfaz no aporta.