#Which film has the largest number of characters in the database?
SELECT movie.title, COUNT(movie_cast.character_name) count_of_cast
FROM movies.movie_cast
JOIN movies.movie ON movie.movie_id = movie_cast.movie_id
GROUP BY movie.title
ORDER BY COUNT(movie_cast.character_name) DESC
LIMIT 3;


# Create a table of female sidekicks
SELECT movie.title, movie_cast.character_name, movie_cast.cast_order
FROM movies.movie_cast
JOIN movies.movie ON movie.movie_id = movie_cast.movie_id
WHERE gender_id = 1 AND cast_order = 1;

# For a specific film, what actors are in it?
SET @movie_id := 767;

SELECT movie.movie_id, movie.title, movie_cast.person_id, movie_cast.character_name, person.person_name
FROM movies.movie
JOIN movies.movie_cast ON movie.movie_id = movie_cast.movie_id
JOIN movies.person on movie_cast.person_id = person.person_id 
WHERE movie.movie_id = @movie_id;

# For a specific film, count the proportion of women to men
SET @movie_name := "Harry Potter and the Half-Blood Prince";

WITH t AS (
	SELECT movie.title, COUNT(gender.gender) total,
    COUNT(CASE
		WHEN gender.gender = 'female' THEN 1
	END) female,
	COUNT(CASE
		WHEN gender.gender = 'male' THEN 1
	END) male
    FROM movies.movie
	JOIN movies.movie_cast ON movie.movie_id = movie_cast.movie_id
	JOIN movies.person on movie_cast.person_id = person.person_id 
	JOIN movies.gender on gender.gender_id = movie_cast.gender_id
	GROUP BY movie.movie_id, movie.title
) 
SELECT t.title, female/male AS "female:male"
FROM t
WHERE title = @movie_name;

# Which 10 actors have the most films in the database?
SELECT person.person_name, COUNT(movie.movie_id) count_of_films
FROM movies.movie
JOIN movies.movie_cast ON movie.movie_id = movie_cast.movie_id
JOIN movies.person on movie_cast.person_id = person.person_id 
JOIN movies.gender on gender.gender_id = movie_cast.gender_id
GROUP BY person.person_name
ORDER BY COUNT(movie.movie_id) DESC
LIMIT 10;



