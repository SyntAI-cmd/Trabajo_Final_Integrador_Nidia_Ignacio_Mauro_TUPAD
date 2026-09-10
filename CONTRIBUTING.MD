# 🤝 Cómo contribuir a AdoptAR

Gracias por tu interés. Esta guía define cómo trabajamos, para que el código se mantenga coherente aunque lo escriban tres personas distintas.

---

## 🌱 Antes de empezar

1. Leé el [glosario](docs/17-glosario.md). El proyecto usa un lenguaje ubicuo: un término, un significado, en el código y en la conversación.
2. Revisá si lo que querés hacer está en [fuera de alcance](docs/02-alcance.md#43-fuera-de-alcance). Si está, hay un fundamento escrito que hay que refutar antes de reabrirlo.
3. Abrí un issue antes de escribir código para cambios que no sean triviales. Es más barato discutir una idea que descartar una implementación.

---

## 🌿 Ramas

| Rama | Propósito | De dónde sale |
|---|---|---|
| `main` | Refleja producción. Protegida | — |
| `develop` | Integración. Despliega a staging. Protegida | `main` |
| `feat/AD-123-descripcion` | Funcionalidad nueva | `develop` |
| `fix/AD-124-descripcion` | Corrección de error | `develop` |
| `docs/AD-125-descripcion` | Sólo documentación | `develop` |
| `chore/AD-126-descripcion` | Mantenimiento, dependencias, configuración | `develop` |
| `hotfix/AD-127-descripcion` | Urgencia en producción | `main` |

Un `hotfix` se integra en `main` **y en `develop`**. Olvidarse del segundo merge reintroduce el error en el siguiente despliegue.

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
| `ci` | Cambios en el pipeline |

### Ámbitos

`animales` · `sanidad` · `adopciones` · `seguimiento` · `identidad` · `auditoria` · `catalogo` · `api` · `db` · `ui` · `infra`

### Ejemplos

```
feat(adopciones): agregar transición de preaprobación

Implementa RF-208 para la transición EN_REVISION -> PREAPROBADA,
con guard de rol y registro en la bitácora.

Closes #42
```

```
fix(sanidad): corregir cálculo de vigencia en años bisiestos

La suma de 365 días producía un desfase de un día cuando el período
atravesaba un 29 de febrero. Se reemplaza por aritmética de fechas.

Refs RN-12
```

> **Escribí la descripción en imperativo:** «agregar», no «agregado» ni «agrega». Es la convención, y además hace que el historial se lea como una lista de instrucciones aplicadas.

---

## ✅ Definición de terminado

Una tarea está terminada cuando cumple **las siete condiciones**:

1. El código implementa el requisito y sus criterios de aceptación.
2. Existen pruebas que ejercen el comportamiento nuevo.
3. El pipeline de CI está en verde.
4. Un integrante **distinto del autor** revisó el pull request.
5. La documentación afectada está actualizada.
6. El incremento está desplegado en el entorno de preview.
7. No introduce advertencias nuevas de lint ni de tipos.

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
| **Fronteras de módulo** | ¿Accede a otro módulo sólo por su superficie pública? |
| **Invariantes** | ¿Toca la máquina de estados o el modelo sanitario? ¿Respeta los ADR? |
| **Datos personales** | ¿Algún dato del adoptante puede llegar a una superficie pública? |
| **Aislamiento** | ¿Alguna consulta escapa al filtro por municipio? |
| **Pruebas** | ¿Prueban comportamiento o implementación? |
| **Legibilidad** | ¿Alguien que llegue en seis meses lo va a entender? |

---

## 🧪 Pruebas

| Nivel | Herramienta | Qué se prueba ahí |
|---|---|---|
| Unitarias | Vitest | Dominio puro: máquinas de estado, cálculos, reglas |
| Integración | Supertest + Testcontainers | Endpoints contra PostgreSQL real |
| E2E | Playwright | Los criterios de aceptación `CA-1` a `CA-6` |

```bash
npm run test:unit
```

```bash
npm run test:integration
```

Detalle completo en [docs/14-testing-y-calidad.md](docs/14-testing-y-calidad.md).

---

## 🎨 Estilo de código

Lo resuelven las herramientas, no la discusión:

```bash
npm run format && npm run lint:fix
```

| Herramienta | Rol |
|---|---|
| Prettier | Formato. No se discute |
| ESLint | Errores comunes y reglas del proyecto |
| TypeScript `strict` | Tipos, nulos, exhaustividad |

### Convenciones que las herramientas no cubren

- **Nombres en español** para los conceptos del dominio (`solicitudAdopcion`, `eventoSanitario`), **en inglés** para lo técnico (`repository`, `handler`, `dto`).
- Sin abreviaturas inventadas: `solicitud`, no `sol`.
- Las funciones dicen qué hacen: `calcularVigencia`, no `procesar`.
- Comentarios que explican **por qué**, no qué. El qué ya está en el código.

---

## 🗄️ Migraciones de base de datos

| Regla |
|---|
| Toda migración es un archivo versionado, revisado en el PR |
| Ninguna migración destructiva sin respaldo verificado previo |
| Los cambios de columna se hacen en dos pasos: agregar y migrar datos, y **en un PR posterior** eliminar |
| El esquema de producción nunca se modifica a mano |

```bash
npx prisma migrate dev --name descripcion_del_cambio
```

---

## 📜 Decisiones de arquitectura

Si tu cambio implica una decisión costosa de revertir, escribí un [ADR](docs/adr/README.md).

Un ADR sin consecuencias negativas declaradas es publicidad, no documentación. Escribí los costos con el mismo detalle que los beneficios.

---

## 🐛 Reportar errores

Usá las [plantillas de issue](.github/ISSUE_TEMPLATE/). Si es una vulnerabilidad de seguridad, **no abras un issue público**: seguí [SECURITY.md](SECURITY.md).

---

## 💙 Código de conducta

Toda interacción en este repositorio se rige por el [Código de Conducta](CODE_OF_CONDUCT.md).

---

<div align="center">
<sub>¿Dudas? Abrí un issue con la etiqueta <code>question</code>. No hay preguntas tontas.</sub>
</div>
