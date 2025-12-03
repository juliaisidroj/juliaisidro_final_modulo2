USE sakila;

-- 1. Queremos seleccionar valores unicos de la tabla film, de la columna tiitle--

SELECT DISTINCT title AS Titulo  /* Seleccionamos solamente los diferentes titulos que aparecen en la table 'film' */
FROM film
ORDER BY Titulo;   /* Ordenamos alfabeticamente para que visualmente sea mas facil de ver */

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
/* Quiero saber, de la tabla films, seleccionar aquellas peliculas que el rating sea igual a PG-13 */
SELECT title AS Titulo /* Seleccionamos, dentro de la tabla 'film' aquellas peliculas donde el rating sea PG-13. En este caso no nos interesa sacar la clasificacion, ya que todas van a ser iguales */
FROM film
WHERE rating = 'PG-13'
ORDER BY Titulo; 

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
 /* Seguimos buscando en la tabla 'film', ahora nos interesa el 'title' y 'descripcion' de aquella peliculas que tengan la palabra 'amazing' en su descripcion*/
 SELECT
    title AS Titulo,
    description AS Descripcion
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/
 /*Nuevamente, solo nos interesa la tabla 'film', a pesar de que nos pide solo el titulo, en este caso vamos a seleccionar tambien la duracion. Y nos pide que filtremos de modo que 'lengh' sea mayor a 120*/
SELECT
    title AS Titulo,
    length AS Duracion  /* La columna leght viene medida en minutos */
FROM film
WHERE length > 120  
ORDER BY length ASC;  /* en este caso ordenamos duracion de menor a mayor, para que nos sea mas facil verificar el filtro*/

-- 5. Recupera los nombres de todos los actores.
 /*En este caso cambiamos de tabla, nos interesa la tabla 'actor', a pesar de que solo nos interesa solo el nombre(first name), vamos a hacer la busqueda tambien con el apellido ya que es lo mas correcto.*/
SELECT
	first_name AS Nombre,
    last_name AS Apellido
FROM actor
GROUP BY Apellido, Nombre;

 -- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
 /* Nuevamente, nos pide utilizar la tabla 'actor', donde nos pide el nombre y apellido, siempre que el apellido sea 'GIBSON'*/
 SELECT
    first_name AS Nombre,
    last_name AS Apellido
FROM actor
WHERE last_name = 'Gibson';
-- Lo ideal seria hacerlo como a continuacion, dado que no especifica que el apellido sea siemplemente 'Gibson'
 SELECT
    first_name AS Nombre,
    last_name AS Apellido
FROM actor
WHERE last_name LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
/* Nos interesa la columna 'actor', y vamos a filtrar aquellos cuyo id esté entre 10 y 20 (ambos inlcuidos). En nombre vamos a poner nombre y apellido, para proporcionarle mas datos*/
SELECT
    first_name AS Nombre,
    last_name AS Apellido,
    actor_id
FROM actor
WHERE actor_id >= 10 AND actor_id <= 20
ORDER BY actor_id; /*lo ordenamos para que sea mas facil comprobar la busqueda, ya que el actor_id es la PRIMARY KEY y sabemos que no se va a repetir*/

-- 8.  Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
/* Volvemos a la tabla 'film'. y hacemos una busqueda donde la clasificacion sea DISTINTA de lo indicado*/
SELECT
    title AS Titulo,
    rating AS Clasificacion
FROM film
WHERE
    rating NOT IN ('R', 'PG-13');
-- Tambien podemos ponerlo para asi comparar la busqueda de cuando queriamos que esta clasificacion SI fuese PG_13
SELECT
    title AS Titulo,
    rating AS Clasificacion
FROM film
WHERE rating != 'R' AND rating != 'PG-13'
ORDER BY rating; /* Lo ordenamos por clasificacion para que nos sea mas facil comprobar dicho filtro*/

-- 9.  Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento
/* Nos interesa hacer una agrupacion por la clasificacion de las peliculas, y contar cuantas peliculas perteneces a cada clasificacion*/
SELECT
    rating AS Clasificacion,
    COUNT(*) AS Total_Peliculas /* Vamos a crear una columna consultiva donde se cuente el total de peliculas, por eso utilizamos COUNT (*)*/
FROM film
GROUP BY rating /* Para contar por tipo de clasificacion, tenemos que agrupar dichas peliculas por esta variable */
ORDER BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
/* Aqui necesitamos hacer una consulta en la que los datos los tenemos que sacar de dos tablas diferentes, 'rental' y customer', que se relacionan por 'customer_id'*/
SELECT
    c.customer_id AS Id_cliente, /* Nos pide que mostremos el ID del cliente, su nombre, apellido, y cuantas peliculas ha alquilado*/
    c.first_name AS Nombre,
    c.last_name AS Apellido,
    COUNT(r.rental_id) AS Total_Alquileres /* Usamos rental_id porque asi nos aseguramos, al ser PRIMARY KEY no se repite, y cada uno esta asociado a una fila de la tabla*/
