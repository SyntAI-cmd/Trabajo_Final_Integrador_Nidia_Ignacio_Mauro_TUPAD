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

Cada una de estas cosas puede sumarse más adelante como una tarea aparte. Están anotadas en `docs/04-tareas.md`.

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

El razonamiento completo de por qué elegimos esto, y qué otra opción evaluamos, está en `docs/02-decisiones.md`.

---

## Estructura del repositorio

```
AdoptAR/
├── README.md              Este archivo
├── CONTRIBUTING.md        Cómo trabajar en el repo y subir cambios
├── docs/
│   ├── 01-alcance.md      Qué hace y qué no hace el sistema, en detalle
│   ├── 02-decisiones.md   Por qué elegimos cada tecnología
│   ├── 03-modelo-datos.md Las tablas de la base y qué guarda cada una
│   └── 04-tareas.md       Lista de tareas repartidas entre los tres
└── (el código se agrega a partir de acá)
```

Todavía no hay código. La documentación se escribió primero para que los tres sepamos qué estamos construyendo antes de empezar a escribir.

---

## Estado del proyecto

En documentación. Próximo paso: crear el proyecto Spring Boot y la base de datos, según lo que está descripto en `docs/03-modelo-datos.md`.
