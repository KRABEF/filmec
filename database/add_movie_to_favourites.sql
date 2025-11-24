CREATE OR REPLACE FUNCTION public.add_movie_to_favourites(user_id integer, movie_id integer)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO favourites (id_user, id_movie, date_added)
    VALUES (user_id, movie_id, CURRENT_DATE);
RETURN true
END;
$function$
;
