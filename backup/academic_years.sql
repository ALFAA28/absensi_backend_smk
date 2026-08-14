-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS academic_years_id_seq;

-- Table Definition
CREATE TABLE "public"."academic_years" (
    "id" int8 NOT NULL DEFAULT nextval('academic_years_id_seq'::regclass),
    "year" varchar(255) NOT NULL,
    "semester" varchar(255) NOT NULL,
    "is_active" bool NOT NULL DEFAULT false,
    "created_at" timestamp(0) DEFAULT now(),
    "updated_at" timestamp(0) DEFAULT now(),
    PRIMARY KEY ("id")
);

INSERT INTO "public"."academic_years" ("id", "year", "semester", "is_active", "created_at", "updated_at") VALUES
(4, '2025/2026', 'Odd', 't', '2026-07-25 13:49:44', '2026-07-25 13:49:44');