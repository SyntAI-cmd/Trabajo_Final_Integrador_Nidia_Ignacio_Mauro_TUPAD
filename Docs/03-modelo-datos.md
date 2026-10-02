# Modelo de datos

El sistema guarda su información en seis tablas principales, más dos tablas maestras chicas (`especie_dicc` y `estado_dicc`) que solo guardan los valores permitidos. Este documento explica qué guarda cada una y por qué está diseñada así.

## Cómo se relacionan

```
usuario (Personal del refugio)

adoptante (Persona que adopta) ───< adopcion >─── mascota ─┬─< vacuna
                                                           └─< foto

especie_dicc ───< mascota >─── estado_dicc     (tablas maestras)
```

La tabla `usuario` pertenece de forma exclusiva al personal que gestiona el refugio. Los procesos de adopción se vinculan formalmente entre el `adoptante` (persona de la comunidad) y la `mascota` mediante la tabla intermedia `adopcion`.

---

## Tabla `usuario`

Las personas que trabajan en el refugio y entran al sistema.

| Columna | Tipo | Descripción |
|---|---|---|
| id | entero, autoincremental | Identificador. |
| nombre | texto (100) | Nombre y apellido, para mostrar en pantalla. |
| email | texto (150), único | Con esto inicia sesión. |
| password | texto (255) | La contraseña **encriptada**. Nunca se guarda tal cual la escribió el usuario. |
| activo | booleano | Si está en `false`, la persona no puede iniciar sesión. Sirve para dar de baja a alguien sin borrar su registro. |

**Por qué la contraseña va encriptada.** Si alguien accede a la base, no puede leer las contraseñas. Spring Boot trae una herramienta (BCrypt) que se encarga de esto: al guardar la transforma, y al iniciar sesión compara sin necesidad de desencriptarla nunca.

**Por qué no hay una columna de rol.** Porque todos los usuarios del sistema hacen lo mismo. Agregar roles cuando hay un solo tipo de usuario es escribir código que nunca se ejecuta.

---

## Tabla `mascota`

El animal. Es la tabla central del sistema.

| Columna | Tipo | Descripción |
|---|---|---|
| id | entero, autoincremental | Identificador. |
| nombre | texto (80) | El nombre que le puso el refugio. |
| especie | texto corto | PERRO o GATO. |
| sexo | texto corto | MACHO o HEMBRA. |
| tamanio | texto corto | CHICO, MEDIANO o GRANDE. |
| fecha_nacimiento_aprox | fecha, puede estar vacía | Casi nunca se sabe la fecha exacta. Se carga una estimación, o se deja vacía. |
| fecha_ingreso | fecha | Cuándo llegó al refugio. Sirve para saber hace cuánto está esperando. |
| descripcion | texto largo | Cómo es el animal, cómo se lleva con chicos o con otros animales, si tiene alguna particularidad. Texto libre. |
| estado | texto corto | DISPONIBLE, EN_PROCESO, ADOPTADO o NO_DISPONIBLE. |

**Por qué la fecha de nacimiento puede estar vacía.** Porque a un animal que aparece en la calle nadie le sabe la edad. Obligar a cargar una fecha llevaría a que la gente invente datos, y un dato inventado es peor que un dato ausente.

**Por qué guardamos la fecha de nacimiento y no la edad.** Si guardáramos "2 años", ese número queda mal dentro de un año. La fecha no se desactualiza nunca: la edad se calcula al momento de mostrarla.

**Por qué la especie y el estado se validan contra una tabla maestra.** Los valores posibles son fijos (PERRO / GATO y los cuatro estados), pero se guardan en `especie_dicc` y `estado_dicc` y `mascota` los referencia con una clave foránea. Así la base rechaza cualquier valor mal escrito aunque venga de un INSERT hecho a mano. El refugio no puede crear valores nuevos desde la aplicación: en Java se manejan como `enum`. Para `sexo` y `tamanio` alcanza con una restricción `CHECK`.

---

