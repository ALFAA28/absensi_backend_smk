-- Table Definition
CREATE TABLE "public"."cache_locks" (
    "key" varchar(255) NOT NULL,
    "owner" varchar(255) NOT NULL,
    "expiration" int4 NOT NULL,
    PRIMARY KEY ("key")
);



-- Indices
CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);

