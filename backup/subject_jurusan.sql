-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS subject_jurusan_id_seq;

-- Table Definition
CREATE TABLE "public"."subject_jurusan" (
    "id" int8 NOT NULL DEFAULT nextval('subject_jurusan_id_seq'::regclass),
    "subject_id" int8 NOT NULL,
    "classroom_id" int8 NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    PRIMARY KEY ("id")
);

INSERT INTO "public"."subject_jurusan" ("id", "subject_id", "classroom_id", "created_at", "updated_at") VALUES
(1, 1, 14, NULL, NULL),
(2, 2, 14, NULL, NULL),
(3, 3, 14, NULL, NULL),
(4, 4, 16, NULL, NULL);

ALTER TABLE "public"."subject_jurusan" ADD FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id") ON DELETE CASCADE;

ALTER TABLE "public"."subject_jurusan" ADD FOREIGN KEY ("classroom_id") REFERENCES "public"."classrooms"("id") ON DELETE CASCADE;

