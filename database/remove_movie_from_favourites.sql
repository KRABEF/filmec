CREATE OR REPLACE FUNCTION public.remove_movie_from_favourites(user_id integer, movie_id integer)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM favourites
    WHERE id_user = user_id AND id_movie = movie_id;
RETURN true
END;
$function$
;
