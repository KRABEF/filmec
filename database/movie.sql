--
-- PostgreSQL database dump
--

\restrict 1U71FKpCF5HIfk3RZXbMK60NmtSBbQ1tvtSvplF7BOQIdM9GY8FbYftSALKZtm5

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: filmec; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE filmec1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE filmec1 OWNER TO postgres;

\unrestrict 1U71FKpCF5HIfk3RZXbMK60NmtSBbQ1tvtSvplF7BOQIdM9GY8FbYftSALKZtm5
\connect filmec1
\restrict 1U71FKpCF5HIfk3RZXbMK60NmtSBbQ1tvtSvplF7BOQIdM9GY8FbYftSALKZtm5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_movie_to_favourites(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_movie_to_favourites(user_id integer, movie_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

    INSERT INTO favourites (id_user, id_movie, date_added)

    VALUES (user_id, movie_id, CURRENT_DATE);

END;

$$;


ALTER FUNCTION public.add_movie_to_favourites(user_id integer, movie_id integer) OWNER TO postgres;

--
-- Name: add_movie_to_watch_later(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_movie_to_watch_later(user_id integer, movie_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

    INSERT INTO watch_later (id_user, id_movie, date_added)

    VALUES (user_id, movie_id, CURRENT_DATE);

END;

$$;


ALTER FUNCTION public.add_movie_to_watch_later(user_id integer, movie_id integer) OWNER TO postgres;

--
-- Name: get_actors_by_movie(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_actors_by_movie(var_movie integer) RETURNS TABLE(name text, surname text, photo text)
    LANGUAGE plpgsql
    AS $$ BEGIN RETURN QUERY SELECT a.name,a.surname,a.photo FROM casting AS c LEFT JOIN actor AS a ON c.id_actor=a.id WHERE c.id_movie=var_movie ORDER BY surname,name; END; $$;


ALTER FUNCTION public.get_actors_by_movie(var_movie integer) OWNER TO postgres;

--
-- Name: get_movies_alphabetically(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_movies_alphabetically() RETURNS TABLE(movie_name text, movie_release_date date, movie_cover text, movie_description text)
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.get_movies_alphabetically() OWNER TO postgres;

--
-- Name: get_movies_by_directors(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_movies_by_directors(var_director integer) RETURNS TABLE(movie_name text, movie_release_date date, movie_cover text, movie_description text, director_name text, director_surname text)
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.get_movies_by_directors(var_director integer) OWNER TO postgres;

--
-- Name: get_movies_by_genres(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_movies_by_genres(var_geners integer) RETURNS TABLE(movie_name text, movie_release_date date, movie_cover text, movie_description text, genres text)
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.get_movies_by_genres(var_geners integer) OWNER TO postgres;

--
-- Name: get_movies_info(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_movies_info() RETURNS TABLE(movie_name text, cover text, description text, duration_movie time without time zone, release_date date, country text, director_name text, director_surname text, rating text, tutor_name text, genres text)
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.get_movies_info() OWNER TO postgres;

--
-- Name: get_movies_with_actor(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_movies_with_actor(var_actor integer) RETURNS TABLE(movie_name text, movie_release_date date, movie_cover text, movie_description text, actor_name text, actor_surname text)
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.get_movies_with_actor(var_actor integer) OWNER TO postgres;

--
-- Name: remove_movie_from_favourites(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_movie_from_favourites(user_id integer, movie_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

    DELETE FROM favourites

    WHERE id_user = user_id AND id_movie = movie_id;

END;

$$;


ALTER FUNCTION public.remove_movie_from_favourites(user_id integer, movie_id integer) OWNER TO postgres;

--
-- Name: remove_movie_from_watch_later(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_movie_from_watch_later(user_id integer, movie_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

    DELETE FROM watch_later

    WHERE id_user = user_id AND id_movie = movie_id;

END;

$$;


ALTER FUNCTION public.remove_movie_from_watch_later(user_id integer, movie_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actor (
    id integer NOT NULL,
    surname text,
    name text,
    photo text
);


ALTER TABLE public.actor OWNER TO postgres;

--
-- Name: actor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actor_id_seq OWNER TO postgres;

--
-- Name: actor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actor_id_seq OWNED BY public.actor.id;


--
-- Name: age_rating; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.age_rating (
    id integer NOT NULL,
    rating text
);


ALTER TABLE public.age_rating OWNER TO postgres;

--
-- Name: age_rating_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.age_rating_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.age_rating_id_seq OWNER TO postgres;

--
-- Name: age_rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.age_rating_id_seq OWNED BY public.age_rating.id;


--
-- Name: casting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.casting (
    id integer NOT NULL,
    id_movie integer NOT NULL,
    id_actor integer NOT NULL
);


ALTER TABLE public.casting OWNER TO postgres;

--
-- Name: cast_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cast_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cast_id_seq OWNER TO postgres;

--
-- Name: cast_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cast_id_seq OWNED BY public.casting.id;


--
-- Name: comments_and_ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments_and_ratings (
    id integer NOT NULL,
    id_user integer NOT NULL,
    id_movie integer NOT NULL,
    ratings integer,
    comments text,
    date date
);


ALTER TABLE public.comments_and_ratings OWNER TO postgres;

--
-- Name: comments_and_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_and_ratings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_and_ratings_id_seq OWNER TO postgres;

--
-- Name: comments_and_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_and_ratings_id_seq OWNED BY public.comments_and_ratings.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    country text
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.country_id_seq OWNER TO postgres;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.country_id_seq OWNED BY public.countries.id;


--
-- Name: director_movie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.director_movie (
    id integer NOT NULL,
    id_director integer NOT NULL,
    id_movie integer NOT NULL
);


ALTER TABLE public.director_movie OWNER TO postgres;

--
-- Name: directing_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directing_staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directing_staff_id_seq OWNER TO postgres;

--
-- Name: directing_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directing_staff_id_seq OWNED BY public.director_movie.id;


--
-- Name: director; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.director (
    id integer NOT NULL,
    surname text,
    name text,
    photo text
);


ALTER TABLE public.director OWNER TO postgres;

--
-- Name: director_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.director_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.director_id_seq OWNER TO postgres;

--
-- Name: director_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.director_id_seq OWNED BY public.director.id;


--
-- Name: favourites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favourites (
    id integer NOT NULL,
    id_user integer NOT NULL,
    id_movie integer NOT NULL,
    date_added date
);


ALTER TABLE public.favourites OWNER TO postgres;

--
-- Name: favourites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.favourites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.favourites_id_seq OWNER TO postgres;

--
-- Name: favourites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.favourites_id_seq OWNED BY public.favourites.id;


--
-- Name: film_tutor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.film_tutor (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.film_tutor OWNER TO postgres;

--
-- Name: film_tutor_countries_movie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.film_tutor_countries_movie (
    id_film_tutor integer,
    id_country integer NOT NULL,
    id_movie integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.film_tutor_countries_movie OWNER TO postgres;

--
-- Name: film_tutor_countries_movie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.film_tutor_countries_movie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.film_tutor_countries_movie_id_seq OWNER TO postgres;

--
-- Name: film_tutor_countries_movie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.film_tutor_countries_movie_id_seq OWNED BY public.film_tutor_countries_movie.id;


--
-- Name: film_tutor_id_seq1; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.film_tutor_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.film_tutor_id_seq1 OWNER TO postgres;

--
-- Name: film_tutor_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.film_tutor_id_seq1 OWNED BY public.film_tutor.id;


--
-- Name: genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre (
    id integer NOT NULL,
    genres text
);


ALTER TABLE public.genre OWNER TO postgres;

--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.genres_id_seq OWNER TO postgres;

--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genre.id;


--
-- Name: movie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie (
    name text,
    release_date date,
    duration_movie time without time zone,
    id integer NOT NULL,
    cover text,
    description text,
    id_age_rating integer
);


ALTER TABLE public.movie OWNER TO postgres;

--
-- Name: movie_country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie_country (
    id integer NOT NULL,
    id_movie integer NOT NULL,
    id_country integer NOT NULL
);


ALTER TABLE public.movie_country OWNER TO postgres;

--
-- Name: movie_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movie_country_id_seq OWNER TO postgres;

--
-- Name: movie_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_country_id_seq OWNED BY public.movie_country.id;


--
-- Name: movie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movie_id_seq OWNER TO postgres;

--
-- Name: movie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movie_id_seq OWNED BY public.movie.id;


--
-- Name: movies_genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies_genres (
    id integer NOT NULL,
    id_movies integer NOT NULL,
    id_genres integer NOT NULL
);


ALTER TABLE public.movies_genres OWNER TO postgres;

--
-- Name: movies_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movies_genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movies_genres_id_seq OWNER TO postgres;

--
-- Name: movies_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movies_genres_id_seq OWNED BY public.movies_genres.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    login text,
    email text,
    password text,
    registration_date date,
    photo text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public.users.id;


--
-- Name: watch_later; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.watch_later (
    id integer NOT NULL,
    id_movie integer NOT NULL,
    id_user integer NOT NULL,
    date_added date NOT NULL
);


ALTER TABLE public.watch_later OWNER TO postgres;

--
-- Name: watch_later_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.watch_later_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.watch_later_id_seq OWNER TO postgres;

--
-- Name: watch_later_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.watch_later_id_seq OWNED BY public.watch_later.id;


--
-- Name: actor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor ALTER COLUMN id SET DEFAULT nextval('public.actor_id_seq'::regclass);


--
-- Name: age_rating id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.age_rating ALTER COLUMN id SET DEFAULT nextval('public.age_rating_id_seq'::regclass);


--
-- Name: casting id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casting ALTER COLUMN id SET DEFAULT nextval('public.cast_id_seq'::regclass);


--
-- Name: comments_and_ratings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments_and_ratings ALTER COLUMN id SET DEFAULT nextval('public.comments_and_ratings_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.country_id_seq'::regclass);


--
-- Name: director id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director ALTER COLUMN id SET DEFAULT nextval('public.director_id_seq'::regclass);


--
-- Name: director_movie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director_movie ALTER COLUMN id SET DEFAULT nextval('public.directing_staff_id_seq'::regclass);


--
-- Name: favourites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favourites ALTER COLUMN id SET DEFAULT nextval('public.favourites_id_seq'::regclass);


--
-- Name: film_tutor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film_tutor ALTER COLUMN id SET DEFAULT nextval('public.film_tutor_id_seq1'::regclass);


--
-- Name: film_tutor_countries_movie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film_tutor_countries_movie ALTER COLUMN id SET DEFAULT nextval('public.film_tutor_countries_movie_id_seq'::regclass);


--
-- Name: genre id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- Name: movie id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie ALTER COLUMN id SET DEFAULT nextval('public.movie_id_seq'::regclass);


--
-- Name: movie_country id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_country ALTER COLUMN id SET DEFAULT nextval('public.movie_country_id_seq'::regclass);


--
-- Name: movies_genres id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies_genres ALTER COLUMN id SET DEFAULT nextval('public.movies_genres_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: watch_later id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_later ALTER COLUMN id SET DEFAULT nextval('public.watch_later_id_seq'::regclass);


--
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actor (id, surname, name, photo) FROM stdin;
1	Макконахи	Меттью	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/7b37ed50-2bb0-4f22-adba-d94023ed9a38/280x420
2	Хэтэуэй	Энн	https://avatars.mds.yandex.net/get-kinopoisk-image/10893610/9750ea26-da2a-4bac-94f5-9d59ad29742f/280x420
3	Кейн	Майкл	https://avatars.mds.yandex.net/get-kinopoisk-image/10703859/04543c9c-9d48-46a4-8f61-86bd2aeeb983/112x168
4	Честейн	Джессика	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/35e92331-afe5-42cd-8df5-eeeab87c647a/112x168
5	Фой	Маккензи	https://avatars.mds.yandex.net/get-kinopoisk-image/10671298/202cba90-4f3a-44eb-aa15-961b4b5cf9f0/112x168
6	Джеси	Дэвид	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/cd0be687-292c-4746-b12d-1679fd697b37/112x168
7	Бентли	Уэс	https://avatars.mds.yandex.net/get-kinopoisk-image/10812607/58126339-ef07-4af3-9676-0a4214707f00/112x168
8	Аффлек	Кейси	https://avatars.mds.yandex.net/get-kinopoisk-image/10592371/520180c7-4d33-4082-801c-83efbbb58321/112x168
9	Литгоу	Джон	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/c1d347eb-8d12-49c0-8c6b-0ca76f36dead/112x168
10	Дэймон	Мэтт	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/1638c058-eec7-4d7c-acc9-2d2fe510fe62/112x168
11	Грейс	Тофер	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/7360ca56-5d36-4f04-beb0-12fcf5bf9099/112x168
12	Бёрстин	Эллен	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/bd4047ba-683d-42cc-a67e-e76de48d1a35/112x168
13	Габер	Элиес	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/53da2000-71f8-4eeb-b920-f72f05c2881f/112x168
14	Шаламе	Тимоти	https://avatars.mds.yandex.net/get-kinopoisk-image/4303601/0ae93f05-a7c4-4a15-8389-f869a8f5e1ed/112x168
15	Ойелоуо	Дэвид	https://avatars.mds.yandex.net/get-kinopoisk-image/9784475/99a6bd90-3c83-4d2a-bc1e-0a28d302c917/112x168
16	Вульф	Коллетт	https://avatars.mds.yandex.net/get-kinopoisk-image/1898899/40009e0e-32c9-4b70-b0db-3625efbe60eb/112x168
17	МакКарти	Френсис 3	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/e63f13aa-9062-409c-99d1-29ed549953b1/112x168
18	Ирвин	Билл	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/8829a7a1-5b85-4c28-8ecb-3bbf8d73737c/112x168
19	Борба	Эндрю	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/64121d56-494f-45ec-9332-efe2c15dda03/112x168
20	Дивэйн	Уильям	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/2dfe6c99-ed22-4689-abf2-95120333032d/112x168
21	Стюарт	Джош	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/f57d2385-4cb1-48f1-a212-0e8bd1b78378/112x168
22	Кейрнс	Леа	https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/f519ef3d-f0ab-4926-b034-234fb54abdda/112x168
23	Дикинсон	Лиам	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/7a82a5a6-a743-4957-bea4-cdceee8d8150/112x168
24	Нолан	Флора	https://avatars.mds.yandex.net/get-kinopoisk-image/10671298/9d11cd53-0e52-4c4b-9ef6-089d6b2fe9e5/112x168
25	Фрейзер	Гриффен	\N
26	Хефнер	Джефф	https://avatars.mds.yandex.net/get-kinopoisk-image/1629390/bf82bab7-af80-4c7d-8128-fc9662830c29/112x168
27	Георгас	Лена	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/d4cb191c-b66e-4276-8703-0ecb0b71f532/112x168
28	Смит	Брук	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/2f0cc055-e15e-48ef-9ef0-64510559a66e/112x168
29	Фега	Расс	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/db1388b8-06a5-4cb9-8309-8a4c21ea3bb1/112x168
30	Браун	Уильям-Патрик	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/ba73640f-05b6-4702-9d99-fb6af83ac632/112x168
31	Кэмпбелл	Кики-Леа	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/322ab0fb-9a5c-489e-a4fc-ff7405d77927/112x168
32	Дайневиц	Марк-Казимир	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/117ccda6-ffbd-428b-a1f5-4f107eed35f9/112x168
33	Fyhn	Troy	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/afe5d9e4-b966-4358-9425-ecb014dad9f6/112x168
34	Харди	Бенжамин	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/cf31d3e7-a5bb-4edf-8f8f-d82226134dba/112x168
35	Хелисек	Александр-Майкл	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/bad2777a-5d9c-484d-843c-ffba85200876/112x168
36	Ирвинг	Райан	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/e4619bef-e479-4b6d-8605-ad5da4123181/112x168
37	Lu	Alexander	\N
38	Макинтайр	Дерек	\N
39	Оливейра 	Джозеф	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/c5a2f41e-1fbd-4102-a7a6-16dfd0a7b01d/112x168
40	Pitz	Benjamin	\N
41	Сандерс	Марлон	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/3459a854-3196-4627-9e5f-eff701952876/112x168
42	Стэмп	Брайан	\N
43	Ван дер Хейден	Кристиан	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/29d7721f-3a1e-4264-b11f-1aff5b4386e9/112x168
44	Вебер	Кеван	\N
45	Клюзе	Клюзе	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/f1615d27-440d-490e-85dd-ecbf5490b554/112x168
46	Си	Омар	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/6ff214c8-e427-4dc2-b447-a1a51743c3ff/112x168
47	Ле Ни	Анн	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/5a5a2bdf-6e96-47ed-9675-cb42c1712d3c/112x168
48	Флёро	Одро	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/8cff3d96-7dd6-487b-a9df-537ff056e375/112x168
49	де Мо	Жозефин	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/726cdd85-f2ca-4ff7-b7ee-5c28db8d1139/112x168
50	Молле	Клотильд	https://avatars.mds.yandex.net/get-kinopoisk-image/10812607/e56ff57c-09d6-4897-a6b9-c672c096879f/112x168
51	Менди	Сирил	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/90716e3d-2413-4012-92f0-62508aade8ef/112x168
52	Камате	Салимата	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/98c86038-52af-4da6-b61b-5f6a02357f13/112x168
53	Тур	Абса-Дьяту	\N
54	Эстерманн	Грегуар	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/830ec715-e4c0-486c-b673-4bd17319f131/112x168
55	Дагье	Доминик	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/2d8184bc-6267-432d-aa83-722cbefe96c6/112x168
56	Карон	Франсуа	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/a5414a97-0235-48de-bfd8-76371eb1d2ef/112x168
57	Амери	Кристиан	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/40e15974-419f-41b7-9a9e-cfd2b4b4a6bf/112x168
58	Соливерес	Тома	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/f2f5a355-2c26-4998-8d8b-f985ab1aeea7/112x168
59	Бриер	Дороти	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/21d2d0f8-b5f5-45b1-a905-d631411a8fa9/112x168
60	Дикуру	Мари-Лор	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/f007f04c-0266-46f0-a32e-1f140f154a9c/112x168
61	Кан	Эмили	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/96eea7c8-6c7b-49e5-adff-7fd18da0f652/112x168
62	Лазард	Сильвен	\N
63	Кэйри	Жан-Француа	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/9426181e-93b2-4d88-90d6-0acae09f99ea/112x168
64	Фенелон	Йен	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/a716b226-aced-4068-bcdd-a87321992f3f/112x168
65	Барсе	Рено	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/d4fa0353-cbf3-472b-b041-fa33f5c6ded7/112x168
66	Бюрелу	Франсуа	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/c110896b-afa8-44f6-9fb2-fb3d296a4175/112x168
67	Марбо	Никки	https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/719706bb-f24d-4b4d-86c8-dafab364b009/112x168
68	Барош	Бенжамин	https://avatars.mds.yandex.net/get-kinopoisk-image/4486454/12c78ab9-4b0f-4003-83b9-575e9ffa080a/112x168
69	Повель	Жером	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/f21e4cb8-ec02-44cf-95c8-dab7ed375f18/112x168
70	Лоран	Антуан	https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/1783e3db-94c0-4d79-b7a9-bafdd123ac49/112x168
71	Матенья	Фабрис	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/78c51ae3-28b2-4a5a-b868-bc5b563ae092/112x168
72	Бушенафа	Хеди	https://avatars.mds.yandex.net/get-kinopoisk-image/4483445/fe58c69b-bfa2-4585-8ec2-4542cee999db/112x168
73	Бург	Каролин	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/16631e4e-9fc4-4b1c-a40b-2c5ec003463b/112x168
74	Виноградов	Мишель	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/d3f6c2a2-84b3-4858-a5d2-4b5d3adf0879/112x168
75	Вамо	Кевин	\N
76	Латиль	Эллион	\N
78	Анри	Доминик	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/f2568cf6-1934-45e5-bf7d-1c9d205adf24/112x168
79	Ле Капариксьо	Франсе	\N
80	Ле Фавр	Филлип	\N
81	Мартелл	Джейден	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/7f8704f5-a0a5-485b-b124-bca839355bac/112x168
82	Рей Тейлор	Джереми	https://avatars.mds.yandex.net/get-kinopoisk-image/9784475/f53493fa-2bff-494d-b7fc-ec3ca5f9b07d/112x168
83	Лиллис	София	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/5ce5994a-44ec-40d2-8c49-7dd97640bd18/112x168
77	Антони	Ален	\N
84	Вулфхард	Финн	https://avatars.mds.yandex.net/get-kinopoisk-image/4303601/75d83acc-3c7e-4eff-8819-f230ab282a95/112x168
85	Джейкобс	Чоузен	https://avatars.mds.yandex.net/get-kinopoisk-image/1629390/67484382-3865-45bc-a3ab-5799c0b553ea/112x168
86	Грейзер	Джек-Дилан	https://avatars.mds.yandex.net/get-kinopoisk-image/4483445/df9e73ab-5571-4e89-8fe4-62d3a18224fd/112x168
87	Олефф	Уайатт	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/297286b5-15b8-451a-87e2-6a46927ef5cd/112x168
88	Скарсгард	Билл	https://avatars.mds.yandex.net/get-kinopoisk-image/6201401/6f16b797-dc7a-4e11-9d49-2b8418406f49/112x168
89	Хэмилтон	Николас	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/6864d710-0937-457c-a9b0-7f0eb4a34094/112x168
90	Сим	Джейк	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/98464e63-4f31-4222-8673-696b0bf5ffce/112x168
91	Томпсон	Логан	https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/7b7eb9e2-4856-4052-b197-e18c60081d1e/112x168
92	Тиг	Оуэн	https://avatars.mds.yandex.net/get-kinopoisk-image/10893610/d1e88b1f-4128-4cf3-8a7d-7d6a81d34d7f/112x168
93	Скотт	Джексон-Роберт	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/9971a8d8-b56d-49ac-a3dc-043b2fcb8801/112x168
94	Богерт	Стивен	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/e3ae176b-3325-4a23-a490-47445e88054f/112x168
95	Хьюз	Стюарт	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/ea4a6746-3dfc-4d92-8206-6fb6a7bda3d5/112x168
96	Паунсетт	Джеффри	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/b64a5f16-e4d6-41ff-a0e7-c995d2b1b177/112x168
97	Двайер	Пип	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/f6bace8c-69cd-4699-b98b-2e740e33aa5e/112x168
98	Эткинсон	Молли	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/e7e55be2-e7a4-4e52-90a1-78121cd76fbd/112x168
99	Уильямс	Стивен	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/751d268b-7928-4f23-9d86-bd480b6dad52/112x168
100	Сондерс	Элизабет	https://avatars.mds.yandex.net/get-kinopoisk-image/4483445/01e8ec26-8fb8-4b69-88de-2bdfec1e1496/112x168
101	Чарпентье	Меган	https://avatars.mds.yandex.net/get-kinopoisk-image/10835644/bb0e7436-d5b7-4313-a251-f333a9a0fa19/112x168
102	Бостик	Джо	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/9d4d173c-f18c-4689-b8aa-ac5e830ef64d/112x168
103	Коэн	Эри	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/988f4de7-2bf5-42b2-8da5-d47acbff6a7a/112x168
104	Юлк	Энтони	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/db2c8506-673a-4fdd-9201-8de1233c05e5/112x168
105	Ботет	Хавьер	https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/8581b3cf-7d18-42cb-b5a5-ed5ec870c2d0/112x168
106	Lunman	Katie	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/5d376df4-57ea-4f95-ae56-f4dbf274582e/112x168
107	Масселмен	Картер	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/d55b571c-821f-4511-941e-1d8da89b7160/112x168
108	Ли	Татум	\N
109	Эди	Инсеттер	https://avatars.mds.yandex.net/get-kinopoisk-image/1629390/49c90065-bd04-42bf-a2b9-a831f2a2ecba/112x168
110	Гибсон	Марта	\N
111	Райнер	Кеси	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/9ce39846-771b-424a-837e-a1366dae0760/112x168
112	Нелисс	Изабель	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/7352f89c-72f8-4adc-8042-9536843e836f/112x168
113	Трайп	Дональд	\N
114	Гордон	Лиз	\N
115	Кроун	Нил	https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/b6a36abb-824a-49a4-aa01-20126fc3f00d/112x168
116	Гаскон	Соня	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/19b8a744-b16f-4f20-b9eb-a259fcdd06db/112x168
117	Портер	Джанет	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/ed08daed-6c62-4b35-9d14-c58194a28639/112x168
118	Ванчон	Шантель	\N
119	Кампанелла	Роберто	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/86c69834-d419-4e5d-8eb1-4a8e5c8126cd/112x168
\.


--
-- Data for Name: age_rating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.age_rating (id, rating) FROM stdin;
1	0+
2	6+
3	12+
4	16+
5	18+
\.


--
-- Data for Name: casting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.casting (id, id_movie, id_actor) FROM stdin;
46	4	45
47	4	46
48	4	47
49	4	48
50	4	49
51	4	50
52	4	51
53	4	52
54	4	53
55	4	54
56	4	55
57	4	56
58	4	57
59	4	58
60	4	59
61	4	60
62	4	61
63	4	62
64	4	63
65	4	64
66	4	65
67	4	66
68	4	67
69	4	68
70	4	69
71	4	70
72	4	71
73	4	72
74	4	73
76	4	74
77	4	75
78	4	76
79	4	77
80	4	78
81	4	79
1	5	1
2	5	2
3	5	3
4	5	4
5	5	5
6	5	6
7	5	7
8	5	8
9	5	9
10	5	10
11	5	11
12	5	12
13	5	13
14	5	14
15	5	15
16	5	16
17	5	17
18	5	18
19	5	19
20	5	20
21	5	21
22	5	22
23	5	23
24	5	24
25	5	25
26	5	26
27	5	27
28	5	28
29	5	29
30	5	30
31	5	31
32	5	32
33	5	33
34	5	34
35	5	35
36	5	36
37	5	37
38	5	38
39	5	39
40	5	40
41	5	41
42	5	42
43	5	43
44	5	44
82	4	80
83	4	81
84	3	82
85	3	83
86	3	84
87	3	85
88	3	86
89	3	87
90	3	88
91	3	89
92	3	90
93	3	91
94	3	92
95	3	93
96	3	94
97	3	95
98	3	96
99	3	97
100	3	98
101	3	99
102	3	100
103	3	101
104	3	102
105	3	103
106	3	104
107	3	105
108	3	106
109	3	107
110	3	108
111	3	109
112	3	110
113	3	111
114	3	112
115	3	113
116	3	114
117	3	115
118	3	116
119	3	117
120	3	118
121	3	119
\.


--
-- Data for Name: comments_and_ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments_and_ratings (id, id_user, id_movie, ratings, comments, date) FROM stdin;
1	1	4	4	крутой фильм!	2025-09-28
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, country) FROM stdin;
1	Афганистан
2	Албания
3	Алжир
4	Андорра
5	Ангола
6	Антигуа и Барбуда
7	Аргентина
8	Армения
9	Австралия
10	Австрия
11	Азербайджан
12	Багамские Острова
13	Бахрейн
14	Бангладеш
15	Барбадос
16	Беларусь
17	Бельгия
18	Белиз
19	Бенин
20	Бутан
21	Боливия
22	Босния и Герцоговина
23	Ботсвана
24	Бразилия
25	Бруней
26	Болгария
27	Буркина-Фасо
28	Бурунди
29	Кабо-Верде
30	Камбоджа
31	Камерун
32	Канада
33	Центральноафриканская Республика
34	Чад
35	Чили
36	Китай
37	Колумбия
38	Коморы
39	Конго
40	Коста-Рика
41	Кот-д'Ивуар
42	Хорватия
43	Куба
44	Кипр
45	Чехия
46	Дания
47	Джибути
48	Доминика
49	Доминиканская Республика
50	Эквадор
51	Египет
52	Сальвадор
53	Экваториальная Гвинея
54	Эритрея
55	Эстония
56	Эсватини
57	Эфиопия
58	Фиджи
59	Финляндия
60	Франция
61	Габон
62	Гамбия
63	Грузия
64	Германия
65	Гана
66	Греция
67	Гренада
68	Гватемала
69	Гвинея
70	Гвинея-Бисау
71	Гайана
72	Гаити
73	Гондурас
74	Венгрия
75	Исландия
76	Индия
77	Индонезия
78	Ирак
79	Иран
80	Ирландия
81	Израиль
82	Италия
83	Ямайка
84	Япония
85	Иордания
86	Казахстан
87	Кения
88	Кирибати
89	Южная Корея
90	Северная Корея
91	Кувейт
92	Кыргызстан
93	Лаос
94	Латвия
95	Ливан
96	Лесото
97	Либерия
98	Ливия
99	Лихтенштейн
100	Литва
101	Люксембург
102	Мадагаскар
103	Малави
104	Малайзия
105	Мальдивы
106	Мали
107	Мальта
108	Маршалловы Острова
109	Мавритания
110	Маврикий
111	Мексика
112	Микронезия
113	Молдова
114	Монако
115	Монголия
116	Черногория
117	Марокко
118	Мозамбик
119	Мьянма
120	Намибия
121	Науру
122	Непал
123	Нидерланды
124	Новая Зеландия
125	Никарагуа
126	Нигер
127	Нигерия
128	Северная Македония
129	Норвегия
130	Оман
131	Пакистан
132	Палау
133	Панама
134	Папуа
135	Парагвай
136	Перу
137	Филиппины
138	Пльша
139	Португалия
140	Катар
141	Румыния
142	Россия
143	Руанда
144	Ватикан
145	Сент-Китс и Невис
146	Сент-Люсия
147	Сент-Винсент и Гренадины
148	Самоа
149	Сан-Марино
150	Сан-Томе и Принсипи
151	Саудовская Аравия
152	Сенегал
153	Сербия
154	Сейшельские Острова
155	Сьерра-Леоне
156	Сингапур
157	Словакия
158	Словения
159	Соломоновы Острова
160	Сомали
161	Южная Африка
162	Испания
163	Шри-Ланка
164	Судан
165	Южный Судан
166	Суринам
167	Швеция
168	Швейцария
169	Сирия
170	Тайвань
171	Таджикистан
172	Танзания
173	Таиланд
174	Тимор-Лесте
175	Того
176	Тонга
177	Тринидад и Тобаго
178	Тунис
179	Турция
180	Туркмения
181	Тувалу
182	Уганда
183	Украина
184	Объединенные Арабские Эмираты
185	Великобритания
186	Соединенные Штаты Америки
187	Уругвай
188	Узбекистан
189	Вануату
190	Венесуэла
191	Вьетнам
192	Йемен
193	Замбия
194	Зимбабве
\.


--
-- Data for Name: director; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director (id, surname, name, photo) FROM stdin;
1	Мускетти	Андрес	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/42409103-f770-42d0-a2d5-92699f653d20/112x168
2	Накаш	Оливье	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/7d392406-5338-4b53-a5d6-e100e6e78c07/112x168
3	Толедано	Эрик	https://avatars.mds.yandex.net/get-kinopoisk-image/1704946/69cae8a2-5cbd-47a3-83dc-a37856243225/112x168
4	Нолан	Кристофер	https://avatars.mds.yandex.net/get-kinopoisk-image/10900341/c16e1382-d91d-4cfc-b179-ce8757a41b10/112x168
\.


--
-- Data for Name: director_movie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director_movie (id, id_director, id_movie) FROM stdin;
1	4	5
2	2	4
3	3	4
4	1	3
\.


--
-- Data for Name: favourites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favourites (id, id_user, id_movie, date_added) FROM stdin;
1	1	3	2025-09-29
\.


--
-- Data for Name: film_tutor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.film_tutor (id, name) FROM stdin;
1	Warner Bros. Pictures
2	\tGaumont
\.


--
-- Data for Name: film_tutor_countries_movie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.film_tutor_countries_movie (id_film_tutor, id_country, id_movie, id) FROM stdin;
1	186	3	1
2	60	4	2
1	186	5	3
\.


--
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genre (id, genres) FROM stdin;
1	Комедия
2	Драма
3	Боевик
4	Детектив
5	Ужасы
6	Триллер
7	Фантастика
8	Приключение
9	Мелодрама
10	Фэнтези
11	Исторический
12	Вестерн
13	Мьюзикл
14	Нуар
15	Военный
16	Биографический
\.


--
-- Data for Name: movie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie (name, release_date, duration_movie, id, cover, description, id_age_rating) FROM stdin;
Оно	2017-09-07	02:15:42	3	https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/ec1991dc-660d-4b90-8912-21e3a46bdb37/1920x	Когда в городке Дерри штата Мэн начинают пропадать дети, несколько ребят сталкиваются со своими величайшими страхами — не только с группой школьных хулиганов, но со злобным клоуном Пеннивайзом, список жертв которого уходит вглубь веков.	5
1+1	2011-04-26	01:52:06	4	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/c52d52de-e1ef-4059-a927-bb07562226cf/1920x	Пострадав в результате несчастного случая, богатый аристократ Филипп нанимает в помощники человека, который менее всего подходит для этой работы, – молодого жителя предместья Дрисса, только что освободившегося из тюрьмы. Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.	5
Интерстеллар	2014-11-06	02:49:08	5	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/78c36c0f-aefd-4102-bc3b-bac0dd4314d8/1920x	Когда засуха, пыльные бури и вымирание растений приводят человечество к продовольственному кризису, коллектив исследователей и учёных отправляется сквозь червоточину (которая предположительно соединяет области пространства-времени через большое расстояние) в путешествие, чтобы превзойти прежние ограничения для космических путешествий человека и найти планету с подходящими для человечества условиями.	5
\.


--
-- Data for Name: movie_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie_country (id, id_movie, id_country) FROM stdin;
1	5	186
2	5	185
3	5	32
4	4	60
5	3	186
6	3	32
\.


--
-- Data for Name: movies_genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movies_genres (id, id_movies, id_genres) FROM stdin;
2	3	5
3	3	10
4	3	2
5	3	4
6	4	1
7	4	2
8	5	2
9	5	7
10	5	8
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, login, email, password, registration_date, photo) FROM stdin;
1	Hih123	hih@gmail.com	123456	2025-09-30	\N
\.


--
-- Data for Name: watch_later; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.watch_later (id, id_movie, id_user, date_added) FROM stdin;
1	5	1	2025-09-30
\.


--
-- Name: actor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actor_id_seq', 114, true);


--
-- Name: age_rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.age_rating_id_seq', 5, true);


--
-- Name: cast_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cast_id_seq', 121, true);


--
-- Name: comments_and_ratings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_and_ratings_id_seq', 1, true);


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_id_seq', 197, true);


--
-- Name: directing_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directing_staff_id_seq', 4, true);


--
-- Name: director_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.director_id_seq', 4, true);


--
-- Name: favourites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favourites_id_seq', 5, true);


--
-- Name: film_tutor_countries_movie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_tutor_countries_movie_id_seq', 3, true);


--
-- Name: film_tutor_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_tutor_id_seq1', 2, true);


--
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genres_id_seq', 16, true);


--
-- Name: movie_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_country_id_seq', 6, true);


--
-- Name: movie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_id_seq', 5, true);


--
-- Name: movies_genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movies_genres_id_seq', 10, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: watch_later_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.watch_later_id_seq', 2, true);


--
-- Name: actor actor_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_unique UNIQUE (id);


--
-- Name: age_rating age_rating_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.age_rating
    ADD CONSTRAINT age_rating_unique UNIQUE (id);


--
-- Name: casting cast_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casting
    ADD CONSTRAINT cast_unique UNIQUE (id);


--
-- Name: comments_and_ratings comments_and_ratings_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments_and_ratings
    ADD CONSTRAINT comments_and_ratings_unique UNIQUE (id);


--
-- Name: countries country_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT country_unique UNIQUE (id);


--
-- Name: director_movie directing_staff_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director_movie
    ADD CONSTRAINT directing_staff_unique UNIQUE (id);


--
-- Name: director director_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director
    ADD CONSTRAINT director_unique UNIQUE (id);


--
-- Name: favourites favourites_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favourites
    ADD CONSTRAINT favourites_unique UNIQUE (id);


--
-- Name: film_tutor_countries_movie film_tutor_countries_movie_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film_tutor_countries_movie
    ADD CONSTRAINT film_tutor_countries_movie_unique UNIQUE (id);


--
-- Name: film_tutor film_tutor_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film_tutor
    ADD CONSTRAINT film_tutor_unique UNIQUE (id);


--
-- Name: genre genres_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genres_unique UNIQUE (id);


--
-- Name: movie_country movie_country_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_country
    ADD CONSTRAINT movie_country_unique UNIQUE (id);


--
-- Name: movie movie_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie
    ADD CONSTRAINT movie_unique UNIQUE (id);


--
-- Name: movies_genres movies_genres_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies_genres
    ADD CONSTRAINT movies_genres_unique UNIQUE (id);


--
-- Name: users user_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_unique UNIQUE (id);


--
-- Name: watch_later watch_later_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_later
    ADD CONSTRAINT watch_later_unique UNIQUE (id);


--
-- Name: casting cast_actor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casting
    ADD CONSTRAINT cast_actor_fk FOREIGN KEY (id_actor) REFERENCES public.actor(id);


--
-- Name: casting cast_movie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casting
    ADD CONSTRAINT cast_movie_fk FOREIGN KEY (id_movie) REFERENCES public.movie(id);


--
-- Name: comments_and_ratings comments_and_ratings_movie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments_and_ratings
    ADD CONSTRAINT comments_and_ratings_movie_fk FOREIGN KEY (id_movie) REFERENCES public.movie(id);


--
-- Name: comments_and_ratings comments_and_ratings_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments_and_ratings
    ADD CONSTRAINT comments_and_ratings_user_fk FOREIGN KEY (id_user) REFERENCES public.users(id);


--
-- Name: director_movie directing_staff_director_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director_movie
    ADD CONSTRAINT directing_staff_director_fk FOREIGN KEY (id_director) REFERENCES public.director(id);


--
-- Name: director_movie directing_staff_movie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.director_movie
    ADD CONSTRAINT directing_staff_movie_fk FOREIGN KEY (id_movie) REFERENCES public.movie(id);


--
-- Name: favourites favourites_movie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favourites
    ADD CONSTRAINT favourites_movie_fk FOREIGN KEY (id_movie) REFERENCES public.movie(id);


--
-- Name: favourites favourites_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favourites
    ADD CONSTRAINT favourites_user_fk FOREIGN KEY (id_user) REFERENCES public.users(id);


--
-- Name: film_tutor_countries_movie film_tutor_countries_movie_film_tutor_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film_tutor_countries_movie
    ADD CONSTRAINT film_tutor_countries_movie_film_tutor_fk FOREIGN KEY (id_film_tutor) REFERENCES public.film_tutor(id);


--
-- Name: film_tutor_countries_movie film_tutor_country_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film_tutor_countries_movie
    ADD CONSTRAINT film_tutor_country_fk FOREIGN KEY (id_country) REFERENCES public.countries(id);


--
-- Name: film_tutor_countries_movie film_tutor_movie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.film_tutor_countries_movie
    ADD CONSTRAINT film_tutor_movie_fk FOREIGN KEY (id_movie) REFERENCES public.movie(id);


--
-- Name: movie movie_age_rating_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie
    ADD CONSTRAINT movie_age_rating_fk FOREIGN KEY (id_age_rating) REFERENCES public.age_rating(id);


--
-- Name: movie_country movie_country_country_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_country
    ADD CONSTRAINT movie_country_country_fk FOREIGN KEY (id_country) REFERENCES public.countries(id);


--
-- Name: movie_country movie_country_movie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movie_country
    ADD CONSTRAINT movie_country_movie_fk FOREIGN KEY (id_movie) REFERENCES public.movie(id);


--
-- Name: movies_genres movies_genres_genres_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies_genres
    ADD CONSTRAINT movies_genres_genres_fk FOREIGN KEY (id_genres) REFERENCES public.genre(id);


--
-- Name: movies_genres movies_genres_movie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies_genres
    ADD CONSTRAINT movies_genres_movie_fk FOREIGN KEY (id_movies) REFERENCES public.movie(id);


--
-- Name: watch_later watch_later_movie_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_later
    ADD CONSTRAINT watch_later_movie_fk FOREIGN KEY (id_movie) REFERENCES public.movie(id);


--
-- Name: watch_later watch_later_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_later
    ADD CONSTRAINT watch_later_user_fk FOREIGN KEY (id_user) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 1U71FKpCF5HIfk3RZXbMK60NmtSBbQ1tvtSvplF7BOQIdM9GY8FbYftSALKZtm5

