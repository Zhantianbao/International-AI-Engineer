--
-- PostgreSQL database dump
--

\restrict q8H6alJb5Q7s3897zrCqHqaSBmxw2G5HkgrHtf0P04DTlceTklu7NUbg0HeM4S4

-- Dumped from database version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applications (
    application_id integer NOT NULL,
    position_id integer NOT NULL,
    status character varying(20) DEFAULT 'planned'::character varying NOT NULL,
    applied_at date,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_applications_applied_at CHECK ((((status)::text = 'planned'::text) OR (applied_at IS NOT NULL))),
    CONSTRAINT ck_applications_status CHECK (((status)::text = ANY ((ARRAY['planned'::character varying, 'applied'::character varying, 'interview'::character varying, 'offer'::character varying, 'rejected'::character varying, 'withdrawn'::character varying])::text[]))),
    CONSTRAINT ck_applications_updated_at CHECK ((updated_at >= created_at))
);


ALTER TABLE public.applications OWNER TO postgres;

--
-- Name: applications_application_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applications ALTER COLUMN application_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.applications_application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    company_id integer NOT NULL,
    name character varying(150) NOT NULL,
    country character varying(100) NOT NULL,
    website_url text,
    is_remote_friendly boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_companies_country_not_blank CHECK ((btrim((country)::text) <> ''::text)),
    CONSTRAINT ck_companies_name_not_blank CHECK ((btrim((name)::text) <> ''::text)),
    CONSTRAINT ck_companies_website_url CHECK (((website_url IS NULL) OR (website_url ~ '^https?://'::text)))
);


ALTER TABLE public.companies OWNER TO postgres;

