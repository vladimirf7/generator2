CREATE TABLE "section" (
    "section_id" SERIAL PRIMARY KEY,
    "section_title" varchar(255),
    "section_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "section_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "post" (
    "post_id" SERIAL PRIMARY KEY,
    "post_content" text,
    "post_title" varchar(255),
    "post_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "post_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "comment" (
    "comment_id" SERIAL PRIMARY KEY,
    "comment_author" varchar(255),
    "comment_text" varchar(255),
    "comment_date" integer,
    "comment_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "comment_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "category" (
    "category_id" SERIAL PRIMARY KEY,
    "category_title" varchar,
    "category_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "category_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "tag" (
    "tag_id" SERIAL PRIMARY KEY,
    "tag_name" varchar(255),
    "tag_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "tag_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "user" (
    "user_id" SERIAL PRIMARY KEY,
    "user_email" varchar(255),
    "user_name" varchar(255),
    "user_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "user_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "post__tag" (
    "post_id" INTEGER NOT NULL,
    "tag_id" INTEGER NOT NULL,
    "post__tag_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "post__tag_updated" timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("post_id", "tag_id")
);

ALTER TABLE "post__tag"
    ADD CONSTRAINT "fk_post__tag_post_id" FOREIGN KEY ("post_id") REFERENCES "post" ("post_id");
    
ALTER TABLE "post__tag"
    ADD CONSTRAINT "fk_post__tag_tag_id" FOREIGN KEY ("tag_id") REFERENCES "tag" ("tag_id");
    
ALTER TABLE "comment" ADD "post_id" INTEGER NOT NULL,
    ADD CONSTRAINT "fk_comment_post_id" FOREIGN KEY ("post_id") REFERENCES "post" ("post_id");

ALTER TABLE "category" ADD "section_id" INTEGER NOT NULL,
    ADD CONSTRAINT "fk_category_section_id" FOREIGN KEY ("section_id") REFERENCES "section" ("section_id");

ALTER TABLE "comment" ADD "user_id" INTEGER NOT NULL,
    ADD CONSTRAINT "fk_comment_user_id" FOREIGN KEY ("user_id") REFERENCES "user" ("user_id");

CREATE OR REPLACE FUNCTION update_section_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.section_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_section_updated" BEFORE UPDATE ON "section" FOR EACH ROW EXECUTE PROCEDURE update_section_timestamp();

CREATE OR REPLACE FUNCTION update_post_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.post_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_post_updated" BEFORE UPDATE ON "post" FOR EACH ROW EXECUTE PROCEDURE update_post_timestamp();

CREATE OR REPLACE FUNCTION update_comment_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.comment_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_comment_updated" BEFORE UPDATE ON "comment" FOR EACH ROW EXECUTE PROCEDURE update_comment_timestamp();

CREATE OR REPLACE FUNCTION update_category_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.category_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_category_updated" BEFORE UPDATE ON "category" FOR EACH ROW EXECUTE PROCEDURE update_category_timestamp();

CREATE OR REPLACE FUNCTION update_tag_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.tag_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_tag_updated" BEFORE UPDATE ON "tag" FOR EACH ROW EXECUTE PROCEDURE update_tag_timestamp();

CREATE OR REPLACE FUNCTION update_user_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.user_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_user_updated" BEFORE UPDATE ON "user" FOR EACH ROW EXECUTE PROCEDURE update_user_timestamp();

CREATE OR REPLACE FUNCTION update_post__tag_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.post__tag_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_post__tag_updated" BEFORE UPDATE ON "post__tag" FOR EACH ROW EXECUTE PROCEDURE update_post__tag_timestamp();

CREATE OR REPLACE FUNCTION update_comment__post_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.comment__post_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_comment__post_updated" BEFORE UPDATE ON "comment__post" FOR EACH ROW EXECUTE PROCEDURE update_comment__post_timestamp();

CREATE OR REPLACE FUNCTION update_category__section_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.category__section_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_category__section_updated" BEFORE UPDATE ON "category__section" FOR EACH ROW EXECUTE PROCEDURE update_category__section_timestamp();

CREATE OR REPLACE FUNCTION update_comment__user_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.comment__user_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_comment__user_updated" BEFORE UPDATE ON "comment__user" FOR EACH ROW EXECUTE PROCEDURE update_comment__user_timestamp();