## Tabla `vacuna`

Cada aplicación de una vacuna a un animal. Es el registro sanitario.

| Columna | Tipo | Descripción |
|---|---|---|
| id | entero, autoincremental | Identificador. |
| mascota_id | entero | A qué mascota corresponde. |
| nombre | texto (100) | Qué vacuna se aplicó (antirrábica, quíntuple, etc.). |
| fecha_aplicacion | fecha | Cuándo se aplicó. |
| proxima_dosis | fecha, puede estar vacía | Cuándo corresponde la siguiente, si corresponde alguna. |
| observaciones | texto largo, puede estar vacío | Cualquier nota del veterinario. |

**Por qué una fila por aplicación y no una columna en `mascota`.** Un animal se vacuna varias veces a lo largo de su vida, y la misma vacuna se repite con el tiempo. Si esto fuera una columna en la tabla `mascota`, cada vacuna nueva pisaría a la anterior y se perdería el historial. Que sea una tabla aparte permite guardar todo y mostrarlo ordenado por fecha.

**Por qué el nombre de la vacuna es texto libre y no una lista cerrada.** Porque no conocemos el listado completo de vacunas que aplica el refugio, y una lista incompleta obliga al operador a elegir la opción equivocada. Si más adelante se ve que siempre se cargan las mismas cuatro o cinco, se convierte en una lista.

---

## Tabla `foto`

Las imágenes de cada animal.

| Columna | Tipo | Descripción |
|---|---|---|
| id | entero, autoincremental | Identificador. |
| mascota_id | entero | A qué mascota corresponde. |
| archivo | texto (255) | El nombre del archivo de imagen guardado en el servidor. |
| principal | booleano | Si es `true`, es la foto que se muestra en el listado. |

**Por qué se guarda el nombre del archivo y no la imagen.** Las imágenes se guardan como archivos en una carpeta del servidor, y en la base solo queda la referencia. Guardar imágenes dentro de la base la hace pesada, lenta de consultar y difícil de respaldar.

**Por qué existe la columna `principal`.** En el listado se muestra una sola foto por animal. Sin esta marca, el sistema tendría que elegir una al azar o siempre la primera cargada, y no necesariamente es la mejor.

---

## Tabla `adoptante`

Registro de las personas interesadas en adoptar una mascota. No tienen credenciales de acceso al sistema operativo del refugio.

| Columna | Tipo | Descripción |
|---|---|---|
| id | entero, autoincremental | Identificador único del adoptante. |
| nombre_completo | texto (100) | Nombre y apellido del interesado. |
| dni | texto (20), único | Documento de identidad indispensable para actas legales. |
| telefono | texto (30) | Teléfono de contacto. |
| direccion | texto (255) | Domicilio (requerido para visitas de seguimiento). |

---

## Tabla `adopcion`

El registro oficial del trámite. Une al adoptante con la mascota que adopta, permitiendo realizar seguimientos a futuro.

| Columna | Tipo | Descripción |
|---|---|---|
| id | entero, autoincremental | Identificador único del trámite. |
| adoptante_id | entero | Qué persona externa adoptó al animal. |
| mascota_id | entero, único | Qué mascota fue adoptada. Es único porque un animal no se adopta dos veces. |
| fecha_adopcion | fecha | Cuándo se concretó la entrega. |
| notas_seguimiento | texto largo, puede estar vacío | Historial de visitas, llamadas o notas de bienestar del animal en su nuevo hogar. |

**Por qué `mascota_id` tiene una restricción de unicidad (UNIQUE).** Para evitar errores humanos: un animal no puede ser adoptado simultáneamente por dos registros diferentes en el sistema.

---

## Lo que este modelo no contempla

- **No hay historial de cambios generales.** Si alguien cambia el estado de un animal sin concretar una adopción, el estado anterior se pierde. Registrar el historial completo requiere una tabla de auditoría más y no la necesitamos todavía.
- **No hay tabla de refugios.** El sistema se instala de forma local o única para un solo refugio.