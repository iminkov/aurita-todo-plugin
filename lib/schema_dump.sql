--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: todo_asset; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_asset (
    todo_asset_id integer NOT NULL,
    asset_id integer NOT NULL,
    name character varying(255),
    comment text,
    concrete_model character varying(100)
);


ALTER TABLE public.todo_asset OWNER TO paracelsus;

--
-- Name: todo_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_asset_id_seq OWNER TO paracelsus;

--
-- Name: todo_basic_asset; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_basic_asset (
    todo_basic_asset_id integer NOT NULL,
    todo_asset_id integer NOT NULL
);


ALTER TABLE public.todo_basic_asset OWNER TO paracelsus;

--
-- Name: todo_basic_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_basic_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_basic_asset_id_seq OWNER TO paracelsus;

--
-- Name: todo_calculation_asset; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_calculation_asset (
    todo_calculation_asset_id integer NOT NULL,
    todo_asset_id integer NOT NULL
);


ALTER TABLE public.todo_calculation_asset OWNER TO paracelsus;

--
-- Name: todo_calculation_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_calculation_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_calculation_asset_id_seq OWNER TO paracelsus;

--
-- Name: todo_calculation_entry; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_calculation_entry (
    todo_calculation_entry_id integer NOT NULL,
    cost numeric DEFAULT 0.0 NOT NULL,
    todo_entry_id integer NOT NULL
);


ALTER TABLE public.todo_calculation_entry OWNER TO paracelsus;

--
-- Name: todo_calculation_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_calculation_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_calculation_entry_id_seq OWNER TO paracelsus;

--
-- Name: todo_container_asset; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_container_asset (
    todo_container_asset_id integer NOT NULL,
    todo_asset_id integer NOT NULL
);


ALTER TABLE public.todo_container_asset OWNER TO paracelsus;

--
-- Name: todo_container_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_container_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_container_asset_id_seq OWNER TO paracelsus;

--
-- Name: todo_container_entry; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_container_entry (
    todo_container_entry_id integer NOT NULL,
    todo_entry_id integer NOT NULL,
    article_id integer NOT NULL
);


ALTER TABLE public.todo_container_entry OWNER TO paracelsus;

--
-- Name: todo_container_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_container_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_container_entry_id_seq OWNER TO paracelsus;

--
-- Name: todo_entry; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_entry (
    todo_entry_id integer NOT NULL,
    todo_asset_id integer NOT NULL,
    title character varying(500),
    done boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    priority integer DEFAULT 1 NOT NULL,
    user_group_id integer NOT NULL,
    description text,
    duration_days integer DEFAULT 0,
    duration_hours integer DEFAULT 0,
    deadline date,
    percent_done integer DEFAULT 0
);


ALTER TABLE public.todo_entry OWNER TO paracelsus;

--
-- Name: todo_entry_history; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_entry_history (
    todo_entry_history_id integer NOT NULL,
    todo_entry_id integer NOT NULL,
    user_group_id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    action character varying(20),
    diff text
);


ALTER TABLE public.todo_entry_history OWNER TO paracelsus;

--
-- Name: todo_entry_history_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_entry_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_entry_history_id_seq OWNER TO paracelsus;

--
-- Name: todo_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_entry_id_seq OWNER TO paracelsus;

--
-- Name: todo_entry_user; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_entry_user (
    todo_entry_user_id integer NOT NULL,
    todo_entry_id integer NOT NULL,
    user_group_id integer NOT NULL
);


ALTER TABLE public.todo_entry_user OWNER TO paracelsus;

--
-- Name: todo_entry_user_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_entry_user_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_entry_user_id_seq OWNER TO paracelsus;

--
-- Name: todo_time_calc_asset; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_time_calc_asset (
    todo_time_calc_asset_id integer NOT NULL,
    todo_asset_id integer NOT NULL
);


ALTER TABLE public.todo_time_calc_asset OWNER TO paracelsus;

--
-- Name: todo_time_calc_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_time_calc_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_time_calc_asset_id_seq OWNER TO paracelsus;

--
-- Name: todo_time_calc_entry; Type: TABLE; Schema: public; Owner: paracelsus; Tablespace: 
--

CREATE TABLE todo_time_calc_entry (
    todo_time_calc_entry_id integer NOT NULL,
    unit_cost numeric DEFAULT 0 NOT NULL,
    todo_entry_id integer NOT NULL
);


ALTER TABLE public.todo_time_calc_entry OWNER TO paracelsus;

--
-- Name: todo_time_calc_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: paracelsus
--

CREATE SEQUENCE todo_time_calc_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_time_calc_entry_id_seq OWNER TO paracelsus;

--
-- Name: todo_asset; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_asset FROM paracelsus;
GRANT ALL ON TABLE todo_asset TO paracelsus;
GRANT ALL ON TABLE todo_asset TO cuba;


