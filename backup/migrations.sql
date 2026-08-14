-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS migrations_id_seq;

-- Table Definition
CREATE TABLE "public"."migrations" (
    "id" int4 NOT NULL DEFAULT nextval('migrations_id_seq'::regclass),
    "migration" varchar(255) NOT NULL,
    "batch" int4 NOT NULL,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."migrations" ("id", "migration", "batch") VALUES
(1, '0001_01_00_000000_create_subjects_table', 1),
(2, '0001_01_01_000000_create_users_table', 1),
(3, '0001_01_01_000001_create_cache_table', 1),
(4, '0001_01_01_000002_create_jobs_table', 1),
(5, '2026_07_22_031048_add_role_to_users_table', 1),
(6, '2026_07_22_040824_create_personal_access_tokens_table', 1),
(7, '2026_07_23_004150_add_status_and_kelas_to_users_table', 1),
(8, '2026_07_25_065807_create_subject_jurusan_table', 2),
(9, '2026_07_25_135652_create_academic_batches_table', 3),
(10, '2026_07_26_033259_add_indexes_to_tables', 4),
(11, '2026_07_26_044000_add_status_and_keterangan_to_students_table', 5),
(12, '2026_07_27_041629_add_academic_batch_id_to_classrooms_table', 6),
(13, '2026_08_03_013249_make_subject_id_nullable_on_attendances_table', 7),
(14, '2026_08_07_000001_create_inventaris_table', 8),
(15, '2026_08_07_000002_create_peminjaman_table', 8);