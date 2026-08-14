--
-- PostgreSQL database dump
--
\ restrict 5jtN1nOzEMNSA5TZy8QuZgagMIFF9GIxQx1Q8Gy7vX2K2qtDs4G2zfPg0z5NBn4 -- Dumped from database version 18.4 (c9a59a4)
-- Dumped by pg_dump version 18.1
SET
    statement_timeout = 0;
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
-- Name: pg_session_jwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_session_jwt WITH SCHEMA public;


--
-- Name: EXTENSION pg_session_jwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_session_jwt IS 'pg_session_jwt: manage authentication sessions using JWTs';


--
-- Name: neon_auth; Type: SCHEMA; Schema: -; Owner: neon_auth
--

CREATE SCHEMA neon_auth;


ALTER SCHEMA neon_auth OWNER TO neon_auth;

--
-- Name: pgrst; Type: SCHEMA; Schema: -; Owner: neon_service
--

CREATE SCHEMA pgrst;


ALTER SCHEMA pgrst OWNER TO neon_service;

--
-- Name: pre_config(); Type: FUNCTION; Schema: pgrst; Owner: neon_service
--

CREATE FUNCTION pgrst.pre_config() RETURNS void
    LANGUAGE sql
    SET search_path TO ''
    AS $$
  SELECT
      set_config('pgrst.db_schemas', 'public', true)
    , set_config('pgrst.db_aggregates_enabled', 'true', true)
    , set_config('pgrst.db_anon_role', 'anonymous', true)
    , set_config('pgrst.jwt_role_claim_key', '.role', true)
$$;


ALTER FUNCTION pgrst.pre_config() OWNER TO neon_service;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.account (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "accountId" text NOT NULL,
    "providerId" text NOT NULL,
    "userId" uuid NOT NULL,
    "accessToken" text,
    "refreshToken" text,
    "idToken" text,
    "accessTokenExpiresAt" timestamp with time zone,
    "refreshTokenExpiresAt" timestamp with time zone,
    scope text,
    password text,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE neon_auth.account OWNER TO neon_auth;

--
-- Name: invitation; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.invitation (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "organizationId" uuid NOT NULL,
    email text NOT NULL,
    role text,
    status text NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "inviterId" uuid NOT NULL
);


ALTER TABLE neon_auth.invitation OWNER TO neon_auth;

--
-- Name: jwks; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.jwks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "publicKey" text NOT NULL,
    "privateKey" text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "expiresAt" timestamp with time zone
);


ALTER TABLE neon_auth.jwks OWNER TO neon_auth;

--
-- Name: member; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.member (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "organizationId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    role text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);


ALTER TABLE neon_auth.member OWNER TO neon_auth;

--
-- Name: organization; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.organization (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    logo text,
    "createdAt" timestamp with time zone NOT NULL,
    metadata text
);


ALTER TABLE neon_auth.organization OWNER TO neon_auth;

--
-- Name: project_config; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.project_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    endpoint_id text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    trusted_origins jsonb NOT NULL,
    social_providers jsonb NOT NULL,
    email_provider jsonb,
    email_and_password jsonb,
    allow_localhost boolean NOT NULL,
    plugin_configs jsonb,
    webhook_config jsonb
);


ALTER TABLE neon_auth.project_config OWNER TO neon_auth;

--
-- Name: session; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.session (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    token text NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "ipAddress" text,
    "userAgent" text,
    "userId" uuid NOT NULL,
    "impersonatedBy" text,
    "activeOrganizationId" text
);


ALTER TABLE neon_auth.session OWNER TO neon_auth;

--
-- Name: user; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth."user" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "emailVerified" boolean NOT NULL,
    image text,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    role text,
    banned boolean,
    "banReason" text,
    "banExpires" timestamp with time zone
);


ALTER TABLE neon_auth."user" OWNER TO neon_auth;

