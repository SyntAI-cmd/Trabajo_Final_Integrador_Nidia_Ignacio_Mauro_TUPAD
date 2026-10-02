# 🤝 Cómo contribuir a AdoptAR

Gracias por tu interés. Esta guía define cómo trabajamos, para que el código se mantenga coherente aunque lo escriban tres personas distintas.

---

## 🌱 Antes de empezar

1. Leé el [alcance](Docs/01-alcance.md) y el [modelo de datos](Docs/03-modelo-datos.md). Usamos los mismos nombres en el código y en la conversación: `mascota`, `vacuna`, `adopcion`, `adoptante`.
2. Revisá si lo que querés hacer está en [qué queda afuera](Docs/01-alcance.md#qué-queda-afuera). Si está, hay un fundamento escrito que hay que discutir antes de reabrirlo.
3. Fijate en [la arquitectura](Docs/05-arquitectura.md) en qué módulo va lo que vas a escribir.
4. Para cambios que no sean triviales, avisá en el grupo o abrí un issue antes de escribir código. Es más barato discutir una idea que descartar una implementación.

---

## 🌿 Ramas

| Rama | Propósito | De dónde sale |
|---|---|---|
| `main` | La versión que funciona y se entrega. Nadie sube directo: todo entra por pull request | — |
| `feat/descripcion-corta` | Funcionalidad nueva (ej. `feat/listado-publico`) | `main` |
| `fix/descripcion-corta` | Corrección de un error | `main` |
| `docs/descripcion-corta` | Sólo documentación | `main` |
| `chore/descripcion-corta` | Configuración, dependencias | `main` |

Con tres personas y una sola entrega, no usamos rama `develop` ni entornos de staging: sería mantener dos ramas para el mismo trabajo. Antes de abrir el PR, actualizá tu rama con lo último de `main`.

---

## 💬 Mensajes de commit

Seguimos [Conventional Commits](https://www.conventionalcommits.org/es/).

```
<tipo>(<ámbito>): <descripción en imperativo>

[cuerpo opcional]

[pie opcional]
```

### Tipos

| Tipo | Cuándo |
|---|---|
| `feat` | Funcionalidad nueva |
| `fix` | Corrección de un error |
| `docs` | Sólo documentación |
| `refactor` | Cambio interno sin alterar el comportamiento |
| `test` | Agregar o corregir pruebas |
| `perf` | Mejora de rendimiento |
| `chore` | Configuración, dependencias, tareas de mantenimiento |

### Ámbitos

Coinciden con los módulos de [la arquitectura](Docs/05-arquitectura.md), más los técnicos:

`mascota` · `sanidad` · `adopcion` · `usuario` · `config` · `db` · `ui`

### Ejemplos

```
feat(adopcion): registrar adopción y pasar la mascota a ADOPTADO

AdopcionService guarda el adoptante y la adopción, y usa
MascotaService.cambiarEstado() para actualizar el estado.

Closes #12
```

```
fix(sanidad): permitir próxima dosis vacía

El formulario exigía la fecha de próxima dosis aunque la columna
admite NULL. Se quita la validación @NotNull del campo.
```

> **Escribí la descripción en imperativo:** «agregar», no «agregado» ni «agrega». Es la convención, y además hace que el historial se lea como una lista de instrucciones aplicadas.

---

## ✅ Definición de terminado

Una tarea está terminada cuando cumple **las cinco condiciones**:

1. El código hace lo que dice la tarjeta de Trello ("Se considera terminada cuando...").
2. El proyecto compila y las pruebas pasan: `./mvnw test`.
3. Un integrante **distinto del autor** revisó el pull request.
4. La documentación afectada está actualizada (README, `Docs/`, `schema.sql`).
5. No quedan `System.out.println` de depuración ni código comentado.

---

## 👀 Revisión de pull requests

### Reglas

- **Nadie aprueba su propio PR.** Sin excepciones.
- Los PR chicos se revisan bien; los de 800 líneas se aprueban sin leer. Preferí varios PR pequeños.
- La revisión es sobre el código, nunca sobre la persona.
- Si algo no se entiende, la respuesta correcta no es explicarlo en el comentario: es hacer que el código no necesite la explicación.

### Qué mira quien revisa

| Aspecto | Pregunta |
|---|---|
| **Corrección** | ¿Hace lo que dice? ¿Hay algún camino no contemplado? |
| **Fronteras de módulo** | ¿Usa otro módulo solo a través de su service? (ver [arquitectura](Docs/05-arquitectura.md)) |
| **Capas** | ¿El controller pasa por el service? ¿Hay lógica de negocio en el controller? |
| **Datos personales** | ¿Algún dato del adoptante (DNI, teléfono, dirección) puede llegar a una pantalla pública? |
| **Base de datos** | ¿Las entidades siguen coincidiendo con `schema.sql`? |
| **Pruebas** | ¿Prueban comportamiento o implementación? |
| **Legibilidad** | ¿Alguien que llegue en seis meses lo va a entender? |

---

## 🧪 Pruebas

| Nivel | Herramienta | Qué se prueba ahí |
|---|---|---|
| Unitarias | JUnit 5 + Mockito | Los services: reglas como "solo se listan las DISPONIBLE" o "una sola foto principal" |
| Integración | `@SpringBootTest` / `@DataJpaTest` | Repositorios y controllers contra una base MySQL de prueba |
| Punta a punta | Manual | La secuencia de [Cómo sabemos que está terminado](Docs/01-alcance.md#cómo-sabemos-que-está-terminado) |

```bash
./mvnw test
```

---

## 🎨 Estilo de código

Usamos el formato por defecto del IDE (IntelliJ o Eclipse) con sangría de 4 espacios. Antes de hacer commit, *Reformat Code* sobre los archivos que tocaste.

### Convenciones

- **Nombres en español** para los conceptos del dominio (`Mascota`, `fechaIngreso`, `cambiarEstado`), **en inglés** para lo técnico (`Repository`, `Service`, `Controller`).
- Sin abreviaturas inventadas: `vacuna`, no `vac`.
- Los métodos dicen qué hacen: `listarDisponibles`, no `procesar`.
- Comentarios que explican **por qué**, no qué. El qué ya está en el código.

---

## 🗄️ Cambios en la base de datos

| Regla |
|---|
| Todo cambio de tablas se hace en `schema.sql` y se revisa en el PR, junto con la entidad Java que corresponda |
| Si cambia una columna, se actualiza también [`Docs/03-modelo-datos.md`](Docs/03-modelo-datos.md) |
| Nadie modifica la estructura de la base a mano sin pasarlo al script |
| La aplicación nunca crea ni modifica tablas: usa `spring.jpa.hibernate.ddl-auto=validate` |

---

## 📜 Decisiones de arquitectura

Si tu cambio implica una decisión costosa de revertir (una librería nueva, otra forma de organizar el código), agregala en [`Docs/02-decisiones.md`](Docs/02-decisiones.md) con el mismo formato: qué elegimos, qué otra opción evaluamos y por qué.

Una decisión sin contras declaradas es publicidad, no documentación. Escribí los costos con el mismo detalle que los beneficios.

---

## 🐛 Reportar errores

Abrí un issue en GitHub con: qué hiciste, qué esperabas que pasara y qué pasó (si hay un error en consola, pegalo completo).

---

## 💙 Convivencia

La revisión es sobre el código, nunca sobre la persona. Si algo no se entiende, se pregunta.

---

<div align="center">
<sub>¿Dudas? Abrí un issue con la etiqueta <code>question</code>. No hay preguntas tontas.</sub>
</div>