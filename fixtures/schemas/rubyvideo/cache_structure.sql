CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "solid_cache_entries" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "key" blob(1024) NOT NULL, "value" blob(536870912) NOT NULL, "created_at" datetime(6) NOT NULL, "key_hash" integer(8) NOT NULL, "byte_size" integer(4) NOT NULL);
CREATE INDEX "index_solid_cache_entries_on_byte_size" ON "solid_cache_entries" ("byte_size") /*application='Rubyvideo'*/;
CREATE INDEX "index_solid_cache_entries_on_key_hash_and_byte_size" ON "solid_cache_entries" ("key_hash", "byte_size") /*application='Rubyvideo'*/;
CREATE UNIQUE INDEX "index_solid_cache_entries_on_key_hash" ON "solid_cache_entries" ("key_hash") /*application='Rubyvideo'*/;
INSERT INTO "schema_migrations" (version) VALUES
('20240516085651'),
('20240516085650'),
('20240516085649'),
('20240516085648');

