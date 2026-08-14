--
-- PostgreSQL database dump
--

\restrict eQghjaPIDMjzG8pkCYf5cAow6udQaEffanMa6DdH94jaDWLlfaeK2EwPnSvD9t3

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academic_years; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.academic_years (
    id bigint NOT NULL,
    year character varying(255) NOT NULL,
    semester character varying(255) NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT academic_years_semester_check CHECK (((semester)::text = ANY ((ARRAY['Odd'::character varying, 'Even'::character varying])::text[])))
);


ALTER TABLE public.academic_years OWNER TO postgres;

--
-- Name: academic_years_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.academic_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.academic_years_id_seq OWNER TO postgres;

--
-- Name: academic_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.academic_years_id_seq OWNED BY public.academic_years.id;


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendances (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    academic_year_id bigint NOT NULL,
    created_by bigint NOT NULL,
    date date NOT NULL,
    status character varying(255) NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT attendances_status_check CHECK (((status)::text = ANY ((ARRAY['Hadir'::character varying, 'Sakit'::character varying, 'Izin'::character varying, 'Alfa'::character varying])::text[])))
);


ALTER TABLE public.attendances OWNER TO postgres;

--
-- Name: attendances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendances_id_seq OWNER TO postgres;

--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- Name: classrooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classrooms (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    grade character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT classrooms_grade_check CHECK (((grade)::text = ANY ((ARRAY['10'::character varying, '11'::character varying, '12'::character varying])::text[])))
);


ALTER TABLE public.classrooms OWNER TO postgres;

--
-- Name: classrooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classrooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.classrooms_id_seq OWNER TO postgres;

--
-- Name: classrooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classrooms_id_seq OWNED BY public.classrooms.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name text NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    id bigint NOT NULL,
    nisn character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    classroom_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_id_seq OWNER TO postgres;

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    classroom_id bigint,
    role character varying(255) DEFAULT 'guru'::character varying NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    kelas character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: violations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.violations (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    academic_year_id bigint NOT NULL,
    created_by bigint NOT NULL,
    date date NOT NULL,
    type character varying(255) NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.violations OWNER TO postgres;

--
-- Name: violations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.violations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.violations_id_seq OWNER TO postgres;

--
-- Name: violations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.violations_id_seq OWNED BY public.violations.id;


--
-- Name: academic_years id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academic_years ALTER COLUMN id SET DEFAULT nextval('public.academic_years_id_seq'::regclass);


--
-- Name: attendances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);


