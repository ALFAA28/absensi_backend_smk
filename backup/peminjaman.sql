-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS peminjaman_id_seq;

-- Table Definition
CREATE TABLE "public"."peminjaman" (
    "id" int8 NOT NULL DEFAULT nextval('peminjaman_id_seq'::regclass),
    "inventaris_id" int8 NOT NULL,
    "nama_peminjam" varchar(255) NOT NULL,
    "tanggal_pinjam" date NOT NULL,
    "jumlah" int4 NOT NULL DEFAULT 1,
    "keterangan" text,
    "status" varchar(255) NOT NULL DEFAULT 'Sedang Dipinjam'::character varying,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    PRIMARY KEY ("id")
);

INSERT INTO "public"."peminjaman" ("id", "inventaris_id", "nama_peminjam", "tanggal_pinjam", "jumlah", "keterangan", "status", "created_at", "updated_at") VALUES
(1, 1, 'alfa', '2026-08-07', 1, 'digunakan untuk mengajar DKV-11', 'Dikembalikan', '2026-08-07 02:24:30', '2026-08-07 02:24:58');

ALTER TABLE "public"."peminjaman" ADD FOREIGN KEY ("inventaris_id") REFERENCES "public"."inventaris"("id") ON DELETE CASCADE;

