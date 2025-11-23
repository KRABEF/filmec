--
-- PostgreSQL database dump
--

\restrict Hbf2nrCVUQRmJE73O6KUIF8Ww806c3kF7pOvILbJRGvegFxt2ZkmfTleFDZjIyi

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: add_movie_to_favourites(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_movie_to_favourites(user_id integer, movie_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO favourites (id_user, id_movie, date_added)
    VALUES (user_id, movie_id, CURRENT_DATE);
RETURN true;
END;
$$;


ALTER FUNCTION public.add_movie_to_favourites(user_id integer, movie_id integer) OWNER TO postgres;

--
-- Name: add_movie_to_watch_later(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_movie_to_watch_later(user_id integer, movie_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO watch_later (id_user, id_movie, date_added)
    VALUES (user_id, movie_id, CURRENT_DATE);
RETURN true;
END;
$$;


ALTER FUNCTION public.add_movie_to_watch_later(user_id integer, movie_id integer) OWNER TO postgres;

--
-- Name: find_duplicate_names(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_duplicate_names() RETURNS TABLE(id integer, name text, surname text)
    LANGUAGE sql
    AS $$
    SELECT id, name, surname
    FROM actor
    WHERE (name, surname) IN (
        SELECT name, surname
        FROM actor
        GROUP BY name, surname
        HAVING COUNT(*) > 1
    )
    ORDER BY name, surname;
$$;


ALTER FUNCTION public.find_duplicate_names() OWNER TO postgres;

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
-- Name: hash(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hash(login text, email text, password text, photo text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$ begin 
insert into users(login, email, password, registration_date, photo) 
values(login, email, crypt(' password', gen_salt('md5')), current_date, photo);
return true;
end;$$;


ALTER FUNCTION public.hash(login text, email text, password text, photo text) OWNER TO postgres;

--
-- Name: pswhash(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pswhash(check_login text, check_password text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$ begin 
return exists(select 1 from users where users.login = check_login and users.password = crypt(check_password, users.password));
end;$$;


ALTER FUNCTION public.pswhash(check_login text, check_password text) OWNER TO postgres;

--
-- Name: remove_movie_from_favourites(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_movie_from_favourites(user_id integer, movie_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM favourites
    WHERE id_user = user_id AND id_movie = movie_id;
RETURN true;
END;
$$;


ALTER FUNCTION public.remove_movie_from_favourites(user_id integer, movie_id integer) OWNER TO postgres;

--
-- Name: remove_movie_from_watch_later(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_movie_from_watch_later(user_id integer, movie_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM watch_later
    WHERE id_user = user_id AND id_movie = movie_id;
RETURN true;
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
    id_age_rating integer,
    id_imdb text
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
25	Фрейзер	Гриффен	\N
37	Lu	Alexander	\N
38	Макинтайр	Дерек	\N
40	Pitz	Benjamin	\N
42	Стэмп	Брайан	\N
44	Вебер	Кеван	\N
53	Тур	Абса-Дьяту	\N
1	Макконахи	Меттью	1.jpg
2	Хэтэуэй	Энн	2.jpg
3	Кейн	Майкл	3.jpg
4	Честейн	Джессика	4.jpg
5	Фой	Маккензи	5.jpg
6	Джеси	Дэвид	6.jpg
7	Бентли	Уэс	7.jpg
8	Аффлек	Кейси	8.jpg
9	Литгоу	Джон	9.jpg
10	Дэймон	Мэтт	10.jpg
11	Грейс	Тофер	11.jpg
12	Бёрстин	Эллен	12.jpg
13	Габер	Элиес	13.jpg
14	Шаламе	Тимоти	14.jpg
15	Ойелоуо	Дэвид	15.jpg
16	Вульф	Коллетт	16.jpg
17	МакКарти	Френсис 3	17.jpg
18	Ирвин	Билл	18.jpg
19	Борба	Эндрю	19.jpg
20	Дивэйн	Уильям	20.jpg
21	Стюарт	Джош	21.jpg
22	Кейрнс	Леа	22.jpg
23	Дикинсон	Лиам	23.jpg
24	Нолан	Флора	24.jpg
26	Хефнер	Джефф	26.jpg
27	Георгас	Лена	27.jpg
28	Смит	Брук	28.jpg
29	Фега	Расс	29.jpg
30	Браун	Уильям-Патрик	30.jpg
31	Кэмпбелл	Кики-Леа	31.jpg
32	Дайневиц	Марк-Казимир	32.jpg
33	Fyhn	Troy	33.jpg
34	Харди	Бенжамин	34.jpg
35	Хелисек	Александр-Майкл	35.jpg
36	Ирвинг	Райан	36.jpg
39	Оливейра 	Джозеф	39.jpg
41	Сандерс	Марлон	41.jpg
43	Ван дер Хейден	Кристиан	43.jpg
45	Клюзе	Клюзе	45.jpg
46	Си	Омар	46.jpg
47	Ле Ни	Анн	47.jpg
48	Флёро	Одро	48.jpg
49	де Мо	Жозефин	49.jpg
50	Молле	Клотильд	50.jpg
51	Менди	Сирил	51.jpg
52	Камате	Салимата	52.jpg
62	Лазард	Сильвен	\N
75	Вамо	Кевин	\N
76	Латиль	Эллион	\N
79	Ле Капариксьо	Франсе	\N
80	Ле Фавр	Филлип	\N
77	Антони	Ален	\N
55	Дагье	Доминик	55.jpg
56	Карон	Франсуа	56.jpg
57	Амери	Кристиан	57.jpg
58	Соливерес	Тома	58.jpg
59	Бриер	Дороти	59.jpg
60	Дикуру	Мари-Лор	60.jpg
61	Кан	Эмили	61.jpg
63	Кэйри	Жан-Француа	63.jpg
64	Фенелон	Йен	64.jpg
65	Барсе	Рено	65.jpg
66	Бюрелу	Франсуа	66.jpg
67	Марбо	Никки	67.jpg
68	Барош	Бенжамин	68.jpg
69	Повель	Жером	69.jpg
70	Лоран	Антуан	70.jpg
71	Матенья	Фабрис	71.jpg
72	Бушенафа	Хеди	72.jpg
73	Бург	Каролин	73.jpg
74	Виноградов	Мишель	74.jpg
78	Анри	Доминик	78.jpg
81	Мартелл	Джейден	81.jpg
82	Рей Тейлор	Джереми	82.jpg
83	Лиллис	София	83.jpg
84	Вулфхард	Финн	84.jpg
85	Джейкобс	Чоузен	85.jpg
86	Грейзер	Джек-Дилан	86.jpg
87	Олефф	Уайатт	87.jpg
88	Скарсгард	Билл	88.jpg
89	Хэмилтон	Николас	89.jpg
90	Сим	Джейк	90.jpg
91	Томпсон	Логан	91.jpg
92	Тиг	Оуэн	92.jpg
93	Скотт	Джексон-Роберт	93.jpg
94	Богерт	Стивен	94.jpg
95	Хьюз	Стюарт	95.jpg
96	Паунсетт	Джеффри	96.jpg
97	Двайер	Пип	97.jpg
98	Эткинсон	Молли	98.jpg
99	Уильямс	Стивен	99.jpg
100	Сондерс	Элизабет	100.jpg
101	Чарпентье	Меган	101.jpg
102	Бостик	Джо	102.jpg
103	Коэн	Эри	103.jpg
104	Юлк	Энтони	104.jpg
105	Ботет	Хавьер	105.jpg
106	Lunman	Katie	106.jpg
108	Ли	Татум	\N
110	Гибсон	Марта	\N
113	Трайп	Дональд	\N
114	Гордон	Лиз	\N
118	Ванчон	Шантель	\N
54	Эстерманн	Грегуар	54.jpg
107	Масселмен	Картер	107.jpg
109	Эди	Инсеттер	109.jpg
111	Райнер	Кеси	111.jpg
112	Нелисс	Изабель	112.jpg
115	Кроун	Нил	115.jpg
116	Гаскон	Соня	116.jpg
117	Портер	Джанет	117.jpg
119	Кампанелла	Роберто	119.jpg
120	Роббинс	Тим	120.jpg
121	Фриман	Морган	121.jpg
122	Гантон	Боб	122.jpg
123	Сэдлер	Уильям	123.jpg
124	Браун	Клэнси	124.jpg
125	Беллоуз	Гил	125.jpg
126	Ролстон	Марк	126.jpg
127	Уитмор	Джеймс	127.jpg
128	ДеМанн	Джефри	128.jpg
129	Бранденбург	Ларри	129.jpg
130	Вуд	Элайджа	130.jpg
131	Маккеллен	Иэн	131.jpg
132	Эстин	Шон	132.jpg
133	Мортенсен	Вигго	133.jpg
134	Бойд	Билли	134.jpg
135	Монахэн	Доминик	135.jpg
136	Рис-Дэвис	Джон	136.jpg
137	Блум	Орландо	137.jpg
138	Бин	Шон	138.jpg
139	Холм	Иэн	139.jpg
140	Хиираги	Руми	140.jpg
141	Ирино	Мию	141.jpg
142	Нацуки	Мари	142.jpg
143	Наито	Такаси	143.jpg
144	Савагути	Ясуко	144.jpg
145	Гасюин	Тацуя	145.jpg
146	Камики	Рюносукэ	146.jpg
147	Тамаи	Юми	147.jpg
148	Оидзуми	Ё	148.jpg
149	Хаяси	Коба	149.jpg
150	Демьяненко	Александр	150.jpg
151	Селезенова	Наталья	151.jpg
152	Смирнов	Алексей	152.jpg
153	Никулин	Юрий	153.jpg
154	Моргунов	Евгений	154.jpg
155	Вицин	Георгий	155.jpg
156	Пуговкин	Михаил	156.jpg
157	Павлов	Виктор	157.jpg
158	Басов	Владимир	158.jpg
159	Зеленая	Рина	159.jpg
160	Румянцева	Надежда	160.jpg
161	Рыбников	Николай	161.jpg
162	Овчинникова	Люсьена	162.jpg
163	Хитров	Станислав	163.jpg
164	Макарова	Инна	164.jpg
165	Дружинина	Светлана	165.jpg
166	Меньшикова	Нина	166.jpg
167	Филлипов	Роман	167.jpg
169	Адоскин	Анатолий	169.jpg
170	Чо	Арден	170.jpg
171	Хун	Мэй	\N
172	Джи-ён	Ю	172.jpg
173	Юн-джин	Ким	173.jpg
174	Хё-соп	Ан	174.jpg
175	Жонг	Кен	175.jpg
176	Бён-хон	Ли	176.jpg
177	Дэ Ким	Дэниэл	177.jpg
178	Оак	Руми	\N
179	Ким Бустер	Джоэль	\N
180	Бэйл	Кристиан	180.jpg
181	Леджер	Хит	 181.jpg
182	Экхарт	Аарон	182.jpg
183	Джилленхол	Мэгги	183.jpg
184	Олдман	Гари	184.jpg
187	Хань	Чинь	187.jpg
188	Корбонелл	Нестор	188.jpg
189	Робертс	Эрик	189.jpg
190	Гибсон	Мэл	 190.jpg
191	Марго	Софи	191.jpg
192	МакГуэн	Патрик	192.jpg
193	Макфадьен	Энгус	193.jpg
194	Глисон	Брендан	 194.jpg
195	МакКормак	Катрин	195.jpg
196	Кокс	Брайан	196.jpg
197	МакСорли	Джерард	 197.jpg
198	Мерфи	Мартин	198.jpg
199	Флэнаган	Томми	199.jpg
200	Малаков	Илья	200.jpg
201	Цой	Александр	201.jpg
202	Ильин мл	Александр	202.jpg
203	Хлынина	Юлия	203.jpg
204	Трибунцев	Тимофей	204.jpg
205	Серебряков	Алексей	205.jpg
206	Савочкин	Игорь	206.jpg
207	Чернышова	Полина	207.jpg
208	Антоненко	Илья	208.jpg
209	Пицхелаури	Георгий	209.jpg
210	Фокс	Джейми	210.jpg
211	Вальц	Кристоф	211.jpg
212	ДиКаприо	Леонардо	212.jpg
213	Вашингтон	Керри	213.jpg
214	Джексон	Сэмюэл	214.jpg
215	Гоггинс	Уолтон	215.jpg
216	Кристофер	Дэннис	216.jpg
217	Римар	Джеймс	217.jpg
218	Джонсон	Дон	 218.jpg
219	Кайюэтт	Лора	219.jpg
220	Рассел	Курт	220.jpg
222	Джейсон Ли	Дженифер	222.jpg
224	Рот	Тим	 224.jpg
225	Мэдсен	Майкл	225.jpg
226	Бичир	Демиан	226.jpg
227	Дерн	Брюс	227.jpg
228	Паркс	Джеймс	228.jpg
229	Гурье	Дэна	229.jpg
232	Тихонов	Иван	232.jpg
233	Владимирова	Валентина	233.jpg
234	Дадыко	Михаил	234.jpg
235	Калкин	Маколей	235.jpg
236	Пеши	Джо	236.jpg
237	Стерн	Дэниел	237.jpg
238	Бродерик	Мэттью	238.jpg
239	Айронс	Джереми	239.jpg
240	Лейн	Нэйтан	240.jpg
241	Хидака	Норико	241.jpg
242	Сакамото	Тика	242.jpg
244	Вудс	Илен	244.jpg
245	Одли	Элеонор	245.jpg
246	Фелтон	Верна	246.jpg
243	Такаги	Хитоси	
247	Меткалф	Джесси	247.jpg
248	Сноу	Бриттани	248.jpg
249	Буш	София	249.jpg
250	Кошина	Маша	250.jpg
251	Мороз	Дарья	251.jpg
252	Гармаш	Сергей	252.jpg
253	Тремблей	Джейкоб	253.jpg
254	Уилсон	Оуэн	254.jpg
255	Видович	Изабелла	255.jpg
256	Ривз	Киану	256.jpg
257	Фишбёрн	Лоренс	257.jpg
258	Мосс	Кэрри-Энн	258.jpg
259	Леонардо	ДиКаприо	259.jpg
260	Уинслет	Кейт	260.jpg
261	Зейн	Билли	261.jpg
262	Гир	Ричард	262.jpg
263	Аллен	Джоан	263.jpg
264	Тагава	Кэри-Хироюки	264.jpg
265	Депп	Джони	265.jpg
266	Раш	Джеффри	266.jpg
268	Кадзи	Юки	268.jpg
269	Исикава	Юи	269.jpg
270	Иноуэ	Марина	270.jpg
271	Метелкин	Александр	271.jpg
272	Нагиев 	Дмитрий	272.jpg
273	Казанцева	Полина	273.jpg
274	Уишоу	Бен	274.jpg
275	Бонневиль	Хью	275.jpg
276	Хоккинс	Салли	276.jpg
277	Гонсалес	Энтони	277.jpg
278	Брэтт	Бенджамин	278.jpg
279	Юбак	Аланна	279.jpg
280	Майерс	Марк	280.jpg
281	Мерфи	Эдди	281.jpg
282	Диас	Кэмерон	282.jpg
284	Варлей	Наталья	284.jpg
286	Кроул	Рассел	286.jpg
287	Феникс	Хоакин	287.jpg
288	Нильсен	Конни	288.jpg
289	Миронов	Андрей	289.jpg
290	Яковлева	Александра	290.jpg
291	Боярский	Михаил	291.jpg
292	Косых	Виктор	292.jpg
293	Евстигнеев	Евгений	293.jpg
294	Алейникова	Арина	294.jpg
295	Ли	Пегги	295.jpg
296	Робертс	Ларри	\N
297	Бауком	Билл	\N
298	Темнова	Екатерина	298.jpg
299	Каргаманян	Карина	299.jpg
300	Степанян	Джульетта	300.jpg
301	Рэдклифф	Дэниэл	301.jpg
302	Гринт	Руперт	302.jpg
303	Уотсон	Эмма	303.jpg
304	Фэлтон	Том	304.jpg
305	Ливанов	Василий	305.jpg
306	Соломин	Виталий	306.jpg
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
122	7	120
123	7	121
124	7	122
125	7	123
126	7	124
127	7	126
128	7	127
129	7	128
130	7	129
141	10	140
131	8	130
132	8	131
133	8	132
134	8	133
135	8	134
136	8	135
137	8	136
138	8	137
139	8	138
140	8	139
142	10	141
143	10	142
144	10	143
145	10	144
146	10	146
147	10	147
148	10	148
149	10	149
150	10	145
151	11	150
152	11	151
153	11	152
154	11	153
155	11	154
156	11	155
157	11	156
158	11	157
159	11	158
160	11	159
161	14	156
162	14	160
163	14	161
164	14	162
165	14	163
166	14	164
167	14	165
168	14	166
169	14	167
170	14	169
171	9	170
172	9	171
173	9	172
174	9	173
175	9	174
176	9	174
177	9	176
178	9	177
179	9	178
180	9	179
181	13	3
182	13	181
183	13	182
184	13	183
185	13	184
186	13	187
187	13	188
188	13	189
189	18	190
190	18	191
191	18	192
192	18	193
193	18	194
194	18	195
195	18	196
196	18	197
197	18	198
198	18	199
199	19	200
200	19	201
201	19	202
202	19	203
203	19	204
204	19	205
205	19	206
206	19	207
207	19	208
208	19	209
209	20	210
210	20	211
211	20	212
212	20	213
213	20	214
214	20	215
215	20	216
216	20	217
217	20	218
218	20	219
219	21	214
220	21	220
221	21	222
222	21	224
223	21	225
224	21	226
225	21	227
226	21	228
227	21	229
228	21	215
229	23	232
230	23	233
231	23	234
232	25	235
233	25	236
234	25	237
235	26	238
236	26	239
237	26	240
238	27	241
239	27	242
240	27	243
241	29	244
242	29	245
243	29	246
244	30	247
245	30	248
246	30	249
247	31	250
248	31	251
249	31	252
250	33	253
251	33	254
252	33	255
253	34	256
254	34	257
255	34	258
256	35	259
257	35	260
258	35	261
259	36	262
260	36	263
261	36	264
262	38	137
263	38	265
264	38	266
265	39	268
266	39	269
267	39	270
268	41	274
269	41	275
270	41	276
271	42	274
272	42	275
273	42	276
274	6	271
275	6	272
276	6	273
277	12	277
278	12	278
279	12	279
280	15	280
281	15	281
282	15	282
283	16	150
284	16	284
285	16	153
286	17	286
287	17	287
288	17	288
289	22	289
290	22	290
291	22	291
292	24	292
293	24	293
294	24	294
295	28	295
296	28	296
297	28	297
298	32	298
299	32	299
300	32	300
301	37	301
302	37	302
303	37	303
304	37	304
305	40	159
306	40	305
307	40	306
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
198	СССР
199	Гонконг
\.


--
-- Data for Name: director; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director (id, surname, name, photo) FROM stdin;
1	Мускетти	Андрес	1.jpg
2	Накаш	Оливье	2.jpg
3	Толедано	Эрик	3.jpg
4	Нолан	Кристофер	4.jpg
5	Пантелеев	Андрей	5.jpg
6	Дарабонт	Фрэнк	6.jpg
7	Джексон	Питер	7.jpg
8	Миядзаки	Хаяо	8.jpg
9	Гайдай	Леонид	9.jpg
10	Чулюкин	Юрий	10.jpg
11	Аппельханс	Крис	\N
12	Кан	Мэгги	12.jpg
13	Гибсон	Мэл	13.jpg
14	Файзиев	Джаник	14.jpg
15	Шурховецкий	Иван	15.jpg
16	Тарантино	Квентин	16.jpg
17	Ростоцкий	Станислав	17.jpg
18	Коламбус	Крис	18.jpg
19	Аллерс	Роджер	19.jpg
20	Минкофф	Роб	 20.jpg
21	Джероними	Клайд	21.jpg
22	Томас	Бетти	22.jpg
23	Лугин	Павел	23.jpg
24	Чбоски	Стивен	24.jpg
25	Вачовски	Лана	25.jpg
26	Вачовски	Лилли	26.jpg
27	Кэмерон	Джеймс	27.jpg
28	Халльстрем	Лассе	28.jpg
29	Вербински	Гор	29.jpg
30	Араки	Тэцуро	30.jpg
31	Кинг	Пол	31.jpg
32	Анкрич	Ли	32.jpg
33	Молина	Эдриан	33.jpg
34	Адамсон	Эндрю	34.jpg
35	Дженсон	Вики	35.jpg
36	Скотт	Ридли	36.jpg
37	Сурикова	Алла	37.jpg
38	Климов	Элем	38.jpg
39	Джексон	Уилфред	39.jpg
40	Ласк	Хэмилтон	40.jpg
41	Каттинг	Джек	\N
42	Марутян	Арман	42.jpg
43	Масленников	Игорь	43.jpg
\.


--
-- Data for Name: director_movie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director_movie (id, id_director, id_movie) FROM stdin;
1	4	5
2	2	4
3	3	4
4	1	3
5	5	6
6	6	7
7	7	8
8	8	10
9	9	11
10	10	14
11	11	9
12	12	9
13	4	13
15	14	19
16	15	19
14	13	18
17	16	20
18	16	21
19	17	23
20	18	25
21	19	26
22	20	26
23	8	27
24	21	29
25	22	30
26	23	31
27	24	33
28	25	34
29	26	34
30	27	35
31	28	36
32	29	38
33	30	39
34	31	41
35	31	42
36	32	12
37	33	12
38	34	15
39	35	15
40	9	16
41	36	17
42	37	22
43	38	24
44	21	28
45	39	28
46	40	28
47	41	28
48	42	32
49	18	37
50	43	40
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
4	Атмосфера Кино
5	 New Line Cinema
6	Toho
7	Мосфильм
8	Netflix
9	Каропрокат
10	ГПМ КИТ
3	Columbia Pictures
11	A Band Apart
12	Централ Партнершип
13	20th Century Fox
14	Disney
15	Наше кино
16	Sony
17	Kodansha
18	DreamWorks Animation
19	К. Б. А.
\.


--
-- Data for Name: film_tutor_countries_movie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.film_tutor_countries_movie (id_film_tutor, id_country, id_movie, id) FROM stdin;
1	186	3	1
2	60	4	2
1	186	5	3
4	142	6	4
3	186	7	5
5	186	8	6
5	124	8	7
6	84	10	8
7	198	11	9
7	198	14	10
8	186	9	11
1	186	13	12
1	185	13	13
1	186	18	14
9	142	19	15
10	142	19	16
3	186	20	17
11	186	20	18
12	186	21	19
7	198	23	20
13	186	25	21
14	186	26	22
6	84	27	23
14	186	29	24
5	186	30	25
5	32	30	26
15	142	31	27
14	186	33	28
14	32	33	29
14	199	33	30
1	186	34	31
1	9	34	32
13	186	35	33
16	186	36	34
16	185	36	35
14	186	38	36
6	84	39	37
17	84	39	38
14	185	41	39
14	185	42	40
14	60	42	41
14	60	41	42
14	186	12	43
14	111	12	44
18	186	15	45
7	198	16	46
18	185	17	48
18	186	17	49
18	198	22	50
18	198	24	51
14	186	28	52
19	142	32	53
1	185	37	54
1	186	37	55
7	198	40	56
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
17	Аниме
18	Мультфильм
19	Семейный
20	Криминал
\.


--
-- Data for Name: movie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie (name, release_date, duration_movie, id, cover, description, id_age_rating, id_imdb) FROM stdin;
Интерстеллар	2014-11-06	02:49:08	5	3.jpg	Когда засуха, пыльные бури и вымирание растений приводят человечество к продовольственному кризису, коллектив исследователей и учёных отправляется сквозь червоточину (которая предположительно соединяет области пространства-времени через большое расстояние) в путешествие, чтобы превзойти прежние ограничения для космических путешествий человека и найти планету с подходящими для человечества условиями.	5	tt0816692
Оно	2017-09-07	02:15:42	3	1.jpg	Когда в городке Дерри штата Мэн начинают пропадать дети, несколько ребят сталкиваются со своими величайшими страхами — не только с группой школьных хулиганов, но со злобным клоуном Пеннивайзом, список жертв которого уходит вглубь веков.	5	tt1396484
Колбаса	2025-09-04	01:39:00	6	4.jpg	Бизнесмен отправляет избалованного сына спасать мясокомбинат. Комедия о перевоспитании с Дмитрием Нагиевым	4	tt34623024
Побег из Шоушенка	1994-09-10	02:22:00	7	5.jpg	Бухгалтер Энди Дюфрейн обвинён в убийстве собственной жены и её любовника. Оказавшись в тюрьме под названием Шоушенк, он сталкивается с жестокостью и беззаконием, царящими по обе стороны решётки. Каждый, кто попадает в эти стены, становится их рабом до конца жизни. Но Энди, обладающий живым умом и доброй душой, находит подход как к заключённым, так и к охранникам, добиваясь их особого к себе расположения.	5	tt0111161
Властелин колец: Братство кольца	2001-12-10	02:58:00	8	6.jpg	Сказания о Средиземье — это хроника Великой войны за Кольцо, длившейся не одну тысячу лет. Тот, кто владел Кольцом, получал неограниченную власть, но был обязан служить злу.	3	tt0120737
Унесенные призраками	2001-07-20	02:04:00	10	7.jpg	Тихиро с мамой и папой переезжает в новый дом. Заблудившись по дороге, они оказываются в странном пустынном городе, где их ждет великолепный пир. Родители с жадностью набрасываются на еду и к ужасу девочки превращаются в свиней, став пленниками злой колдуньи Юбабы. Теперь, оказавшись одна среди волшебных существ и загадочных видений, Тихиро должна придумать, как избавить своих родителей от чар коварной старухи.	3	tt0245429
Операция «Ы» и другие приключения Шурика	1965-07-23	01:35:00	11	8.jpg	Студент Шурик попадает в самые невероятные ситуации: сражается с хулиганом Верзилой, весьма оригинальным способом готовится к экзамену и предотвращает «ограбление века», на которое идёт троица бандитов — Балбес, Трус и Бывалый.	2	tt0059550
Девчата	1962-03-07	01:32:00	14	9.jpg	В сибирский поселок приехала юная повариха Тося Кислицына — наивная и эксцентричная девчонка. Она сует свой нос во все дела, каждому стремится помочь. Местный красавец Илья на спор заводит с Тосей роман.	1	tt0134614
Кей-поп-охотницы на демонов	2025-06-20	01:35:00	9	10.jpg	С древних времён девушки с необычными голосами охраняют людей от демонов: пением устанавливают защитный барьер, чтобы зло не проникло в наш мир. Такова миссия трёх участниц женской кей-поп-группы Huntrix, и они с ней успешно справлялись, пока их фанатов не начала переманивать мужская — команда коварных демонов, прикидывающихся симпатичными парнями.	3	tt14205554
Темный рыцарь	2008-07-14	02:32:00	13	11.jpg	Бэтмен поднимает ставки в войне с криминалом. С помощью лейтенанта Джима Гордона и прокурора Харви Дента он намерен очистить улицы Готэма от преступности. Сотрудничество оказывается эффективным, но скоро они обнаружат себя посреди хаоса, развязанного восходящим криминальным гением, известным напуганным горожанам под именем Джокер.	5	tt0468569
Храброе сердце	1995-05-18	02:58:00	18	12.jpg	Действие фильма начинается в 1280 году в Шотландии. Это история легендарного национального героя Уильяма Уоллеса, посвятившего себя борьбе с англичанами при короле Эдварде Длинноногом.	5	tt0112573
Легенда о Коловрате	2017-11-30	01:57:00	19	13.jpg	XIII век. Русь раздроблена и вот-вот падёт на колени перед ханом Золотой Орды Батыем. Испепеляя города и заливая русские земли кровью, захватчики не встречают серьёзного сопротивления, и лишь один воин бросает им вызов. Молодой рязанский витязь Евпатий Коловрат возглавляет отряд смельчаков, чтобы отомстить за свою любовь и за свою родину. Его отвага поразит даже Батыя, а его имя навсегда останется в памяти народа. Воин, ставший легендой. Подвиг, сохранившийся в веках.	3	tt6054874
Джанго освобожденный	2012-12-11	02:45:00	20	14.jpg	Шульц — эксцентричный охотник за головами, который выслеживает и отстреливает самых опасных преступников. Он освобождает раба по имени Джанго, поскольку тот может помочь ему в поисках трёх бандитов. Джанго знает этих парней в лицо, ведь у него с ними свои счёты.	5	tt1853728
Омерзительная восьмерка	2015-12-07	02:48:00	21	15.jpg	США после Гражданской войны. Легендарный охотник за головами Джон Рут по кличке Вешатель конвоирует заключенную. По пути к ним прибиваются еще несколько путешественников. Снежная буря вынуждает компанию искать укрытие в лавке на отшибе, где уже расположилось весьма пёстрое общество: генерал конфедератов, мексиканец, ковбой… И один из них — не тот, за кого себя выдает.	5	tt3460252
Белый Бим Черное ухо	1977-09-15	03:03:00	23	16.jpg	Трогательная лирическая киноповесть о судьбе собаки, теряющей любимого хозяина, об отношении людей к «братьям меньшим», которое как рентгеном просвечивает души, выявляя в одних низость и мелочную подлость, а в других - благородство, способность сострадать и любить…	2	tt0077222
Один дома	1990-11-10	01:43:00	25	17.jpg	Американское семейство отправляется из Чикаго в Европу, но в спешке сборов бестолковые родители забывают дома... одного из своих детей. Юное создание, однако, не теряется и демонстрирует чудеса изобретательности. И когда в дом залезают грабители, им приходится не раз пожалеть о встрече с милым крошкой.	1	tt0099785
Король Лев	1994-06-12	01:28:00	26	18.jpg	У величественного Короля-Льва Муфасы рождается наследник по имени Симба. Уже в детстве любознательный малыш становится жертвой интриг своего завистливого дяди Шрама, мечтающего о власти.	1	tt0110357
Мой сосед Тоторо	1988-04-16	01:26:00	27	19.jpg	Сестры Сацуки и Мэй переезжают вместе с папой в деревенский дом. Однажды девочки обнаруживают, что по соседству с ними живут лесные духи — хранители леса во главе со своим могущественным и добрым повелителем Тоторо. Постепенно Тоторо становится другом девочек, помогая им в их повседневных приключениях.	2	tt0096283
Золушка	1950-02-15	01:14:00	29	20.jpg	Золушка - бедная сиротка, которую злая мачеха и ее вздорные дочки заставляют тяжко работать с утра до ночи. Она так хочет попасть на королевский бал. На помощь бедняжке приходит Добрая фея! Силой волшебства она наделяет Золушку роскошной каретой, чудесным платьем и необыкновенными хрустальными башмачками.	1	tt0042332
Сдохни, Джон Такер!	2006-11-02	01:29:00	30	21.jpg	Три бывшие подружки крутого школьного ловеласа решают ему отомстить. Для приведения жестокого плана в действие нужна приманка. Выбор падает на только что переехавшую в их школу очаровательную блондиночку…	4	tt0455967
Василиса и хранители времени	2024-10-03	01:38:00	31	22.jpg	За некие провинности Хранители времени из дальней вселенной отправляют на Землю Волшебника. Там он обретает внучку Василису, тоже наделенную чудодейственными силами. Вместе они знакомятся со звездой интернета Дашей, которая живёт вниманием и любовью своих поклонников в социальных сетях: чем больше их армия, чем больше их лайков, тем моложе и красивее она становится. Задача коварной Даши — завладеть волшебной силой Василисы и с ее помощью обрести вечную молодость.	4	tt30990277
Чудо	2017-11-14	01:53:00	33	23.jpg	С одной стороны 10-летний Август Пулман такой же как и другие мальчишки его возраста — любит ходить на дни рождения к друзьям, играть в компьютерные игры и фанатеет от «Звездных войн». А с другой — он совсем не такой. Август никогда не ходил в обычную школу — с первого класса с ним дома занималась мама. Также мальчик перенес 27 операций. Из-за генетической аномалии у Августа деформировано лицо, и он идёт в школу первый раз.	4	tt2543472
Матрица	1999-03-24	02:16:00	34	24.jpg	Жизнь Томаса Андерсона разделена на две части: днём он — самый обычный офисный работник, получающий нагоняи от начальства, а ночью превращается в хакера по имени Нео, и нет места в сети, куда он бы не смог проникнуть. Но однажды всё меняется. Томас узнаёт ужасающую правду о реальности.	5	tt0133093
Титаник	1997-11-01	03:14:00	35	25.jpg	Апрель 1912 года. В первом и последнем плавании шикарного «Титаника» встречаются двое. Пассажир нижней палубы Джек выиграл билет в карты, а богатая наследница Роза отправляется в Америку, чтобы выйти замуж по расчёту. Чувства молодых людей только успевают расцвести, и даже не классовые различия создадут испытания влюблённым, а айсберг, вставший на пути считавшегося непотопляемым лайнера.	3	tt0120338
Хатико: Самый верный друг	2009-07-13	01:29:00	36	26.jpg	Однажды, возвращаясь с работы, профессор колледжа нашел на вокзале симпатичного щенка породы акита-ину. Профессор и Хатико стали верными друзьями. Каждый день пес провожал и встречал хозяина на вокзале.	1	tt1028532
Пираты Карибского моря: Проклятие Черной жемчужины	2003-06-28	02:23:00	38	27.jpg	Жизнь харизматичного авантюриста, капитана Джека Воробья, полная увлекательных приключений, резко меняется, когда его заклятый враг капитан Барбосса похищает корабль Джека Черную Жемчужину, а затем нападает на Порт Ройал и крадет прекрасную дочь губернатора Элизабет Свонн.	3	tt0325980
Атака Титанов: Последняя атака	2024-11-08	02:25:00	39	28.jpg	После катастрофических действий Эрена его друзья и бывшие враги объединяются против него. Армин, Микаса и оставшиеся в живых солдаты разведкорпуса формируют временный союз с Райнером Брауном и остатками марлийской армии. Противостояние людей и титанов достигает апогея.	5	tt2560140
Приключения Паддингтона 2	2017-11-05	01:43:00	41	29.jpg	В антикварном магазине Лондона обаятельный и хорошо воспитанный медведь Паддингтон находит уникальную старинную книгу. Пока он изо всех своих медвежьих сил старается накопить на неё, редчайшее издание внезапно похищают. Паддингтон оказывается втянут в аферу века, затеянную знаменитым, но вышедшим в тираж актером, который ныне рекламирует собачьи консервы, а свой талант к перевоплощению использует в охоте за сокровищами.	5	tt4468740
Приключения Паддингтона	2014-11-23	01:35:00	42	30.jpg	Познакомьтесь, это медведь по имени Паддингтон из дремучего Перу. Он приехал в Лондон, чтобы обрести семью и стать настоящим английским джентльменом. На пути к этой цели его ожидают невероятные приключения, полные юмора и опасностей.	5	tt1109624
1+1	2011-04-26	01:52:06	4	2.jpg	Пострадав в результате несчастного случая, богатый аристократ Филипп нанимает в помощники человека, который менее всего подходит для этой работы, – молодого жителя предместья Дрисса, только что освободившегося из тюрьмы. Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.	5	tt1675434
Тайна Коко	2017-10-20	01:45:00	12	31.jpg	12-летний Мигель живёт в мексиканской деревушке в семье сапожников и тайно мечтает стать музыкантом. Тайно, потому что в его семье музыка считается проклятием. Когда-то его прапрадед оставил жену, прапрабабку Мигеля, ради мечты, которая теперь не даёт спокойно жить и его праправнуку. С тех пор музыкальная тема в семье стала табу. Мигель обнаруживает, что между ним и его любимым певцом Эрнесто де ла Крусом, ныне покойным, существует некая связь. Паренёк отправляется к своему кумиру в Страну Мёртвых, где встречает души предков. Мигель знакомится там с духом-скелетом по имени Гектор, который становится его проводником. Вдвоём они отправляются на поиски де ла Круса.	3	tt2380307
Шрэк	2001-04-22	01:30:00	15	32.jpg	Жил да был в сказочном государстве большой зеленый великан по имени Шрэк. Жил он в гордом одиночестве в лесу, на болоте, которое считал своим. Но однажды злобный коротышка — лорд Фаркуад, правитель волшебного королевства, безжалостно согнал на Шрэково болото всех сказочных обитателей.	5	tt0126029
Кавказская пленница, или Новые приключения Шурика	1967-04-01	01:22:00	16	33.jpg	Отправившись в одну из горных республик собирать фольклор, студент Шурик влюбляется в симпатичную Нину — спортсменку, отличницу, комсомолку и просто красавицу. Однако банда из трёх человек похищает девушку, чтобы насильно выдать замуж. Поняв, что происходит, Шурик отважно бросается освобождать кавказскую пленницу.	2	tt0060584
Гладиатор	2000-05-01	02:35:00	17	34.jpg	Римская империя. Бесстрашного и благородного генерала Максимуса боготворят солдаты, а старый император Марк Аврелий безгранично доверяет ему и относится как к сыну. Однако опытный воин, готовый сразиться с любым противником в честном бою, оказывается бессильным перед коварными придворными интригами. Коммод, сын Марка Аврелия, убивает отца, который планировал сделать преемником не его, а Максимуса, и захватывает власть. Решив избавиться от опасного соперника, который к тому же отказывается присягнуть ему на верность, Коммод отдаёт приказ убить Максимуса и всю его семью. Чудом выжив, но не сумев спасти близких, Максимус попадает в плен к работорговцу, который продаёт его организатору гладиаторских боёв Проксимо. Так легендарный полководец становится гладиатором. Но вскоре ему представится шанс встретиться со своим смертельным врагом лицом к лицу.	5	tt0172495
Человек с бульвара Капуцинов	1987-06-23	01:38:00	22	35.jpg	В одном из ковбойских городков Дикого Запада с его традиционной стрельбой, сквернословием и мордобоем появляется тихий миссионер кино мистер Фёст. Неведомое прежде ковбоям «синема» до неузнаваемости меняет уклад их жизни, нравы и привычки.	3	tt0092745
Добро пожаловать, или Посторонним вход воспрещен	1964-10-09	01:11:00	24	36.jpg	Пионер Костя Иночкин, будучи в пионерском лагере, переплыл реку и оказался на запретной для посещений территории, за что и был изгнан его начальником товарищем Дыниным. Не желая доводить бабушку до инфаркта своим досрочным прибытием, мальчик тайно возвращается в лагерь, где пионеры так же тайно содержат его и предпринимают все меры, чтобы не состоялся родительский день. Ведь именно в этот день Костина бабушка заявится в лагерь...	2	tt0058022
Леди и бродяга	1995-06-16	01:16:00	28	37.jpg	Трогательная и захватывающая история сближения двух абсолютно разных собак - породистой комнатной неженки и обычной дворняги. Изящная и пушистая как игрушка, коккер-спаниельша Леди была любимицей хозяев, пока в их семье не появился младенец. Надетый намордник стал последней каплей, подтолкнувшей обиженную героиню к бегству. Но на улице ее поджидала целая куча опасностей, о существовании которых она даже не подозревала. И тогда на помощь миниатюрной черноглазой красотке пришел пес Бродяга, благородство которого было не в породе, а в душе.	1	tt0048280
Манюня	2021-09-23	00:24:00	32	38.jpg	Армения, 1979 год. Горы, солнце, прекрасные зеленые луга и ощущение праздника. После смешного эпизода в школе девочки Наринэ и Манюня становятся лучшими подругами. Наринэ очень боялась строгой бабушки Манюни, но во время их знакомства выяснилось, что Ба печет тающее во рту печенье и вкуснейший яблочный пирог. Девочек-непосед ждет масса приключений.	2	tt19883218
Гарри Поттер и философский камень	2001-11-04	02:32:00	37	39.jpg	Жизнь десятилетнего Гарри Поттера нельзя назвать сладкой: родители умерли, едва ему исполнился год, а от дяди и тёти, взявших сироту на воспитание, достаются лишь тычки да подзатыльники. Но в одиннадцатый день рождения Гарри всё меняется. Странный гость, неожиданно появившийся на пороге, приносит письмо, из которого мальчик узнаёт, что на самом деле он - волшебник и зачислен в школу магии под названием Хогвартс. А уже через пару недель Гарри будет мчаться в поезде Хогвартс-экспресс навстречу новой жизни, где его ждут невероятные приключения, верные друзья и самое главное — ключ к разгадке тайны смерти его родителей.	3	tt0241527
Шерлок Холмс и доктор Ватсон: Знакомство	1980-03-22	01:08:00	40	40.jpg	Молодой доктор по фамилии Ватсон возвратился из Афганистана в родной туманный Лондон. Ему нужно недорогое жилье. И вот, по совету друга, он поселяется в маленьком домике на Бейкер-стрит. Его хозяйка - милая чудаковатая старушка миссис Хадсон. Также там имеется сосед - некий мистер Шерлок Холмс. Это непонятная и таинственная личность - к нему в гости приходят оборванцы и бандиты, а иногда полицейские и лорды. Кто же он? Доктор в растерянности...	3	tt0298697
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
7	6	142
8	7	186
9	8	186
10	8	124
11	10	84
12	11	198
13	14	198
14	9	186
15	13	186
16	13	185
17	18	186
18	19	142
19	20	186
20	21	186
21	23	198
22	25	186
23	26	186
24	27	84
25	29	186
26	30	186
27	30	32
28	31	142
29	33	186
30	33	32
31	33	199
32	34	186
33	34	9
34	35	186
35	36	186
36	36	185
37	38	186
38	39	84
39	41	185
40	42	185
41	42	60
42	41	60
43	12	186
44	12	111
45	15	186
46	16	198
47	17	185
48	17	186
49	22	198
50	24	198
51	28	186
52	32	142
53	37	185
54	37	186
55	40	198
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
11	6	1
12	7	2
13	8	10
14	8	8
15	8	2
16	8	3
17	10	17
18	10	18
19	10	10
20	10	8
21	10	19
22	11	1
23	11	9
24	11	20
25	14	1
26	14	9
27	9	18
28	9	10
29	9	1
30	9	13
31	9	3
32	13	7
33	13	3
34	13	6
35	13	20
36	13	2
37	18	11
38	18	16
39	18	2
40	18	15
41	19	11
42	19	3
43	19	10
44	20	12
45	20	3
46	20	2
47	20	1
48	21	12
49	21	20
50	21	6
51	21	2
52	21	4
53	23	2
54	25	1
55	25	19
56	26	18
57	26	13
58	26	10
59	26	2
60	26	8
61	26	19
62	27	17
63	27	18
64	27	10
65	27	8
66	27	19
67	29	18
68	29	13
69	29	10
70	29	9
71	29	19
72	30	1
73	30	9
74	31	10
75	31	8
76	31	19
77	33	2
78	33	19
79	34	7
80	34	3
81	35	9
82	35	6
83	35	2
84	36	2
85	36	19
86	36	16
87	38	10
88	38	2
89	38	8
90	39	17
91	39	18
92	39	7
93	39	2
94	39	3
95	39	10
96	41	10
97	41	1
98	41	19
99	42	1
100	42	19
101	42	9
102	42	10
104	12	18
105	12	10
106	12	1
107	12	8
108	12	19
109	12	13
110	15	18
111	15	10
112	15	9
113	15	1
114	15	8
115	15	19
116	16	1
117	16	8
118	16	9
119	16	13
120	17	11
121	17	3
122	17	2
123	17	14
124	22	12
125	22	1
126	22	13
127	22	9
128	24	1
129	24	19
130	28	18
131	28	13
132	28	9
133	28	1
134	28	8
135	28	19
136	32	19
137	32	1
138	32	8
139	37	10
140	37	8
141	37	19
142	40	4
143	40	20
144	13	5
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, login, email, password, registration_date, photo) FROM stdin;
1	Hih123	hih@gmail.com	123456	2025-09-30	\N
2	fff	qwe@gm	$1$NQ8wlY9p$YTfU04Lt3JqGLbiIOgS790	2025-11-06	s;lfkwfwpefj
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

SELECT pg_catalog.setval('public.actor_id_seq', 307, true);


--
-- Name: age_rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.age_rating_id_seq', 5, true);


--
-- Name: cast_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cast_id_seq', 307, true);


--
-- Name: comments_and_ratings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_and_ratings_id_seq', 1, true);


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_id_seq', 199, true);


--
-- Name: directing_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directing_staff_id_seq', 50, true);


--
-- Name: director_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.director_id_seq', 43, true);


--
-- Name: favourites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favourites_id_seq', 5, true);


--
-- Name: film_tutor_countries_movie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_tutor_countries_movie_id_seq', 56, true);


--
-- Name: film_tutor_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_tutor_id_seq1', 19, true);


--
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genres_id_seq', 20, true);


--
-- Name: movie_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_country_id_seq', 55, true);


--
-- Name: movie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movie_id_seq', 42, true);


--
-- Name: movies_genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movies_genres_id_seq', 144, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 2, true);


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

\unrestrict Hbf2nrCVUQRmJE73O6KUIF8Ww806c3kF7pOvILbJRGvegFxt2ZkmfTleFDZjIyi












