-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS violations_id_seq;

-- Table Definition
CREATE TABLE "public"."violations" (
    "id" int8 NOT NULL DEFAULT nextval('violations_id_seq'::regclass),
    "student_id" int8 NOT NULL,
    "academic_year_id" int8 NOT NULL,
    "created_by" int8 NOT NULL,
    "date" date NOT NULL,
    "type" varchar(255) NOT NULL,
    "notes" text,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    PRIMARY KEY ("id")
);



ALTER TABLE "public"."violations" ADD FOREIGN KEY ("student_id") REFERENCES "public"."students"("id");

ALTER TABLE "public"."violations" ADD FOREIGN KEY ("academic_year_id") REFERENCES "public"."academic_years"("id");

ALTER TABLE "public"."violations" ADD FOREIGN KEY ("created_by") REFERENCES "public"."users"("id");

