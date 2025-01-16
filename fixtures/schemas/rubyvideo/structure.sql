CREATE VIRTUAL TABLE speakers_search_index USING fts5 (name, github, tokenize = porter)
/* speakers_search_index(name,github) */;
CREATE TABLE IF NOT EXISTS 'speakers_search_index_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'speakers_search_index_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'speakers_search_index_content'(id INTEGER PRIMARY KEY, c0, c1);
CREATE TABLE IF NOT EXISTS 'speakers_search_index_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'speakers_search_index_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE VIRTUAL TABLE talks_search_index USING fts5 (title, summary, speaker_names, tokenize = porter)
/* talks_search_index(title,summary,speaker_names) */;
CREATE TABLE IF NOT EXISTS 'talks_search_index_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'talks_search_index_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'talks_search_index_content'(id INTEGER PRIMARY KEY, c0, c1, c2);
CREATE TABLE IF NOT EXISTS 'talks_search_index_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'talks_search_index_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "ahoy_events" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "visit_id" integer, "user_id" integer, "name" varchar, "properties" text, "time" datetime(6));
CREATE INDEX "index_ahoy_events_on_name_and_time" ON "ahoy_events" ("name", "time") /*application='Rubyvideo'*/;
CREATE INDEX "index_ahoy_events_on_user_id" ON "ahoy_events" ("user_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_ahoy_events_on_visit_id" ON "ahoy_events" ("visit_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "ahoy_visits" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "visit_token" varchar, "visitor_token" varchar, "user_id" integer, "ip" varchar, "user_agent" text, "referrer" text, "referring_domain" varchar, "landing_page" text, "browser" varchar, "os" varchar, "device_type" varchar, "country" varchar, "region" varchar, "city" varchar, "latitude" float, "longitude" float, "utm_source" varchar, "utm_medium" varchar, "utm_term" varchar, "utm_content" varchar, "utm_campaign" varchar, "app_version" varchar, "os_version" varchar, "platform" varchar, "started_at" datetime(6));
CREATE INDEX "index_ahoy_visits_on_user_id" ON "ahoy_visits" ("user_id") /*application='Rubyvideo'*/;
CREATE UNIQUE INDEX "index_ahoy_visits_on_visit_token" ON "ahoy_visits" ("visit_token") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "organisations" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar DEFAULT '' NOT NULL, "description" text DEFAULT '' NOT NULL, "website" varchar DEFAULT '' NOT NULL, "kind" integer DEFAULT 0 NOT NULL, "frequency" integer DEFAULT 0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "youtube_channel_id" varchar DEFAULT '' NOT NULL, "youtube_channel_name" varchar DEFAULT '' NOT NULL, "slug" varchar DEFAULT '' NOT NULL, "twitter" varchar DEFAULT '' NOT NULL, "language" varchar DEFAULT '' NOT NULL);
CREATE INDEX "index_organisations_on_frequency" ON "organisations" ("frequency") /*application='Rubyvideo'*/;
CREATE INDEX "index_organisations_on_kind" ON "organisations" ("kind") /*application='Rubyvideo'*/;
CREATE INDEX "index_organisations_on_name" ON "organisations" ("name") /*application='Rubyvideo'*/;
CREATE INDEX "index_organisations_on_slug" ON "organisations" ("slug") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "rollups" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "interval" varchar NOT NULL, "time" datetime(6) NOT NULL, "dimensions" json DEFAULT '{}' NOT NULL, "value" float);
CREATE UNIQUE INDEX "index_rollups_on_name_and_interval_and_time_and_dimensions" ON "rollups" ("name", "interval", "time", "dimensions") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "speaker_talks" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "speaker_id" integer NOT NULL, "talk_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_speaker_talks_on_speaker_id_and_talk_id" ON "speaker_talks" ("speaker_id", "talk_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_speaker_talks_on_speaker_id" ON "speaker_talks" ("speaker_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_speaker_talks_on_talk_id" ON "speaker_talks" ("talk_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar NOT NULL, "password_digest" varchar NOT NULL, "verified" boolean DEFAULT 0 NOT NULL, "admin" boolean DEFAULT 0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "name" varchar, "github_handle" varchar);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email") /*application='Rubyvideo'*/;
CREATE UNIQUE INDEX "index_users_on_github_handle" ON "users" ("github_handle") WHERE github_handle IS NOT NULL /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "watch_lists" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "name" varchar NOT NULL, "description" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "talks_count" integer DEFAULT 0);
CREATE INDEX "index_watch_lists_on_user_id" ON "watch_lists" ("user_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "watched_talks" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "talk_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_watched_talks_on_talk_id_and_user_id" ON "watched_talks" ("talk_id", "user_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_watched_talks_on_talk_id" ON "watched_talks" ("talk_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_watched_talks_on_user_id" ON "watched_talks" ("user_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "connected_accounts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "uid" varchar, "provider" varchar, "username" varchar, "user_id" integer NOT NULL, "access_token" varchar, "expires_at" datetime(6), "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_b9795ad9a7"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE UNIQUE INDEX "index_connected_accounts_on_provider_and_uid" ON "connected_accounts" ("provider", "uid") /*application='Rubyvideo'*/;
CREATE UNIQUE INDEX "index_connected_accounts_on_provider_and_username" ON "connected_accounts" ("provider", "username") /*application='Rubyvideo'*/;
CREATE INDEX "index_connected_accounts_on_user_id" ON "connected_accounts" ("user_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "email_verification_tokens" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, CONSTRAINT "fk_rails_37a6b0cc74"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_email_verification_tokens_on_user_id" ON "email_verification_tokens" ("user_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "events" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "date" date, "city" varchar, "country_code" varchar, "organisation_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "name" varchar DEFAULT '' NOT NULL, "slug" varchar DEFAULT '' NOT NULL, "talks_count" integer DEFAULT 0 NOT NULL, "canonical_id" integer, "website" varchar DEFAULT '', CONSTRAINT "fk_rails_b5f99cbf85"
FOREIGN KEY ("canonical_id")
  REFERENCES "events" ("id")
, CONSTRAINT "fk_rails_69d23b5b85"
FOREIGN KEY ("organisation_id")
  REFERENCES "organisations" ("id")
);
CREATE INDEX "index_events_on_canonical_id" ON "events" ("canonical_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_events_on_name" ON "events" ("name") /*application='Rubyvideo'*/;
CREATE INDEX "index_events_on_organisation_id" ON "events" ("organisation_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_events_on_slug" ON "events" ("slug") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "password_reset_tokens" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, CONSTRAINT "fk_rails_1dfd31e72f"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_password_reset_tokens_on_user_id" ON "password_reset_tokens" ("user_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "sessions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "user_agent" varchar, "ip_address" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_758836b4f0"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_sessions_on_user_id" ON "sessions" ("user_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "speakers" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar DEFAULT '' NOT NULL, "twitter" varchar DEFAULT '' NOT NULL, "github" varchar DEFAULT '' NOT NULL, "bio" text DEFAULT '' NOT NULL, "website" varchar DEFAULT '' NOT NULL, "slug" varchar DEFAULT '' NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "talks_count" integer DEFAULT 0 NOT NULL, "canonical_id" integer, "speakerdeck" varchar DEFAULT '' NOT NULL, "pronouns_type" varchar DEFAULT 'not_specified' NOT NULL, "pronouns" varchar DEFAULT '' NOT NULL, "mastodon" varchar DEFAULT '' NOT NULL, "bsky" varchar DEFAULT '' NOT NULL, "linkedin" varchar DEFAULT '' NOT NULL, "bsky_metadata" json DEFAULT '{}' NOT NULL, "github_metadata" json DEFAULT '{}' NOT NULL, CONSTRAINT "fk_rails_d9d3023aaa"
FOREIGN KEY ("canonical_id")
  REFERENCES "speakers" ("id")
);
CREATE INDEX "index_speakers_on_canonical_id" ON "speakers" ("canonical_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_speakers_on_name" ON "speakers" ("name") /*application='Rubyvideo'*/;
CREATE UNIQUE INDEX "index_speakers_on_slug" ON "speakers" ("slug") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "suggestions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "content" text, "status" integer DEFAULT 0 NOT NULL, "suggestable_type" varchar NOT NULL, "suggestable_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "approved_by_id" integer, "suggested_by_id" integer, CONSTRAINT "fk_rails_5f9746f758"
FOREIGN KEY ("approved_by_id")
  REFERENCES "users" ("id")
, CONSTRAINT "fk_rails_294e0e5776"
FOREIGN KEY ("suggested_by_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_suggestions_on_approved_by_id" ON "suggestions" ("approved_by_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_suggestions_on_status" ON "suggestions" ("status") /*application='Rubyvideo'*/;
CREATE INDEX "index_suggestions_on_suggestable" ON "suggestions" ("suggestable_type", "suggestable_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_suggestions_on_suggested_by_id" ON "suggestions" ("suggested_by_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "talk_topics" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "talk_id" integer NOT NULL, "topic_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_6949c1fd36"
FOREIGN KEY ("talk_id")
  REFERENCES "talks" ("id")
, CONSTRAINT "fk_rails_2b0216df0f"
FOREIGN KEY ("topic_id")
  REFERENCES "topics" ("id")
);
CREATE INDEX "index_talk_topics_on_talk_id" ON "talk_topics" ("talk_id") /*application='Rubyvideo'*/;
CREATE UNIQUE INDEX "index_talk_topics_on_topic_id_and_talk_id" ON "talk_topics" ("topic_id", "talk_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_talk_topics_on_topic_id" ON "talk_topics" ("topic_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "talk_transcripts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "talk_id" integer NOT NULL, "raw_transcript" text, "enhanced_transcript" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_4a9f090074"
FOREIGN KEY ("talk_id")
  REFERENCES "talks" ("id")
);
CREATE INDEX "index_talk_transcripts_on_talk_id" ON "talk_transcripts" ("talk_id") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "talks" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar DEFAULT '' NOT NULL, "description" text DEFAULT '' NOT NULL, "slug" varchar DEFAULT '' NOT NULL, "video_id" varchar DEFAULT '' NOT NULL, "video_provider" varchar DEFAULT '' NOT NULL, "thumbnail_sm" varchar DEFAULT '' NOT NULL, "thumbnail_md" varchar DEFAULT '' NOT NULL, "thumbnail_lg" varchar DEFAULT '' NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "event_id" integer, "thumbnail_xs" varchar DEFAULT '' NOT NULL, "thumbnail_xl" varchar DEFAULT '' NOT NULL, "date" date, "like_count" integer DEFAULT 0, "view_count" integer DEFAULT 0, "summary" text DEFAULT '' NOT NULL, "language" varchar DEFAULT 'en' NOT NULL, "slides_url" varchar, "summarized_using_ai" boolean DEFAULT 1 NOT NULL, "external_player" boolean DEFAULT 0 NOT NULL, "external_player_url" varchar DEFAULT '' NOT NULL, "kind" varchar DEFAULT 'talk' NOT NULL, "parent_talk_id" integer, "meta_talk" boolean DEFAULT 0 NOT NULL, "start_seconds" integer, "end_seconds" integer, CONSTRAINT "fk_rails_3c1d100388"
FOREIGN KEY ("event_id")
  REFERENCES "events" ("id")
, CONSTRAINT "fk_rails_6fe33c7ce5"
FOREIGN KEY ("parent_talk_id")
  REFERENCES "talks" ("id")
);
CREATE INDEX "index_talks_on_date" ON "talks" ("date") /*application='Rubyvideo'*/;
CREATE INDEX "index_talks_on_event_id" ON "talks" ("event_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_talks_on_kind" ON "talks" ("kind") /*application='Rubyvideo'*/;
CREATE INDEX "index_talks_on_parent_talk_id" ON "talks" ("parent_talk_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_talks_on_slug" ON "talks" ("slug") /*application='Rubyvideo'*/;
CREATE INDEX "index_talks_on_title" ON "talks" ("title") /*application='Rubyvideo'*/;
CREATE INDEX "index_talks_on_updated_at" ON "talks" ("updated_at") /*application='Rubyvideo'*/;
CREATE INDEX "index_talks_on_video_provider_and_date" ON "talks" ("video_provider", "date") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "topics" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "description" text, "published" boolean DEFAULT 0, "slug" varchar DEFAULT '' NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "status" varchar DEFAULT 'pending' NOT NULL, "canonical_id" integer, "talks_count" integer, CONSTRAINT "fk_rails_ce885477bc"
FOREIGN KEY ("canonical_id")
  REFERENCES "topics" ("id")
);
CREATE INDEX "index_topics_on_canonical_id" ON "topics" ("canonical_id") /*application='Rubyvideo'*/;
CREATE UNIQUE INDEX "index_topics_on_name" ON "topics" ("name") /*application='Rubyvideo'*/;
CREATE INDEX "index_topics_on_slug" ON "topics" ("slug") /*application='Rubyvideo'*/;
CREATE INDEX "index_topics_on_status" ON "topics" ("status") /*application='Rubyvideo'*/;
CREATE TABLE IF NOT EXISTS "watch_list_talks" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "watch_list_id" integer NOT NULL, "talk_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_cbd0d0de54"
FOREIGN KEY ("talk_id")
  REFERENCES "talks" ("id")
, CONSTRAINT "fk_rails_5324e5a732"
FOREIGN KEY ("watch_list_id")
  REFERENCES "watch_lists" ("id")
);
CREATE INDEX "index_watch_list_talks_on_talk_id" ON "watch_list_talks" ("talk_id") /*application='Rubyvideo'*/;
CREATE UNIQUE INDEX "index_watch_list_talks_on_watch_list_id_and_talk_id" ON "watch_list_talks" ("watch_list_id", "talk_id") /*application='Rubyvideo'*/;
CREATE INDEX "index_watch_list_talks_on_watch_list_id" ON "watch_list_talks" ("watch_list_id") /*application='Rubyvideo'*/;
INSERT INTO "schema_migrations" (version) VALUES
('20250115215944'),
('20250108221813'),
('20250104095544'),
('20250102175230'),
('20241203001515'),
('20241130095835'),
('20241128073415'),
('20241122163052'),
('20241122155013'),
('20241108215612'),
('20241105151601'),
('20241105143943'),
('20241101185604'),
('20241031112333'),
('20241029112719'),
('20241023154126'),
('20241023150341'),
('20241023093844'),
('20241022012631'),
('20241020174649'),
('20241019135118'),
('20240920154237'),
('20240920054416'),
('20240919193323'),
('20240918215740'),
('20240918050951'),
('20240914162252'),
('20240912164120'),
('20240912163159'),
('20240912163015'),
('20240909194059'),
('20240908072819'),
('20240908072757'),
('20240902204752'),
('20240901163900'),
('20240823221832'),
('20240821191208'),
('20240819134138'),
('20240818212042'),
('20240817083428'),
('20240816074626'),
('20240815155647'),
('20240811122145'),
('20240811121204'),
('20240718202658'),
('20240709200506'),
('20240709194147'),
('20240614060123'),
('20240614060122'),
('20240614060121'),
('20240611113918'),
('20230720151537'),
('20230720104208'),
('20230625215935'),
('20230622202051'),
('20230615105716'),
('20230615055800'),
('20230615055319'),
('20230615053959'),
('20230614234246'),
('20230614233712'),
('20230614232412'),
('20230614231651'),
('20230614230539'),
('20230604215247'),
('20230525132507'),
('20230522213244'),
('20230522212710'),
('20230522133315'),
('20230522133314'),
('20230522133313'),
('20230522133312'),
('20230522051939'),
('20230521211825'),
('20230521202931'),
('20230512051225'),
('20230512050041');

