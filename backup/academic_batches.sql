-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS academic_batches_id_seq;

-- Table Definition
CREATE TABLE "public"."academic_batches" (
    "id" int8 NOT NULL DEFAULT nextval('academic_batches_id_seq'::regclass),
    "name" varchar(255) NOT NULL,
    "year" varchar(255) NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    PRIMARY KEY ("id")
);

INSERT INTO "public"."academic_batches" ("id", "name", "year", "created_at", "updated_at") VALUES
(1, 'ANGKATAN 2026', '2026/2027', '2026-07-25 14:09:05', '2026-08-14 00:44:34');