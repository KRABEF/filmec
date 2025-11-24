CREATE OR REPLACE FUNCTION public.get_movies_by_genres(var_geners integer)
 RETURNS TABLE(movie_name text, movie_release_date date, movie_cover text, movie_description text, genres text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        m.name AS movie_name,
        m.release_date AS movie_release_date,
        m.cover AS movie_cover,
        m.description AS movie_description,
        g.genres AS genres
    FROM
        movies_genres mg
    LEFT JOIN
        genre g ON mg.id_genres  = g.id
    LEFT JOIN
		movie m ON mg.id_movies = m.id
    WHERE mg.id_genres  = var_geners;
END;
$function$
;
