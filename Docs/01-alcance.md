# Alcance del sistema

Este documento describe qué hace AdoptAR, quién lo usa y qué queda deliberadamente afuera.

## Quiénes lo usan

**El visitante.** Cualquier persona que entra a la web desde su celular o su computadora. No se registra ni inicia sesión. Solo mira los animales disponibles.

**El operador del refugio.** La persona que trabaja en el refugio o en el área de zoonosis. Tiene usuario y contraseña. Es quien carga los animales, sube las fotos, registra las vacunas y actualiza el estado.

En esta versión hay un solo tipo de usuario con sesión. No hacemos distinción entre "administrador" y "operador" porque en un refugio chico esa separación no aporta nada y sí agrega trabajo.

## Qué puede hacer cada uno

### El visitante

| Acción | Detalle |
|---|---|
| Ver el listado de animales | Solo aparecen los que están en estado *disponible*. Se muestran con la foto principal, el nombre, la especie y el tamaño. |
| Filtrar el listado | Por especie (perro / gato) y por tamaño. Nada más complejo que eso. |
| Ver la ficha de un animal | Todas sus fotos, la descripción, el sexo, la edad aproximada y desde cuándo está en el refugio. |

El visitante no ve las vacunas. Es información interna del refugio y no aporta a la decisión de adoptar.

### El operador

| Acción | Detalle |
|---|---|
| Iniciar sesión | Con email y contraseña. |
| Ver todos los animales | Incluidos los adoptados y los no disponibles, que en la parte pública no aparecen. |
| Cargar un animal | Nombre, especie, sexo, fecha de ingreso, edad aproximada, tamaño y una descripción libre. |
| Editar un animal | Cualquiera de los datos anteriores. |
| Subir fotos | Varias por animal. Una se marca como principal: es la que se ve en el listado. |
| Registrar una vacuna | Nombre de la vacuna, fecha en que se aplicó y, si corresponde, cuándo toca la próxima. |
| Cambiar el estado | Mover al animal entre los cuatro estados posibles. |
| Dar de baja | El animal deja de verse, pero no se borra de la base. Se guarda el registro. |

## Los estados de un animal

Un animal siempre está en uno de estos cuatro estados:

- **Disponible.** Está en el refugio y se puede adoptar. Es el único estado que se ve en la parte pública.
- **En proceso.** Alguien se interesó y la adopción está en trámite. No se muestra públicamente para que no lo pidan varias personas a la vez.
- **Adoptado.** Ya tiene hogar. Queda en el sistema como registro histórico.
- **No disponible.** Cualquier otro caso: está enfermo, en tratamiento, o se fue del refugio por otro motivo.

El operador cambia el estado a mano. No hay reglas automáticas que lo cambien solo. Esa decisión es a propósito: automatizar el pasaje de estados requiere definir un montón de casos borde que no conocemos todavía.

## Qué queda afuera

Ya está listado en el README, pero acá va el detalle del porqué:

**Solicitudes de adopción por la web.** Implicaría un formulario público, guardar los datos de personas que no son usuarias del sistema, un circuito de aprobación y un estado paralelo por cada solicitud. Es prácticamente un segundo sistema. Los refugios hoy reciben las consultas por teléfono o por WhatsApp y eso les funciona.

**Varios refugios o municipios en la misma instalación.** Habría que agregar la noción de "a qué refugio pertenece cada cosa" en todas las tablas y en todas las consultas. Es una decisión que conviene tomar cuando exista un segundo refugio interesado, no antes.

**Notificaciones automáticas por correo.** Requiere configurar un servidor de correo y manejar los errores de envío. No cambia en nada lo que el sistema resuelve.

**Reportes y estadísticas.** Tiene sentido cuando haya un año de datos cargados. Con la base vacía, un gráfico no dice nada.

**Instalarla como aplicación en el celular (PWA).** Es algo que nos interesa y lo dejamos anotado como mejora futura. Se agrega después, sobre la web ya funcionando, sin tocar nada de lo que esté hecho.

## Cómo sabemos que está terminado

La primera versión está lista cuando se puede hacer esta secuencia completa, de punta a punta, sin tocar la base de datos a mano:

1. El operador inicia sesión.
2. Carga un perro nuevo con su foto.
3. Le registra una vacuna.
4. El visitante entra a la web desde otro navegador y ve ese perro en el listado.
5. Abre la ficha y ve la foto y la descripción.
6. El operador marca el perro como adoptado.
7. El visitante recarga la página y el perro ya no aparece.

Si eso funciona, la primera versión está entregable.
