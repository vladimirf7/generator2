
CREATE TABLE "tag" (
    "tag_id" SERIAL PRIMARY KEY,
    "tag_value" varchar(50),
    "tag_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "tag_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE "category" (
    "category_id" SERIAL PRIMARY KEY,
    "category_title" varchar(50),
    "category_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "category_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE "article" (
    "article_id" SERIAL PRIMARY KEY,
    "article_text" text,
    "article_title" varchar(50),
    "article_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "article_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);


CREATE OR REPLACE FUNCTION update_tag_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.tag_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_tag_updated" BEFORE UPDATE ON "tag" FOR EACH ROW EXECUTE PROCEDURE update_tag_timestamp();


CREATE OR REPLACE FUNCTION update_category_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.category_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_category_updated" BEFORE UPDATE ON "category" FOR EACH ROW EXECUTE PROCEDURE update_category_timestamp();


CREATE OR REPLACE FUNCTION update_article_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.article_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_article_updated" BEFORE UPDATE ON "article" FOR EACH ROW EXECUTE PROCEDURE update_article_timestamp();

