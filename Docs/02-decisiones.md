 # Decisiones técnicas

Acá queda registrado qué elegimos, qué otras opciones evaluamos y por qué nos decidimos por una. La idea es que dentro de tres meses, cuando alguien pregunte "¿por qué esto y no aquello?", la respuesta esté escrita y no dependa de que nos acordemos.

Un criterio general que usamos en todas las decisiones: **si no lo vimos en la carrera, no va.** Podemos aprender algo nuevo si hace falta, pero no vamos a meter una herramienta solo porque es moderna o porque queda bien en el informe. El proyecto lo tenemos que poder explicar y mantener los tres.

---

## Decisión 1: Java con Spring Boot

**Qué elegimos:** Java 17 con Spring Boot 3.

**Qué otra opción evaluamos:** JavaScript con Node.js y Express.

**La discusión que tuvimos en el grupo.** Las dos tecnologías las venimos viendo en la cursada, así que las dos eran viables. El grupo estuvo dividido un tiempo y vale la pena dejar registrado el argumento de cada lado.

*A favor de Node con Express:* se usa un solo lenguaje, JavaScript, tanto en el servidor como en el navegador. Eso reduce el cambio de contexto mental: uno escribe siempre en el mismo idioma. Además, arrancar un proyecto de Express es más rápido, tiene menos configuración inicial y menos archivos.

*A favor de Java con Spring Boot:* es lo que más trabajamos en las materias de programación orientada a objetos, así que es donde estamos más cómodos escribiendo clases, dividiendo responsabilidades y entendiendo los errores del compilador. Spring Boot además trae resuelto de fábrica el manejo de sesiones y el acceso a la base de datos, que en Express hay que armar eligiendo librerías de terceros.

**Por qué nos quedamos con Java.** Pesó más la comodidad del equipo que la comodidad de la herramienta. El tiempo que ahorraríamos en configurar Express lo perderíamos después, escribiendo código en un lenguaje que dominamos menos y depurando errores que en Java el compilador nos avisa antes de ejecutar.

Dicho esto, **la opción de JavaScript sigue anotada**. Si en algún momento el proyecto crece hacia una aplicación con mucha interacción en el navegador, o si en las materias siguientes se profundiza en Node, es una alternativa que ya está evaluada y no habría que discutirla de cero.

---

## Decisión 2: Thymeleaf para las pantallas

**Qué elegimos:** que el servidor genere el HTML con Thymeleaf.

**Qué otra opción evaluamos:** separar el proyecto en dos, una API en Spring Boot y un frontend aparte en React o en JavaScript puro, comunicándose por JSON.

**Por qué.** Separar el proyecto en dos partes es la forma en que se trabaja en la industria, pero acá no aporta: son dos proyectos para configurar, dos para levantar cada vez que uno programa, dos para entregar y dos lugares donde puede romperse algo. Y no lo necesitamos, porque AdoptAR no tiene pantallas con mucha interacción; son formularios y listados.

Con Thymeleaf el servidor arma el HTML y lo manda ya listo. El navegador solo lo muestra. Es un solo proyecto, un solo comando para correrlo y un solo lugar donde buscar un error.

Si el día de mañana hiciera falta una aplicación móvil o una pantalla más interactiva, se puede agregar una API al mismo proyecto sin tirar nada de lo hecho.

---

## Decisión 3: MySQL como base de datos

**Qué elegimos:** MySQL 8.

**Qué habíamos decidido antes:** PostgreSQL.

**Por qué cambiamos.** En un principio íbamos a usar PostgreSQL. Es una base sólida y para lo que necesitamos habría funcionado igual de bien: las dos son bases relacionales, las dos usan SQL y las tablas que diseñamos son exactamente las mismas en cualquiera de las dos.

El cambio no fue técnico, fue práctico. MySQL es la que venimos usando en la materia de bases de datos, es con la que los tres ya tenemos instalada la herramienta para verla (MySQL Workbench) y es con la que sabemos hacer una copia de seguridad o restaurar el archivo si algo se rompe. Con PostgreSQL uno de nosotros iba a estar aprendiendo la herramienta al mismo tiempo que el proyecto.

Preferimos que la base sea la parte aburrida del proyecto y no un obstáculo. Como el sistema no usa ninguna función exclusiva de PostgreSQL, el costo de cambiar es cero y el beneficio es que los tres podemos trabajar sin trabarnos.

---

## Decisión 4: Spring Data JPA para hablar con la base

**Qué elegimos:** Spring Data JPA.

**Qué otra opción evaluamos:** escribir las consultas SQL a mano con JDBC.

**Por qué.** JPA nos deja trabajar con las clases de Java (una `Mascota`, una `Vacuna`) y se encarga de traducir eso a tablas y consultas. Nos ahorra escribir el mismo INSERT y el mismo SELECT una y otra vez para cada tabla.

La contra es que agrega una capa de abstracción: cuando algo no funciona, hay que entender qué consulta generó JPA por debajo. Nos parece un costo razonable, y en los casos donde necesitemos una consulta puntual JPA permite escribir el SQL a mano igual.

---

## Decisión 5: CSS propio, sin framework de estilos

**Qué elegimos:** escribir el CSS nosotros.

**Qué otra opción evaluamos:** Bootstrap o Tailwind.

**Por qué.** Son cinco o seis pantallas. Un framework de estilos resuelve el problema de mantener consistencia en un sistema grande, y acá ese problema no existe. Escribir el CSS a mano nos deja entender exactamente por qué cada cosa se ve como se ve, que para una materia de programación es más valioso que copiar clases de una documentación.

Si más adelante las pantallas se multiplican, sumar Bootstrap u otra libreria es una tarde de trabajo.

---

## Sobre la PWA

En las primeras charlas del grupo hablamos de hacer una PWA, es decir, una web que el usuario pueda "instalar" en el celular y que funcione parcialmente sin internet.

Lo dejamos afuera de la primera versión, pero no lo descartamos. Una PWA no es una tecnología distinta: es una web común a la que se le agregan dos archivos (un manifiesto y un service worker). Se puede convertir AdoptAR en PWA cuando la web ya funcione, sin rehacer nada.

Ponerlo primero sería empezar por la decoración.