--
-- Name: classrooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classrooms ALTER COLUMN id SET DEFAULT nextval('public.classrooms_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: violations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations ALTER COLUMN id SET DEFAULT nextval('public.violations_id_seq'::regclass);


--
-- Data for Name: academic_years; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.academic_years (id, year, semester, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: attendances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendances (id, student_id, academic_year_id, created_by, date, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: classrooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classrooms (id, name, grade, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2026_07_22_012756_add_role_to_users_table	1
5	2026_07_22_031048_add_role_to_users_table	1
6	2026_07_22_040824_create_personal_access_tokens_table	2
7	2026_07_23_004150_add_status_and_kelas_to_users_table	3
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
1	App\\Models\\User	3	auth_token	30bcd069f8f7015f910ed108f9f5acf97a613f7eb4b1619e57e66566ea580c9a	["*"]	\N	\N	2026-07-22 04:13:15	2026-07-22 04:13:15
2	App\\Models\\User	2	auth_token	456f958f2413694f547c7cc6bf51037b46274b9ce67c14be7f0079efc006a0da	["*"]	\N	\N	2026-07-22 04:13:30	2026-07-22 04:13:30
3	App\\Models\\User	1	auth_token	ab264f81201466f7070b38632606d6b74fb7ea43579b48a36f51116722334e5d	["*"]	\N	\N	2026-07-22 04:15:01	2026-07-22 04:15:01
4	App\\Models\\User	3	auth_token	7f2b102c74bbf7477a3d13d497047f3dfffefa33c5cc49334859ee5ebbd17a0e	["*"]	\N	\N	2026-07-22 04:26:15	2026-07-22 04:26:15
5	App\\Models\\User	3	auth_token	178e3caaf812f75dc0cc68e6916cc03a0acfa05e8994924607a9985de6b23ecd	["*"]	\N	\N	2026-07-22 04:58:46	2026-07-22 04:58:46
6	App\\Models\\User	3	auth_token	cfae0f081ff08fc5b33e629e4bcb2932f94a74ee237ab39eec5e77466604fdf7	["*"]	\N	\N	2026-07-23 00:14:35	2026-07-23 00:14:35
7	App\\Models\\User	4	auth_token	42082f068a8960a4627c9571ae6884829835f66a4610b54c076c59672d3181b7	["*"]	\N	\N	2026-07-23 00:31:06	2026-07-23 00:31:06
8	App\\Models\\User	3	auth_token	3c0c9b85cc859d89c06cd6ad6ae436bc4c445dcf1796d398da7d61d01ed3d65e	["*"]	\N	\N	2026-07-23 00:31:29	2026-07-23 00:31:29
9	App\\Models\\User	4	auth_token	a04350e25687b61a4a75c7b4d24718ab03aca3c1872599abf911b808b70cf7f4	["*"]	\N	\N	2026-07-23 00:38:10	2026-07-23 00:38:10
17	App\\Models\\User	3	auth_token	4cb506b2de6fadb01db6af13cfc523019c5a271718d7eda9350ad4e0aadffdb4	["*"]	2026-07-23 01:19:09	\N	2026-07-23 01:18:54	2026-07-23 01:19:09
18	App\\Models\\User	4	auth_token	5cc2d914fd1dca3e2978281dc1eb1ef7f8e1743a0c2ee7916e7ddc3808362be3	["*"]	\N	\N	2026-07-23 01:19:34	2026-07-23 01:19:34
19	App\\Models\\User	4	auth_token	5968b0860e2cc4a17316612982eb07a85b79931f22c0b2880f8ae1bdbaadf2bc	["*"]	\N	\N	2026-07-23 01:23:29	2026-07-23 01:23:29
20	App\\Models\\User	3	auth_token	869b97405b00530299fdc9013006adbf33abf18c16b9941107902a534a59178b	["*"]	\N	\N	2026-07-23 01:25:49	2026-07-23 01:25:49
21	App\\Models\\User	3	auth_token	f0f6b0cae9d057f4b30db40b34a2cf5dfb68569e7a89435341fcce8d428e2e5a	["*"]	\N	\N	2026-07-23 01:26:10	2026-07-23 01:26:10
22	App\\Models\\User	3	auth_token	0aa1436cd745b0916f27d6ed256131849cb2cca243c103bb33bea2b15f42a17e	["*"]	2026-07-23 01:29:06	\N	2026-07-23 01:29:03	2026-07-23 01:29:06
23	App\\Models\\User	4	auth_token	e3004571b10b3695dc9867c487742b9137c8349cbd161ea150dc7f77324107fe	["*"]	\N	\N	2026-07-23 01:29:50	2026-07-23 01:29:50
24	App\\Models\\User	4	auth_token	c0a8b8603bb04bc021aaec57aa67808d0322ea84f6ea83c024c156742e3e8a49	["*"]	\N	\N	2026-07-23 01:30:36	2026-07-23 01:30:36
25	App\\Models\\User	3	auth_token	12813288d8e449e8b5eac609a8a6908d6c7e087f4b49dabb9086a157d28406b7	["*"]	2026-07-23 01:33:13	\N	2026-07-23 01:33:10	2026-07-23 01:33:13
10	App\\Models\\User	3	auth_token	6b48ef2b7dc6d9c32ee0178a95fdce9426886637397a72ec1763e3d0cbd639f9	["*"]	2026-07-23 01:07:56	\N	2026-07-23 00:38:35	2026-07-23 01:07:56
26	App\\Models\\User	3	auth_token	fcfaff1c4f572aca441e0b331ea013247647eb3c7d3703060fdd884493507137	["*"]	\N	\N	2026-07-23 02:04:37	2026-07-23 02:04:37
11	App\\Models\\User	3	auth_token	b68234d27be2a06222855388581a0ead0dcb0189bdebea08be2ff2b6b5f042f4	["*"]	2026-07-23 01:08:55	\N	2026-07-23 01:08:51	2026-07-23 01:08:55
12	App\\Models\\User	5	auth_token	d6f9f60f61c6ca9b112e79a507cdc2d00c74d48ef87f49f8d1172758717f1474	["*"]	\N	\N	2026-07-23 01:09:16	2026-07-23 01:09:16
27	App\\Models\\User	4	auth_token	8c748b10c6f2f3e81acaf1f5e06afbb18deaafcb8757f9bb746d2c95bb700977	["*"]	2026-07-23 02:05:40	\N	2026-07-23 02:04:58	2026-07-23 02:05:40
28	App\\Models\\User	4	auth_token	4c1a98caac9040b479d55217609dff5cfa2f4de1683784607a851a837d16a9f9	["*"]	\N	\N	2026-07-23 02:06:03	2026-07-23 02:06:03
29	App\\Models\\User	4	auth_token	be91ca3b70a16b08dbbff2affadfefcf0d16aaa6b560c2b6968f3c98e09f01e1	["*"]	\N	\N	2026-07-23 02:07:09	2026-07-23 02:07:09
13	App\\Models\\User	3	auth_token	c55d8d565964c58a3c6d5960f043e40404677aedfa45947ce6f593e7a2e90c0f	["*"]	2026-07-23 01:10:27	\N	2026-07-23 01:09:51	2026-07-23 01:10:27
14	App\\Models\\User	5	auth_token	038f6f5a8ebdfb931913577b90b03b69411e73298c92d75e8b15b059670e23b0	["*"]	\N	\N	2026-07-23 01:11:05	2026-07-23 01:11:05
15	App\\Models\\User	4	auth_token	15af05431e4e5a8c34cbc6c0bb464f1bf22b46a75dfd4c5d3b576193b5318d01	["*"]	\N	\N	2026-07-23 01:11:26	2026-07-23 01:11:26
16	App\\Models\\User	4	auth_token	a08021f65d6ebf9c9839130da2159e58e717c2589c2403a36dee0205cacd05da	["*"]	\N	\N	2026-07-23 01:18:31	2026-07-23 01:18:31
30	App\\Models\\User	3	auth_token	d44419e66fcf123dcc0769796aa309fc5ba1eb74611cf5adc5b109f218f79a1e	["*"]	2026-07-23 02:07:40	\N	2026-07-23 02:07:22	2026-07-23 02:07:40
31	App\\Models\\User	3	auth_token	c1b9d7311248c23229cce51c47c39822a16ee383d18b4f0d472f5b5e058bf2a3	["*"]	2026-07-24 00:25:19	\N	2026-07-23 02:07:54	2026-07-24 00:25:19
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
uuJ0hC3vLzEs5lZz1XmT0aEq3LLRfs5MbrfOEHjK	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiVm9NQWR5MGJDcnRyaExhNmtzOVBUdDNabmlPb3M5dmlDd1BkbmN6VSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1784696134
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (id, nisn, name, classroom_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at, classroom_id, role, status, kelas) FROM stdin;
2	Pak Budi (Guru)	guru@sekolah.com	\N	$2y$12$rwmGy9AumGdL4S8om7TRouPDQygb.vdmi5BukO6bkfp1BTd0nL3me	\N	2026-07-22 03:54:31	2026-07-23 00:50:00	\N	guru	inactive	\N
1	Staf Sarpras	sarpras@sekolah.com	\N	$2y$12$GqsDvc5SzlqQwG3DRq0dlu1Id2jhUtrp8MefN9AFhVA.wHB.cVVLu	\N	2026-07-22 03:54:31	2026-07-23 00:50:10	\N	sarpras	inactive	\N
5	pida	pida@sekolah.com	\N	$2y$12$GLVMhUP4WOK6hPnwwd2oteg/pDD1H.bkeTf.2CmvAvLQPtAFQH.L6	\N	2026-07-23 01:08:31	2026-07-23 01:19:08	\N	guru	inactive	11 RPL
4	alfa	alfa@sekolah.com	\N	$2y$12$bGpCRnCKeG.fp4Sh7CloLuIAHJ2sIdQWA139EA8mCnph.04Z2jHu.	\N	2026-07-23 00:30:44	2026-07-23 02:05:40	\N	guru	active	\N
3	Admin Sekolah	admin@sekolah.com	\N	$2y$12$aUmnC9V8Mm2o6DpJj9gdQew52lcGiOv8tHqrC.sekaaIcyejahrTy	\N	2026-07-22 03:54:31	2026-07-23 02:07:41	\N	admin	pending	\N
\.


--
-- Data for Name: violations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.violations (id, student_id, academic_year_id, created_by, date, type, notes, created_at, updated_at) FROM stdin;
\.


--
-- Name: academic_years_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.academic_years_id_seq', 1, false);


--
-- Name: attendances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendances_id_seq', 1, false);


--
-- Name: classrooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classrooms_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 7, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 31, true);


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: violations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.violations_id_seq', 1, false);


--
-- Name: academic_years academic_years_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academic_years
    ADD CONSTRAINT academic_years_pkey PRIMARY KEY (id);


--
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: classrooms classrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classrooms
    ADD CONSTRAINT classrooms_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: students students_nisn_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_nisn_unique UNIQUE (nisn);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: violations violations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_pkey PRIMARY KEY (id);


--
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: attendances attendances_academic_year_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_academic_year_id_foreign FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id);


--
-- Name: attendances attendances_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: attendances attendances_student_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_student_id_foreign FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: students students_classroom_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_classroom_id_foreign FOREIGN KEY (classroom_id) REFERENCES public.classrooms(id);


--
-- Name: users users_classroom_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_classroom_id_foreign FOREIGN KEY (classroom_id) REFERENCES public.classrooms(id) ON DELETE SET NULL;


--
-- Name: violations violations_academic_year_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_academic_year_id_foreign FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id);


--
-- Name: violations violations_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: violations violations_student_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_student_id_foreign FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- PostgreSQL database dump complete
--

\unrestrict eQghjaPIDMjzG8pkCYf5cAow6udQaEffanMa6DdH94jaDWLlfaeK2EwPnSvD9t3

