-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS users_id_seq;

-- Table Definition
CREATE TABLE "public"."users" (
    "id" int8 NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    "name" varchar(255) NOT NULL,
    "email" varchar(255) NOT NULL,
    "email_verified_at" timestamp(0),
    "password" varchar(255) NOT NULL,
    "remember_token" varchar(100),
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    "classroom_id" int8,
    "role" varchar(255) NOT NULL DEFAULT 'guru'::character varying,
    "status" varchar(255) NOT NULL DEFAULT 'pending'::character varying,
    "kelas" varchar(255),
    PRIMARY KEY ("id")
);

INSERT INTO "public"."users" ("id", "name", "email", "email_verified_at", "password", "remember_token", "created_at", "updated_at", "classroom_id", "role", "status", "kelas") VALUES
(2, 'admin', 'admin@sekolah.com', NULL, '$2y$12$dwCHTmwFtVYXo61ad4jFU.BG0u24sBlMGBi3oijK.UKAbXAriD1wi', NULL, '2026-07-25 07:25:00', '2026-08-05 02:47:03', NULL, 'admin', 'active', '10 RPL'),
(4, 'pida', 'pida@sekolah.com', NULL, '$2y$04$wV2zcdTiBKDICHTn0efBuOSf5OMJeEtr3bAgEeKq4CNjFgFJf8mGi', NULL, '2026-07-25 09:00:09', '2026-07-29 01:22:34', 15, 'wali_kelas', 'active', '12 RPL'),
(8, 'sarpras', 'sarpras@sekolah.com', NULL, '$2y$12$iES/maO/MlvEYSqENUNPnOBtsac4MsVdMUt5eB9Tw5qu3g6glwYYK', NULL, '2026-07-25 07:35:00', '2026-08-06 01:02:39', NULL, 'sarpras', 'active', NULL),
(10, 'alfa1', 'alfa1@sekolah.com', NULL, '$2y$12$x34hTxOLyxco9d1B/EndL.zyiKC79BC590Fhogyej6Da/0d0QqUii', NULL, '2026-07-27 01:16:01', '2026-08-06 01:01:05', 14, 'wali_kelas', 'active', NULL),
(13, 'guru', 'guru@sekolah.com', NULL, '$2y$12$BHCxAGWJqKsmK1iZOkKvKudRoWxMsOA/8fLvN30Y5G0ymqYQWXKoK', NULL, '2026-08-13 23:56:06', '2026-08-13 23:57:08', NULL, 'guru_mapel', 'active', NULL);

-- Indices
CREATE UNIQUE INDEX users_email_unique ON public.users USING btree (email);

ALTER TABLE "public"."users" ADD FOREIGN KEY ("classroom_id") REFERENCES "public"."classrooms"("id") ON DELETE SET NULL;