--
-- Name: verification; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.verification (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    identifier text NOT NULL,
    value text NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE neon_auth.verification OWNER TO neon_auth;

--
-- Name: academic_batches; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.academic_batches (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    year character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.academic_batches OWNER TO neondb_owner;

--
-- Name: academic_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.academic_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.academic_batches_id_seq OWNER TO neondb_owner;

--
-- Name: academic_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.academic_batches_id_seq OWNED BY public.academic_batches.id;


--
-- Name: academic_years; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.academic_years (
    id bigint NOT NULL,
    year character varying(255) NOT NULL,
    semester character varying(255) NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now(),
    updated_at timestamp(0) without time zone DEFAULT now(),
    CONSTRAINT academic_years_semester_check CHECK (((semester)::text = ANY ((ARRAY['Odd'::character varying, 'Even'::character varying])::text[])))
);


ALTER TABLE public.academic_years OWNER TO neondb_owner;

--
-- Name: academic_years_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.academic_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.academic_years_id_seq OWNER TO neondb_owner;

--
-- Name: academic_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.academic_years_id_seq OWNED BY public.academic_years.id;


--
-- Name: attendances; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.attendances (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    subject_id bigint,
    academic_year_id bigint NOT NULL,
    created_by bigint,
    date date NOT NULL,
    status character varying(255) NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT attendances_status_check CHECK (((status)::text = ANY ((ARRAY['Hadir'::character varying, 'Sakit'::character varying, 'Izin'::character varying, 'Alfa'::character varying])::text[])))
);


ALTER TABLE public.attendances OWNER TO neondb_owner;

--
-- Name: attendances_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendances_id_seq OWNER TO neondb_owner;

--
-- Name: attendances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO neondb_owner;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO neondb_owner;

--
-- Name: classrooms; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.classrooms (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    grade character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    singkatan character varying(255),
    academic_batch_id bigint,
    CONSTRAINT classrooms_grade_check CHECK (((grade)::text = ANY ((ARRAY['10'::character varying, '11'::character varying, '12'::character varying])::text[])))
);


ALTER TABLE public.classrooms OWNER TO neondb_owner;

--
-- Name: classrooms_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.classrooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.classrooms_id_seq OWNER TO neondb_owner;

--
-- Name: classrooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.classrooms_id_seq OWNED BY public.classrooms.id;


--
-- Name: inventaris; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.inventaris (
    id bigint NOT NULL,
    kode character varying(255) NOT NULL,
    nama character varying(255) NOT NULL,
    kategori character varying(255) NOT NULL,
    jumlah integer DEFAULT 0 NOT NULL,
    kondisi character varying(255) DEFAULT 'Baik'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.inventaris OWNER TO neondb_owner;

--
-- Name: inventaris_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.inventaris_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventaris_id_seq OWNER TO neondb_owner;

--
-- Name: inventaris_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.inventaris_id_seq OWNED BY public.inventaris.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO neondb_owner;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO neondb_owner;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO neondb_owner;

--
-- Name: peminjaman; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.peminjaman (
    id bigint NOT NULL,
    inventaris_id bigint NOT NULL,
    nama_peminjam character varying(255) NOT NULL,
    tanggal_pinjam date NOT NULL,
    jumlah integer DEFAULT 1 NOT NULL,
    keterangan text,
    status character varying(255) DEFAULT 'Sedang Dipinjam'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.peminjaman OWNER TO neondb_owner;

--
-- Name: peminjaman_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.peminjaman_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.peminjaman_id_seq OWNER TO neondb_owner;

--
-- Name: peminjaman_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.peminjaman_id_seq OWNED BY public.peminjaman.id;


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: neondb_owner
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


ALTER TABLE public.personal_access_tokens OWNER TO neondb_owner;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO neondb_owner;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO neondb_owner;

--
-- Name: students; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.students (
    id bigint NOT NULL,
    nisn character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    classroom_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    status character varying(255) DEFAULT 'Aktif'::character varying NOT NULL,
    status_keterangan character varying(255)
);


ALTER TABLE public.students OWNER TO neondb_owner;

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_id_seq OWNER TO neondb_owner;

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- Name: subject_jurusan; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.subject_jurusan (
    id bigint NOT NULL,
    subject_id bigint NOT NULL,
    classroom_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.subject_jurusan OWNER TO neondb_owner;

--
-- Name: subject_jurusan_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.subject_jurusan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subject_jurusan_id_seq OWNER TO neondb_owner;

--
-- Name: subject_jurusan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.subject_jurusan_id_seq OWNED BY public.subject_jurusan.id;


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.subjects (
    id bigint NOT NULL,
    kode_mapel character varying(255) NOT NULL,
    nama_mapel character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.subjects OWNER TO neondb_owner;

--
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subjects_id_seq OWNER TO neondb_owner;

--
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.subjects_id_seq OWNED BY public.subjects.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: neondb_owner
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


ALTER TABLE public.users OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: violations; Type: TABLE; Schema: public; Owner: neondb_owner
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


ALTER TABLE public.violations OWNER TO neondb_owner;

--
-- Name: violations_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.violations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.violations_id_seq OWNER TO neondb_owner;

--
-- Name: violations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.violations_id_seq OWNED BY public.violations.id;


--
-- Name: academic_batches id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.academic_batches ALTER COLUMN id SET DEFAULT nextval('public.academic_batches_id_seq'::regclass);


--
-- Name: academic_years id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.academic_years ALTER COLUMN id SET DEFAULT nextval('public.academic_years_id_seq'::regclass);


--
-- Name: attendances id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);


--
-- Name: classrooms id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.classrooms ALTER COLUMN id SET DEFAULT nextval('public.classrooms_id_seq'::regclass);


--
-- Name: inventaris id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.inventaris ALTER COLUMN id SET DEFAULT nextval('public.inventaris_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: peminjaman id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.peminjaman ALTER COLUMN id SET DEFAULT nextval('public.peminjaman_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- Name: subject_jurusan id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.subject_jurusan ALTER COLUMN id SET DEFAULT nextval('public.subject_jurusan_id_seq'::regclass);


--
-- Name: subjects id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.subjects ALTER COLUMN id SET DEFAULT nextval('public.subjects_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: violations id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.violations ALTER COLUMN id SET DEFAULT nextval('public.violations_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.account (id, "accountId", "providerId", "userId", "accessToken", "refreshToken", "idToken", "accessTokenExpiresAt", "refreshTokenExpiresAt", scope, password, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: invitation; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.invitation (id, "organizationId", email, role, status, "expiresAt", "createdAt", "inviterId") FROM stdin;
\.


--
-- Data for Name: jwks; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.jwks (id, "publicKey", "privateKey", "createdAt", "expiresAt") FROM stdin;
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.member (id, "organizationId", "userId", role, "createdAt") FROM stdin;
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.organization (id, name, slug, logo, "createdAt", metadata) FROM stdin;
\.


--
-- Data for Name: project_config; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.project_config (id, name, endpoint_id, created_at, updated_at, trusted_origins, social_providers, email_provider, email_and_password, allow_localhost, plugin_configs, webhook_config) FROM stdin;
fc31dabf-6a15-4de3-b9b7-d48fbffe3f5f	abasensi_backend	ep-morning-leaf-azbrhfcn	2026-08-06 01:44:56.131+00	2026-08-06 01:44:56.131+00	[]	[{"id": "google", "isShared": true}]	{"type": "shared"}	{"enabled": true, "disableSignUp": false, "emailVerificationMethod": "otp", "requireEmailVerification": false, "autoSignInAfterVerification": true, "sendVerificationEmailOnSignIn": false, "sendVerificationEmailOnSignUp": false}	t	{"magicLink": {"config": {"expiresIn": 5, "disableSignUp": false}, "enabled": false}, "phoneNumber": {"config": {"otp_expires_in": 300}, "enabled": false}, "organization": {"config": {"creatorRole": "owner", "membershipLimit": 100, "organizationLimit": 10, "sendInvitationEmail": false}, "enabled": true}}	{"enabled": false, "enabledEvents": [], "timeoutSeconds": 5}
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.session (id, "expiresAt", token, "createdAt", "updatedAt", "ipAddress", "userAgent", "userId", "impersonatedBy", "activeOrganizationId") FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth."user" (id, name, email, "emailVerified", image, "createdAt", "updatedAt", role, banned, "banReason", "banExpires") FROM stdin;
\.


--
-- Data for Name: verification; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.verification (id, identifier, value, "expiresAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: academic_batches; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.academic_batches (id, name, year, created_at, updated_at) FROM stdin;
1	ANGKATAN 2026	2026/2027	2026-07-25 14:09:05	2026-08-14 00:44:34
\.


--
-- Data for Name: academic_years; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.academic_years (id, year, semester, is_active, created_at, updated_at) FROM stdin;
4	2025/2026	Odd	t	2026-07-25 13:49:44	2026-07-25 13:49:44
\.


--
-- Data for Name: attendances; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.attendances (id, student_id, subject_id, academic_year_id, created_by, date, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: classrooms; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.classrooms (id, name, grade, created_at, updated_at, singkatan, academic_batch_id) FROM stdin;
15	Teknik Kendaraan Ringan 11A	10	2026-07-26 04:04:06	2026-08-14 00:16:27	TKR-11A	1
14	Layanan Penunjang Keperawatan dan Caregiving 11	10	2026-07-25 15:31:01	2026-08-14 00:16:40	LPKC-11	1
18	Teknik Kendaraan Ringan 11B	10	2026-08-14 00:17:34	2026-08-14 00:17:34	TKR-11B	1
19	Desain Komunikasi Visual 12	10	2026-08-14 00:31:35	2026-08-14 00:31:35	DKV-12	1
20	Layanan Penunjang Keperawatan dan Caregiving 12	10	2026-08-14 00:32:15	2026-08-14 00:32:15	LPKC-12	1
21	Teknik Kendaraan Ringan 12A	10	2026-08-14 00:33:00	2026-08-14 00:33:00	TKR-12A	1
22	Teknik Kendaraan Ringan 12B	10	2026-08-14 00:33:34	2026-08-14 00:33:34	TKR-12B	1
16	Desain Komunikasi Visual 11	10	2026-07-27 02:15:20	2026-08-14 00:45:19	DKV-11	1
\.


--
-- Data for Name: inventaris; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.inventaris (id, kode, nama, kategori, jumlah, kondisi, created_at, updated_at) FROM stdin;
1	PJT-001	Epson X600	Elektronik	10	Baik	2026-08-07 02:23:31	2026-08-07 02:24:58
2	SPK-001	Crimson PA15 2E	Elektronik	2	Baik	2026-08-07 02:35:25	2026-08-07 02:35:25
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_00_000000_create_subjects_table	1
2	0001_01_01_000000_create_users_table	1
3	0001_01_01_000001_create_cache_table	1
4	0001_01_01_000002_create_jobs_table	1
5	2026_07_22_031048_add_role_to_users_table	1
6	2026_07_22_040824_create_personal_access_tokens_table	1
7	2026_07_23_004150_add_status_and_kelas_to_users_table	1
8	2026_07_25_065807_create_subject_jurusan_table	2
9	2026_07_25_135652_create_academic_batches_table	3
10	2026_07_26_033259_add_indexes_to_tables	4
11	2026_07_26_044000_add_status_and_keterangan_to_students_table	5
12	2026_07_27_041629_add_academic_batch_id_to_classrooms_table	6
13	2026_08_03_013249_make_subject_id_nullable_on_attendances_table	7
14	2026_08_07_000001_create_inventaris_table	8
15	2026_08_07_000002_create_peminjaman_table	8
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: peminjaman; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.peminjaman (id, inventaris_id, nama_peminjam, tanggal_pinjam, jumlah, keterangan, status, created_at, updated_at) FROM stdin;
1	1	alfa	2026-08-07	1	digunakan untuk mengajar DKV-11	Dikembalikan	2026-08-07 02:24:30	2026-08-07 02:24:58
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
18	App\\Models\\User	4	auth_token	51559b0fdf896d6b801d0b9677186553d6d5dfc6deb47e2465981ad6a9a7603f	["*"]	2026-07-25 13:00:41	\N	2026-07-25 12:46:21	2026-07-25 13:00:41
34	App\\Models\\User	2	auth_token	c11d2adf95f1512541f6d44cc6c2c9b8bac9c4b25afca54c0ad0150a4b377f0b	["*"]	2026-07-27 01:15:30	\N	2026-07-27 01:14:02	2026-07-27 01:15:30
1	App\\Models\\User	2	auth_token	6bc0cac164201b09acec8f101a0171f88159fcf5bdbfa057544994123120b049	["*"]	2026-07-25 07:26:00	\N	2026-07-25 07:25:47	2026-07-25 07:26:00
23	App\\Models\\User	3	auth_token	2ee0d0de73f694b5f5a67db53a0aec1118b40e18d1855e9bc9fe0352a7e578fb	["*"]	2026-07-26 05:17:34	\N	2026-07-26 05:17:12	2026-07-26 05:17:34
38	App\\Models\\User	2	auth_token	b3a99c220b7903f6c741754497228488d8e4341f8282c3bf2adca7fa1d471a47	["*"]	2026-07-27 01:48:30	\N	2026-07-27 01:47:13	2026-07-27 01:48:30
12	App\\Models\\User	2	auth_token	19de19cfc8d2669032a9073a68eb21001f8e75c543bddf945c85f7555f487957	["*"]	2026-07-25 10:31:19	\N	2026-07-25 10:10:00	2026-07-25 10:31:19
31	App\\Models\\User	2	auth_token	54fd21baeba19d4f9472b8d0d1a964326ad420629d2af9ac5c5bec763fc8e2ef	["*"]	2026-07-26 10:22:17	\N	2026-07-26 10:21:14	2026-07-26 10:22:17
13	App\\Models\\User	2	auth_token	f80595e7d25ca197ab526ed7218e9eb782d8376e4d4faeb03328d0ea33cd9345	["*"]	2026-07-25 10:32:35	\N	2026-07-25 10:32:26	2026-07-25 10:32:35
9	App\\Models\\User	2	auth_token	cc20af0581ecc1d078e2e7fddec3f78ce14ff81f8757b20216272c5ccafe826c	["*"]	2026-07-25 10:08:30	\N	2026-07-25 09:54:58	2026-07-25 10:08:30
22	App\\Models\\User	2	auth_token	c46d21b4bad5a0bb2eac191868991e76d4c31c56a8b1ca2ad2f6ab721cbbef7d	["*"]	2026-07-26 05:17:00	\N	2026-07-26 04:35:36	2026-07-26 05:17:00
14	App\\Models\\User	5	auth_token	fc14afa676660145d9e3da35afc7e638c85fc1e09e01f0174d0f76f5464024ca	["*"]	2026-07-25 11:19:42	\N	2026-07-25 10:32:49	2026-07-25 11:19:42
10	App\\Models\\User	3	auth_token	5e00cf97682828689a5678fb37d2acb489630545510261742c0a6fdb333741ee	["*"]	2026-07-25 10:09:01	\N	2026-07-25 10:08:52	2026-07-25 10:09:01
16	App\\Models\\User	2	auth_token	acffb91843369e2fd9823b35585e825ee8bb9a5d69fac9730fca9c62c7a1932d	["*"]	2026-07-25 12:21:47	\N	2026-07-25 11:22:16	2026-07-25 12:21:47
2	App\\Models\\User	2	auth_token	c825df138fcb4ec095742319cdab24bff243e920303557f1160eb91c86b2698a	["*"]	2026-07-25 08:57:57	\N	2026-07-25 07:27:17	2026-07-25 08:57:57
15	App\\Models\\User	2	auth_token	190208c7d2c67b8bea7d6b8d6408ee756d3f92d0fc8095562beaf145db56de27	["*"]	2026-07-25 11:20:17	\N	2026-07-25 11:20:10	2026-07-25 11:20:17
11	App\\Models\\User	4	auth_token	183b5a875936cbcbb6edccb1d09963bf2a34a15e7ed49347db3495370a811be4	["*"]	2026-07-25 10:09:23	\N	2026-07-25 10:09:14	2026-07-25 10:09:23
3	App\\Models\\User	3	auth_token	e3dfbfe980c00ade19ad9b32bab4c45443982059fdeec06850b919078d6f197e	["*"]	2026-07-25 08:59:29	\N	2026-07-25 08:59:19	2026-07-25 08:59:29
6	App\\Models\\User	2	auth_token	c4fb4eb905096c767faae2cb86d5e4e9714da6904e4dc67e9591bf7c63c6a9e3	["*"]	2026-07-25 09:53:40	\N	2026-07-25 09:31:28	2026-07-25 09:53:40
4	App\\Models\\User	2	auth_token	cc8377ad08139f662dea795a0eed5ca1cef69876a655148e335e8ba7a1679208	["*"]	2026-07-25 09:00:31	\N	2026-07-25 09:00:22	2026-07-25 09:00:31
5	App\\Models\\User	4	auth_token	d10ca90296b4148d64334425561994a7d1302ba1b8c6b1ede05b0d486e8a6844	["*"]	2026-07-25 09:31:09	\N	2026-07-25 09:01:04	2026-07-25 09:31:09
21	App\\Models\\User	3	auth_token	f92dc58334ef43c300aa03461e785f35ded5445f1e9172751f3a1f17c0851e7e	["*"]	2026-07-26 04:35:23	\N	2026-07-26 04:04:32	2026-07-26 04:35:23
7	App\\Models\\User	4	auth_token	aafa5d41e0a823f7a6cfe9529b42b7311b022c015aa9a96f73b9a16992413936	["*"]	2026-07-25 09:54:10	\N	2026-07-25 09:54:02	2026-07-25 09:54:10
25	App\\Models\\User	2	auth_token	1b029f51edbb97aa51db30b35c48e9e3508deb811a9e8b48ec01e63d55b0dd3b	["*"]	2026-07-26 09:44:51	\N	2026-07-26 05:18:39	2026-07-26 09:44:51
20	App\\Models\\User	4	auth_token	ca3b11c871c4e3bca6f51a4058b417d8919689ad3a8b7a902bd61a34e7c899aa	["*"]	2026-07-26 04:04:11	\N	2026-07-26 04:02:31	2026-07-26 04:04:11
8	App\\Models\\User	3	auth_token	bed474ba412bda36917d7fb19416f33ff55919d1504a2bff376ec56727d26b57	["*"]	2026-07-25 09:54:50	\N	2026-07-25 09:54:41	2026-07-25 09:54:50
19	App\\Models\\User	2	auth_token	c290c0eb303e648f648658d52ff57d55d95e5225e81658c637de578cc8a9a3fa	["*"]	2026-07-26 03:56:08	\N	2026-07-25 13:01:31	2026-07-26 03:56:08
17	App\\Models\\User	2	auth_token	cba5cda4273089e8eb3be836ba1bd5c95fe64598e6c7a963c64ea60afcd8cc4f	["*"]	2026-07-25 12:46:05	\N	2026-07-25 12:45:52	2026-07-25 12:46:05
30	App\\Models\\User	8	auth_token	bbfc33b70513092c8d4b6090b43e788be779ffa0cb7176b16097109dc3fe1642	["*"]	2026-07-26 10:05:54	\N	2026-07-26 10:04:08	2026-07-26 10:05:54
41	App\\Models\\User	7	auth_token	3564ff524c64a541c4ed8807ecb883dccdc04716b13c810fa96fa8984e600415	["*"]	2026-07-27 01:59:33	\N	2026-07-27 01:59:09	2026-07-27 01:59:33
27	App\\Models\\User	2	auth_token	6b844eb1b1ff026ce54ec408c907874fe0bf736d7c8a372114ff2d76fc2ed027	["*"]	2026-07-26 10:01:41	\N	2026-07-26 10:01:14	2026-07-26 10:01:41
24	App\\Models\\User	3	auth_token	07a1fcb2526b7dd292ec92ad8832dd5914be05f3c6e209375f9a9c78140a93c5	["*"]	2026-07-26 05:18:32	\N	2026-07-26 05:18:07	2026-07-26 05:18:32
37	App\\Models\\User	2	auth_token	83c38ac1ee652443e8be6bcd5eac481ea3cba8fe7a9a9f6907c8780edd6fe62c	["*"]	2026-07-27 01:47:03	\N	2026-07-27 01:38:19	2026-07-27 01:47:03
32	App\\Models\\User	2	auth_token	d57efb252b1b59a2f85443322bfcdddc1dd3138323331dc8ed3ca6df53fb3ec1	["*"]	2026-07-27 01:11:59	\N	2026-07-26 10:30:02	2026-07-27 01:11:59
28	App\\Models\\User	2	auth_token	22d489552d75a7a7db910143b4716b5a87a89379294d6ff182bb037ca5950d54	["*"]	2026-07-26 10:02:40	\N	2026-07-26 10:02:18	2026-07-26 10:02:40
26	App\\Models\\User	2	auth_token	fe8a93534899c6bbc8530ab75565fd9c0dd5f0c0a54208a287fa71ec8a4c69ae	["*"]	2026-07-26 10:00:17	\N	2026-07-26 09:54:30	2026-07-26 10:00:17
29	App\\Models\\User	8	auth_token	65ffff0c7609668150aa6569fd2b7db6c7599d0a3d976722fb3d213799b8c5c7	["*"]	2026-07-26 10:03:34	\N	2026-07-26 10:03:06	2026-07-26 10:03:34
33	App\\Models\\User	2	auth_token	b068188dad1f6d6d5aef59c8701bc0372d43dd8fb680dec478321041ba32b921	["*"]	2026-07-27 01:12:44	\N	2026-07-27 01:12:18	2026-07-27 01:12:44
35	App\\Models\\User	2	auth_token	29a2e83b7c03322d9f2f376ad2764d7179f971f589f05e1393073bba1712760a	["*"]	2026-07-27 01:17:38	\N	2026-07-27 01:16:18	2026-07-27 01:17:38
36	App\\Models\\User	10	auth_token	1ae411a45c875691495eaeb9200db5f2cde53ed4b159ec76ae128ea80b68af38	["*"]	2026-07-27 01:18:57	\N	2026-07-27 01:17:54	2026-07-27 01:18:57
39	App\\Models\\User	2	auth_token	ce7f0288559bf5c54785233d9f95aa927570b37162c76ed7c59df6f783491ab1	["*"]	2026-07-27 01:49:05	\N	2026-07-27 01:48:13	2026-07-27 01:49:05
40	App\\Models\\User	2	auth_token	80ff93212b948465bc67e71f88de836d4faecdf7cdbdfdefebfb71cc231b0ca3	["*"]	2026-07-27 01:58:22	\N	2026-07-27 01:57:56	2026-07-27 01:58:22
43	App\\Models\\User	4	auth_token	8d507bddf8bc24241fb10aa457c25756714a404e5d726b38b4e9fd1a28b9c6e1	["*"]	2026-07-27 02:00:46	\N	2026-07-27 02:00:12	2026-07-27 02:00:46
42	App\\Models\\User	7	auth_token	bb28e3cc5cf06d8088ba5e00138be8827ae831160389fe3887b2564e1f79b7ce	["*"]	2026-07-27 02:00:05	\N	2026-07-27 01:59:50	2026-07-27 02:00:05
70	App\\Models\\User	2	auth_token	d3f88df646ed741cd944657cead34333c2b593da5f2164f6f4362a59c87a0571	["*"]	2026-07-29 01:23:23	\N	2026-07-29 01:21:29	2026-07-29 01:23:23
52	App\\Models\\User	2	auth_token	818792ed4c30a23d09dd23ed5c4d7a937347137fdbc2c8fd701490e468c6e592	["*"]	2026-07-27 02:33:07	\N	2026-07-27 02:32:50	2026-07-27 02:33:07
44	App\\Models\\User	4	auth_token	b15514b0d64e39d5dac49b96f5b4c7ac3c4796b47133acfcd92b7e6e089515ca	["*"]	2026-07-27 02:01:44	\N	2026-07-27 02:01:27	2026-07-27 02:01:44
55	App\\Models\\User	2	auth_token	a3276c9a054dbf1d6b06b787ad9d8d4ba7ee2aaafb2cadda816f4b3efb725580	["*"]	2026-07-27 04:26:07	\N	2026-07-27 04:25:59	2026-07-27 04:26:07
58	App\\Models\\User	4	auth_token	a500f3cc0521aeae6587e157956327bf6ba2119d234976de446857b0e9447e69	["*"]	2026-07-29 00:42:00	\N	2026-07-29 00:40:55	2026-07-29 00:42:00
76	App\\Models\\User	8	auth_token	7fc8bbe42998729f3b10d9fd9c420100293956980d704b6bcf76b200b320bd7e	["*"]	2026-07-30 00:40:08	\N	2026-07-30 00:39:45	2026-07-30 00:40:08
62	App\\Models\\User	8	auth_token	569499fd20f0183e92f8184b9bb2c29ed0b4f8b3ce0f035e4cb1fbe7ee9824bc	["*"]	2026-07-29 00:44:29	\N	2026-07-29 00:44:01	2026-07-29 00:44:29
45	App\\Models\\User	10	auth_token	ac6d8655a3239ae0dc83c52699831fa3d2d735a814186fc34cee610d105f5972	["*"]	2026-07-27 02:02:30	\N	2026-07-27 02:02:04	2026-07-27 02:02:30
68	App\\Models\\User	7	auth_token	5b3a3d60b41f7c9dacdbdb805b778d39db51dd9bb6e7110cb515543437daa6d7	["*"]	2026-07-29 01:19:31	\N	2026-07-29 01:18:03	2026-07-29 01:19:31
65	App\\Models\\User	2	auth_token	d8407fddd763ef14f6e8ba6b4994003dd54e4830491bb9f58f2c353dbe1f97ba	["*"]	2026-07-29 00:49:12	\N	2026-07-29 00:48:51	2026-07-29 00:49:12
75	App\\Models\\User	2	auth_token	3cc6eea38d055661ee15b77477a7321f49bf15e11b05e3cde4827e5309f044e4	["*"]	2026-07-30 00:38:07	\N	2026-07-30 00:37:48	2026-07-30 00:38:07
50	App\\Models\\User	2	auth_token	ab7b7bed133c32db9d3cc9224558bcbd6497e373ed724aadac271c92cf9225cd	["*"]	2026-07-27 02:32:26	\N	2026-07-27 02:05:44	2026-07-27 02:32:26
77	App\\Models\\User	2	auth_token	8f643d4d66c1009a365ad0d558e648a0f805bb041e011ef347b367c6c1600b61	["*"]	2026-07-30 02:28:16	\N	2026-07-30 02:21:46	2026-07-30 02:28:16
53	App\\Models\\User	2	auth_token	c4cfba5cca372cffd247262d981a623149a505a6b5ebba4f7cad54e06f49ccd2	["*"]	2026-07-27 03:55:56	\N	2026-07-27 02:44:37	2026-07-27 03:55:56
46	App\\Models\\User	10	auth_token	23c8b4f8320f9b69ca476045931e853fb68e14fa4ebc16e2b1c09a721d664800	["*"]	2026-07-27 02:03:46	\N	2026-07-27 02:02:50	2026-07-27 02:03:46
47	App\\Models\\User	8	auth_token	7fcf89803b89d8c769153bb802358169eb94762836e20d7e07b2a74f49672714	["*"]	\N	\N	2026-07-27 02:03:54	2026-07-27 02:03:54
48	App\\Models\\User	8	auth_token	9c75a3383b2aa902fbb83ba269fc6706681798413f8d199a4ab65d5bf03af85a	["*"]	2026-07-27 02:04:26	\N	2026-07-27 02:04:05	2026-07-27 02:04:26
73	App\\Models\\User	7	auth_token	ffbc719df0860b04261f5be59208a9f34fa6dd58e7e25867380ed8c7deefb720	["*"]	2026-07-29 01:54:57	\N	2026-07-29 01:54:40	2026-07-29 01:54:57
59	App\\Models\\User	2	auth_token	e8e16d9aa99cb80eb2ce02e59d93de5bc0f2dd5842ceb46fdc4015997d8d90a6	["*"]	2026-07-29 00:42:33	\N	2026-07-29 00:41:59	2026-07-29 00:42:33
66	App\\Models\\User	11	auth_token	055542d030b87508626e1939114878f5b28cc300d51b3a050aa7e97b340c27fa	["*"]	2026-07-29 00:51:36	\N	2026-07-29 00:49:27	2026-07-29 00:51:36
49	App\\Models\\User	2	auth_token	c04550703b6e44da648f47be32135d2b6731f45364bb70a246b05260884f96bf	["*"]	2026-07-27 02:05:29	\N	2026-07-27 02:05:06	2026-07-27 02:05:29
51	App\\Models\\User	2	auth_token	8d0aa60a02e74c706318bce21b41ea81d04e6b33ca947efaec78c86ed66dfe55	["*"]	2026-07-27 02:32:56	\N	2026-07-27 02:31:37	2026-07-27 02:32:56
56	App\\Models\\User	7	auth_token	5bb01e161dce8c8b5c2827d51ce1cdab6188c03242346e269b03a2b20bf7e64b	["*"]	2026-07-28 01:02:22	\N	2026-07-27 04:26:24	2026-07-28 01:02:22
54	App\\Models\\User	2	auth_token	882b5cde8b8c40d0e8fc1471a4c284d78ac56faa2bb1f5a08b19b67feab1bc21	["*"]	2026-07-27 04:20:51	\N	2026-07-27 03:55:51	2026-07-27 04:20:51
63	App\\Models\\User	10	auth_token	ce984ba33f12c05fe6ef661eb900a861ea77246157454e292f67ccfcf1481e61	["*"]	2026-07-29 00:45:44	\N	2026-07-29 00:45:06	2026-07-29 00:45:44
61	App\\Models\\User	4	auth_token	b8a83f8bb261f0c73750ec8aca359991b3dd15a97b49eb2f27b3e59730398526	["*"]	2026-07-29 00:43:58	\N	2026-07-29 00:42:55	2026-07-29 00:43:58
60	App\\Models\\User	2	auth_token	1b030556e19186c4c435e1a277421fa1c7ab80ce6987b203b17741c40f3fbe87	["*"]	2026-07-29 00:42:46	\N	2026-07-29 00:42:26	2026-07-29 00:42:46
57	App\\Models\\User	2	auth_token	d86acad7618b078ba3c7a8ff9ce6ab9441fdf909ad1bcb3bffe090fa32cdaaf0	["*"]	2026-07-29 00:41:52	\N	2026-07-28 01:15:40	2026-07-29 00:41:52
71	App\\Models\\User	4	auth_token	3b8050a293755ebc6145de7ba684641c1b2b9e95776e1f122f2a1760c5536d0c	["*"]	2026-07-29 01:25:17	\N	2026-07-29 01:23:18	2026-07-29 01:25:17
69	App\\Models\\User	2	auth_token	b0fe3840970b66b3c7207cefe12e81084685405b57253ac9512108e92fe1b4af	["*"]	2026-07-29 01:20:55	\N	2026-07-29 01:20:21	2026-07-29 01:20:55
64	App\\Models\\User	2	auth_token	ca46890d3507c4628cb09a7f503acf8199f002575998a221a6038370bc5ded4e	["*"]	2026-07-29 00:48:59	\N	2026-07-29 00:47:57	2026-07-29 00:48:59
74	App\\Models\\User	7	auth_token	f0b233534ea885752c1d8271936035bf7a709dbfff3560bac4f299702c023a31	["*"]	2026-07-29 01:56:04	\N	2026-07-29 01:55:24	2026-07-29 01:56:04
67	App\\Models\\User	2	auth_token	287c31952b64a43723a1454cfe014593a42a7df7fdb167bba7563b4edf8a93b5	["*"]	2026-07-29 01:12:13	\N	2026-07-29 00:51:56	2026-07-29 01:12:13
81	App\\Models\\User	11	auth_token	0076e355e107ec609c5a29b864472e311f8e945e96783ef2264d0b3ab512ab39	["*"]	2026-08-03 01:11:37	\N	2026-08-03 01:11:17	2026-08-03 01:11:37
72	App\\Models\\User	7	auth_token	83830271549427651ce164c5db1671fc7698ee3d33e1cb4089a81d337fb28919	["*"]	2026-07-29 01:54:04	\N	2026-07-29 01:53:14	2026-07-29 01:54:04
78	App\\Models\\User	7	auth_token	e8a359c8f545c093b67ddac93ec34d2ba1b938aca4c0bcfab148201ce96a6e96	["*"]	2026-07-30 02:29:35	\N	2026-07-30 02:28:52	2026-07-30 02:29:35
79	App\\Models\\User	2	auth_token	4d165e0ddd61e0a83323fd7f88745a80b0c22f2c93592a46533adc7ab6d54eaf	["*"]	2026-07-30 23:42:54	\N	2026-07-30 02:31:07	2026-07-30 23:42:54
80	App\\Models\\User	2	auth_token	ca91ec5d90f9f665d76a749ea9e96b14f88592304fb3be83a4f7647b96fc7ab0	["*"]	2026-08-03 01:11:02	\N	2026-07-31 00:34:21	2026-08-03 01:11:02
83	App\\Models\\User	8	auth_token	8b0ea5dd3bb8a1e3a5a6df2eb39f5dcbc5886d8ac925f9a22318fe8dd47b59f7	["*"]	2026-08-03 03:01:24	\N	2026-08-03 03:01:02	2026-08-03 03:01:24
82	App\\Models\\User	2	auth_token	46e0ee02b077e2a25ba5c882c3819bd6920c0d6d974943eab82be91f1cfafa4a	["*"]	2026-08-03 02:59:18	\N	2026-08-03 01:13:50	2026-08-03 02:59:18
84	App\\Models\\User	2	auth_token	6d96a42020ead819c5dca8f33bafa03d22b7d381d2d042242360645e77afda4e	["*"]	2026-08-03 03:03:45	\N	2026-08-03 03:03:32	2026-08-03 03:03:45
85	App\\Models\\User	10	auth_token	27401898205683c5cc1ba449bfb8bb44f4fe908c2854a70f94e1aefd16509b5e	["*"]	2026-08-03 03:04:23	\N	2026-08-03 03:03:58	2026-08-03 03:04:23
86	App\\Models\\User	2	auth_token	9608f5cad000b695eabf7685817e59c09cf657272028b016c53138587c6659b4	["*"]	2026-08-03 04:23:12	\N	2026-08-03 04:23:02	2026-08-03 04:23:12
114	App\\Models\\User	2	auth_token	83fd065ec29e1193c8e00755990f58dd454a2098fc8d03839bc518e995e1af59	["*"]	2026-08-06 07:03:23	\N	2026-08-06 07:02:59	2026-08-06 07:03:23
90	App\\Models\\User	2	auth_token	13294c9c865e58e598b69a0cec087240dcb586af7125c49f991bbc8b3a585af9	["*"]	2026-08-03 05:12:53	\N	2026-08-03 05:12:16	2026-08-03 05:12:53
87	App\\Models\\User	2	auth_token	e0f2f508863c6401f1b0d5e4db3c6232b211fec17500f411a8cff36e3e6b3c80	["*"]	2026-08-03 04:37:18	\N	2026-08-03 04:23:17	2026-08-03 04:37:18
94	App\\Models\\User	2	auth_token	4cd1550d74fa6b3ec29b8937a6450b2f9e1d3387b408993a750ba2f317a0bffd	["*"]	2026-08-05 02:55:22	\N	2026-08-05 02:47:25	2026-08-05 02:55:22
111	App\\Models\\User	2	auth_token	a178bd286ec51af15b20e68ef65fb1605158e1ecd0264a5dfed0d44f273371c4	["*"]	2026-08-06 06:18:10	\N	2026-08-06 06:00:07	2026-08-06 06:18:10
96	App\\Models\\User	2	auth_token	9bdf116ceed12471405164ee3bbe089553c4386414f553fb96a5fdb8ccca8371	["*"]	2026-08-06 00:30:21	\N	2026-08-06 00:23:21	2026-08-06 00:30:21
88	App\\Models\\User	10	auth_token	785ed3eb4ebadacbaa68be7bbf32f3f8e014740625a8876421713c962cd2ba83	["*"]	2026-08-03 04:47:03	\N	2026-08-03 04:46:53	2026-08-03 04:47:03
99	App\\Models\\User	10	auth_token	c29d5f6b384f53ab6aba22d7ba24208da91a9a89e6081d4c23800a7015afbc65	["*"]	2026-08-06 01:01:58	\N	2026-08-06 01:01:05	2026-08-06 01:01:58
116	App\\Models\\User	2	auth_token	008e9437966be31c90900322f1aeb7cdd8a2cac60cac5ec7b630e41772214a2a	["*"]	2026-08-07 00:08:23	\N	2026-08-07 00:08:22	2026-08-07 00:08:23
105	App\\Models\\User	2	auth_token	17c3e20e75fb64620194fcf68c47683d474dbefc05631cc99e0940847f9c9254	["*"]	2026-08-06 04:17:46	\N	2026-08-06 04:04:31	2026-08-06 04:17:46
95	App\\Models\\User	2	auth_token	fc322312413144d05b9ed2f251209f1a6800cf4d95633e2904147b8e72539d45	["*"]	2026-08-06 00:13:31	\N	2026-08-06 00:13:10	2026-08-06 00:13:31
104	App\\Models\\User	2	auth_token	82c70c16439bb20499842234c392620d868cad63f7680243c059f8910ba92f52	["*"]	2026-08-06 04:04:11	\N	2026-08-06 04:03:48	2026-08-06 04:04:11
91	App\\Models\\User	2	auth_token	0de5ba7a179f72dee9846fa94066f9d5e7acb4b2d20801fc7a780d6dbb5a8b65	["*"]	2026-08-04 23:57:48	\N	2026-08-04 23:56:12	2026-08-04 23:57:48
92	App\\Models\\User	8	auth_token	c8d7ba34e05541ce35110f316d130144a9237793264fca46bfd096cac30d5881	["*"]	2026-08-06 00:19:47	\N	2026-08-05 00:45:31	2026-08-06 00:19:47
103	App\\Models\\User	2	auth_token	30a782663279900d912cf13ac520ae7bc503cd4c541bcb8b8b7a8ac1c22c6300	["*"]	2026-08-06 04:04:14	\N	2026-08-06 03:53:08	2026-08-06 04:04:14
100	App\\Models\\User	8	auth_token	fd6d12b36e09d300bffbc58376e00b7b734ff123588172602297e2ea62a5e39f	["*"]	2026-08-06 01:03:04	\N	2026-08-06 01:02:39	2026-08-06 01:03:04
89	App\\Models\\User	2	auth_token	d82ee207cac0f4d011603ab0e1a6074888a468d08ebc4dcaadc428e1e429499a	["*"]	2026-08-03 04:49:31	\N	2026-08-03 04:47:14	2026-08-03 04:49:31
98	App\\Models\\User	2	auth_token	bfa371ae17eec88424782eab06509a233ebcff9f34676a5c823477a56ff5b650	["*"]	2026-08-06 00:52:06	\N	2026-08-06 00:30:52	2026-08-06 00:52:06
97	App\\Models\\User	2	auth_token	bf35b273dba8be3ccc5092cc3e226f0be553e63ea8a728149597d30b6faff9cb	["*"]	2026-08-06 00:54:33	\N	2026-08-06 00:27:53	2026-08-06 00:54:33
101	App\\Models\\User	2	auth_token	62680f541eef196599f5c9809e4dcb86d756b78b314447bf05c728ba5751471a	["*"]	2026-08-06 01:56:09	\N	2026-08-06 01:56:00	2026-08-06 01:56:09
106	App\\Models\\User	2	auth_token	f0507618f8c6b980c1cec731015e7ae2c1d399150165568c5cf56c709ba76a21	["*"]	2026-08-06 04:19:11	\N	2026-08-06 04:18:01	2026-08-06 04:19:11
119	App\\Models\\User	8	auth_token	d2468472af4a354e3a9ca2ce8a85ac01f7c23269e74f5164d69ab4259ad38518	["*"]	2026-08-07 01:26:22	\N	2026-08-07 01:17:03	2026-08-07 01:26:22
93	App\\Models\\User	2	auth_token	2ee8ed48620b7ba822db82d1e3128f77c02806420267a76335f8d1366005faa3	["*"]	2026-08-06 00:55:10	\N	2026-08-05 02:47:03	2026-08-06 00:55:10
102	App\\Models\\User	2	auth_token	18dbdba245f3d2be535c31febe1c39851d6adc9129dde95f69852915935231ff	["*"]	2026-08-06 03:51:34	\N	2026-08-06 03:51:15	2026-08-06 03:51:34
120	App\\Models\\User	8	auth_token	133ba39b457769afaca603b7d31ea050a881f4201b871b66eb83ac5620341d58	["*"]	\N	\N	2026-08-07 01:27:13	2026-08-07 01:27:13
110	App\\Models\\User	2	auth_token	cff291ffc028efb0a9911e31bd2f554994d935ffed3f91e5096dc7efa40ce6da	["*"]	2026-08-06 05:59:44	\N	2026-08-06 05:46:50	2026-08-06 05:59:44
113	App\\Models\\User	2	auth_token	10e1640bfcaed28171956cfdc1fc1e140f67a1a728957d1170d69d7f38a3e5e7	["*"]	2026-08-06 06:20:45	\N	2026-08-06 06:19:19	2026-08-06 06:20:45
108	App\\Models\\User	2	auth_token	59c770a9a5a4b527f7875618d00cab5a279ac1186174f77017465cfce559c462	["*"]	2026-08-06 05:34:19	\N	2026-08-06 05:25:30	2026-08-06 05:34:19
109	App\\Models\\User	2	auth_token	7cd81148d6618c8759ce4ceb43ef336dc12c28504865967596a5770c00e107c9	["*"]	2026-08-06 05:34:45	\N	2026-08-06 05:34:44	2026-08-06 05:34:45
118	App\\Models\\User	8	auth_token	3ab8257057f525f6e89b6f34618e4c78f001c1db65e75ca82def801da856d551	["*"]	\N	\N	2026-08-07 00:32:09	2026-08-07 00:32:09
107	App\\Models\\User	2	auth_token	07af9310043af2d5576d9a593c5d66a3347626ebd7c27d2302853db4e7c1b1f7	["*"]	2026-08-06 04:58:07	\N	2026-08-06 04:19:27	2026-08-06 04:58:07
112	App\\Models\\User	2	auth_token	ac28f3ea08227fdf2a9da67b9a68935c6dd6974e7c59460169d40a2be4b1bbcd	["*"]	2026-08-06 07:00:37	\N	2026-08-06 06:07:07	2026-08-06 07:00:37
117	App\\Models\\User	8	auth_token	31a8e650dc893b6c669dd22de86dab1646ad03c12493675c7644b39be9894f4d	["*"]	2026-08-07 00:32:09	\N	2026-08-07 00:08:53	2026-08-07 00:32:09
123	App\\Models\\User	8	auth_token	462983d5678d647263c2fc8c3766de18e7dd5bb088948819be07946919322e56	["*"]	2026-08-07 01:57:54	\N	2026-08-07 01:45:28	2026-08-07 01:57:54
115	App\\Models\\User	2	auth_token	1ea761010f2d8d103dccacd19de02d59ff2a08000b944789c64bb9c9e325bc5a	["*"]	2026-08-07 00:08:14	\N	2026-08-06 14:38:56	2026-08-07 00:08:14
124	App\\Models\\User	8	auth_token	230203a11d5f375ed1572c5df96ad72d2c576d9e13febd771544912ef3dea99a	["*"]	\N	\N	2026-08-07 01:58:08	2026-08-07 01:58:08
125	App\\Models\\User	8	auth_token	78a885c63cef4e093b122ccf5e09226074849d3a31d741230e9dbe656d2cc4cd	["*"]	\N	\N	2026-08-07 02:02:49	2026-08-07 02:02:49
121	App\\Models\\User	8	auth_token	cc8361a6dc46823c81a561d9c7b6ee4599638c2ab47602a1a072b5abda329315	["*"]	2026-08-07 01:43:53	\N	2026-08-07 01:37:41	2026-08-07 01:43:53
126	App\\Models\\User	8	auth_token	d4411d6db5e522e7fad733928fe1156506862c9c5daedade14917888650495a2	["*"]	2026-08-07 02:16:39	\N	2026-08-07 02:10:07	2026-08-07 02:16:39
127	App\\Models\\User	8	auth_token	bf587c673dd2b5d5cc73d4471e5fad2270b9528601d5fa821085a49e6cc8a832	["*"]	2026-08-07 02:24:58	\N	2026-08-07 02:16:53	2026-08-07 02:24:58
128	App\\Models\\User	8	auth_token	1b9769cc495e4b483c5a6fadba527bb385d1cfb0cc1fa119e13b687834cfb2c2	["*"]	2026-08-07 02:35:25	\N	2026-08-07 02:27:17	2026-08-07 02:35:25
129	App\\Models\\User	2	auth_token	f89aa2d1091ffd97a0fd090fceda6f6ef20c6868f56d13c3d4b9a671cff181be	["*"]	2026-08-10 00:11:15	\N	2026-08-07 02:51:37	2026-08-10 00:11:15
122	App\\Models\\User	8	auth_token	bb0539440498930e47dd3cb5e4ff0db88291d85a31ccb6c2a113a8eecd43d532	["*"]	2026-08-07 03:53:01	\N	2026-08-07 01:44:08	2026-08-07 03:53:01
145	App\\Models\\User	2	auth_token	98da74793924d324f5f52bef392321726865ab7eca4cda33708f592ec635670a	["*"]	2026-08-13 23:57:19	\N	2026-08-13 23:56:56	2026-08-13 23:57:19
148	App\\Models\\User	2	auth_token	1e1459b34af7797fc1ca64feaa312b9656724378e70c5c44e06aa1a94e9c456a	["*"]	2026-08-14 00:47:34	\N	2026-08-14 00:44:15	2026-08-14 00:47:34
132	App\\Models\\User	2	auth_token	0cc53e7c4382a87d4352e86c852de0eb20658cb875bf2e161413cfc025dbf09b	["*"]	2026-08-14 01:07:39	\N	2026-08-10 00:11:21	2026-08-14 01:07:39
130	App\\Models\\User	2	auth_token	0d86d7ed5eb0b1a8e34dbef00703ed3e7e99d176361e3c38a08d45b9b87995cb	["*"]	2026-08-07 03:54:57	\N	2026-08-07 03:54:31	2026-08-07 03:54:57
142	App\\Models\\User	2	auth_token	0f0cc85bbf17068a47fefdca20f2bc65fba4fd2d36c4a0bd70ee3ef4d468b930	["*"]	2026-08-13 23:50:36	\N	2026-08-13 23:50:08	2026-08-13 23:50:36
136	App\\Models\\User	2	auth_token	3aa0dc6c2e3f0ffa94bc14a6076c1029d95dc5ff0502a205a22cd88b8ed6bfba	["*"]	2026-08-10 01:43:02	\N	2026-08-10 01:35:33	2026-08-10 01:43:02
131	App\\Models\\User	10	auth_token	24eb8b907d069d1ed95599a328b5a5dc068f17ebb90b96067acb017bfa24f777	["*"]	2026-08-07 03:55:41	\N	2026-08-07 03:55:23	2026-08-07 03:55:41
147	App\\Models\\User	2	auth_token	07983cb7e517c7e95baf845f9b28014282adb15e31854a14618b9754c22958d0	["*"]	2026-08-14 00:36:54	\N	2026-08-14 00:19:29	2026-08-14 00:36:54
134	App\\Models\\User	2	auth_token	8c4d750cd786b2e4b4875fa57170009506d2781634019c47298776ed9ca30267	["*"]	2026-08-10 01:32:25	\N	2026-08-10 01:02:37	2026-08-10 01:32:25
141	App\\Models\\User	10	auth_token	342af79c5d813647c015c2abd498d6aab9e5d16d78fc51dcbcdce4b53dc99751	["*"]	2026-08-11 01:55:29	\N	2026-08-11 01:50:56	2026-08-11 01:55:29
143	App\\Models\\User	10	auth_token	994b42eaafd118cac509efe3cc558b4492375ce16ce216ede0e80981329edcf5	["*"]	2026-08-13 23:54:31	\N	2026-08-13 23:54:15	2026-08-13 23:54:31
133	App\\Models\\User	2	auth_token	2b6c73bffb071d3dc70893bba654670e6ce4934cccc546ea060dab1c06489024	["*"]	2026-08-10 01:02:17	\N	2026-08-10 01:02:15	2026-08-10 01:02:17
137	App\\Models\\User	2	auth_token	0f7209ca46859d648f77aa91c51ba87d8ec0edbfc9cffbee462ae2ace31ab047	["*"]	2026-08-10 02:02:31	\N	2026-08-10 01:43:22	2026-08-10 02:02:31
139	App\\Models\\User	2	auth_token	3dd27d4f4322a05368dbf128a4dc4a5999c2c89329882471ccd0390ba1b921f3	["*"]	2026-08-10 02:23:59	\N	2026-08-10 02:04:55	2026-08-10 02:23:59
140	App\\Models\\User	2	auth_token	e3c5aaca58fcb0c536b0693e27320b02ebdee5b1eec499008bd3b189ee3d8bff	["*"]	2026-08-10 02:25:12	\N	2026-08-10 02:25:00	2026-08-10 02:25:12
146	App\\Models\\User	13	auth_token	e04b8e17ba2a38e489f5edd6e771d1faae229ba5af8af089a4118400b886de60	["*"]	2026-08-14 00:18:44	\N	2026-08-13 23:57:34	2026-08-14 00:18:44
138	App\\Models\\User	2	auth_token	1cf709c94ab8623ab0fac1ca35fb21157a32b02fea4e324ef9f9cc2fbae2c6e2	["*"]	2026-08-10 02:04:21	\N	2026-08-10 02:03:02	2026-08-10 02:04:21
144	App\\Models\\User	2	auth_token	7e0ba8c3f00ef029f666b30a739986044db028e1eca068d749df80f3997b38f5	["*"]	2026-08-13 23:55:04	\N	2026-08-13 23:54:43	2026-08-13 23:55:04
135	App\\Models\\User	2	auth_token	c8316a13899b494991ce7a92c22d0ac4e32106eca91feb04d7e395f606f4c797	["*"]	2026-08-10 01:33:55	\N	2026-08-10 01:32:51	2026-08-10 01:33:55
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
72xitibArpawLpgzdyE5ewx2EqtVPK6Nkhazfrp7	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiMmNERTI4bDJMa3pwY21Vb0pObGU4ZlJMU0JXQXo4MUY1VGh1cE9TRyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785896552
F4qz8Mkn03wvprHMCacnAdkTVIghvFzLBEjk5LsU	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiTTRNeVZZYTJzM0VaRjcwM0NoOEtHVnpuVlR4d3FEQlpKTEVaNm1qeiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785896598
NL40CKGPmXLIBzvaWHpho3V27BBmNl5cRB2UYrou	\N	127.0.0.1	Go-http-client/2.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiOTc2dDB4OUJPcTJXem5JMGJJVU9tQklKNkhvVzkxNDVqZzVwWXhJQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLm9ucmVuZGVyLmNvbSI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785896599
ROhB3HaV4ef9lPwdFQCITCmyV5bhSqisrnuGv2h4	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiTDZTQ0E4ZlkxVU54TFRUeWRZeEtZV3c1dDVCYU9jQ0plMVRydm9vWiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785896912
5kYywGpqSUSYzEma7B8R8TRzLOYUT6Rn0x0ospvS	\N	127.0.0.1	Go-http-client/2.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaThjWHNjYlZkTmZJSFVlbU5jQjJ1YkJQNzlFMXBwY05SWUlrT2V3TSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLm9ucmVuZGVyLmNvbSI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785896913
0kP2r86FVR43CWgU6k90oQgIVOEn5nkWoHhYAhiY	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiNGUzblNDek5XTlRVZG5HYkl5azRFQVFDOGtNOEQ0OUV1VXhDSzZ1TiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785977609
jaPl5xV5e821ndE9h4tO7tWkmo2NJJcjIlvc7hv5	\N	127.0.0.1	Go-http-client/2.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNnhSOUtTazBtM0pzekVOUThQeGE3ZEExZ2Vuc2loUUhnV2ZuaWtCUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLm9ucmVuZGVyLmNvbSI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785977610
ih4G7A8mBdFzs3XYFGQ31QZGqncKADFlDvOlSwxI	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiYW9qcENFRTF2VEUzMGpLcndHM1lDODlCeFVhRnVScndJbWtFbWtKMSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785987230
ST4YonZDkF2J36c9hAF7OTOvhKkKSq1TWMQAbRVP	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiTDlEWWpwaEVRaG52NGZmNU1jQTM1NnExRHdicHNPVlR4OVFpbDFHcCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1785987279
Aw7S8anpZPfYo2ROpF9ebBh7zcGebZwY3Z7eqXf6	\N	127.0.0.1	Go-http-client/2.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoidERoZlZTUnB2STdoSngxN3NKQWY5cUdFUm1TVTgxY0EyTHpTeU9QdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLWdwaXcub25yZW5kZXIuY29tIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1785987280
gpxc07CC9t9HRBSNdbSnitPZ3CEotuLSAhryO2tM	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoicVJ3eEhkVEZ0S1J6bHVmY0h3RHgwNDNVMzEyUmZ4NVRlS2k3eDhqSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLWdwaXcub25yZW5kZXIuY29tIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1785988044
LWilBKrnxiiNMZPjuyrGWiTilNhwJo6C5GRQaXSr	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoidUNOM3kwd0pZd3g3YzRtMjZjY1J6OVdPeXZzalkxNzR4UEwxbWVMOCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1786025689
ebP6hAZ1x8r9eRibnCE17D6JvcmKXh37QghTZm2w	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiUFI3TGtYTWdqaWltRk1VOFdwNjV4dnI5Q3h5eWhIQXFlN09tWW5wZyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1786025739
1rwBkN8zuPqHtzSjw6o2BwLNxnIXsgdhREqI6XgI	\N	127.0.0.1	Go-http-client/2.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiWWhpUmFLcHlzdU1hTE5ROHVRZUl3ZkJ5dHFEblFWN0JzSktlU0ZnWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLWIwMzcub25yZW5kZXIuY29tIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1786025743
GLmefkVRraCTwTzwX69RpZnYqU4m0AxsLV7Rr6j8	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiTDg1eGdlSm5KVEZEeW9wNFd1bThxT0U2bENOMUlSQVNTbndhdWo1ciI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1786065942
AUJbaasKI1W7GaUmtlHDN4L6H2zEuWrfmhTmUmKA	\N	127.0.0.1	Go-http-client/2.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoicXhyNTRIZE5FcDlDbkVVRjJDOTRjTjQ5M1RtVlZjVHZ2M3o5Zm93byI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLWIwMzcub25yZW5kZXIuY29tIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1786065950
DZpQ3Vx5tmGQNpJbezjBtuzYj1kpOjSuzKXKnprP	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiN0ZwQVZFV3p6dWFzZUw1akt2OFZ5Sm9vQ3g2dVY4aGMzbHEwQXMyYSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1786066179
W5ay2oUhnFnoqL1vwOQSA3qsRb5bGqohuqfH8XxL	\N	127.0.0.1	Go-http-client/2.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNmhyR2czYURqVG1ReVlVZ3RjSXR1NEo4c3BrM25EUzk4ZG5RZW5oMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLWIwMzcub25yZW5kZXIuY29tIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1786066180
Pn1TyB90b9rIRJc6IND9GIhDfSpHvNgqD2vs3Ac0	\N	127.0.0.1	curl/8.21.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiclNDRDBHQTJaWlI0TjZzOXRJdldWdnd3RXU1NWc4R0JOejdTa2FrciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLWIwMzcub25yZW5kZXIuY29tIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1786066437
12c3HBRFZC8JmeYm6gtsf5cvsMXzRUTycchON1r2	\N	127.0.0.1	Go-http-client/1.1	YToyOntzOjY6Il90b2tlbiI7czo0MDoiM2poZUVOWlB3Ynd2dzAxWTJSMlluanFIUkpPcmx5Yjk1UDRoR1RtSiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1786067958
udQjAqtegygu3ajxjnGKYxeq61i2MrlltqjDmlI2	\N	127.0.0.1	Go-http-client/2.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiN2hLbEV2UWRCWmpiYVdPNDhHM2N2Q2l4aGdxb25VOGg4Mk1mZ2kxRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLWIwMzcub25yZW5kZXIuY29tIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1786067959
RqFZ2nuMr6rVMkZTmEElDutf7lIapqKquhGU2Iom	\N	127.0.0.1	python-requests/2.32.5	YTozOntzOjY6Il90b2tlbiI7czo0MDoiS2RvcmQxQTd5bUJ3d3VQZnRwVFFoUjFFZEk5MWw4ejFHZHRXbUdkYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9hYnNlbnNpLWJhY2tlbmQtc21rLWIwMzcub25yZW5kZXIuY29tIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19	1786075282
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.students (id, nisn, name, classroom_id, created_at, updated_at, deleted_at, status, status_keterangan) FROM stdin;
78	0102652733	Andhika Radhitiya Nurahmattuloh	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
79	0106517535	FIRMAN NUR HERMAWAN	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
80	0105304939	GALANG ALDIANO PUTRA	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
81	0096620699	MUHAMMAD AMIRUL HAKIM	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
82	0105296284	MUHAMMAD RISQI AL JABARU	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
83	0091065644	RADITYA HANUNG BRAHMANTARA	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
84	0099899630	RONALD PERDANA KUSUMA	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
85	0096794950	SANDI LUTFIYO	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
86	0104705906	ADELIA SASKIA PUTRI	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
87	0093553507	Alya Juwita Pratama	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
88	0101541748	AMELIA FAIZATUL MAULIDYA	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
89	0096560558	AROFATUL MARDLIYAH	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
90	0097811519	ASVIRATUL MUTOHAROH	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
91	3097714983	AUDREY AUDRYA PUTRI LUKMAN	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
92	0107313589	CINDY EKA PUTRI	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
93	0098942288	Debby Warda Fannisa	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
94	0106879215	DECHA DWI KASIH	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
95	0086521755	DESI DWI ASTUTI	16	2026-08-14 00:19:47	2026-08-14 00:19:47	\N	Aktif	\N
96	0091070040	DISTA MELANY NATASYA	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
97	0099320073	Gebby Marwa Annisa	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
98	0108168253	LUTVY KHORYDATUN NABYLAH	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
99	3095079097	NADZIFA RISMATU AQILA	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
100	0095275609	NI'MA MAULIDIA OKTAVIA	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
101	0107271940	NI'MATUL KHOIRIYYAH	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
102	0086095569	OKTAVIA EKA FITRIYANI	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
103	0092176949	OKTAVIA EKA PERMATASARI	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
104	0105691497	RAVA APRILIA REMANDA	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
105	0101480146	SANIYATUN MAULIDA AFIYA	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
106	0088306899	Sebti Nikmasari	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
107	0108154403	SHAFA RAHMA WATI	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
108	3097314725	ULFA KAROMATUL FAJRIN	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
109	0101794072	VARA DINI VINATA	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
110	0099756422	VIVI OLI VIYA	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
111	0094233970	Wulan	16	2026-08-14 00:19:48	2026-08-14 00:19:48	\N	Aktif	\N
112	0095877060	ADI MALIKI	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
113	0092464169	AHMAD NUR DIANSYAH PUTRA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
114	0099580262	ALDI KUSUMA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
115	0106483458	Aldino Cahayafi	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
116	0103171843	ANGGA EKA SADEWA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
117	0092132565	Anggada Cucu Bikara	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
118	0095162741	ARJUNA RAMADANI	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
119	0105450372	DHAFA FYVAUL MAULLA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
120	0082863394	DIKI SAPUTRA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
121	0108432880	DIMAS AGENG NOVIANTO	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
122	0098886238	Dino Wafiki Aldiansyah	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
123	0095852603	Fabian Wisnutama	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
124	0093368961	FAIZ ZAKI RAMADHAN	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
125	0101122493	HAIDAR NASRULLOH	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
126	0106527588	IRFAN MAULANA RAHMADANI	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
127	0095648409	IRVAN	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
128	0103492649	JERRY AGUSTIAN	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
129	0098405302	KELVIN ALVERNANDO	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
130	0093084599	LUBAIBIL ASROR HABIB ARIF MUHAMMAD	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
131	0106076220	MARKHABAN ZAIDUN NI'AM	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
132	0092707279	Mijaya Ningrum	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
133	0101819540	MUHAMAD NASA ALDIANSYAH	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
134	0108590654	MUHAMMAD AZIZUL IQBAL FAHRONI	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
135	0103708182	NANDA DIAN SATRIA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
136	0095921764	NOVANDA DEVINO ARIANTO	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
137	0084376023	RENDY CHOIRUL ROZIKIN	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
138	0098095203	REYZA PUTRA PRATAMA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
139	0093305629	RIZKY ADI PRATAMA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
140	0096173598	YOGA PRATAMA	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
141	0096265629	ZAINUL ARIFIN	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
142	0102135982	SENTIA ANGGREENI	15	2026-08-14 00:20:19	2026-08-14 00:20:19	\N	Aktif	\N
143	0088966353	Agus Suhartono	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
144	0099368826	BIYANTO	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
145	0091788107	DETA NAKIA MELVANA	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
146	0102153283	RANGGA ADI SAPUTRA	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
147	0083825737	Rofik Adhianto	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
148	0096516701	ARIYANTI ROSSIANA	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
149	0095861337	DEVINTHA ANGNESIA EKA PUTRI	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
150	0108007607	ENANG SULAEMIN IDAYANI	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
151	0103009228	Erlinda Ayuningtyas	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
152	0104463381	FINA TRI WAHYUNI	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
153	0087281140	GITA KUMALASARI	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
154	0104880605	LINA ANGGRAENI	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
155	0104207829	MEYTHA INDRIANI	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
156	0086268141	NOR KHOLIFFAH	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
157	0097826602	OKTAVIA DWI INDRIANI	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
158	0099492404	PUTRI ANGGUN FITRIANI	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
159	0091328672	Resa Maulidia	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
160	0097467938	SHELLA DECHA CINDY AULIA	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
161	0093828777	TIAS NAURA MADHAN	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
162	0094368781	ZAHROTUL JANNAH	14	2026-08-14 00:21:05	2026-08-14 00:21:05	\N	Aktif	\N
163	0102060954	ACHMAD ANWARUL FADHIL	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
164	0092039566	ADE WAHYU NUGROHO	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
165	0105073993	ALEXXA DIMAS NANDA SAPUTRA	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
166	0109421766	ALMI VALENTINO PRATAMA	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
167	0097361165	Cahya Aldi Firdiansyah	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
168	0097860550	DEDEK ALDI JIWANTORO	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
169	0086219879	FAREL FURI FERDIANSAH	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
170	0083345209	FARIQUL HUDA	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
171	0084325054	HANDRIX EXGRIYAN	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
172	0093378172	LAZUARDI YUDISTIRA REVINO	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
173	0091236269	MARIADI	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
174	0092255842	Muhamad Ridho Pratama Putra	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
175	0099701759	MUHAMMAD FA'IZUL FATHIR	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
176	0081390293	Muhammad Fadilah Alfiqi	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
177	0106932632	MUHAMMAD HABIB ABDILLAH	19	2026-08-14 00:21:30	2026-08-14 00:35:55	\N	Aktif	\N
178	0097315259	MUHAMMAD MASRIFAL FARDANI	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
179	0096272526	MUHAMMAD MUSA JANKY DAUSATS ALMAHFUUDH	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
180	0096041587	MUHAMMAD YUSUF NASHRUDINULLOH	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
181	0082245347	MUKHAMAD KHOIRUL ANAM	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
182	0095436204	NIKO SAPUTRA	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
183	0091568185	OCHA SETIAWAN	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
184	0101689091	PANGESTU BUYUNG WIBISONO	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
185	0118847322	PURNIAWAN BENI WAHYUDI	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
186	0099385047	RADITIA EKA PRADANA	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
187	0096482282	RAFAEL AHMAD FAHREZA	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
188	0096776736	REHAN MAULANA	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
189	0098539073	RENDI KHOLIDATUL FAHRI	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
190	0099641313	REVANO PRANATA ABDILLAH	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
191	0096074669	REZALUL MUTTAQIN	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
192	0095659727	VEBIANO FELIX SUBASTIAN	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
193	0101923113	YOGA SOLMA DASIN	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
194	0093385777	YOGINDA RIZKI	19	2026-08-14 00:21:31	2026-08-14 00:35:55	\N	Aktif	\N
195	0074188777	Adit Tiya	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
196	0085533363	RAYHAN NUR FATURROHMAN	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
197	0081652493	ALIVYA PELANGI DINDA CAHYANI	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
198	0089171835	ANANDA SERLEY	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
199	0097151993	AUREL AINUN NISA	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
200	0077624483	DWI RAHMADANI	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
201	3087494659	GISKA RAYA VANESYA	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
202	0084076466	LAILI AMANDA PUTRI RAMADHANI	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
203	0098776551	LUTFIANA	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
204	0084759265	NATASYA PUTRI YULIA	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
205	0089756391	NIKMATUL KHOIRIYAH	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
206	0099977300	NINA FEBRIKA RISTI	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
207	0081405413	Savitri	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
208	0088523242	SILVI	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
209	0089088858	SINDI ULIFATUL NABILA	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
210	0088156584	TANIA VITRIANA	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
211	0082304931	VENI WIDHAYANTI	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
212	0151261204	ZARA ANGGRA ZAHRA	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
213	3092516733	ZELFI LUTFIA MAHARANI	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
214	3093003782	ZHELVA YUSRAN DWI AMELIA	20	2026-08-14 00:36:13	2026-08-14 00:36:13	\N	Aktif	\N
215	0089867188	ACHXELL ADE NUGROHO	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
216	0072435021	Agustiyan Haikal Fais	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
217	3093036966	AHMAD JESSEN KURNIAWAN	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
218	0082697784	AJI PANGESTU MULYO	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
219	0082186242	AKBAR RAFILA DIBA	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
220	0093802197	DZALLU AKBAR SATRIA	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
221	3085234160	FARHAN SUKRON JAZILAN	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
222	0093733763	FEBIO ARIL DEFETRA	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
223	0061004146	FIQHI HERDIANSAH ADITYA LUKIAWAN	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
224	0092029857	FIRMAN DWI ANUGRAH	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
225	0082953280	GALIH FATWA RIZAL	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
226	0097345488	Lutfi Dafa Alfianto	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
227	0081819993	M ZIDAN NURIL FAHMI AB-ROR	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
228	0095575663	MARIO NAUFAL MAULANA	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
229	0087849037	MOCH ABI FAHRUR RAHMAN	21	2026-08-14 00:36:29	2026-08-14 00:36:29	\N	Aktif	\N
230	0081377636	NAYANDRA SATRIA PUTRA	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
231	0094884934	NOVAL WIBISANGKA	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
232	0083421787	NUR HUDA	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
233	0078726676	RAFEL ADI OCTAFIAN	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
234	0084102421	REHAN ZAENAL ALIM	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
235	0084117822	RENO SATRIYO PRATAMA	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
236	0076353858	REVA FAVIAN VEDORA	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
237	0089736394	WILLY CAHYA SAPUTRA HARIYANTO	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
238	0091206832	YOVAL EKI PRATAMA	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
239	0096053613	ZALVA CHOIRUL ANAM	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
240	0067379467	Siti Nurahma	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
241	0099432176	YESI SELIYA MUFITASARI	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
242	3099161441	YEZA LINDA CANTIKA	21	2026-08-14 00:36:30	2026-08-14 00:36:30	\N	Aktif	\N
243	0091907597	ALVINO ELANG DISTARA	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
244	0084222590	APRILIANDRA PURNAMAHADI	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
245	0056663187	ARIF ANGGARA	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
246	0094260908	ARIFATUS SOFYAN	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
247	0093440992	ARIS ANDRIAN KURNIAWAN	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
248	0081080889	AZAQI NIKO FIRDAUS	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
249	0081282603	Dava Aldi Saputra	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
250	0064460398	DHAVA KRIZNA ADHI NANTA	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
251	0091422780	DIMAS ALDI KURNIAWAN	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
252	0084509217	EKA KRISDIANSYAH	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
253	0098904086	Esa Nur Rohman	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
254	0075970058	EXSAN PUTRA RAMADI	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
255	0096587283	GUSTIAR BIMA FADHIL ELALAMSYAH	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
256	0097037311	HELMI ILYAS	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
257	0093338793	JEYSEN DWI SAPUTRA	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
258	0095141728	LINGGA AFRILIAN PRATAMA	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
259	0092177338	LUFFY APRILLIANTSYAH	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
260	3085887437	MOHAMAD NUURAN WAFII B	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
261	0097617514	MUHAMMAD FARID ARDIANSYAH	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
262	0094194924	MUHAMMAD MEi YUNUS	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
263	0088487228	NANDO ABDI MUHAMAD SHOLEH	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
264	0097758502	REFAN ALDIANO	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
265	0082127260	Riki Ardiansyah	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
266	0095298906	TEGAR BAGAS PRASETIO	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
267	0082943411	ANANDA DEWI GITA	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
268	0151978242	DENISTYA EKA PRATAMA	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
269	0089086580	SILVIA PUTRI RAHMADHANI	22	2026-08-14 00:36:40	2026-08-14 00:36:40	\N	Aktif	\N
\.


--
-- Data for Name: subject_jurusan; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.subject_jurusan (id, subject_id, classroom_id, created_at, updated_at) FROM stdin;
1	1	14	\N	\N
2	2	14	\N	\N
3	3	14	\N	\N
4	4	16	\N	\N
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.subjects (id, kode_mapel, nama_mapel, created_at, updated_at) FROM stdin;
1	MAT-10A	Matematika	2026-07-25 07:27:50	2026-07-25 07:27:50
3	BINA-10A	Bahasa Indonesia	2026-07-26 05:15:02	2026-07-26 05:15:02
2	BING-10A	Bahasa Inggris	2026-07-25 07:30:59	2026-07-25 07:30:59
4	IPA-11	Ilmu Pengetahuan Alam 11	2026-07-27 04:06:00	2026-07-27 04:06:00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at, classroom_id, role, status, kelas) FROM stdin;
2	admin	admin@sekolah.com	\N	$2y$12$dwCHTmwFtVYXo61ad4jFU.BG0u24sBlMGBi3oijK.UKAbXAriD1wi	\N	2026-07-25 07:25:00	2026-08-05 02:47:03	\N	admin	active	10 RPL
10	alfa1	alfa1@sekolah.com	\N	$2y$12$x34hTxOLyxco9d1B/EndL.zyiKC79BC590Fhogyej6Da/0d0QqUii	\N	2026-07-27 01:16:01	2026-08-06 01:01:05	14	wali_kelas	active	\N
8	sarpras	sarpras@sekolah.com	\N	$2y$12$iES/maO/MlvEYSqENUNPnOBtsac4MsVdMUt5eB9Tw5qu3g6glwYYK	\N	2026-07-25 07:35:00	2026-08-06 01:02:39	\N	sarpras	active	\N
13	guru	guru@sekolah.com	\N	$2y$12$BHCxAGWJqKsmK1iZOkKvKudRoWxMsOA/8fLvN30Y5G0ymqYQWXKoK	\N	2026-08-13 23:56:06	2026-08-13 23:57:08	\N	guru_mapel	active	\N
4	pida	pida@sekolah.com	\N	$2y$04$wV2zcdTiBKDICHTn0efBuOSf5OMJeEtr3bAgEeKq4CNjFgFJf8mGi	\N	2026-07-25 09:00:09	2026-07-29 01:22:34	15	wali_kelas	active	12 RPL
\.


--
-- Data for Name: violations; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.violations (id, student_id, academic_year_id, created_by, date, type, notes, created_at, updated_at) FROM stdin;
\.


--
-- Name: academic_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.academic_batches_id_seq', 5, true);


--
-- Name: academic_years_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.academic_years_id_seq', 4, true);


--
-- Name: attendances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.attendances_id_seq', 42, true);


--
-- Name: classrooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.classrooms_id_seq', 22, true);


--
-- Name: inventaris_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.inventaris_id_seq', 2, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.migrations_id_seq', 15, true);


--
-- Name: peminjaman_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.peminjaman_id_seq', 1, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 148, true);


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.students_id_seq', 269, true);


--
-- Name: subject_jurusan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.subject_jurusan_id_seq', 4, true);


--
-- Name: subjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.subjects_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.users_id_seq', 13, true);


--
-- Name: violations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.violations_id_seq', 1, false);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: invitation invitation_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT invitation_pkey PRIMARY KEY (id);


--
-- Name: jwks jwks_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.jwks
    ADD CONSTRAINT jwks_pkey PRIMARY KEY (id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: organization organization_slug_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.organization
    ADD CONSTRAINT organization_slug_key UNIQUE (slug);


--
-- Name: project_config project_config_endpoint_id_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.project_config
    ADD CONSTRAINT project_config_endpoint_id_key UNIQUE (endpoint_id);


--
-- Name: project_config project_config_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.project_config
    ADD CONSTRAINT project_config_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: session session_token_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT session_token_key UNIQUE (token);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: verification verification_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.verification
    ADD CONSTRAINT verification_pkey PRIMARY KEY (id);


--
-- Name: academic_batches academic_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.academic_batches
    ADD CONSTRAINT academic_batches_pkey PRIMARY KEY (id);


--
-- Name: academic_years academic_years_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.academic_years
    ADD CONSTRAINT academic_years_pkey PRIMARY KEY (id);


--
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: classrooms classrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.classrooms
    ADD CONSTRAINT classrooms_pkey PRIMARY KEY (id);


--
-- Name: inventaris inventaris_kode_unique; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.inventaris
    ADD CONSTRAINT inventaris_kode_unique UNIQUE (kode);


--
-- Name: inventaris inventaris_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.inventaris
    ADD CONSTRAINT inventaris_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: peminjaman peminjaman_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.peminjaman
    ADD CONSTRAINT peminjaman_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: students students_nisn_unique; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_nisn_unique UNIQUE (nisn);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: subject_jurusan subject_jurusan_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.subject_jurusan
    ADD CONSTRAINT subject_jurusan_pkey PRIMARY KEY (id);


--
-- Name: subjects subjects_kode_mapel_unique; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_kode_mapel_unique UNIQUE (kode_mapel);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: violations violations_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_pkey PRIMARY KEY (id);


--
-- Name: account_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "account_userId_idx" ON neon_auth.account USING btree ("userId");


--
-- Name: invitation_email_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX invitation_email_idx ON neon_auth.invitation USING btree (email);


--
-- Name: invitation_organizationId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "invitation_organizationId_idx" ON neon_auth.invitation USING btree ("organizationId");


--
-- Name: member_organizationId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "member_organizationId_idx" ON neon_auth.member USING btree ("organizationId");


--
-- Name: member_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "member_userId_idx" ON neon_auth.member USING btree ("userId");


--
-- Name: organization_slug_uidx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE UNIQUE INDEX organization_slug_uidx ON neon_auth.organization USING btree (slug);


--
-- Name: session_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "session_userId_idx" ON neon_auth.session USING btree ("userId");


--
-- Name: verification_identifier_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX verification_identifier_idx ON neon_auth.verification USING btree (identifier);


--
-- Name: attendances_date_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX attendances_date_index ON public.attendances USING btree (date);


--
-- Name: attendances_student_id_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX attendances_student_id_index ON public.attendances USING btree (student_id);


--
-- Name: attendances_subject_id_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX attendances_subject_id_index ON public.attendances USING btree (subject_id);


--
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: students_classroom_id_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX students_classroom_id_index ON public.students USING btree (classroom_id);


--
-- Name: account account_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.account
    ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: invitation invitation_inviterId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT "invitation_inviterId_fkey" FOREIGN KEY ("inviterId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: invitation invitation_organizationId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT "invitation_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES neon_auth.organization(id) ON DELETE CASCADE;


--
-- Name: member member_organizationId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT "member_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES neon_auth.organization(id) ON DELETE CASCADE;


--
-- Name: member member_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT "member_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: session session_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: attendances attendances_academic_year_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_academic_year_id_foreign FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id) ON DELETE CASCADE;


--
-- Name: attendances attendances_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: attendances attendances_student_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_student_id_foreign FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: attendances attendances_subject_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_subject_id_foreign FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: classrooms classrooms_academic_batch_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.classrooms
    ADD CONSTRAINT classrooms_academic_batch_id_foreign FOREIGN KEY (academic_batch_id) REFERENCES public.academic_batches(id) ON DELETE SET NULL;


--
-- Name: peminjaman peminjaman_inventaris_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.peminjaman
    ADD CONSTRAINT peminjaman_inventaris_id_foreign FOREIGN KEY (inventaris_id) REFERENCES public.inventaris(id) ON DELETE CASCADE;


--
-- Name: students students_classroom_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_classroom_id_foreign FOREIGN KEY (classroom_id) REFERENCES public.classrooms(id);


--
-- Name: subject_jurusan subject_jurusan_classroom_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.subject_jurusan
    ADD CONSTRAINT subject_jurusan_classroom_id_foreign FOREIGN KEY (classroom_id) REFERENCES public.classrooms(id) ON DELETE CASCADE;


--
-- Name: subject_jurusan subject_jurusan_subject_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.subject_jurusan
    ADD CONSTRAINT subject_jurusan_subject_id_foreign FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: users users_classroom_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_classroom_id_foreign FOREIGN KEY (classroom_id) REFERENCES public.classrooms(id) ON DELETE SET NULL;


--
-- Name: violations violations_academic_year_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_academic_year_id_foreign FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id);


--
-- Name: violations violations_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: violations violations_student_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_student_id_foreign FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO authenticated;


--
-- Name: SCHEMA pgrst; Type: ACL; Schema: -; Owner: neon_service
--

GRANT USAGE ON SCHEMA pgrst TO authenticator;


--
-- Name: FUNCTION pre_config(); Type: ACL; Schema: pgrst; Owner: neon_service
--

GRANT ALL ON FUNCTION pgrst.pre_config() TO authenticator;


--
-- Name: TABLE academic_batches; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.academic_batches TO authenticated;


--
-- Name: SEQUENCE academic_batches_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.academic_batches_id_seq TO authenticated;


--
-- Name: TABLE academic_years; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.academic_years TO authenticated;


--
-- Name: SEQUENCE academic_years_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.academic_years_id_seq TO authenticated;


--
-- Name: TABLE attendances; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.attendances TO authenticated;


--
-- Name: SEQUENCE attendances_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.attendances_id_seq TO authenticated;


--
-- Name: TABLE cache; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cache TO authenticated;


--
-- Name: TABLE cache_locks; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cache_locks TO authenticated;


--
-- Name: TABLE classrooms; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.classrooms TO authenticated;


--
-- Name: SEQUENCE classrooms_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.classrooms_id_seq TO authenticated;


--
-- Name: TABLE inventaris; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.inventaris TO authenticated;


--
-- Name: SEQUENCE inventaris_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.inventaris_id_seq TO authenticated;


--
-- Name: TABLE migrations; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.migrations TO authenticated;


--
-- Name: SEQUENCE migrations_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.migrations_id_seq TO authenticated;


--
-- Name: TABLE password_reset_tokens; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.password_reset_tokens TO authenticated;


--
-- Name: TABLE peminjaman; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.peminjaman TO authenticated;


--
-- Name: SEQUENCE peminjaman_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.peminjaman_id_seq TO authenticated;


--
-- Name: TABLE personal_access_tokens; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.personal_access_tokens TO authenticated;


--
-- Name: SEQUENCE personal_access_tokens_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.personal_access_tokens_id_seq TO authenticated;


--
-- Name: TABLE sessions; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sessions TO authenticated;


--
-- Name: TABLE students; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.students TO authenticated;


--
-- Name: SEQUENCE students_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.students_id_seq TO authenticated;


--
-- Name: TABLE subject_jurusan; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.subject_jurusan TO authenticated;


--
-- Name: SEQUENCE subject_jurusan_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.subject_jurusan_id_seq TO authenticated;


--
-- Name: TABLE subjects; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.subjects TO authenticated;


--
-- Name: SEQUENCE subjects_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.subjects_id_seq TO authenticated;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO authenticated;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.users_id_seq TO authenticated;


--
-- Name: TABLE violations; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.violations TO authenticated;


--
-- Name: SEQUENCE violations_id_seq; Type: ACL; Schema: public; Owner: neondb_owner
--

GRANT USAGE ON SEQUENCE public.violations_id_seq TO authenticated;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: neondb_owner
--

ALTER DEFAULT PRIVILEGES FOR ROLE neondb_owner IN SCHEMA public GRANT USAGE ON SEQUENCES TO authenticated;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: neondb_owner
--

ALTER DEFAULT PRIVILEGES FOR ROLE neondb_owner IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: neondb_owner
--

ALTER DEFAULT PRIVILEGES FOR ROLE neondb_owner IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO authenticated;


--
-- PostgreSQL database dump complete
--

\unrestrict 5jtN1nOzEMNSA5TZy8QuZgagMIFF9GIxQx1Q8Gy7vX2K2qtDs4G2zfPg0z5NBn4

