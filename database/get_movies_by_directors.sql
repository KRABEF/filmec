CREATE OR REPLACE FUNCTION public.get_movies_by_directors(var_director integer)
 RETURNS TABLE(movie_name text, movie_release_date date, movie_cover text, movie_description text, director_name text, director_surname text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        m.name AS movie_name,
        m.release_date,
        m.cover,
        m.description,
        d.name AS director_name,
        d.surname AS director_surname
    FROM
        director_movie dm
    LEFT JOIN
        director d ON dm.id_director = d.id
	LEFT JOIN
		movie m ON dm.id_movie = m.id
	WHERE dm.id_director = var_director;
END;
$function$
;
