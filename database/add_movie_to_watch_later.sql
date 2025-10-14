CREATE OR REPLACE FUNCTION public.add_movie_to_watch_later(user_id integer, movie_id integer)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO watch_later (id_user, id_movie, date_added)
    VALUES (user_id, movie_id, CURRENT_DATE);
RETURN true;
END;
$function$
;
