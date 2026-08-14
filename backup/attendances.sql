-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS attendances_id_seq;

-- Table Definition
CREATE TABLE "public"."attendances" (
    "id" int8 NOT NULL DEFAULT nextval('attendances_id_seq'::regclass),
    "student_id" int8 NOT NULL,
    "subject_id" int8,
    "academic_year_id" int8 NOT NULL,
    "created_by" int8,
    "date" date NOT NULL,
    "status" varchar(255) NOT NULL,
    "notes" text,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    PRIMARY KEY ("id")
);



-- Indices
CREATE INDEX attendances_date_index ON public.attendances USING btree (date);
CREATE INDEX attendances_student_id_index ON public.attendances USING btree (student_id);
CREATE INDEX attendances_subject_id_index ON public.attendances USING btree (subject_id);

ALTER TABLE "public"."attendances" ADD FOREIGN KEY ("subject_id") REFERENCES "public"."subjects"("id") ON DELETE CASCADE;

ALTER TABLE "public"."attendances" ADD FOREIGN KEY ("student_id") REFERENCES "public"."students"("id") ON DELETE CASCADE;

ALTER TABLE "public"."attendances" ADD FOREIGN KEY ("academic_year_id") REFERENCES "public"."academic_years"("id") ON DELETE CASCADE;

ALTER TABLE "public"."attendances" ADD FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL;

