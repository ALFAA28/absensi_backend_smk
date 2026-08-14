-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS inventaris_id_seq;

-- Table Definition
CREATE TABLE "public"."inventaris" (
    "id" int8 NOT NULL DEFAULT nextval('inventaris_id_seq'::regclass),
    "kode" varchar(255) NOT NULL,
    "nama" varchar(255) NOT NULL,
    "kategori" varchar(255) NOT NULL,
    "jumlah" int4 NOT NULL DEFAULT 0,
    "kondisi" varchar(255) NOT NULL DEFAULT 'Baik'::character varying,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    PRIMARY KEY ("id")
);

INSERT INTO "public"."inventaris" ("id", "kode", "nama", "kategori", "jumlah", "kondisi", "created_at", "updated_at") VALUES
(1, 'PJT-001', 'Epson X600', 'Elektronik', 10, 'Baik', '2026-08-07 02:23:31', '2026-08-07 02:24:58'),
(2, 'SPK-001', 'Crimson PA15 2E', 'Elektronik', 2, 'Baik', '2026-08-07 02:35:25', '2026-08-07 02:35:25');

-- Indices
CREATE UNIQUE INDEX inventaris_kode_unique ON public.inventaris USING btree (kode);

