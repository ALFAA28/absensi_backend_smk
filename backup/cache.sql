-- Table Definition
CREATE TABLE "public"."cache" (
    "key" varchar(255) NOT NULL,
    "value" text NOT NULL,
    "expiration" int4 NOT NULL,
    PRIMARY KEY ("key")
);



-- Indices
CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);

