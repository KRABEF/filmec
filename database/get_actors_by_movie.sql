CREATE OR REPLACE FUNCTION public.get_actors_by_movie(var_movie integer)
 RETURNS TABLE(name text, surname text, photo text)
 LANGUAGE plpgsql
AS $function$ BEGIN RETURN QUERY SELECT a.name,a.surname,a.photo FROM casting AS c LEFT JOIN actor AS a ON c.id_actor=a.id WHERE c.id_movie=var_movie ORDER BY surname,name; END; $function$
;
