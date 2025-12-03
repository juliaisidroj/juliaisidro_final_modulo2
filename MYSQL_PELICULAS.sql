USE PELICULAS;

-- ¿Cuántas películas tienen una duración superior a 120 minutos?
SELECT COUNT(*)
FROM peliculas
WHERE duracion > 120;

-- ¿Cuántas películas tienen contenido adulto?
/* Como entendemos que cuando contiene contenido adulto, la columna "adulto = 1"*/
SELECT COUNT(*)
FROM peliculas
WHERE adultos = '1';

-- ¿Cuál es la película más antigua registrada en la base de datos?
/* En este caso tengo dos opciones para hacer*/
/* Puedo ordenar las peliculas por año de manera ascendente, y limitar la busqueda a la primera opcion */
SELECT titulo, año
FROM peliculas
ORDER BY año ASC
LIMIT 1;
/* Puedo hacer una subconsulta, donde seleccione, en año, el minimo */
SELECT titulo, año
FROM peliculas
WHERE año = (
    SELECT MIN(año)
    FROM peliculas
);

-- Muestra el promedio de duración de las películas agrupado por género.
SELECT
    genero,
    AVG(duracion) AS Duracion_Media /* Nos interesa la media de minutos que duran las peliculas, agrupadas por genero */
FROM peliculas
GROUP BY genero
ORDER BY
    Duracion_Media;

-- ¿Cuántas películas por año se han registrado en la base de datos? Ordena de mayor a menor.
SELECT
    año,
    COUNT(*) AS Peliculas_Año
FROM peliculas
GROUP BY año
ORDER BY Peliculas_Año DESC;

-- ¿Cuál es el año con más películas en la base de datos?
/* Podemos utilizar exactamente la misma consulta anterior, pero limitando la seleccion a un año */
SELECT
    año,
    COUNT(*) AS Peliculas_Año
FROM peliculas
GROUP BY año
ORDER BY Peliculas_Año DESC
LIMIT 1;

-- Obtén un listado de todos los géneros y cuántas películas corresponden a cada uno.
SELECT
    genero,
    COUNT(*) AS Peliculas_por_genero
FROM peliculas
GROUP BY genero
ORDER BY Peliculas_por_genero;

--  Muestra todas las películas cuyo título contenga la palabra "Shreck" 
SELECT *
FROM peliculas
WHERE
    titulo LIKE '%Shrek%';
    
--  Muestra todas las películas cuyo título contenga la palabra "Godfather" 
SELECT *
FROM peliculas
WHERE
    titulo LIKE '%Godfather%'
ORDER BY titulo;