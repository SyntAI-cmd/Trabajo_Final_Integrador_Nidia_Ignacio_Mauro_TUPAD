# Modelo de datos

El sistema guarda su información en cuatro tablas. Este documento explica qué guarda cada una y por qué está diseñada así.

## Cómo se relacionan

```
usuario            (quien entra al sistema)

mascota  ─┬─< vacuna      (una mascota tiene muchas vacunas)
          └─< foto        (una mascota tiene muchas fotos)
```

La tabla `usuario` no se relaciona con las demás. En esta versión no guardamos quién cargó cada mascota. Es información que se podría agregar después con una columna más, pero por ahora no la necesitamos y agregarla implicaría arrastrarla en todas las pantallas.

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

**Por qué el estado es una columna y no una tabla aparte.** Son cuatro valores fijos que no van a cambiar. Una tabla de estados tendría sentido si el refugio pudiera crear estados nuevos, y no es el caso.

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

## Lo que este modelo no contempla

- **No hay tabla de adoptantes ni de solicitudes.** Está fuera del alcance de esta versión (ver `01-alcance.md`).
- **No hay historial de cambios.** Si alguien cambia el estado de un animal, el estado anterior se pierde. Registrar el historial requiere una tabla más y no lo necesitamos todavía.
- **No hay tabla de refugios.** El sistema se instala para un refugio.

Las tres cosas se  agregarian más adelante sin rehacer lo que ya está.
