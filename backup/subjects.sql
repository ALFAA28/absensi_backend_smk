-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS subjects_id_seq;

-- Table Definition
CREATE TABLE "public"."subjects" (
    "id" int8 NOT NULL DEFAULT nextval('subjects_id_seq'::regclass),
    "kode_mapel" varchar(255) NOT NULL,
    "nama_mapel" varchar(255) NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    PRIMARY KEY ("id")
);

INSERT INTO "public"."subjects" ("id", "kode_mapel", "nama_mapel", "created_at", "updated_at") VALUES
(1, 'MAT-10A', 'Matematika', '2026-07-25 07:27:50', '2026-07-25 07:27:50'),
(2, 'BING-10A', 'Bahasa Inggris', '2026-07-25 07:30:59', '2026-07-25 07:30:59'),
(3, 'BINA-10A', 'Bahasa Indonesia', '2026-07-26 05:15:02', '2026-07-26 05:15:02'),
(4, 'IPA-11', 'Ilmu Pengetahuan Alam 11', '2026-07-27 04:06:00', '2026-07-27 04:06:00');

-- Indices
CREATE UNIQUE INDEX subjects_kode_mapel_unique ON public.subjects USING btree (kode_mapel);

