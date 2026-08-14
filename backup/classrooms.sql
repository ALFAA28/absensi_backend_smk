-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS classrooms_id_seq;

-- Table Definition
CREATE TABLE "public"."classrooms" (
    "id" int8 NOT NULL DEFAULT nextval('classrooms_id_seq'::regclass),
    "name" varchar(255) NOT NULL,
    "grade" varchar(255) NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    "singkatan" varchar(255),
    "academic_batch_id" int8,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."classrooms" ("id", "name", "grade", "created_at", "updated_at", "singkatan", "academic_batch_id") VALUES
(14, 'Layanan Penunjang Keperawatan dan Caregiving 11', '10', '2026-07-25 15:31:01', '2026-08-14 00:16:40', 'LPKC-11', 1),
(15, 'Teknik Kendaraan Ringan 11A', '10', '2026-07-26 04:04:06', '2026-08-14 00:16:27', 'TKR-11A', 1),
(16, 'Desain Komunikasi Visual 11', '10', '2026-07-27 02:15:20', '2026-08-14 00:45:19', 'DKV-11', 1),
(18, 'Teknik Kendaraan Ringan 11B', '10', '2026-08-14 00:17:34', '2026-08-14 00:17:34', 'TKR-11B', 1),
(19, 'Desain Komunikasi Visual 12', '10', '2026-08-14 00:31:35', '2026-08-14 00:31:35', 'DKV-12', 1),
(20, 'Layanan Penunjang Keperawatan dan Caregiving 12', '10', '2026-08-14 00:32:15', '2026-08-14 00:32:15', 'LPKC-12', 1),
(21, 'Teknik Kendaraan Ringan 12A', '10', '2026-08-14 00:33:00', '2026-08-14 00:33:00', 'TKR-12A', 1),
(22, 'Teknik Kendaraan Ringan 12B', '10', '2026-08-14 00:33:34', '2026-08-14 00:33:34', 'TKR-12B', 1);

ALTER TABLE "public"."classrooms" ADD FOREIGN KEY ("academic_batch_id") REFERENCES "public"."academic_batches"("id") ON DELETE SET NULL;

