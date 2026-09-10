# Reparto de tareas

Este documento traduce el tablero de Trello del proyecto a texto, para que quede versionado en el repositorio y no dependa de que los tres tengamos la sesión de Trello abierta. Es una fotografía del tablero al **10 de septiembre de 2026**; el tablero en sí sigue siendo la fuente viva donde se mueven las tarjetas día a día.

El tablero tiene cinco columnas y las tarjetas se mueven de izquierda a derecha a medida que avanzan:

| Columna | Qué significa |
|---|---|
| 💡 Ideas para después | No entra en esta entrega. Ver `01-alcance.md` para el porqué de cada una. |
| 📝 Pendiente | Definida, todavía sin empezar. |
| 🔧 Haciendo | Alguien la está escribiendo ahora mismo. |
| 🔍 En revisión | El código está escrito y espera que otro integrante lo revise (ver `CONTRIBUTING.md`, nadie aprueba su propio trabajo). |
| ✅ Hecho | Terminada y en el repositorio. |

Cada tarjeta tiene una etiqueta de color que indica el área (`Backend`, `Pantallas`, `Documentación`, `Base del proyecto`) y, cuando ya tiene dueño, una segunda etiqueta con el nombre: **Ignacio** (naranja), **Mauro** (azul), **Nidia** (verde). En Trello, Mauro aparece unido a sus tarjetas con el usuario `ryzenbox`.

---

## Las tres tareas que destraban el resto

Las tarjetas de la etiqueta `Base del proyecto` bloquean a todas las demás: sin el proyecto Spring Boot creado, sin las tablas en MySQL y sin la conexión funcionando, nadie más puede empezar a programar en serio. Por eso son lo primero que se resuelve, una por integrante:

| Tarea | Responsable | Estado | Se considera terminada cuando... |
|---|---|---|---|
| Crear el proyecto Spring Boot con Maven y subirlo | Mauro | 🔧 Haciendo | El proyecto arranque y se vea la estructura base en el repo. |
| Escribir el script SQL que crea las cuatro tablas | Nidia | 🔧 Haciendo | El script cree las cuatro tablas sin errores. |
| Configurar la conexión a MySQL y verificar que arranque | Ignacio | 📝 Pendiente | El sistema levante y se conecte a la base sin fallar. |

---

## Reparto por integrante

### Ignacio Roveres

| Tarea | Estado | Se considera terminada cuando... |
|---|---|---|
| Configurar la conexión a MySQL y verificar que arranque | 📝 Pendiente | El sistema levante bien y se conecte a la base sin fallar. |
| Subida de fotos: archivo al servidor, referencia a la base | 📝 Pendiente | La imagen se suba bien y quede asociada al animal. |
| Marcar una foto como principal | 📝 Pendiente | Se pueda elegir una foto y quede marcada correctamente. |
| Pantalla para registrar vacunas de un animal | 📝 Pendiente | Se puedan registrar vacunas y verlas guardadas. |
| Listado de vacunas en la ficha de administración | 📝 Pendiente | El administrador vea ahí el historial de vacunas. |
| Hoja de estilos que se adapte al celular | 📝 Pendiente | Las pantallas se usen cómodo en una pantalla chica. |
| Probar la secuencia completa de punta a punta *(junto con Mauro)* | 📝 Pendiente | El flujo funcione sin errores de principio a fin. |
| Subir el CONTRIBUTING con las reglas de trabajo en el repo | 🔧 Haciendo | El archivo explique cómo colaborar y quede guardado en el repositorio. |
| Subir el archivo de reparto de tareas (este archivo) | 🔧 Haciendo | El archivo esté subido y se vea desde el repositorio. |
| Mover los documentos a una carpeta `docs/` | 🔍 En revisión | Los archivos estén ahí y el repositorio quede más prolijo. |

### Mauro Ponce

| Tarea | Estado | Se considera terminada cuando... |
|---|---|---|
| Crear el proyecto Spring Boot con Maven y subirlo | 🔧 Haciendo | El proyecto arranque y se vea la estructura base en el repo. |
| Clases de entidad: Mascota, Vacuna, Foto, Usuario | 🔧 Haciendo | Esas clases existan y tengan los campos necesarios del modelo. |
| Repositorios de Spring Data JPA para las cuatro entidades | 🔧 Haciendo | Cada entidad tenga su repositorio funcionando. |
| Pantalla pública: listado de animales disponibles | 📝 Pendiente | Cualquiera pueda entrar y ver el listado correctamente. |
| Pantalla pública: ficha de un animal | 📝 Pendiente | Desde el listado se pueda abrir la ficha y ver su información. |
| Filtros del listado por especie y por tamaño | 📝 Pendiente | El listado muestre solo lo que coincide con el filtro elegido. |
| Probar la secuencia completa de punta a punta *(junto con Ignacio)* | 📝 Pendiente | El flujo funcione sin errores de principio a fin. |

### Nidia Samaniego

| Tarea | Estado | Se considera terminada cuando... |
|---|---|---|
| Escribir el script SQL que crea las cuatro tablas | 🔧 Haciendo | El script cree las cuatro tablas sin errores. |
| Login y logout con Spring Security | 📝 Pendiente | Se pueda iniciar y cerrar sesión sin problemas. |
| Guardar la contraseña encriptada con BCrypt | 📝 Pendiente | Las contraseñas se guarden de forma segura y el acceso siga funcionando. |
| Panel de administración: listado de todos los animales | 📝 Pendiente | El administrador pueda verlos todos desde ese panel. |
| Formulario para cargar y editar un animal | 📝 Pendiente | Se pueda guardar cambios y verlos reflejados. |
| Cambiar el estado de un animal | 📝 Pendiente | El cambio quede guardado y se vea en la ficha o el listado. |

---

## Documentación (sin dueño individual)

Estas se escribieron entre los tres, por eso no llevan una etiqueta de nombre:

| Tarea | Estado |
|---|---|
| Escribir el README con el problema, el alcance y el stack | ✅ Hecho |
| Escribir el documento de alcance | ✅ Hecho |
| Escribir las decisiones técnicas | ✅ Hecho |
| Escribir el modelo de datos | ✅ Hecho |
| Cargar diez animales de ejemplo con fotos | 📝 Pendiente |
| Escribir en el README cómo instalar y correr el proyecto | 📝 Pendiente |

---

## Fuera de esta entrega (ideas para después)

Estas tarjetas están en el tablero para no perder la idea, pero no se van a hacer en esta versión. El porqué de cada una está desarrollado en `01-alcance.md`; acá va solo el resumen:

| Idea | Se consideraría terminada cuando... |
|---|---|
| Convertir la web en PWA | Se pueda abrir desde el navegador, instalar y usar desde un acceso directo. |
| Formulario público de solicitud de adopción | El pedido se pueda completar, enviar y guardar correctamente. |
| Aviso cuando toca la próxima dosis de una vacuna | El sistema muestre o registre el aviso en el momento correcto. |
| Buscador por nombre | Se pueda escribir un nombre y ver los resultados filtrados. |
| Reporte de adopciones por mes | Se pueda consultar el reporte con datos correctos. |

---

## Cómo se actualiza este archivo

El tablero de Trello es el que se edita en el día a día: ahí se mueven las tarjetas, se agregan comentarios y se marcan los checklists. Este archivo se vuelve a exportar y actualizar cada vez que el reparto cambia de forma importante (se suma una tarea, cambia de dueño, o se termina un tramo grande), no después de cada movimiento chico de una tarjeta.