--
-- Name: todo_asset_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_asset_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_asset_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_asset_id_seq TO cuba;


--
-- Name: todo_basic_asset; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_basic_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_basic_asset FROM paracelsus;
GRANT ALL ON TABLE todo_basic_asset TO paracelsus;
GRANT ALL ON TABLE todo_basic_asset TO cuba;


--
-- Name: todo_basic_asset_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_basic_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_basic_asset_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_basic_asset_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_basic_asset_id_seq TO cuba;


--
-- Name: todo_calculation_asset; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_calculation_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_calculation_asset FROM paracelsus;
GRANT ALL ON TABLE todo_calculation_asset TO paracelsus;
GRANT ALL ON TABLE todo_calculation_asset TO cuba;


--
-- Name: todo_calculation_asset_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_calculation_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_calculation_asset_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_calculation_asset_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_calculation_asset_id_seq TO cuba;


--
-- Name: todo_calculation_entry; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_calculation_entry FROM PUBLIC;
REVOKE ALL ON TABLE todo_calculation_entry FROM paracelsus;
GRANT ALL ON TABLE todo_calculation_entry TO paracelsus;
GRANT ALL ON TABLE todo_calculation_entry TO cuba;


--
-- Name: todo_calculation_entry_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_calculation_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_calculation_entry_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_calculation_entry_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_calculation_entry_id_seq TO cuba;


--
-- Name: todo_container_asset; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_container_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_container_asset FROM paracelsus;
GRANT ALL ON TABLE todo_container_asset TO paracelsus;
GRANT ALL ON TABLE todo_container_asset TO cuba;


--
-- Name: todo_container_asset_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_container_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_container_asset_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_container_asset_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_container_asset_id_seq TO cuba;


--
-- Name: todo_container_entry; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_container_entry FROM PUBLIC;
REVOKE ALL ON TABLE todo_container_entry FROM paracelsus;
GRANT ALL ON TABLE todo_container_entry TO paracelsus;
GRANT ALL ON TABLE todo_container_entry TO cuba;


--
-- Name: todo_container_entry_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_container_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_container_entry_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_container_entry_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_container_entry_id_seq TO cuba;


--
-- Name: todo_entry; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_entry FROM PUBLIC;
REVOKE ALL ON TABLE todo_entry FROM paracelsus;
GRANT ALL ON TABLE todo_entry TO paracelsus;
GRANT ALL ON TABLE todo_entry TO cuba;


--
-- Name: todo_entry_history; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_entry_history FROM PUBLIC;
REVOKE ALL ON TABLE todo_entry_history FROM paracelsus;
GRANT ALL ON TABLE todo_entry_history TO paracelsus;
GRANT ALL ON TABLE todo_entry_history TO cuba;


--
-- Name: todo_entry_history_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_entry_history_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_entry_history_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_entry_history_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_entry_history_id_seq TO cuba;


--
-- Name: todo_entry_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_entry_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_entry_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_entry_id_seq TO cuba;


--
-- Name: todo_entry_user; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_entry_user FROM PUBLIC;
REVOKE ALL ON TABLE todo_entry_user FROM paracelsus;
GRANT ALL ON TABLE todo_entry_user TO paracelsus;
GRANT ALL ON TABLE todo_entry_user TO cuba;


--
-- Name: todo_entry_user_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_entry_user_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_entry_user_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_entry_user_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_entry_user_id_seq TO cuba;


--
-- Name: todo_time_calc_asset; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_time_calc_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_time_calc_asset FROM paracelsus;
GRANT ALL ON TABLE todo_time_calc_asset TO paracelsus;
GRANT ALL ON TABLE todo_time_calc_asset TO cuba;


--
-- Name: todo_time_calc_asset_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_time_calc_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_time_calc_asset_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_time_calc_asset_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_time_calc_asset_id_seq TO cuba;


--
-- Name: todo_time_calc_entry; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON TABLE todo_time_calc_entry FROM PUBLIC;
REVOKE ALL ON TABLE todo_time_calc_entry FROM paracelsus;
GRANT ALL ON TABLE todo_time_calc_entry TO paracelsus;
GRANT ALL ON TABLE todo_time_calc_entry TO cuba;


--
-- Name: todo_time_calc_entry_id_seq; Type: ACL; Schema: public; Owner: paracelsus
--

REVOKE ALL ON SEQUENCE todo_time_calc_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_time_calc_entry_id_seq FROM paracelsus;
GRANT ALL ON SEQUENCE todo_time_calc_entry_id_seq TO paracelsus;
GRANT ALL ON SEQUENCE todo_time_calc_entry_id_seq TO cuba;


--
-- PostgreSQL database dump complete
--