FROM customer c 
JOIN
    rental r ON c.customer_id = r.customer_id /*Conectamos los clientes con los alquileres por la columna comun */
GROUP BY
    c.customer_id, c.first_name, c.last_name /* Agrupamos los datos del cliente*/
ORDER BY Id_cliente; 

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
/* Me interesa hacer una consulta donde se muestren cuantos alquileres tiene cada una de las categorias de las peliculas. Tenemos que tener en cuenta que, en primer lugar, los alquileres estan en la tabla 'rental', que debemos relacionarla con la tabla 'inventory' ya que es la unica fila (inventory_id) donde podemos obtener datos de las peliculas, su PRIMARY KEY. Por otro lado nos interesa relacinarla con la tabla film_category ya que podemos ver relacion entre la pelicula y su categoria, ya que se relaciona con la primary key de category, por tanto: */
SELECT
    ca.name AS Categoria,                      /* Nos interesa saber el nombre de la categoria y cuantos alquileres tienen dichas categorias*/
    COUNT(r.rental_id) AS Recuento_Alquileres   /* Contamos rental_id porque es la PRIMARY KEY que nos ayuda a contar cada alquiler */
FROM category ca								/* El conteo total procede de cada categoria, que esta recogida en category */
JOIN
    film_category fc ON ca.category_id = fc.category_id /* Debido a que la union peliculas - categoria es una union 'Muchos con Muchos', 'Film_category' es su tabla de union. Por tanto, estamos uniendo la informacion de la pelicula con las informacion de las catgorias' */
JOIN
    inventory i ON fc.film_id = i.film_id  /* Debemos relacionar cada pelicula con cuantas existencias tenemos de ella, ya que no contamos titulos, vamos a contar cuantas peliculas tenemos, y de cada titulo existen varias copias */
JOIN
    rental r ON i.inventory_id = r.inventory_id /* Debemos relacionar cada copia que tenemos con las veces que se ha alquilado, ya que no es una variable estatica, una sola copia se puede alquilar varias veces en un periodo de tiempo*/
GROUP BY
    ca.name /* Agrupamos las categorias por nombre, ya que lo que nos pide es el nombre de cada categoria */
ORDER BY
    Categoria;  /* Para poder detectar mejor cada categoria, la ordenamos alfabeticamente */

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
/* LA clasificacion de la peliculas 'rating', como la duracion de las peliculas 'length' se encuentra todo en la tabla de 'film' */
/* el promedio de la duracion lo calcularemos con AVG(lenght), y esta media la calcularemos en funcion de la categoria de las peliculas */
SELECT
    rating AS Clasificacion,
    AVG(length) AS Promedio_duracion  /* El promedio de la duracion es en minutos, ya que es como se mide en la tabla */
FROM film
GROUP BY rating          /* Debemos agruparlas por la categoria */
ORDER BY
	Clasificacion;
    
-- 13.  Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
/* Debemos relacionar las peliculas 'film' con los actores 'actor'. Al ser una relacion muchos a muchos, se relacionan con la tabla de union 'film_actor', la cual solo tiene primary keys.  debemos ir uniendolas para poder obtener los datos que nos pide */
SELECT
    a.first_name AS Nombre,     /* Nos interesa hacer la consulta del nombre y apellido de los actores que se encuentra en la tabla 'actor' */
    a.last_name AS Apellido
FROM actor a
JOIN
    film_actor fa ON a.actor_id = fa.actor_id  /* Relacionamos a cada actor con el id de cada pelicula */
JOIN
    film f ON fa.film_id = f.film_id          /* Relacionamos cada pelicula con su id*/
WHERE
    f.title = 'Indian Love';               /* Dado que nos interesa solamente los actores de una pelicula especifica, filtramos por nombre, es decir, donde la consulta coincida con lo que buscamos */

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT
    title AS Titulo  /* Seleccionamos simplemente el titulo, que esta contenido en la tabla 'film', aunque para asegurarnos que esta bien, lo ideal seria mostrar tambien la descripcion */
FROM film
WHERE
    description LIKE '%dog%'   
    OR description LIKE '%cat%';
    
-- 15. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010
SELECT
    title AS Titulo,
    release_year AS Año_Lanzamiento /* A pesar de que nos pide el titulo solamente, es mas logico poner tambien el año de lanzamiento */
FROM film
WHERE
    release_year BETWEEN 2005 AND 2010 /* Entendemos que tambien cuentan aquellas peliculas lanzadas en el 2005 y 2010 */
ORDER BY
    Año_Lanzamiento, Titulo;  /* Es mas visual si lo ordenamor por año de lanzamiento, y dentro del año de lanzamiento, de manera alfabetica */