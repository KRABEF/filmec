--
-- PostgreSQL database dump
--

\restrict GFQbMMVbgtFEE20ux58iTHEWd1CzFqDvlLXTg8ayoIDYDDXdnYmMydU62vOkKqd

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
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE postgres OWNER TO postgres;

\unrestrict GFQbMMVbgtFEE20ux58iTHEWd1CzFqDvlLXTg8ayoIDYDDXdnYmMydU62vOkKqd
\connect postgres
\restrict GFQbMMVbgtFEE20ux58iTHEWd1CzFqDvlLXTg8ayoIDYDDXdnYmMydU62vOkKqd

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


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
1	Мускетти	Андрес	1.jpg
2	Накаш	Оливье	2.jpg
3	Толедано	Эрик	3.jpg
4	Нолан	Кристофер	4.jpg
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

COPY public.movie (name, release_date, duration_movie, id, cover, description, id_age_rating, id_imdb) FROM stdin;
Интерстеллар	2014-11-06	02:49:08	5	3.jpg	Когда засуха, пыльные бури и вымирание растений приводят человечество к продовольственному кризису, коллектив исследователей и учёных отправляется сквозь червоточину (которая предположительно соединяет области пространства-времени через большое расстояние) в путешествие, чтобы превзойти прежние ограничения для космических путешествий человека и найти планету с подходящими для человечества условиями.	5	tt0816692
Оно	2017-09-07	02:15:42	3	1.jpg	Когда в городке Дерри штата Мэн начинают пропадать дети, несколько ребят сталкиваются со своими величайшими страхами — не только с группой школьных хулиганов, но со злобным клоуном Пеннивайзом, список жертв которого уходит вглубь веков.	5	tt1396484
Колбаса	2025-09-04	01:39:00	6	https://avatars.mds.yandex.net/get-kinopoisk-image/10703859/3e7a9bbb-2b4b-4dd7-a5d7-739d06700202/1920x	Бизнесмен отправляет избалованного сына спасать мясокомбинат. Комедия о перевоспитании с Дмитрием Нагиевым	4	tt34623024
Побег из Шоушенка	1994-09-10	02:22:00	7	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/e26044e5-2d5a-4b38-a133-a776ad93366f/1920x	Бухгалтер Энди Дюфрейн обвинён в убийстве собственной жены и её любовника. Оказавшись в тюрьме под названием Шоушенк, он сталкивается с жестокостью и беззаконием, царящими по обе стороны решётки. Каждый, кто попадает в эти стены, становится их рабом до конца жизни. Но Энди, обладающий живым умом и доброй душой, находит подход как к заключённым, так и к охранникам, добиваясь их особого к себе расположения.	5	tt0111161
Властелин колец: Братство кольца	2001-12-10	02:58:00	8	https://avatars.mds.yandex.net/get-kinopoisk-image/1777765/05233b2d-a25a-44fe-9cca-47063a2f2b4d/1920x	Сказания о Средиземье — это хроника Великой войны за Кольцо, длившейся не одну тысячу лет. Тот, кто владел Кольцом, получал неограниченную власть, но был обязан служить злу.	3	tt0120737
Унесенные призраками	2001-07-20	02:04:00	10	https://avatars.mds.yandex.net/get-kinopoisk-image/10812607/ee04f3d4-6e87-4b34-93f8-95b4f33954a5/1920x	Тихиро с мамой и папой переезжает в новый дом. Заблудившись по дороге, они оказываются в странном пустынном городе, где их ждет великолепный пир. Родители с жадностью набрасываются на еду и к ужасу девочки превращаются в свиней, став пленниками злой колдуньи Юбабы. Теперь, оказавшись одна среди волшебных существ и загадочных видений, Тихиро должна придумать, как избавить своих родителей от чар коварной старухи.	3	tt0245429
Операция «Ы» и другие приключения Шурика	1965-07-23	01:35:00	11	https://avatars.mds.yandex.net/get-kinopoisk-image/6201401/26a13cad-25ec-4456-987b-f5acebba5f45/1920x	Студент Шурик попадает в самые невероятные ситуации: сражается с хулиганом Верзилой, весьма оригинальным способом готовится к экзамену и предотвращает «ограбление века», на которое идёт троица бандитов — Балбес, Трус и Бывалый.	2	tt0059550
Девчата	1962-03-07	01:32:00	14	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/11025d70-a7f8-4028-a2fa-d7556c8d0b56/1920x	В сибирский поселок приехала юная повариха Тося Кислицына — наивная и эксцентричная девчонка. Она сует свой нос во все дела, каждому стремится помочь. Местный красавец Илья на спор заводит с Тосей роман.	1	tt0134614
Кей-поп-охотницы на демонов	2025-06-20	01:35:00	9	https://avatars.mds.yandex.net/get-kinopoisk-image/10592371/4eaa527e-c0e0-4fba-9a4d-a8dde6f5fc91/1920x	С древних времён девушки с необычными голосами охраняют людей от демонов: пением устанавливают защитный барьер, чтобы зло не проникло в наш мир. Такова миссия трёх участниц женской кей-поп-группы Huntrix, и они с ней успешно справлялись, пока их фанатов не начала переманивать мужская — команда коварных демонов, прикидывающихся симпатичными парнями.	3	tt14205554
Темный рыцарь	2008-07-14	02:32:00	13	https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/93683fc1-b7b5-440b-a65d-2eddf3f862d1/1920x	Бэтмен поднимает ставки в войне с криминалом. С помощью лейтенанта Джима Гордона и прокурора Харви Дента он намерен очистить улицы Готэма от преступности. Сотрудничество оказывается эффективным, но скоро они обнаружат себя посреди хаоса, развязанного восходящим криминальным гением, известным напуганным горожанам под именем Джокер.	5	tt0468569
Храброе сердце	1995-05-18	02:58:00	18	https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/0fed82c5-9614-421e-ab58-90e841a7c6d6/1920x	Действие фильма начинается в 1280 году в Шотландии. Это история легендарного национального героя Уильяма Уоллеса, посвятившего себя борьбе с англичанами при короле Эдварде Длинноногом.	5	tt0112573
Легенда о Коловрате	2017-11-30	01:57:00	19	https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/55b0e046-ce68-415a-a682-38761ada03d8/1920x	XIII век. Русь раздроблена и вот-вот падёт на колени перед ханом Золотой Орды Батыем. Испепеляя города и заливая русские земли кровью, захватчики не встречают серьёзного сопротивления, и лишь один воин бросает им вызов. Молодой рязанский витязь Евпатий Коловрат возглавляет отряд смельчаков, чтобы отомстить за свою любовь и за свою родину. Его отвага поразит даже Батыя, а его имя навсегда останется в памяти народа. Воин, ставший легендой. Подвиг, сохранившийся в веках.	3	tt6054874
Джанго освобожденный	2012-12-11	02:45:00	20	https://avatars.mds.yandex.net/get-kinopoisk-image/1629390/29bf7393-16a4-4657-a337-f6482004f481/1920x	Шульц — эксцентричный охотник за головами, который выслеживает и отстреливает самых опасных преступников. Он освобождает раба по имени Джанго, поскольку тот может помочь ему в поисках трёх бандитов. Джанго знает этих парней в лицо, ведь у него с ними свои счёты.	5	tt1853728
Омерзительная восьмерка	2015-12-07	02:48:00	21	https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/0bf728af-ce48-4c0e-9da3-f20ee81bc276/1920x	США после Гражданской войны. Легендарный охотник за головами Джон Рут по кличке Вешатель конвоирует заключенную. По пути к ним прибиваются еще несколько путешественников. Снежная буря вынуждает компанию искать укрытие в лавке на отшибе, где уже расположилось весьма пёстрое общество: генерал конфедератов, мексиканец, ковбой… И один из них — не тот, за кого себя выдает.	5	tt3460252
Белый Бим Черное ухо	1977-09-15	03:03:00	23	https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/1ae4ca0d-ee01-4c23-b63e-c5dbc7dd5075/1920x	Трогательная лирическая киноповесть о судьбе собаки, теряющей любимого хозяина, об отношении людей к «братьям меньшим», которое как рентгеном просвечивает души, выявляя в одних низость и мелочную подлость, а в других - благородство, способность сострадать и любить…	2	tt0077222
Один дома	1990-11-10	01:43:00	25	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/c7195513-24f6-4e80-8f8a-d6777577abb9/1920x	Американское семейство отправляется из Чикаго в Европу, но в спешке сборов бестолковые родители забывают дома... одного из своих детей. Юное создание, однако, не теряется и демонстрирует чудеса изобретательности. И когда в дом залезают грабители, им приходится не раз пожалеть о встрече с милым крошкой.	1	tt0099785
Король Лев	1994-06-12	01:28:00	26	https://avatars.mds.yandex.net/get-kinopoisk-image/10671298/39c06510-f4b2-48c3-8678-4e1a3c24c419/1920x	У величественного Короля-Льва Муфасы рождается наследник по имени Симба. Уже в детстве любознательный малыш становится жертвой интриг своего завистливого дяди Шрама, мечтающего о власти.	1	tt0110357
Мой сосед Тоторо	1988-04-16	01:26:00	27	https://avatars.mds.yandex.net/get-kinopoisk-image/10703959/507d8d5c-87e0-4b2e-8da3-e699976ab1cf/1920x	Сестры Сацуки и Мэй переезжают вместе с папой в деревенский дом. Однажды девочки обнаруживают, что по соседству с ними живут лесные духи — хранители леса во главе со своим могущественным и добрым повелителем Тоторо. Постепенно Тоторо становится другом девочек, помогая им в их повседневных приключениях.	2	tt0096283
Золушка	1950-02-15	01:14:00	29	https://avatars.mds.yandex.net/get-kinopoisk-image/6201401/154231eb-703f-438d-ae81-30813586025b/1920x	Золушка - бедная сиротка, которую злая мачеха и ее вздорные дочки заставляют тяжко работать с утра до ночи. Она так хочет попасть на королевский бал. На помощь бедняжке приходит Добрая фея! Силой волшебства она наделяет Золушку роскошной каретой, чудесным платьем и необыкновенными хрустальными башмачками.	1	tt0042332
Сдохни, Джон Такер!	2006-11-02	01:29:00	30	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/d973b6c9-6f23-4261-88de-73c68ec56c9d/1920x	Три бывшие подружки крутого школьного ловеласа решают ему отомстить. Для приведения жестокого плана в действие нужна приманка. Выбор падает на только что переехавшую в их школу очаровательную блондиночку…	4	tt0455967
Василиса и хранители времени	2024-10-03	01:38:00	31	https://avatars.mds.yandex.net/get-kinopoisk-image/10900341/2c1f0699-7d99-4d23-ab36-4bcb2fa989bb/1920x	За некие провинности Хранители времени из дальней вселенной отправляют на Землю Волшебника. Там он обретает внучку Василису, тоже наделенную чудодейственными силами. Вместе они знакомятся со звездой интернета Дашей, которая живёт вниманием и любовью своих поклонников в социальных сетях: чем больше их армия, чем больше их лайков, тем моложе и красивее она становится. Задача коварной Даши — завладеть волшебной силой Василисы и с ее помощью обрести вечную молодость.	4	tt30990277
Чудо	2017-11-14	01:53:00	33	https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/5d1dd390-7710-4d28-a152-411241b4b987/1920x	С одной стороны 10-летний Август Пулман такой же как и другие мальчишки его возраста — любит ходить на дни рождения к друзьям, играть в компьютерные игры и фанатеет от «Звездных войн». А с другой — он совсем не такой. Август никогда не ходил в обычную школу — с первого класса с ним дома занималась мама. Также мальчик перенес 27 операций. Из-за генетической аномалии у Августа деформировано лицо, и он идёт в школу первый раз.	4	tt2543472
Матрица	1999-03-24	02:16:00	34	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/258fc3d6-8223-40ce-94ea-c87c2acc9f4b/1920x	Жизнь Томаса Андерсона разделена на две части: днём он — самый обычный офисный работник, получающий нагоняи от начальства, а ночью превращается в хакера по имени Нео, и нет места в сети, куда он бы не смог проникнуть. Но однажды всё меняется. Томас узнаёт ужасающую правду о реальности.	5	tt0133093
Титаник	1997-11-01	03:14:00	35	https://avatars.mds.yandex.net/get-kinopoisk-image/10592371/7f0e6761-4635-46ad-b804-59d5cf1ae85c/1920x	Апрель 1912 года. В первом и последнем плавании шикарного «Титаника» встречаются двое. Пассажир нижней палубы Джек выиграл билет в карты, а богатая наследница Роза отправляется в Америку, чтобы выйти замуж по расчёту. Чувства молодых людей только успевают расцвести, и даже не классовые различия создадут испытания влюблённым, а айсберг, вставший на пути считавшегося непотопляемым лайнера.	3	tt0120338
Хатико: Самый верный друг	2009-07-13	01:29:00	36	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/8c709231-b7b1-4fbd-8991-ccfe33245ef8/1920x	Однажды, возвращаясь с работы, профессор колледжа нашел на вокзале симпатичного щенка породы акита-ину. Профессор и Хатико стали верными друзьями. Каждый день пес провожал и встречал хозяина на вокзале.	1	tt1028532
Пираты Карибского моря: Проклятие Черной жемчужины	2003-06-28	02:23:00	38	https://avatars.mds.yandex.net/get-kinopoisk-image/1629390/9bb710bf-97d9-4ce1-99e5-ceadd9bbee97/1920x	Жизнь харизматичного авантюриста, капитана Джека Воробья, полная увлекательных приключений, резко меняется, когда его заклятый враг капитан Барбосса похищает корабль Джека Черную Жемчужину, а затем нападает на Порт Ройал и крадет прекрасную дочь губернатора Элизабет Свонн.	3	tt0325980
Атака Титанов: Последняя атака	2024-11-08	02:25:00	39	https://avatars.mds.yandex.net/get-kinopoisk-image/10853012/34784733-2981-4aaa-bc9b-859a7d12679d/1920x	После катастрофических действий Эрена его друзья и бывшие враги объединяются против него. Армин, Микаса и оставшиеся в живых солдаты разведкорпуса формируют временный союз с Райнером Брауном и остатками марлийской армии. Противостояние людей и титанов достигает апогея.	5	tt2560140
Приключения Паддингтона 2	2017-11-05	01:43:00	41	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/dd610085-b998-4fec-b4af-ceed88fc0b18/1920x	В антикварном магазине Лондона обаятельный и хорошо воспитанный медведь Паддингтон находит уникальную старинную книгу. Пока он изо всех своих медвежьих сил старается накопить на неё, редчайшее издание внезапно похищают. Паддингтон оказывается втянут в аферу века, затеянную знаменитым, но вышедшим в тираж актером, который ныне рекламирует собачьи консервы, а свой талант к перевоплощению использует в охоте за сокровищами.	5	tt4468740
Приключения Паддингтона	2014-11-23	01:35:00	42	https://avatars.mds.yandex.net/get-kinopoisk-image/1773646/01730272-8391-4c3c-ab77-8cfb9d06100b/1920x	Познакомьтесь, это медведь по имени Паддингтон из дремучего Перу. Он приехал в Лондон, чтобы обрести семью и стать настоящим английским джентльменом. На пути к этой цели его ожидают невероятные приключения, полные юмора и опасностей.	5	tt1109624
1+1	2011-04-26	01:52:06	4	2.jpg	Пострадав в результате несчастного случая, богатый аристократ Филипп нанимает в помощники человека, который менее всего подходит для этой работы, – молодого жителя предместья Дрисса, только что освободившегося из тюрьмы. Несмотря на то, что Филипп прикован к инвалидному креслу, Дриссу удается привнести в размеренную жизнь аристократа дух приключений.	5	tt1675434
Тайна Коко	2017-10-20	01:45:00	12	https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/c1001292-78a7-4d8e-ba60-79475d10165c/1920x	12-летний Мигель живёт в мексиканской деревушке в семье сапожников и тайно мечтает стать музыкантом. Тайно, потому что в его семье музыка считается проклятием. Когда-то его прапрадед оставил жену, прапрабабку Мигеля, ради мечты, которая теперь не даёт спокойно жить и его праправнуку. С тех пор музыкальная тема в семье стала табу. Мигель обнаруживает, что между ним и его любимым певцом Эрнесто де ла Крусом, ныне покойным, существует некая связь. Паренёк отправляется к своему кумиру в Страну Мёртвых, где встречает души предков. Мигель знакомится там с духом-скелетом по имени Гектор, который становится его проводником. Вдвоём они отправляются на поиски де ла Круса.	3	tt2380307
Шрэк	2001-04-22	01:30:00	15	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/191ba182-8612-4fe2-a3e6-ae3517165cc3/1920x	Жил да был в сказочном государстве большой зеленый великан по имени Шрэк. Жил он в гордом одиночестве в лесу, на болоте, которое считал своим. Но однажды злобный коротышка — лорд Фаркуад, правитель волшебного королевства, безжалостно согнал на Шрэково болото всех сказочных обитателей.	5	tt0126029
Кавказская пленница, или Новые приключения Шурика	1967-04-01	01:22:00	16	https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/1f7b3dc7-d10b-4e2d-b5b4-ca257d3737ac/1920x	Отправившись в одну из горных республик собирать фольклор, студент Шурик влюбляется в симпатичную Нину — спортсменку, отличницу, комсомолку и просто красавицу. Однако банда из трёх человек похищает девушку, чтобы насильно выдать замуж. Поняв, что происходит, Шурик отважно бросается освобождать кавказскую пленницу.	2	tt0060584
Гладиатор	2000-05-01	02:35:00	17	https://avatars.mds.yandex.net/get-kinopoisk-image/10809116/08b917e4-6dbd-456d-b517-a2c873e293cd/1920x	Римская империя. Бесстрашного и благородного генерала Максимуса боготворят солдаты, а старый император Марк Аврелий безгранично доверяет ему и относится как к сыну. Однако опытный воин, готовый сразиться с любым противником в честном бою, оказывается бессильным перед коварными придворными интригами. Коммод, сын Марка Аврелия, убивает отца, который планировал сделать преемником не его, а Максимуса, и захватывает власть. Решив избавиться от опасного соперника, который к тому же отказывается присягнуть ему на верность, Коммод отдаёт приказ убить Максимуса и всю его семью. Чудом выжив, но не сумев спасти близких, Максимус попадает в плен к работорговцу, который продаёт его организатору гладиаторских боёв Проксимо. Так легендарный полководец становится гладиатором. Но вскоре ему представится шанс встретиться со своим смертельным врагом лицом к лицу.	5	tt0172495
Человек с бульвара Капуцинов	1987-06-23	01:38:00	22	https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/ed0d417d-5b85-42cb-940c-12b229923424/1920x	В одном из ковбойских городков Дикого Запада с его традиционной стрельбой, сквернословием и мордобоем появляется тихий миссионер кино мистер Фёст. Неведомое прежде ковбоям «синема» до неузнаваемости меняет уклад их жизни, нравы и привычки.	3	tt0092745
Добро пожаловать, или Посторонним вход воспрещен	1964-10-09	01:11:00	24	https://avatars.mds.yandex.net/get-kinopoisk-image/1599028/84263259-c172-4eea-a688-76a8df042cda/1920x	Пионер Костя Иночкин, будучи в пионерском лагере, переплыл реку и оказался на запретной для посещений территории, за что и был изгнан его начальником товарищем Дыниным. Не желая доводить бабушку до инфаркта своим досрочным прибытием, мальчик тайно возвращается в лагерь, где пионеры так же тайно содержат его и предпринимают все меры, чтобы не состоялся родительский день. Ведь именно в этот день Костина бабушка заявится в лагерь...	2	tt0058022
Леди и бродяга	1995-06-16	01:16:00	28	https://avatars.mds.yandex.net/get-kinopoisk-image/6201401/7f0d7416-6c90-4626-bc45-c7ee18370011/1920x	Трогательная и захватывающая история сближения двух абсолютно разных собак - породистой комнатной неженки и обычной дворняги. Изящная и пушистая как игрушка, коккер-спаниельша Леди была любимицей хозяев, пока в их семье не появился младенец. Надетый намордник стал последней каплей, подтолкнувшей обиженную героиню к бегству. Но на улице ее поджидала целая куча опасностей, о существовании которых она даже не подозревала. И тогда на помощь миниатюрной черноглазой красотке пришел пес Бродяга, благородство которого было не в породе, а в душе.	1	tt0048280
Манюня	2021-09-23	00:24:00	32	https://avatars.mds.yandex.net/get-kinopoisk-image/9784475/4d896196-5222-4873-a165-1d77c01d9f03/1920x	Армения, 1979 год. Горы, солнце, прекрасные зеленые луга и ощущение праздника. После смешного эпизода в школе девочки Наринэ и Манюня становятся лучшими подругами. Наринэ очень боялась строгой бабушки Манюни, но во время их знакомства выяснилось, что Ба печет тающее во рту печенье и вкуснейший яблочный пирог. Девочек-непосед ждет масса приключений.	2	tt19883218
Гарри Поттер и философский камень	2001-11-04	02:32:00	37	https://avatars.mds.yandex.net/get-kinopoisk-image/1946459/c493015d-3330-49d5-b36d-2c0f6b064a33/1920x	Жизнь десятилетнего Гарри Поттера нельзя назвать сладкой: родители умерли, едва ему исполнился год, а от дяди и тёти, взявших сироту на воспитание, достаются лишь тычки да подзатыльники. Но в одиннадцатый день рождения Гарри всё меняется. Странный гость, неожиданно появившийся на пороге, приносит письмо, из которого мальчик узнаёт, что на самом деле он - волшебник и зачислен в школу магии под названием Хогвартс. А уже через пару недель Гарри будет мчаться в поезде Хогвартс-экспресс навстречу новой жизни, где его ждут невероятные приключения, верные друзья и самое главное — ключ к разгадке тайны смерти его родителей.	3	tt0241527
Шерлок Холмс и доктор Ватсон: Знакомство	1980-03-22	01:08:00	40	https://avatars.mds.yandex.net/get-ott/1648503/2a00000198546c9a87c8607e3e156955383d/300x450	Молодой доктор по фамилии Ватсон возвратился из Афганистана в родной туманный Лондон. Ему нужно недорогое жилье. И вот, по совету друга, он поселяется в маленьком домике на Бейкер-стрит. Его хозяйка - милая чудаковатая старушка миссис Хадсон. Также там имеется сосед - некий мистер Шерлок Холмс. Это непонятная и таинственная личность - к нему в гости приходят оборванцы и бандиты, а иногда полицейские и лорды. Кто же он? Доктор в растерянности...	3	tt0298697
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

SELECT pg_catalog.setval('public.movie_id_seq', 42, true);


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

\unrestrict GFQbMMVbgtFEE20ux58iTHEWd1CzFqDvlLXTg8ayoIDYDDXdnYmMydU62vOkKqd

