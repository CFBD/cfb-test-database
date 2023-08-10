--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5 (Debian 11.5-1.pgdg90+1)
-- Dumped by pg_dump version 11.20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: division; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.division AS ENUM (
    'fbs',
    'fcs',
    'ii/iii',
    'ii',
    'iii'
);


--
-- Name: down_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.down_type AS ENUM (
    'standard',
    'passing'
);


--
-- Name: game_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.game_status AS ENUM (
    'scheduled',
    'in_progress',
    'completed'
);


--
-- Name: home_away; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.home_away AS ENUM (
    'home',
    'away'
);


--
-- Name: media_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.media_type AS ENUM (
    'tv',
    'radio',
    'web',
    'ppv',
    'mobile'
);


--
-- Name: play_call; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.play_call AS ENUM (
    'rush',
    'pass'
);


--
-- Name: recruit_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.recruit_type AS ENUM (
    'HighSchool',
    'JUCO',
    'PrepSchool'
);


--
-- Name: season_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.season_type AS ENUM (
    'preseason',
    'regular',
    'postseason',
    'allstar',
    'spring_regular',
    'spring_postseason'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: conference_team; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conference_team (
    id integer NOT NULL,
    conference_id smallint NOT NULL,
    team_id integer NOT NULL,
    division character varying(20),
    start_year smallint,
    end_year smallint
);


--
-- Name: drive; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drive (
    id bigint NOT NULL,
    game_id integer NOT NULL,
    offense_id integer NOT NULL,
    defense_id integer NOT NULL,
    scoring boolean NOT NULL,
    start_period smallint NOT NULL,
    start_yardline smallint NOT NULL,
    start_time interval NOT NULL,
    end_period smallint NOT NULL,
    end_yardline smallint NOT NULL,
    end_time interval NOT NULL,
    elapsed interval NOT NULL,
    plays smallint NOT NULL,
    yards smallint NOT NULL,
    result_id smallint NOT NULL,
    drive_number smallint
);


--
-- Name: game; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game (
    id integer NOT NULL,
    season smallint NOT NULL,
    week smallint NOT NULL,
    season_type public.season_type NOT NULL,
    start_date timestamp without time zone NOT NULL,
    neutral_site boolean NOT NULL,
    conference_game boolean,
    attendance integer,
    venue_id integer,
    spread smallint,
    over_under smallint,
    excitement numeric,
    start_time_tbd boolean,
    highlights character varying(15),
    notes character varying(100),
    status public.game_status DEFAULT 'scheduled'::public.game_status NOT NULL,
    current_period smallint,
    current_clock interval,
    current_home_score smallint,
    current_away_score smallint,
    current_situation character varying(20),
    current_possession character varying(5)
);


--
-- Name: game_player_stat; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_player_stat (
    id bigint NOT NULL,
    game_team_id bigint NOT NULL,
    athlete_id bigint NOT NULL,
    category_id smallint NOT NULL,
    type_id smallint NOT NULL,
    stat character varying(10) NOT NULL
);


--
-- Name: game_team; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_team (
    id bigint NOT NULL,
    game_id integer NOT NULL,
    team_id integer NOT NULL,
    home_away public.home_away NOT NULL,
    points smallint,
    winner boolean,
    line_scores smallint[],
    win_prob numeric,
    start_elo integer,
    end_elo integer
);


--
-- Name: game_team_stat; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_team_stat (
    id bigint NOT NULL,
    game_team_id bigint NOT NULL,
    type_id smallint NOT NULL,
    stat character varying(10) NOT NULL
);


--
-- Name: play; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.play (
    id bigint NOT NULL,
    drive_id bigint,
    offense_id integer NOT NULL,
    defense_id integer NOT NULL,
    home_score smallint NOT NULL,
    away_score smallint NOT NULL,
    period smallint NOT NULL,
    clock interval NOT NULL,
    yard_line smallint NOT NULL,
    down smallint NOT NULL,
    distance smallint NOT NULL,
    yards_gained smallint NOT NULL,
    scoring boolean NOT NULL,
    play_type_id smallint NOT NULL,
    play_text text,
    ppa numeric,
    garbage_time boolean DEFAULT false NOT NULL,
    play_number smallint,
    home_timeouts smallint,
    away_timeouts smallint,
    home_win_prob numeric,
    wallclock timestamp without time zone,
    success boolean,
    down_type public.down_type,
    play_call public.play_call
);


--
-- Name: team; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team (
    id integer NOT NULL,
    school character varying(50) NOT NULL,
    mascot character varying(50),
    ncaa_name character varying(25),
    alt_name character varying,
    nickname character varying(50),
    abbreviation character varying,
    display_name character varying(50) NOT NULL,
    short_display_name character varying(50),
    color character varying(7),
    alt_color character varying(7),
    active boolean NOT NULL,
    images character varying(100)[],
    venue_id integer,
    twitter character varying(20)
);

--
-- Name: conference; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conference (
    id smallint NOT NULL,
    name character varying(60) NOT NULL,
    short_name character varying(60),
    abbreviation character varying(10),
    sr_name character varying(25),
    division public.division
);

--
-- Name: athlete; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.athlete (
    id bigint NOT NULL,
    team_id integer,
    name character varying(100) NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    weight smallint,
    height smallint,
    jersey smallint,
    hometown_id integer,
    position_id smallint,
    active boolean,
    year smallint
);


--
-- Name: athlete_team; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.athlete_team (
    id integer NOT NULL,
    athlete_id bigint NOT NULL,
    team_id integer NOT NULL,
    start_year smallint,
    end_year smallint
);


--
-- Name: athlete_team_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.athlete_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: athlete_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.athlete_team_id_seq OWNED BY public.athlete_team.id;


--
-- Name: city; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.city (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: city_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.city_id_seq OWNED BY public.city.id;


--
-- Name: coach; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coach (
    id integer NOT NULL,
    first_name character varying(20) NOT NULL,
    last_name character varying(20) NOT NULL
);


--
-- Name: coach_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coach_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coach_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coach_id_seq OWNED BY public.coach.id;


--
-- Name: coach_season; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coach_season (
    id smallint NOT NULL,
    coach_id smallint NOT NULL,
    team_id integer NOT NULL,
    year smallint NOT NULL,
    games smallint NOT NULL,
    wins smallint NOT NULL,
    losses smallint NOT NULL,
    ties smallint NOT NULL,
    preseason_rank smallint,
    postseason_rank smallint
);


--
-- Name: coach_season_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coach_season_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coach_season_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coach_season_id_seq OWNED BY public.coach_season.id;


--
-- Name: coach_team; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coach_team (
    id integer NOT NULL,
    coach_id integer NOT NULL,
    team_id integer NOT NULL,
    hire_date date
);


--
-- Name: coach_team_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coach_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coach_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coach_team_id_seq OWNED BY public.coach_team.id;


--
-- Name: conference_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conference_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conference_id_seq OWNED BY public.conference.id;


--
-- Name: conference_team_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conference_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conference_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conference_team_id_seq OWNED BY public.conference_team.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.country (
    id smallint NOT NULL,
    name character varying(30) NOT NULL
);


--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.country_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.country_id_seq OWNED BY public.country.id;


--
-- Name: current_conferences; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.current_conferences AS
 SELECT t.id AS team_id,
    t.school,
    c.id AS conference_id,
    c.division AS classification,
    c.name,
    c.abbreviation,
    ct.division
   FROM ((public.conference c
     JOIN public.conference_team ct ON (((c.id = ct.conference_id) AND (ct.end_year IS NULL))))
     JOIN public.team t ON ((ct.team_id = t.id)))
  ORDER BY c.division, t.id;


--
-- Name: draft_picks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draft_picks (
    id integer NOT NULL,
    college_id integer,
    college_team_id integer NOT NULL,
    nfl_team_id smallint NOT NULL,
    position_id smallint NOT NULL,
    overall smallint NOT NULL,
    round smallint NOT NULL,
    name character varying(100) NOT NULL,
    height smallint,
    weight smallint,
    overall_rank smallint,
    position_rank smallint,
    grade smallint,
    pick smallint NOT NULL,
    year smallint NOT NULL
);


--
-- Name: draft_position; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draft_position (
    id smallint NOT NULL,
    name character varying(25) NOT NULL,
    abbreviation character varying(5) NOT NULL
);


--
-- Name: draft_team; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draft_team (
    id smallint NOT NULL,
    location character varying(25) NOT NULL,
    mascot character varying(25),
    display_name character varying(50),
    nickname character varying(25),
    short_display_name character varying(25),
    logo character varying(100)
);


--
-- Name: drive_result; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drive_result (
    id smallint NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: drive_result_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drive_result_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drive_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drive_result_id_seq OWNED BY public.drive_result.id;


--
-- Name: game_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_lines (
    id bigint NOT NULL,
    game_id integer NOT NULL,
    lines_provider_id integer NOT NULL,
    spread numeric,
    over_under numeric,
    spread_open numeric,
    over_under_open numeric,
    moneyline_home integer,
    moneyline_away integer
);


--
-- Name: game_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.game_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.game_lines_id_seq OWNED BY public.game_lines.id;


--
-- Name: game_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_media (
    id bigint NOT NULL,
    game_id integer NOT NULL,
    media_type public.media_type NOT NULL,
    name character varying(20) NOT NULL
);


--
-- Name: game_media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.game_media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.game_media_id_seq OWNED BY public.game_media.id;


--
-- Name: game_player_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.game_player_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_player_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.game_player_stat_id_seq OWNED BY public.game_player_stat.id;


--
-- Name: game_team_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.game_team_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_team_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.game_team_stat_id_seq OWNED BY public.game_team_stat.id;


--
-- Name: game_weather; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_weather (
    game_id integer NOT NULL,
    temperature numeric,
    dewpoint numeric,
    humidity numeric,
    precipitation numeric DEFAULT 0,
    snowfall numeric DEFAULT 0,
    wind_direction numeric,
    wind_speed numeric,
    wind_gust numeric,
    pressure numeric,
    total_sun numeric,
    weather_condition_code smallint
);


--
-- Name: hometown; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hometown (
    id integer NOT NULL,
    city character varying(30),
    state character varying(10),
    country character varying(30),
    latitude numeric,
    longitude numeric,
    county_fips character varying
);


--
-- Name: hometown_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hometown_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hometown_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hometown_id_seq OWNED BY public.hometown.id;


--
-- Name: lines_provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lines_provider (
    id integer NOT NULL,
    name character varying(30) NOT NULL
);


--
-- Name: play_stat; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.play_stat (
    id bigint NOT NULL,
    play_id bigint NOT NULL,
    athlete_id bigint NOT NULL,
    stat_type_id smallint NOT NULL,
    stat smallint NOT NULL
);


--
-- Name: play_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.play_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.play_stat_id_seq OWNED BY public.play_stat.id;


--
-- Name: play_stat_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.play_stat_type (
    id smallint NOT NULL,
    name character varying(20) NOT NULL,
    abbreviation character varying(5)
);


--
-- Name: play_stat_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.play_stat_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_stat_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.play_stat_type_id_seq OWNED BY public.play_stat_type.id;


--
-- Name: play_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.play_type (
    id smallint NOT NULL,
    text character varying(35) NOT NULL,
    abbreviation character varying(5),
    sequence smallint
);


--
-- Name: player_stat_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.player_stat_category (
    id smallint NOT NULL,
    name character varying(15) NOT NULL
);


--
-- Name: player_stat_category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.player_stat_category_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: player_stat_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.player_stat_category_id_seq OWNED BY public.player_stat_category.id;


--
-- Name: player_stat_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.player_stat_type (
    id smallint NOT NULL,
    name character varying(10) NOT NULL
);


--
-- Name: player_stat_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.player_stat_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: player_stat_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.player_stat_type_id_seq OWNED BY public.player_stat_type.id;


--
-- Name: poll; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poll (
    id integer NOT NULL,
    season_type public.season_type NOT NULL,
    season integer NOT NULL,
    week smallint NOT NULL,
    poll_type_id integer NOT NULL
);


--
-- Name: poll_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.poll_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: poll_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.poll_id_seq OWNED BY public.poll.id;


--
-- Name: poll_rank; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poll_rank (
    id integer NOT NULL,
    poll_id integer NOT NULL,
    team_id integer NOT NULL,
    rank smallint,
    first_place_votes smallint,
    points integer
);


--
-- Name: poll_rank_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.poll_rank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: poll_rank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.poll_rank_id_seq OWNED BY public.poll_rank.id;


--
-- Name: poll_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poll_type (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    short_name character varying(50) NOT NULL,
    abbreviation character varying(10)
);


--
-- Name: position; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."position" (
    id smallint NOT NULL,
    name character varying(30) NOT NULL,
    display_name character varying(30) NOT NULL,
    abbreviation character varying(3) NOT NULL
);


--
-- Name: ppa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ppa (
    id integer NOT NULL,
    yard_line smallint NOT NULL,
    down smallint NOT NULL,
    distance smallint NOT NULL,
    predicted_points numeric NOT NULL
);


--
-- Name: ppa_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ppa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ppa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ppa_id_seq OWNED BY public.ppa.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ratings (
    id integer NOT NULL,
    year smallint NOT NULL,
    team_id integer NOT NULL,
    rating numeric NOT NULL,
    o_rating numeric NOT NULL,
    d_rating numeric NOT NULL,
    st_rating numeric,
    sos numeric,
    second_order_wins numeric,
    o_success numeric,
    o_explosiveness numeric,
    o_rushing numeric,
    o_passing numeric,
    o_standard_downs numeric,
    o_passing_downs numeric,
    o_run_rate numeric,
    o_pace numeric,
    d_success numeric,
    d_explosiveness numeric,
    d_rushing numeric,
    d_passing numeric,
    d_standard_downs numeric,
    d_passing_downs numeric,
    d_havoc numeric,
    d_front_seven_havoc numeric,
    d_db_havoc numeric
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ratings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ratings_id_seq OWNED BY public.ratings.id;


--
-- Name: recruit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recruit (
    id bigint NOT NULL,
    year smallint NOT NULL,
    name character varying(150) NOT NULL,
    recruit_school_id integer,
    recruit_position_id smallint,
    height real,
    weight smallint,
    stars smallint NOT NULL,
    rating real NOT NULL,
    college_id integer,
    recruit_type public.recruit_type NOT NULL,
    city_id integer,
    state_id smallint,
    country_id smallint,
    ranking smallint,
    athlete_id integer,
    hometown_id integer,
    overall_rank smallint,
    position_rank smallint
);


--
-- Name: recruit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recruit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recruit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recruit_id_seq OWNED BY public.recruit.id;


--
-- Name: recruit_position; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recruit_position (
    id smallint NOT NULL,
    "position" character varying(4) NOT NULL,
    position_group character varying(30)
);


--
-- Name: recruit_position_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recruit_position_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recruit_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recruit_position_id_seq OWNED BY public.recruit_position.id;


--
-- Name: recruit_school; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recruit_school (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


--
-- Name: recruit_school_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recruit_school_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recruit_school_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recruit_school_id_seq OWNED BY public.recruit_school.id;


--
-- Name: recruiting_team; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recruiting_team (
    id integer NOT NULL,
    year smallint NOT NULL,
    team_id integer NOT NULL,
    rank smallint NOT NULL,
    points numeric NOT NULL
);


--
-- Name: recruiting_team_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recruiting_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recruiting_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recruiting_team_id_seq OWNED BY public.recruiting_team.id;


--
-- Name: srs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.srs (
    id integer NOT NULL,
    year smallint NOT NULL,
    team_id integer NOT NULL,
    rating numeric NOT NULL,
    epa_offense numeric,
    epa_defense numeric
);


--
-- Name: srs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.srs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: srs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.srs_id_seq OWNED BY public.srs.id;


--
-- Name: state_province; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.state_province (
    id smallint NOT NULL,
    name character varying(30) NOT NULL
);


--
-- Name: state_province_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.state_province_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: state_province_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.state_province_id_seq OWNED BY public.state_province.id;


--
-- Name: team_game_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_game_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_game_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_game_id_seq OWNED BY public.game_team.id;


--
-- Name: team_stat_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_stat_type (
    id smallint NOT NULL,
    name character varying(25) NOT NULL,
    player_category_mapping_id smallint,
    player_type_mapping_id smallint
);


--
-- Name: team_stat_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_stat_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_stat_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_stat_type_id_seq OWNED BY public.team_stat_type.id;


--
-- Name: team_talent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_talent (
    id smallint NOT NULL,
    team_id integer NOT NULL,
    year smallint NOT NULL,
    talent numeric(6,2) NOT NULL
);


--
-- Name: team_talent_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_talent_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_talent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_talent_id_seq OWNED BY public.team_talent.id;


--
-- Name: transfer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfer (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    position_id smallint NOT NULL,
    from_team_id integer NOT NULL,
    to_team_id integer,
    transfer_date timestamp without time zone,
    rating numeric,
    stars smallint,
    eligibility character varying(25),
    season smallint NOT NULL
);


--
-- Name: venue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venue (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    grass boolean,
    city character varying(50),
    state character varying(25),
    zip character(5),
    country_code character varying(5),
    location point,
    elevation numeric,
    year_constructed smallint,
    dome boolean,
    timezone character varying(50)
);


--
-- Name: weather_condition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weather_condition (
    id smallint NOT NULL,
    description character varying(25) NOT NULL
);


--
-- Name: athlete_team id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athlete_team ALTER COLUMN id SET DEFAULT nextval('public.athlete_team_id_seq'::regclass);


--
-- Name: city id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.city ALTER COLUMN id SET DEFAULT nextval('public.city_id_seq'::regclass);


--
-- Name: coach id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach ALTER COLUMN id SET DEFAULT nextval('public.coach_id_seq'::regclass);


--
-- Name: coach_season id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach_season ALTER COLUMN id SET DEFAULT nextval('public.coach_season_id_seq'::regclass);


--
-- Name: coach_team id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach_team ALTER COLUMN id SET DEFAULT nextval('public.coach_team_id_seq'::regclass);


--
-- Name: conference id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conference ALTER COLUMN id SET DEFAULT nextval('public.conference_id_seq'::regclass);


--
-- Name: conference_team id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conference_team ALTER COLUMN id SET DEFAULT nextval('public.conference_team_id_seq'::regclass);


--
-- Name: country id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country ALTER COLUMN id SET DEFAULT nextval('public.country_id_seq'::regclass);


--
-- Name: drive_result id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drive_result ALTER COLUMN id SET DEFAULT nextval('public.drive_result_id_seq'::regclass);


--
-- Name: game_lines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_lines ALTER COLUMN id SET DEFAULT nextval('public.game_lines_id_seq'::regclass);


--
-- Name: game_media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_media ALTER COLUMN id SET DEFAULT nextval('public.game_media_id_seq'::regclass);


--
-- Name: game_player_stat id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_player_stat ALTER COLUMN id SET DEFAULT nextval('public.game_player_stat_id_seq'::regclass);


--
-- Name: game_team id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_team ALTER COLUMN id SET DEFAULT nextval('public.team_game_id_seq'::regclass);


--
-- Name: game_team_stat id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_team_stat ALTER COLUMN id SET DEFAULT nextval('public.game_team_stat_id_seq'::regclass);


--
-- Name: hometown id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hometown ALTER COLUMN id SET DEFAULT nextval('public.hometown_id_seq'::regclass);


--
-- Name: play_stat id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_stat ALTER COLUMN id SET DEFAULT nextval('public.play_stat_id_seq'::regclass);


--
-- Name: play_stat_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_stat_type ALTER COLUMN id SET DEFAULT nextval('public.play_stat_type_id_seq'::regclass);


--
-- Name: player_stat_category id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_stat_category ALTER COLUMN id SET DEFAULT nextval('public.player_stat_category_id_seq'::regclass);


--
-- Name: player_stat_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_stat_type ALTER COLUMN id SET DEFAULT nextval('public.player_stat_type_id_seq'::regclass);


--
-- Name: poll id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poll ALTER COLUMN id SET DEFAULT nextval('public.poll_id_seq'::regclass);


--
-- Name: poll_rank id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poll_rank ALTER COLUMN id SET DEFAULT nextval('public.poll_rank_id_seq'::regclass);


--
-- Name: ppa id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ppa ALTER COLUMN id SET DEFAULT nextval('public.ppa_id_seq'::regclass);


--
-- Name: ratings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings ALTER COLUMN id SET DEFAULT nextval('public.ratings_id_seq'::regclass);


--
-- Name: recruit id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruit ALTER COLUMN id SET DEFAULT nextval('public.recruit_id_seq'::regclass);


--
-- Name: recruit_position id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruit_position ALTER COLUMN id SET DEFAULT nextval('public.recruit_position_id_seq'::regclass);


--
-- Name: recruit_school id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruit_school ALTER COLUMN id SET DEFAULT nextval('public.recruit_school_id_seq'::regclass);


--
-- Name: recruiting_team id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiting_team ALTER COLUMN id SET DEFAULT nextval('public.recruiting_team_id_seq'::regclass);


--
-- Name: srs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.srs ALTER COLUMN id SET DEFAULT nextval('public.srs_id_seq'::regclass);


--
-- Name: state_province id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.state_province ALTER COLUMN id SET DEFAULT nextval('public.state_province_id_seq'::regclass);


--
-- Name: team_stat_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_stat_type ALTER COLUMN id SET DEFAULT nextval('public.team_stat_type_id_seq'::regclass);


--
-- Name: team_talent id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_talent ALTER COLUMN id SET DEFAULT nextval('public.team_talent_id_seq'::regclass);


--
-- Name: athlete athlete_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athlete
    ADD CONSTRAINT athlete_pkey PRIMARY KEY (id);


--
-- Name: athlete_team athlete_team_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athlete_team
    ADD CONSTRAINT athlete_team_pkey PRIMARY KEY (id);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: coach coach_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach
    ADD CONSTRAINT coach_pkey PRIMARY KEY (id);


--
-- Name: coach_season coach_season_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach_season
    ADD CONSTRAINT coach_season_pkey PRIMARY KEY (id);


--
-- Name: coach_team coach_team_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach_team
    ADD CONSTRAINT coach_team_pkey PRIMARY KEY (id);


--
-- Name: conference conference_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conference
    ADD CONSTRAINT conference_pkey PRIMARY KEY (id);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: draft_picks draft_picks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_picks
    ADD CONSTRAINT draft_picks_pkey PRIMARY KEY (id);


--
-- Name: draft_position draft_position_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_position
    ADD CONSTRAINT draft_position_pkey PRIMARY KEY (id);


--
-- Name: draft_team draft_team_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_team
    ADD CONSTRAINT draft_team_pkey PRIMARY KEY (id);


--
-- Name: drive drive_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drive
    ADD CONSTRAINT drive_pkey PRIMARY KEY (id);


--
-- Name: drive_result drive_result_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drive_result
    ADD CONSTRAINT drive_result_pkey PRIMARY KEY (id);


--
-- Name: game_lines game_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_lines
    ADD CONSTRAINT game_lines_pkey PRIMARY KEY (id);


--
-- Name: game_media game_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_media
    ADD CONSTRAINT game_media_pkey PRIMARY KEY (id);


--
-- Name: game game_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_pkey PRIMARY KEY (id);


--
-- Name: game_player_stat game_player_stat_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_player_stat
    ADD CONSTRAINT game_player_stat_pkey PRIMARY KEY (id);


--
-- Name: game_team_stat game_team_stat_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_team_stat
    ADD CONSTRAINT game_team_stat_pkey PRIMARY KEY (id);


--
-- Name: game_weather game_weather_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_weather
    ADD CONSTRAINT game_weather_pkey PRIMARY KEY (game_id);


--
-- Name: hometown hometown_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hometown
    ADD CONSTRAINT hometown_pkey PRIMARY KEY (id);


--
-- Name: lines_provider lines_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lines_provider
    ADD CONSTRAINT lines_provider_pkey PRIMARY KEY (id);


--
-- Name: play play_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_pkey PRIMARY KEY (id);


--
-- Name: play_stat play_stat_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_stat
    ADD CONSTRAINT play_stat_pkey PRIMARY KEY (id);


--
-- Name: play_stat_type play_stat_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_stat_type
    ADD CONSTRAINT play_stat_type_pkey PRIMARY KEY (id);


--
-- Name: play_type play_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_type
    ADD CONSTRAINT play_type_pkey PRIMARY KEY (id);


--
-- Name: player_stat_category player_stat_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_stat_category
    ADD CONSTRAINT player_stat_category_pkey PRIMARY KEY (id);


--
-- Name: player_stat_type player_stat_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_stat_type
    ADD CONSTRAINT player_stat_type_pkey PRIMARY KEY (id);


--
-- Name: poll poll_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poll
    ADD CONSTRAINT poll_pkey PRIMARY KEY (id);


--
-- Name: poll_rank poll_rank_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poll_rank
    ADD CONSTRAINT poll_rank_pkey PRIMARY KEY (id);


--
-- Name: poll_type poll_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poll_type
    ADD CONSTRAINT poll_type_pkey PRIMARY KEY (id);


--
-- Name: position position_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (id);


--
-- Name: ppa ppa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ppa
    ADD CONSTRAINT ppa_pkey PRIMARY KEY (id);


--
-- Name: recruiting_team recruiting_team_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiting_team
    ADD CONSTRAINT recruiting_team_pkey PRIMARY KEY (id);


--
-- Name: srs srs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.srs
    ADD CONSTRAINT srs_pkey PRIMARY KEY (id);


--
-- Name: state_province state_province_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.state_province
    ADD CONSTRAINT state_province_pkey PRIMARY KEY (id);


--
-- Name: game_team team_game_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_team
    ADD CONSTRAINT team_game_pkey PRIMARY KEY (id);


--
-- Name: team team_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- Name: team_stat_type team_stat_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_stat_type
    ADD CONSTRAINT team_stat_type_pkey PRIMARY KEY (id);


--
-- Name: team_talent team_talent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_talent
    ADD CONSTRAINT team_talent_pkey PRIMARY KEY (id);


--
-- Name: transfer transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfer
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (id, season);


--
-- Name: game_lines uk_game_lines_game_provider; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_lines
    ADD CONSTRAINT uk_game_lines_game_provider UNIQUE (game_id, lines_provider_id);


--
-- Name: venue venue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue
    ADD CONSTRAINT venue_pkey PRIMARY KEY (id);


--
-- Name: weather_condition weather_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weather_condition
    ADD CONSTRAINT weather_condition_pkey PRIMARY KEY (id);


--
-- Name: fki_fk_athlete_team_athlete; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_athlete_team_athlete ON public.athlete_team USING btree (athlete_id);


--
-- Name: fki_fk_athlete_team_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_athlete_team_team ON public.athlete_team USING btree (team_id);


--
-- Name: fki_fk_coach_team_coach; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_coach_team_coach ON public.coach_team USING btree (coach_id);


--
-- Name: fki_fk_coach_team_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_coach_team_team ON public.coach_team USING btree (team_id);


--
-- Name: fki_fk_conference_team_conference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_conference_team_conference ON public.conference_team USING btree (conference_id);


--
-- Name: fki_fk_conference_team_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_conference_team_team ON public.conference_team USING btree (team_id);


--
-- Name: fki_fk_draft_picks_college_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_draft_picks_college_team_id ON public.draft_picks USING btree (college_team_id);


--
-- Name: fki_fk_draft_picks_draft_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_draft_picks_draft_position ON public.draft_picks USING btree (position_id);


--
-- Name: fki_fk_draft_picks_draft_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_draft_picks_draft_team ON public.draft_picks USING btree (nfl_team_id);


--
-- Name: fki_fk_game_lines_game; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_game_lines_game ON public.game_lines USING btree (game_id);


--
-- Name: fki_fk_game_lines_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_game_lines_provider ON public.game_lines USING btree (lines_provider_id);


--
-- Name: fki_fk_game_media_game; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_game_media_game ON public.game_media USING btree (game_id);


--
-- Name: fki_fk_hometown; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_hometown ON public.recruit USING btree (hometown_id);


--
-- Name: fki_fk_ratings_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_ratings_team ON public.ratings USING btree (team_id);


--
-- Name: fki_fk_recruit_athlete; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_recruit_athlete ON public.recruit USING btree (athlete_id);


--
-- Name: fki_fk_srs_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_srs_team ON public.srs USING btree (team_id);


--
-- Name: fki_fk_team_venue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_fk_team_venue ON public.team USING btree (venue_id);


--
-- Name: game_season; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX game_season ON public.game USING btree (season);


--
-- Name: game_season_week; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX game_season_week ON public.game USING btree (season, week);


--
-- Name: ix_athlete_hometown_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_athlete_hometown_id ON public.athlete USING btree (hometown_id);


--
-- Name: ix_athlete_last_name_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_athlete_last_name_first_name ON public.athlete USING btree (last_name, first_name);


--
-- Name: ix_athlete_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_athlete_name ON public.athlete USING btree (name);


--
-- Name: ix_athlete_position_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_athlete_position_id ON public.athlete USING btree (position_id);


--
-- Name: ix_athlete_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_athlete_team_id ON public.athlete USING btree (team_id);


--
-- Name: ix_athlete_team_id_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_athlete_team_id_name ON public.athlete USING btree (team_id, name);


--
-- Name: ix_coach_season_coach_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_coach_season_coach_id ON public.coach_season USING btree (coach_id);


--
-- Name: ix_coach_season_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_coach_season_team_id ON public.coach_season USING btree (team_id);


--
-- Name: ix_coach_season_team_id_coach_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_coach_season_team_id_coach_id ON public.coach_season USING btree (coach_id, team_id);


--
-- Name: ix_coach_season_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_coach_season_year ON public.coach_season USING btree (year);


--
-- Name: ix_conference_team_filtered; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_conference_team_filtered ON public.conference_team USING btree (team_id) WHERE (end_year IS NULL);


--
-- Name: ix_conference_team_years; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_conference_team_years ON public.conference_team USING btree (start_year, end_year);


--
-- Name: ix_draft_picks_college_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_draft_picks_college_id ON public.draft_picks USING btree (college_id) WHERE (college_id IS NOT NULL);


--
-- Name: ix_draft_picks_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_draft_picks_year ON public.draft_picks USING btree (year DESC NULLS LAST);


--
-- Name: ix_drive_defense_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_drive_defense_id ON public.drive USING btree (defense_id);


--
-- Name: ix_drive_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_drive_game_id ON public.drive USING btree (game_id);


--
-- Name: ix_drive_offense_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_drive_offense_id ON public.drive USING btree (offense_id);


--
-- Name: ix_drive_result_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_drive_result_id ON public.drive USING btree (result_id);


--
-- Name: ix_drive_result_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_drive_result_name ON public.drive_result USING btree (name);


--
-- Name: ix_game_filtered; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_filtered ON public.game USING btree (season DESC NULLS LAST, week) INCLUDE (id, season, week, season_type) WHERE (season > 2000);


--
-- Name: ix_game_player_stat_athlete_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_player_stat_athlete_id ON public.game_player_stat USING btree (athlete_id);


--
-- Name: ix_game_player_stat_category_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_player_stat_category_type ON public.game_player_stat USING btree (category_id, type_id);


--
-- Name: ix_game_player_stat_game_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_player_stat_game_team_id ON public.game_player_stat USING btree (game_team_id);


--
-- Name: ix_game_player_stat_game_team_id_filtered; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_player_stat_game_team_id_filtered ON public.game_player_stat USING btree (game_team_id) WHERE ((stat)::text <> '0'::text);


--
-- Name: ix_game_team_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_team_game_id ON public.game_team USING btree (game_id);


--
-- Name: ix_game_team_stat_game_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_team_stat_game_team_id ON public.game_team_stat USING btree (game_team_id);


--
-- Name: ix_game_team_stat_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_team_stat_type_id ON public.game_team_stat USING btree (type_id);


--
-- Name: ix_game_team_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_team_team_id ON public.game_team USING btree (team_id);


--
-- Name: ix_game_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_game_venue_id ON public.game USING btree (venue_id);


--
-- Name: ix_hometown_country_state_city; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_hometown_country_state_city ON public.hometown USING btree (country, state, city);


--
-- Name: ix_last_name_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_last_name_first_name ON public.coach USING btree (last_name, first_name);


--
-- Name: ix_play_defense_filtered; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_defense_filtered ON public.play USING btree (defense_id) WHERE (ppa IS NOT NULL);


--
-- Name: ix_play_defense_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_defense_id ON public.play USING btree (defense_id);


--
-- Name: ix_play_down_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_down_distance ON public.play USING btree (down, distance);


--
-- Name: ix_play_drive_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_drive_id ON public.play USING btree (drive_id);


--
-- Name: ix_play_garbage_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_garbage_time ON public.play USING btree (garbage_time);


--
-- Name: ix_play_offense_filtered; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_offense_filtered ON public.play USING btree (offense_id) WHERE (ppa IS NOT NULL);


--
-- Name: ix_play_offense_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_offense_id ON public.play USING btree (offense_id);


--
-- Name: ix_play_play_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_play_type_id ON public.play USING btree (play_type_id);


--
-- Name: ix_play_stat_athlete_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_stat_athlete_id ON public.play_stat USING btree (athlete_id);


--
-- Name: ix_play_stat_athlete_id_stat_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_stat_athlete_id_stat_type_id ON public.play_stat USING btree (athlete_id, stat_type_id);


--
-- Name: ix_play_stat_play_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_stat_play_id ON public.play_stat USING btree (play_id);


--
-- Name: ix_play_stat_type_abbreviation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_stat_type_abbreviation ON public.play_stat_type USING btree (abbreviation);


--
-- Name: ix_play_stat_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_play_stat_type_id ON public.play_stat USING btree (stat_type_id);


--
-- Name: ix_play_stat_type_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_play_stat_type_name ON public.play_stat_type USING btree (name);


--
-- Name: ix_play_type_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_play_type_name ON public.play_type USING btree (text);


--
-- Name: ix_player_stat_category_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_player_stat_category_name ON public.player_stat_category USING btree (name);


--
-- Name: ix_player_stat_type_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_player_stat_type_name ON public.player_stat_type USING btree (name);


--
-- Name: ix_position_abbreviation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_position_abbreviation ON public."position" USING btree (abbreviation);


--
-- Name: ix_position_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_position_name ON public."position" USING btree (name);


--
-- Name: ix_ratings_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_ratings_year ON public.ratings USING btree (year);


--
-- Name: ix_team_abbreviation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_team_abbreviation ON public.team USING btree (abbreviation);


--
-- Name: ix_team_id_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_team_id_last_name ON public.athlete USING btree (team_id, last_name);

--
-- Name: ix_team_school; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_team_school ON public.team USING btree (school);


--
-- Name: ix_team_stat_type_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_team_stat_type_name ON public.team_stat_type USING btree (name);


--
-- Name: ix_team_talent_talent_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_team_talent_talent_year ON public.team_talent USING btree (talent, year);


--
-- Name: ix_team_talent_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_team_talent_team_id ON public.team_talent USING btree (team_id);


--
-- Name: ix_team_talent_team_id_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_team_talent_team_id_year ON public.team_talent USING btree (team_id, year);


--
-- Name: ix_team_talent_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_team_talent_year ON public.team_talent USING btree (year);


--
-- Name: ix_venue_city_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_venue_city_state ON public.venue USING btree (city, state);


--
-- Name: ix_venue_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_venue_name ON public.venue USING btree (name);


--
-- Name: ix_venue_zip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_venue_zip ON public.venue USING btree (zip);


--
-- Name: ux_game_team; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_game_team ON public.game_team USING btree (game_id, team_id);


--
-- Name: ux_poll_type_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ux_poll_type_name ON public.poll_type USING btree (name);


--
-- Name: ux_yard_line_down_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_yard_line_down_distance ON public.ppa USING btree (down, distance, yard_line) INCLUDE (predicted_points);


--
-- Name: athlete athlete_hometown_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athlete
    ADD CONSTRAINT athlete_hometown_id_fkey FOREIGN KEY (hometown_id) REFERENCES public.hometown(id);


--
-- Name: athlete athlete_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athlete
    ADD CONSTRAINT athlete_position_id_fkey FOREIGN KEY (position_id) REFERENCES public."position"(id);


--
-- Name: athlete athlete_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athlete
    ADD CONSTRAINT athlete_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.team(id);


--
-- Name: coach_season coach_season_coach_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach_season
    ADD CONSTRAINT coach_season_coach_id_fkey FOREIGN KEY (coach_id) REFERENCES public.coach(id);


--
-- Name: coach_season coach_season_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach_season
    ADD CONSTRAINT coach_season_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.team(id);


--
-- Name: drive drive_defense_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drive
    ADD CONSTRAINT drive_defense_id_fkey FOREIGN KEY (defense_id) REFERENCES public.team(id);


--
-- Name: drive drive_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drive
    ADD CONSTRAINT drive_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.game(id) ON DELETE CASCADE;


--
-- Name: drive drive_offense_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drive
    ADD CONSTRAINT drive_offense_id_fkey FOREIGN KEY (offense_id) REFERENCES public.team(id);


--
-- Name: drive drive_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drive
    ADD CONSTRAINT drive_result_id_fkey FOREIGN KEY (result_id) REFERENCES public.drive_result(id);


--
-- Name: athlete_team fk_athlete_team_athlete; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athlete_team
    ADD CONSTRAINT fk_athlete_team_athlete FOREIGN KEY (athlete_id) REFERENCES public.athlete(id) NOT VALID;


--
-- Name: athlete_team fk_athlete_team_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.athlete_team
    ADD CONSTRAINT fk_athlete_team_team FOREIGN KEY (team_id) REFERENCES public.team(id) NOT VALID;


--
-- Name: coach_team fk_coach_team_coach; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach_team
    ADD CONSTRAINT fk_coach_team_coach FOREIGN KEY (coach_id) REFERENCES public.coach(id) NOT VALID;


--
-- Name: coach_team fk_coach_team_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coach_team
    ADD CONSTRAINT fk_coach_team_team FOREIGN KEY (team_id) REFERENCES public.team(id) NOT VALID;


--
-- Name: conference_team fk_conference_team_conference; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conference_team
    ADD CONSTRAINT fk_conference_team_conference FOREIGN KEY (conference_id) REFERENCES public.conference(id) NOT VALID;


--
-- Name: conference_team fk_conference_team_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conference_team
    ADD CONSTRAINT fk_conference_team_team FOREIGN KEY (team_id) REFERENCES public.team(id) NOT VALID;


--
-- Name: draft_picks fk_draft_picks_college_team_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_picks
    ADD CONSTRAINT fk_draft_picks_college_team_id FOREIGN KEY (college_team_id) REFERENCES public.team(id) NOT VALID;


--
-- Name: draft_picks fk_draft_picks_draft_position; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_picks
    ADD CONSTRAINT fk_draft_picks_draft_position FOREIGN KEY (position_id) REFERENCES public.draft_position(id) NOT VALID;


--
-- Name: draft_picks fk_draft_picks_draft_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_picks
    ADD CONSTRAINT fk_draft_picks_draft_team FOREIGN KEY (nfl_team_id) REFERENCES public.draft_team(id) NOT VALID;


--
-- Name: game_lines fk_game_lines_game; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_lines
    ADD CONSTRAINT fk_game_lines_game FOREIGN KEY (game_id) REFERENCES public.game(id);


--
-- Name: game_lines fk_game_lines_provider; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_lines
    ADD CONSTRAINT fk_game_lines_provider FOREIGN KEY (lines_provider_id) REFERENCES public.lines_provider(id);


--
-- Name: game_media fk_game_media_game; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_media
    ADD CONSTRAINT fk_game_media_game FOREIGN KEY (game_id) REFERENCES public.game(id) NOT VALID;


--
-- Name: game_weather fk_game_weather_game; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_weather
    ADD CONSTRAINT fk_game_weather_game FOREIGN KEY (game_id) REFERENCES public.game(id) NOT VALID;


--
-- Name: recruit fk_hometown; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruit
    ADD CONSTRAINT fk_hometown FOREIGN KEY (hometown_id) REFERENCES public.hometown(id) NOT VALID;


--
-- Name: poll fk_poll_poll_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poll
    ADD CONSTRAINT fk_poll_poll_type FOREIGN KEY (poll_type_id) REFERENCES public.poll_type(id);


--
-- Name: poll_rank fk_poll_rank_poll; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poll_rank
    ADD CONSTRAINT fk_poll_rank_poll FOREIGN KEY (poll_id) REFERENCES public.poll(id);


--
-- Name: poll_rank fk_poll_rank_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poll_rank
    ADD CONSTRAINT fk_poll_rank_team FOREIGN KEY (team_id) REFERENCES public.team(id);


--
-- Name: ratings fk_ratings_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ratings
    ADD CONSTRAINT fk_ratings_team FOREIGN KEY (team_id) REFERENCES public.team(id) NOT VALID;


--
-- Name: recruit fk_recruit_athlete; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruit
    ADD CONSTRAINT fk_recruit_athlete FOREIGN KEY (athlete_id) REFERENCES public.athlete(id) NOT VALID;


--
-- Name: srs fk_srs_team; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.srs
    ADD CONSTRAINT fk_srs_team FOREIGN KEY (team_id) REFERENCES public.team(id) NOT VALID;


--
-- Name: team fk_team_venue; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT fk_team_venue FOREIGN KEY (venue_id) REFERENCES public.venue(id) NOT VALID;


--
-- Name: game_player_stat game_player_stat_athlete_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_player_stat
    ADD CONSTRAINT game_player_stat_athlete_id_fkey FOREIGN KEY (athlete_id) REFERENCES public.athlete(id);


--
-- Name: game_player_stat game_player_stat_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_player_stat
    ADD CONSTRAINT game_player_stat_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.player_stat_category(id);


--
-- Name: game_player_stat game_player_stat_game_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_player_stat
    ADD CONSTRAINT game_player_stat_game_team_id_fkey FOREIGN KEY (game_team_id) REFERENCES public.game_team(id) ON DELETE CASCADE;


--
-- Name: game_player_stat game_player_stat_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_player_stat
    ADD CONSTRAINT game_player_stat_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.player_stat_type(id);


--
-- Name: game_team_stat game_team_stat_game_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_team_stat
    ADD CONSTRAINT game_team_stat_game_team_id_fkey FOREIGN KEY (game_team_id) REFERENCES public.game_team(id) ON DELETE CASCADE;


--
-- Name: game_team_stat game_team_stat_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_team_stat
    ADD CONSTRAINT game_team_stat_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.team_stat_type(id);


--
-- Name: game game_venue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_venue_id_fkey FOREIGN KEY (venue_id) REFERENCES public.venue(id);


--
-- Name: play play_defense_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_defense_id_fkey FOREIGN KEY (defense_id) REFERENCES public.team(id);


--
-- Name: play play_drive_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_drive_id_fkey FOREIGN KEY (drive_id) REFERENCES public.drive(id) ON DELETE CASCADE;


--
-- Name: play play_offense_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_offense_id_fkey FOREIGN KEY (offense_id) REFERENCES public.team(id);


--
-- Name: play play_play_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_play_type_id_fkey FOREIGN KEY (play_type_id) REFERENCES public.play_type(id);


--
-- Name: play_stat play_stat_athlete_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_stat
    ADD CONSTRAINT play_stat_athlete_id_fkey FOREIGN KEY (athlete_id) REFERENCES public.athlete(id);


--
-- Name: play_stat play_stat_play_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_stat
    ADD CONSTRAINT play_stat_play_id_fkey FOREIGN KEY (play_id) REFERENCES public.play(id);


--
-- Name: play_stat play_stat_stat_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_stat
    ADD CONSTRAINT play_stat_stat_type_id_fkey FOREIGN KEY (stat_type_id) REFERENCES public.play_stat_type(id);


--
-- Name: game_team team_game_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_team
    ADD CONSTRAINT team_game_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.game(id) ON DELETE CASCADE;


--
-- Name: game_team team_game_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_team
    ADD CONSTRAINT team_game_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.team(id);


--
-- Name: team_talent team_talent_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_talent
    ADD CONSTRAINT team_talent_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.team(id);


--
-- PostgreSQL database dump complete
--


INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (1, 'ACC', 'Atlantic Coast Conference', 'ACC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (4, 'Big 12', 'Big 12 Conference', 'B12', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (5, 'Big Ten', 'Big Ten Conference', 'B1G', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (12, 'Conference USA', 'Conference USA', 'CUSA', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (18, 'FBS Independents', 'FBS Independents', 'Ind', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (15, 'Mid-American', 'Mid-American Conference', 'MAC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (17, 'Mountain West', 'Mountain West Conference', 'MWC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (9, 'Pac-12', 'Pac-12 Conference', 'PAC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (8, 'SEC', 'Southeastern Conference', 'SEC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (37, 'Sun Belt', 'Sun Belt Conference', 'SBC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (151, 'American Athletic', 'American Athletic Conference', 'AAC', 'American', 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (220, 'Pac-10', 'Pacific 10', 'Pac-10', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (222, 'Big East', 'Big East Conference', 'BE', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (175, 'AWC', 'ASUN-WAC Challenge', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (20, 'Big Sky', 'Big Sky Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (40, 'Big South', 'Big South Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (48, 'CAA', 'Colonial Athletic Association', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (22, 'Ivy', 'Ivy League', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (24, 'MEAC', 'Mid-Eastern Athletic Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (21, 'MVFC', 'Missouri Valley Football Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (25, 'NEC', 'Northeast Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (26, 'OVC', 'Ohio Valley Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (27, 'Patriot', 'Patriot League', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (28, 'Pioneer', 'Pioneer Football League', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (31, 'SWAC', 'Southwestern Athletic Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (29, 'Southern', 'Southern Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (30, 'Southland', 'Southland Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (114, 'American Rivers', 'American Rivers Conference', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (100, 'American Southwest', 'American Southwest', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (102, 'CCIW', 'CCIW', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (103, 'Centennial', 'Centennial', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (123, 'Commonwealth Coast', 'Commonwealth Coast Conference', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (105, 'ECFC', 'ECFC', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (106, 'Empire 8', 'Empire 8', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (111, 'Heartland', 'Heartland', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (214, 'Big 8', 'Big 8 Conference', 'Big 8', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (216, 'Pac-8', 'Pacific 8 Conference', 'Pac-8', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (202, 'Missouri Valley', 'Missouri Valley Intercollegiate Athletic Association', 'MVIAA', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (203, 'Rocky Mountain', 'Rocky Mountain Conference', 'RMC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (204, 'Southwest', 'Southwest Conference', 'SWC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (205, 'Pacific', 'Pacific Coast Conference', 'PCC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (206, 'Southern', 'Southern Conference', 'Southern', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (207, 'Big 6', 'Big 6 Conference', 'Big 6', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (208, 'Missouri Valley', 'Missouri Valley Conference', 'MVC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (223, 'Border', 'Border Intercollegiate Athletic Association', 'BIAA', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (209, 'Mountain State', 'Mountain State Athletic Conference', 'MSAC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (210, 'Big 7', 'Big 7 Conference', 'Big 7', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (211, 'Skyline', 'Skyline Conference', 'Skyline', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (113, 'Independent DIII', 'Independent DIII', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (115, 'Liberty League', 'Liberty League', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (160, 'MSCAC', 'Massachusetts State Collegiate Athletic Conference', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (117, 'Michigan', 'Michigan', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (119, 'Mid Atlantic', 'Middle Atlantic Conference', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (120, 'Midwest', 'Midwest', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (121, 'Minnesota', 'Minnesota', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (128, 'NACC', 'Northern Athletics Collegiate Conference', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (122, 'NESCAC', 'NESCAC', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (166, 'NEWMAC', 'New England Women''s and Men''s Athletic Conference', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (124, 'New Jersey', 'New Jersey', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (126, 'North Coast', 'North Coast', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (130, 'Northwest', 'Northwest', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (131, 'Ohio', 'Ohio', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (132, 'Old Dominion', 'Old Dominion', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (134, 'Presidents''', 'Presidents''', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (138, 'So. Cal.', 'So. Cal.', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (147, 'Southern Athletic', 'Southern Athletic Association', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (143, 'USA South', 'USA South', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (142, 'Upper Midwest', 'Upper Midwest', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (145, 'Wisconsin', 'Wisconsin', NULL, NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (104, 'CIAA', 'CIAA', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (107, 'GLIAC', 'GLIAC', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (146, 'Great American', 'Great American Conference', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (108, 'Great Lakes', 'Great Lakes', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (165, 'Great Midwest Athletic', 'Great Midwest Athletic Conference', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (109, 'Great Northwest', 'Great Northwest', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (110, 'Gulf South', 'Gulf South', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (112, 'Independent DII', 'Independent DII', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (116, 'Lone Star', 'Lone Star', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (118, 'Mid America', 'Mid America', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (144, 'Mountain East', 'Mountain East Conference', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (127, 'Northeast 10', 'Northeast 10', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (129, 'Northern Sun', 'Northern Sun', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (133, 'Pennsylvania State Athletic', 'Pennsylvania State Athletic Conference', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (135, 'Rocky Mountain', 'Rocky Mountain', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (136, 'SIAC', 'SIAC', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (139, 'South Atlantic', 'South Atlantic', NULL, NULL, 'ii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (212, 'Ivy', 'The Ivy League', 'Ivy', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (213, 'AAWU', 'Athletic Association of Western Universities', 'AAWU', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (215, 'Western Athletic', 'Western Athletic Conference', 'WAC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (217, 'PCAA', 'Pacific Coast Athletic Association', 'PCAA', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (218, 'Southland', 'Southland Conference', 'Southland', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (219, 'SWAC', 'Southwest Athletic Conference', 'SWAC', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (221, 'Big West', 'Big West Conference', 'BW', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (201, 'Western', 'Western Conference', 'Western', NULL, 'fbs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (176, 'Atlantic Sun', 'Atlantic Sun Conference', 'ASUN', NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (16, 'Western Athletic', 'Western Athletic Conference', 'WAC', NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (32, 'FCS Independents', 'FCS Independents', 'INDAA', NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (148, 'Southern Collegiate Athletic', 'Southern Collegiate Athletic Conference', 'SCAC', NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (141, 'University', 'University', 'UNI', NULL, 'iii');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (43, 'Great West', 'Great West Conference', 'GWEST', NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (23, 'Metro Atlantic Athletic', 'Metro Atlantic Athletic Conference', 'MAAC', NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (19, 'Atlantic 10', 'Atlantic 10 Conference', 'ATL10', NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (179, 'Big South-OVC', 'Big South-OVC Association', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (177, 'UAC', 'United Athletic Conference', NULL, NULL, 'fcs');
INSERT INTO public.conference (id, name, short_name, abbreviation, sr_name, division) VALUES (178, 'Landmark Conference', 'Landmark Conference', NULL, NULL, 'iii');

SELECT pg_catalog.setval('public.conference_id_seq', 221, false);



INSERT INTO public.drive_result (id, name) VALUES (1, 'BLOCKED PUNT TD TD');
INSERT INTO public.drive_result (id, name) VALUES (2, 'FG GOOD TD');
INSERT INTO public.drive_result (id, name) VALUES (3, 'LATERAL');
INSERT INTO public.drive_result (id, name) VALUES (4, 'FUMBLE RETURN TD');
INSERT INTO public.drive_result (id, name) VALUES (5, 'TURNOVER ON DOWNS');
INSERT INTO public.drive_result (id, name) VALUES (6, 'SF');
INSERT INTO public.drive_result (id, name) VALUES (7, 'NETRCV');
INSERT INTO public.drive_result (id, name) VALUES (8, 'TURNOVER ON DOWNS TD');
INSERT INTO public.drive_result (id, name) VALUES (9, 'BLOCKED FG');
INSERT INTO public.drive_result (id, name) VALUES (10, 'INT TD');
INSERT INTO public.drive_result (id, name) VALUES (11, 'RUSH');
INSERT INTO public.drive_result (id, name) VALUES (12, 'TD');
INSERT INTO public.drive_result (id, name) VALUES (13, 'RUSHING TD TD');
INSERT INTO public.drive_result (id, name) VALUES (14, 'BLOCKED FG (TD) TD');
INSERT INTO public.drive_result (id, name) VALUES (15, 'PUNT RETURN TD');
INSERT INTO public.drive_result (id, name) VALUES (16, 'END OF HALF');
INSERT INTO public.drive_result (id, name) VALUES (17, 'PASSING TD TD');
INSERT INTO public.drive_result (id, name) VALUES (18, 'MISSED FG TD');
INSERT INTO public.drive_result (id, name) VALUES (19, 'PASS COMPLETE');
INSERT INTO public.drive_result (id, name) VALUES (20, 'END OF GAME TD');
INSERT INTO public.drive_result (id, name) VALUES (21, 'MADE FG');
INSERT INTO public.drive_result (id, name) VALUES (22, 'FG TD');
INSERT INTO public.drive_result (id, name) VALUES (23, 'MISSED PAT RETURN');
INSERT INTO public.drive_result (id, name) VALUES (24, 'DOWNS TD');
INSERT INTO public.drive_result (id, name) VALUES (25, 'END OF GAME');
INSERT INTO public.drive_result (id, name) VALUES (26, 'END OF HALF TD');
INSERT INTO public.drive_result (id, name) VALUES (27, 'INT');
INSERT INTO public.drive_result (id, name) VALUES (28, 'KICKOFF');
INSERT INTO public.drive_result (id, name) VALUES (29, 'MISSED FG');
INSERT INTO public.drive_result (id, name) VALUES (30, 'FG');
INSERT INTO public.drive_result (id, name) VALUES (31, 'LATERAL TD');
INSERT INTO public.drive_result (id, name) VALUES (32, 'BLOCKED PUNT');
INSERT INTO public.drive_result (id, name) VALUES (33, 'POSS. ON DOWNS');
INSERT INTO public.drive_result (id, name) VALUES (34, 'INCOMPLETE');
INSERT INTO public.drive_result (id, name) VALUES (35, 'BLOCKED PUNT TD');
INSERT INTO public.drive_result (id, name) VALUES (36, 'SACK');
INSERT INTO public.drive_result (id, name) VALUES (37, 'TIMEOUT');
INSERT INTO public.drive_result (id, name) VALUES (38, 'FG MISSED TD');
INSERT INTO public.drive_result (id, name) VALUES (39, '2PT PASS FAILED');
INSERT INTO public.drive_result (id, name) VALUES (40, 'INT RETURN TOUCH');
INSERT INTO public.drive_result (id, name) VALUES (41, 'POSSESSION (FOR OT DRIVES)');
INSERT INTO public.drive_result (id, name) VALUES (42, 'PUNT TD');
INSERT INTO public.drive_result (id, name) VALUES (43, 'KICK RETURN TD');
INSERT INTO public.drive_result (id, name) VALUES (44, 'KICKOFF RETURN TD');
INSERT INTO public.drive_result (id, name) VALUES (45, 'MISSED FG (TD) TD');
INSERT INTO public.drive_result (id, name) VALUES (46, 'FUMBLE TD');
INSERT INTO public.drive_result (id, name) VALUES (47, 'BLOCKED FG (TD)');
INSERT INTO public.drive_result (id, name) VALUES (48, 'PUNT');
INSERT INTO public.drive_result (id, name) VALUES (49, 'PASSING TD');
INSERT INTO public.drive_result (id, name) VALUES (50, 'PENALTY');
INSERT INTO public.drive_result (id, name) VALUES (51, 'FG GOOD');
INSERT INTO public.drive_result (id, name) VALUES (52, 'FUMBLE');
INSERT INTO public.drive_result (id, name) VALUES (53, 'FG MISSED');
INSERT INTO public.drive_result (id, name) VALUES (54, 'PUNT RETURN TD TD');
INSERT INTO public.drive_result (id, name) VALUES (55, 'DOWNS');
INSERT INTO public.drive_result (id, name) VALUES (56, 'RUSHING TD');
INSERT INTO public.drive_result (id, name) VALUES (57, 'POSSESSION (FOR OT DRIVES) TD');
INSERT INTO public.drive_result (id, name) VALUES (58, 'Uncategorized');
INSERT INTO public.drive_result (id, name) VALUES (59, 'END OF 4TH QUARTER');

SELECT pg_catalog.setval('public.drive_result_id_seq', 59, true);


INSERT INTO public.lines_provider (id, name) VALUES (1004, 'consensus');
INSERT INTO public.lines_provider (id, name) VALUES (38, 'Caesars');
INSERT INTO public.lines_provider (id, name) VALUES (1003, 'numberfire');
INSERT INTO public.lines_provider (id, name) VALUES (1002, 'teamrankings');
INSERT INTO public.lines_provider (id, name) VALUES (999999, 'Bovada');
INSERT INTO public.lines_provider (id, name) VALUES (41, 'SugarHouse');
INSERT INTO public.lines_provider (id, name) VALUES (45, 'William Hill (New Jersey)');
INSERT INTO public.lines_provider (id, name) VALUES (43, 'Caesars (Pennsylvania)');
INSERT INTO public.lines_provider (id, name) VALUES (52, 'Caesars Sportsbook (Colorado)');
INSERT INTO public.lines_provider (id, name) VALUES (888888, 'DraftKings');

INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (1, 'Incompletion', 'Inc');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (2, 'Target', NULL);
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (3, 'Pass Breakup', 'PBI');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (4, 'Completion', 'Comp');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (5, 'Reception', 'Rec');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (6, 'Tackle', 'T');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (7, 'Rush', 'Rush');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (8, 'Fumble', 'Fum');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (9, 'Fumble Forced', 'FF');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (10, 'Fumble Recovered', 'FR');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (11, 'Sack Taken', NULL);
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (12, 'Sack', NULL);
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (13, 'Kickoff', 'KO');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (14, 'Onside Kick', NULL);
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (15, 'Kickoff Return', 'KR');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (16, 'Punt', 'P');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (17, 'Punt Block', NULL);
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (18, 'FG Attempt Blocked', NULL);
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (19, 'Field Goal Block', NULL);
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (20, 'Interception Thrown', 'INT');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (21, 'Interception', 'INT');
INSERT INTO public.play_stat_type (id, name, abbreviation) VALUES (22, 'Touchdown', 'TD');


SELECT pg_catalog.setval('public.play_stat_type_id_seq', 21, true);


INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (5, 'Rush', 'RUSH', 1);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (24, 'Pass Reception', 'REC', 2);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (3, 'Pass Incompletion', NULL, 3);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (53, 'Kickoff', 'K', 4);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (52, 'Punt', 'PUNT', 5);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (8, 'Penalty', 'PEN', 6);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (21, 'Timeout', 'TO', 7);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (7, 'Sack', NULL, 8);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (68, 'Rushing Touchdown', 'TD', 9);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (67, 'Passing Touchdown', 'TD', 10);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (2, 'End Period', 'EP', 11);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (59, 'Field Goal Good', 'FG', 12);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (26, 'Pass Interception Return', 'INTR', 13);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (65, 'End of Half', 'EH', 14);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (9, 'Fumble Recovery (Own)', NULL, 15);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (29, 'Fumble Recovery (Opponent)', NULL, 16);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (60, 'Field Goal Missed', 'FGM', 17);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (12, 'Kickoff Return (Offense)', NULL, 18);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (36, 'Interception Return Touchdown', 'TD', 19);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (18, 'Blocked Field Goal', 'BFG', 20);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (17, 'Blocked Punt', 'BP', 21);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (20, 'Safety', 'SF', 22);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (32, 'Kickoff Return Touchdown', 'TD', 23);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (39, 'Fumble Return Touchdown', 'TD', 24);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (999, 'Uncategorized', NULL, 25);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (57, 'Defensive 2pt Conversion', 'D2P', 26);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (37, 'Blocked Punt Touchdown', NULL, 27);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (40, 'Missed Field Goal Return', 'AFG', 28);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (34, 'Punt Return Touchdown', 'TD', 29);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (70, 'placeholder', 'pla', 30);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (41, 'Missed Field Goal Return Touchdown', NULL, 31);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (16, 'Two Point Rush', NULL, 32);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (66, 'End of Game', 'EG', 33);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (63, 'Interception', 'INT', 34);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (38, 'Blocked Field Goal Touchdown', NULL, 35);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (51, 'Pass', 'PASS', 36);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (56, '2pt Conversion', '2P', 37);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (61, 'Extra Point Good', 'XP', 38);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (62, 'Extra Point Missed', 'EPM', 39);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (4, 'Pass Completion', 'PASS', 40);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (6, 'Pass Interception', 'INT', 41);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (78, 'Offensive 1pt Safety', 'SF', 42);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (43, 'Blocked PAT', NULL, 43);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (13, 'Kickoff Return (Defense)', NULL, 44);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (14, 'Punt Return', NULL, 45);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (15, 'Two Point Pass', NULL, 46);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (79, 'End of Regulation', 'ER', 79);
INSERT INTO public.play_type (id, text, abbreviation, sequence) VALUES (800, 'Start of Period', NULL, 80);



INSERT INTO public.player_stat_category (id, name) VALUES (1, 'rushing');
INSERT INTO public.player_stat_category (id, name) VALUES (2, 'kicking');
INSERT INTO public.player_stat_category (id, name) VALUES (3, 'punting');
INSERT INTO public.player_stat_category (id, name) VALUES (4, 'kickReturns');
INSERT INTO public.player_stat_category (id, name) VALUES (5, 'puntReturns');
INSERT INTO public.player_stat_category (id, name) VALUES (6, 'interceptions');
INSERT INTO public.player_stat_category (id, name) VALUES (7, 'defensive');
INSERT INTO public.player_stat_category (id, name) VALUES (8, 'receiving');
INSERT INTO public.player_stat_category (id, name) VALUES (9, 'passing');
INSERT INTO public.player_stat_category (id, name) VALUES (10, 'fumbles');


SELECT pg_catalog.setval('public.player_stat_category_id_seq', 10, true);



INSERT INTO public.player_stat_type (id, name) VALUES (1, 'PD');
INSERT INTO public.player_stat_type (id, name) VALUES (2, 'FG');
INSERT INTO public.player_stat_type (id, name) VALUES (3, 'C/ATT');
INSERT INTO public.player_stat_type (id, name) VALUES (4, 'FUM');
INSERT INTO public.player_stat_type (id, name) VALUES (5, 'PTS');
INSERT INTO public.player_stat_type (id, name) VALUES (6, 'TB');
INSERT INTO public.player_stat_type (id, name) VALUES (7, 'PCT');
INSERT INTO public.player_stat_type (id, name) VALUES (8, 'YDS');
INSERT INTO public.player_stat_type (id, name) VALUES (9, 'REC');
INSERT INTO public.player_stat_type (id, name) VALUES (10, 'XP');
INSERT INTO public.player_stat_type (id, name) VALUES (11, 'CAR');
INSERT INTO public.player_stat_type (id, name) VALUES (12, 'SOLO');
INSERT INTO public.player_stat_type (id, name) VALUES (13, 'QB HUR');
INSERT INTO public.player_stat_type (id, name) VALUES (14, 'NO');
INSERT INTO public.player_stat_type (id, name) VALUES (15, 'LONG');
INSERT INTO public.player_stat_type (id, name) VALUES (16, 'TFL');
INSERT INTO public.player_stat_type (id, name) VALUES (17, 'QBR');
INSERT INTO public.player_stat_type (id, name) VALUES (18, 'INT');
INSERT INTO public.player_stat_type (id, name) VALUES (19, 'SACKS');
INSERT INTO public.player_stat_type (id, name) VALUES (20, 'LOST');
INSERT INTO public.player_stat_type (id, name) VALUES (21, 'In 20');
INSERT INTO public.player_stat_type (id, name) VALUES (22, 'TD');
INSERT INTO public.player_stat_type (id, name) VALUES (23, 'TOT');
INSERT INTO public.player_stat_type (id, name) VALUES (24, 'AVG');


SELECT pg_catalog.setval('public.player_stat_type_id_seq', 24, true);




INSERT INTO public.poll_type (id, name, short_name, abbreviation) VALUES (3, 'BCS Standings', 'BCS Standings', NULL);
INSERT INTO public.poll_type (id, name, short_name, abbreviation) VALUES (1, 'AP Top 25', 'AP Poll', NULL);
INSERT INTO public.poll_type (id, name, short_name, abbreviation) VALUES (2, 'Coaches Poll', 'Coaches Poll', NULL);
INSERT INTO public.poll_type (id, name, short_name, abbreviation) VALUES (4, 'NCAA College Football Power Rankings', 'Power Rankings', NULL);
INSERT INTO public.poll_type (id, name, short_name, abbreviation) VALUES (11, 'AFCA Division II Coaches Poll', 'AFCA Div II', NULL);
INSERT INTO public.poll_type (id, name, short_name, abbreviation) VALUES (12, 'AFCA Division III Coaches Poll', 'AFCA Div III', NULL);
INSERT INTO public.poll_type (id, name, short_name, abbreviation) VALUES (21, 'Playoff Committee Rankings', 'CFP Rankings', NULL);
INSERT INTO public.poll_type (id, name, short_name, abbreviation) VALUES (20, 'FCS Coaches Poll', 'FCS Coaches Poll', NULL);



INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (1, 'Wide Receiver', 'Wide Receiver', 'WR');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (4, 'Center', 'Center', 'C');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (7, 'Tight End', 'Tight End', 'TE');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (8, 'Quarterback', 'Quarterback', 'QB');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (9, 'Running Back', 'Running Back', 'RB');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (10, 'Fullback', 'Fullback', 'FB');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (12, 'Nose Tackle', 'Nose Tackle', 'NT');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (22, 'Place kicker', 'Place kicker', 'PK');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (23, 'Punter', 'Punter', 'P');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (29, 'Cornerback', 'Cornerback', 'CB');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (30, 'Linebacker', 'Linebacker', 'LB');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (31, 'Defensive End', 'Defensive End', 'DE');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (32, 'Defensive Tackle', 'Defensive Tackle', 'DT');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (35, 'Defensive Back', 'Defensive Back', 'DB');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (36, 'Safety', 'Safety', 'S');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (37, 'Defensive Lineman', 'Defensive Lineman', 'DL');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (39, 'Long Snapper', 'Long Snapper', 'LS');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (45, 'Offensive Lineman', 'Offensive Lineman', 'OL');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (46, 'Offensive Tackle', 'Offensive Tackle', 'OT');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (73, 'Guard', 'Guard', 'G');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (99, 'Unknown', 'Unknown', '?');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (78, 'Long Snapper', 'Long Snapper', 'LS');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (200, 'Inside Linebacker', 'Inside Linebacker', 'ILB');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (201, 'Outside Linebacker', 'Outside Linebacker', 'OLB');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (50, 'Athlete', 'Athlete', 'ATH');
INSERT INTO public."position" (id, name, display_name, abbreviation) VALUES (76, 'Punt Returner', 'Punt Returner', 'PR');



INSERT INTO public.recruit_position (id, "position", position_group) VALUES (3, 'PRO', 'Quarterback');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (18, 'DUAL', 'Quarterback');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (6, 'RB', 'Running Back');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (17, 'FB', 'Running Back');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (19, 'APB', 'Running Back');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (4, 'WR', 'Receiver');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (15, 'TE', 'Receiver');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (7, 'OT', 'Offensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (13, 'OC', 'Offensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (14, 'OG', 'Offensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (5, 'SDE', 'Defensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (9, 'WDE', 'Defensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (12, 'DT', 'Defensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (2, 'ILB', 'Linebacker');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (11, 'OLB', 'Linebacker');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (8, 'CB', 'Defensive Back');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (10, 'S', 'Defensive Back');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (16, 'ATH', 'Special Teams');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (20, 'K', 'Special Teams');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (21, 'P', 'Special Teams');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (22, 'LS', 'Special Teams');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (23, 'SF', 'Special Teams');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (24, 'RET', 'Special Teams');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (25, 'EDGE', 'Defensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (26, 'DL', 'Defensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (27, 'IOL', 'Offensive Line');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (28, 'QB', 'Quarterback');
INSERT INTO public.recruit_position (id, "position", position_group) VALUES (29, 'LB', 'Linebacker');


SELECT pg_catalog.setval('public.recruit_position_id_seq', 29, true);



INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (1, 'yardsPerPass', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (2, 'rushingYards', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (3, 'netPassingYards', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (4, 'totalYards', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (5, 'completionAttempts', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (6, 'totalPenaltiesYards', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (7, 'firstDowns', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (8, 'possessionTime', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (9, 'yardsPerRushAttempt', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (10, 'turnovers', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (11, 'rushingAttempts', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (12, 'fumblesLost', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (13, 'interceptions', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (14, 'thirdDownEff', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (15, 'fourthDownEff', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (16, 'passesDeflected', 7, 1);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (17, 'qbHurries', 7, 13);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (18, 'sacks', 7, 19);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (19, 'tackles', 7, 12);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (20, 'defensiveTDs', 7, 22);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (21, 'tacklesForLoss', 7, 16);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (22, 'totalFumbles', 10, 4);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (23, 'fumblesRecovered', 10, 9);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (24, 'passesIntercepted', 6, 18);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (25, 'interceptionTDs', 6, 22);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (26, 'interceptionYards', 6, 8);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (29, 'kickingPoints', 2, 5);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (31, 'kickReturns', 4, 14);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (32, 'kickReturnTDs', 4, 22);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (33, 'kickReturnYards', 4, 8);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (34, 'passingTDs', 9, 22);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (35, 'puntReturns', 5, 14);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (36, 'puntReturnTDs', 5, 22);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (37, 'puntReturnYards', 5, 8);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (38, 'rushingTDs', 1, 22);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (27, 'fieldGoals', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (28, 'fieldGoalPct', NULL, NULL);
INSERT INTO public.team_stat_type (id, name, player_category_mapping_id, player_type_mapping_id) VALUES (30, 'extraPoints', NULL, NULL);



SELECT pg_catalog.setval('public.team_stat_type_id_seq', 38, true);



INSERT INTO public.weather_condition (id, description) VALUES (1, 'Clear');
INSERT INTO public.weather_condition (id, description) VALUES (2, 'Fair');
INSERT INTO public.weather_condition (id, description) VALUES (3, 'Cloudy');
INSERT INTO public.weather_condition (id, description) VALUES (4, 'Overcast');
INSERT INTO public.weather_condition (id, description) VALUES (5, 'Fog');
INSERT INTO public.weather_condition (id, description) VALUES (6, 'Freezing Fog');
INSERT INTO public.weather_condition (id, description) VALUES (7, 'Light Rain');
INSERT INTO public.weather_condition (id, description) VALUES (8, 'Rain');
INSERT INTO public.weather_condition (id, description) VALUES (9, 'Heavy Rain');
INSERT INTO public.weather_condition (id, description) VALUES (10, 'Freezing Rain');
INSERT INTO public.weather_condition (id, description) VALUES (11, 'Heavy Freezing Rain');
INSERT INTO public.weather_condition (id, description) VALUES (12, 'Sleet');
INSERT INTO public.weather_condition (id, description) VALUES (13, 'Heavy Sleet');
INSERT INTO public.weather_condition (id, description) VALUES (14, 'Light Snowfall');
INSERT INTO public.weather_condition (id, description) VALUES (15, 'Snowfall');
INSERT INTO public.weather_condition (id, description) VALUES (16, 'Heavy Snowfall');
INSERT INTO public.weather_condition (id, description) VALUES (17, 'Rain Shower');
INSERT INTO public.weather_condition (id, description) VALUES (18, 'Heavy Rain Shower');
INSERT INTO public.weather_condition (id, description) VALUES (19, 'Sleet Shower');
INSERT INTO public.weather_condition (id, description) VALUES (20, 'Heavy Sleet Shower');
INSERT INTO public.weather_condition (id, description) VALUES (21, 'Snow Shower');
INSERT INTO public.weather_condition (id, description) VALUES (22, 'Heavy Snow Shower');
INSERT INTO public.weather_condition (id, description) VALUES (23, 'Lightning');
INSERT INTO public.weather_condition (id, description) VALUES (24, 'Hail');
INSERT INTO public.weather_condition (id, description) VALUES (25, 'Thunderstorm');
INSERT INTO public.weather_condition (id, description) VALUES (26, 'Heavy Thunderstorm');
INSERT INTO public.weather_condition (id, description) VALUES (27, 'Storm');