--
-- Name: companies_company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.companies ALTER COLUMN company_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.companies_company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: position_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.position_skills (
    position_id integer NOT NULL,
    skill_id integer NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.position_skills OWNER TO postgres;

--
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    position_id integer NOT NULL,
    company_id integer NOT NULL,
    title character varying(200) NOT NULL,
    location character varying(150),
    remote_type character varying(20) DEFAULT 'onsite'::character varying NOT NULL,
    employment_type character varying(30) DEFAULT 'internship'::character varying NOT NULL,
    job_url text,
    description text,
    posted_at date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_positions_employment_type CHECK (((employment_type)::text = ANY ((ARRAY['internship'::character varying, 'part_time'::character varying, 'full_time'::character varying, 'contract'::character varying])::text[]))),
    CONSTRAINT ck_positions_job_url CHECK (((job_url IS NULL) OR (job_url ~ '^https?://'::text))),
    CONSTRAINT ck_positions_remote_type CHECK (((remote_type)::text = ANY ((ARRAY['onsite'::character varying, 'hybrid'::character varying, 'remote'::character varying])::text[]))),
    CONSTRAINT ck_positions_title_not_blank CHECK ((btrim((title)::text) <> ''::text))
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- Name: positions_position_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.positions ALTER COLUMN position_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.positions_position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skills (
    skill_id integer NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(30) DEFAULT 'other'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_skills_category CHECK (((category)::text = ANY ((ARRAY['programming_language'::character varying, 'framework'::character varying, 'database'::character varying, 'ai_ml'::character varying, 'cloud'::character varying, 'devops'::character varying, 'tool'::character varying, 'other'::character varying])::text[]))),
    CONSTRAINT ck_skills_name_not_blank CHECK ((btrim((name)::text) <> ''::text))
);


ALTER TABLE public.skills OWNER TO postgres;

--
-- Name: skills_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.skills ALTER COLUMN skill_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.skills_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applications (application_id, position_id, status, applied_at, notes, created_at, updated_at) FROM stdin;
1	1	applied	2026-07-24	Application submitted through the company website.	2026-07-25 01:44:29.903449+08	2026-07-25 01:44:29.903449+08
2	3	planned	\N	Review the job requirements before applying.	2026-07-25 01:44:29.903449+08	2026-07-25 01:44:29.903449+08
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companies (company_id, name, country, website_url, is_remote_friendly, created_at) FROM stdin;
1	OpenAI	United States	https://openai.com	t	2026-07-25 01:44:29.903449+08
2	DeepSeek	China	https://www.deepseek.com	t	2026-07-25 01:44:29.903449+08
3	Canonical	United Kingdom	https://canonical.com	t	2026-07-25 01:44:29.903449+08
\.


--
-- Data for Name: position_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.position_skills (position_id, skill_id, is_required, created_at) FROM stdin;
3	1	t	2026-07-25 01:44:29.903449+08
2	1	t	2026-07-25 01:44:29.903449+08
1	1	t	2026-07-25 01:44:29.903449+08
2	2	t	2026-07-25 01:44:29.903449+08
1	2	f	2026-07-25 01:44:29.903449+08
2	3	t	2026-07-25 01:44:29.903449+08
3	4	t	2026-07-25 01:44:29.903449+08
3	5	f	2026-07-25 01:44:29.903449+08
1	6	t	2026-07-25 01:44:29.903449+08
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.positions (position_id, company_id, title, location, remote_type, employment_type, job_url, description, posted_at, created_at) FROM stdin;
1	1	AI Engineer Intern	San Francisco	hybrid	internship	https://example.com/jobs/openai-ai-intern	Build and evaluate AI applications.	2026-07-20	2026-07-25 01:44:29.903449+08
2	2	Backend Engineer Intern	Beijing	onsite	internship	https://example.com/jobs/deepseek-backend-intern	Develop backend services for AI products.	2026-07-21	2026-07-25 01:44:29.903449+08
3	3	Python Developer Intern	Remote	remote	internship	https://example.com/jobs/canonical-python-intern	Develop Python services in a distributed team.	2026-07-22	2026-07-25 01:44:29.903449+08
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skills (skill_id, name, category, created_at) FROM stdin;
1	Python	programming_language	2026-07-25 01:44:29.903449+08
2	PostgreSQL	database	2026-07-25 01:44:29.903449+08
3	FastAPI	framework	2026-07-25 01:44:29.903449+08
4	Git	tool	2026-07-25 01:44:29.903449+08
5	Docker	devops	2026-07-25 01:44:29.903449+08
6	Machine Learning	ai_ml	2026-07-25 01:44:29.903449+08
\.


--
-- Name: applications_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applications_application_id_seq', 2, true);


--
-- Name: companies_company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.companies_company_id_seq', 6, true);


--
-- Name: positions_position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.positions_position_id_seq', 100004, true);


--
-- Name: skills_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skills_skill_id_seq', 6, true);


--
-- Name: applications pk_applications; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT pk_applications PRIMARY KEY (application_id);


--
-- Name: companies pk_companies; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT pk_companies PRIMARY KEY (company_id);


--
-- Name: position_skills pk_position_skills; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.position_skills
    ADD CONSTRAINT pk_position_skills PRIMARY KEY (position_id, skill_id);


--
-- Name: positions pk_positions; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT pk_positions PRIMARY KEY (position_id);


--
-- Name: skills pk_skills; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT pk_skills PRIMARY KEY (skill_id);


--
-- Name: applications uq_applications_position; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT uq_applications_position UNIQUE (position_id);


--
-- Name: companies uq_companies_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT uq_companies_name UNIQUE (name);


--
-- Name: positions uq_positions_job_url; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT uq_positions_job_url UNIQUE (job_url);


--
-- Name: skills uq_skills_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT uq_skills_name UNIQUE (name);


--
-- Name: applications fk_applications_position; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT fk_applications_position FOREIGN KEY (position_id) REFERENCES public.positions(position_id) ON DELETE CASCADE;


--
-- Name: position_skills fk_position_skills_position; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.position_skills
    ADD CONSTRAINT fk_position_skills_position FOREIGN KEY (position_id) REFERENCES public.positions(position_id) ON DELETE CASCADE;


--
-- Name: position_skills fk_position_skills_skill; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.position_skills
    ADD CONSTRAINT fk_position_skills_skill FOREIGN KEY (skill_id) REFERENCES public.skills(skill_id) ON DELETE CASCADE;


--
-- Name: positions fk_positions_company; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT fk_positions_company FOREIGN KEY (company_id) REFERENCES public.companies(company_id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict q8H6alJb5Q7s3897zrCqHqaSBmxw2G5HkgrHtf0P04DTlceTklu7NUbg0HeM4S4

