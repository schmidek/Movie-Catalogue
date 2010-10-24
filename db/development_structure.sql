CREATE TABLE "catalogues" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "movie_holders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "catalogue_id" integer, "movie_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "movies" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "cover" varchar(255), "trailer" varchar(255), "imdb" varchar(255), "year" integer, "added" date, "rating" integer, "summary" text, "notes" text, "movie_holder_id" integer, "revision_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "revisions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "catalogue_id" integer, "user_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(255), "email" varchar(255), "crypted_password" varchar(255), "password_salt" varchar(255), "persistence_token" varchar(255), "single_access_token" varchar(255), "perishable_token" varchar(255), "login_count" integer, "failed_login_count" integer, "last_request_at" datetime, "current_login_at" datetime, "last_login_at" datetime, "current_login_ip" varchar(255), "last_login_ip" varchar(255), "catalogue_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20101017055938');

INSERT INTO schema_migrations (version) VALUES ('20101018021844');

INSERT INTO schema_migrations (version) VALUES ('20101019060240');

INSERT INTO schema_migrations (version) VALUES ('20101019060502');

INSERT INTO schema_migrations (version) VALUES ('20101022193500');