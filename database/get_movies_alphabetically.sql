CREATE OR REPLACE FUNCTION public.get_movies_alphabetically()
 RETURNS TABLE(movie_name text, movie_release_date date, movie_cover text, movie_description text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        m.name AS movie_name,
        m.release_date AS movie_release_date,
        m.cover AS movie_cover,
        m.description AS movie_description
    FROM movie m
    ORDER BY m.name;
END;
$function$
;
