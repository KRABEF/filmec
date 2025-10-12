CREATE OR REPLACE FUNCTION public.get_movies_info()
 RETURNS TABLE(movie_name text, cover text, description text, duration_movie time without time zone, release_date date, country text, director_name text, director_surname text, rating text, tutor_name text, genres text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        m.name AS movie_name, 
        m.cover, 
        m.description, 
        m.duration_movie, 
        m.release_date, 
        c.country, 
        d.name AS director_name, 
        d.surname AS director_surname, 
        ar.rating, 
        ft.name AS tutor_name,
        g.genres
    FROM movie m 
    LEFT JOIN age_rating ar ON m.id_age_rating = ar.id 
    LEFT JOIN movie_country mc ON m.id = mc.id_movie 
    LEFT JOIN countries c ON mc.id_country = c.id 
    LEFT JOIN director_movie dm ON m.id = dm.id_movie 
    LEFT JOIN director d ON dm.id_director = d.id 
    LEFT JOIN movies_genres mg ON m.id = mg.id_movies 
    LEFT JOIN genre g ON mg.id_genres = g.id
    LEFT JOIN film_tutor_countries_movie ftcm ON m.id = ftcm.id_movie 
    LEFT JOIN film_tutor ft ON ftcm.id_film_tutor = ft.id ORDER BY m.name; 
END;
$function$
;
