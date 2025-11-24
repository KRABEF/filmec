CREATE OR REPLACE FUNCTION public.get_movies_with_actor(var_actor integer)
 RETURNS TABLE(movie_name text, movie_release_date date, movie_cover text, movie_description text, actor_name text, actor_surname text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        m.name AS movie_name,
        m.release_date AS movie_release_date,
        m.cover AS movie_cover,
        m.description AS movie_description,
        a.name AS actor_name,
        a.surname AS actor_surname
    FROM
        casting c
    LEFT JOIN
        actor a ON c.id_actor = a.id
    LEFT JOIN
		movie m ON c.id_movie = m.id
    WHERE c.id_actor = var_actor;
END;
$function$
;
