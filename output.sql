CREATE TABLE "discount" (
    "discount_id" SERIAL PRIMARY KEY,
    "discount_amount" int,
    "discount_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "discount_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "cafe" (
    "cafe_id" SERIAL PRIMARY KEY,
    "cafe_title" varchar,
    "cafe_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "cafe_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "user" (
    "user_id" SERIAL PRIMARY KEY,
    "user_firstname" varchar,
    "user_lastname" varchar,
    "user_email" varchar,
    "user_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "user_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "payment" (
    "payment_id" SERIAL PRIMARY KEY,
    "payment_total" numeric,
    "payment_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "payment_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "order" (
    "order_id" SERIAL PRIMARY KEY,
    "order_title" varchar,
    "order_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "order_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "menu" (
    "menu_id" SERIAL PRIMARY KEY,
    "menu_price" numeric,
    "menu_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "menu_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "item" (
    "item_id" SERIAL PRIMARY KEY,
    "item_title" varchar,
    "item_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "item_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_discount_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.discount_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_discount_updated" BEFORE UPDATE ON "discount" FOR EACH ROW EXECUTE PROCEDURE update_discount_timestamp();

CREATE OR REPLACE FUNCTION update_cafe_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.cafe_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_cafe_updated" BEFORE UPDATE ON "cafe" FOR EACH ROW EXECUTE PROCEDURE update_cafe_timestamp();

CREATE OR REPLACE FUNCTION update_user_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.user_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_user_updated" BEFORE UPDATE ON "user" FOR EACH ROW EXECUTE PROCEDURE update_user_timestamp();

CREATE OR REPLACE FUNCTION update_payment_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.payment_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_payment_updated" BEFORE UPDATE ON "payment" FOR EACH ROW EXECUTE PROCEDURE update_payment_timestamp();

CREATE OR REPLACE FUNCTION update_order_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_order_updated" BEFORE UPDATE ON "order" FOR EACH ROW EXECUTE PROCEDURE update_order_timestamp();

CREATE OR REPLACE FUNCTION update_menu_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.menu_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_menu_updated" BEFORE UPDATE ON "menu" FOR EACH ROW EXECUTE PROCEDURE update_menu_timestamp();

CREATE OR REPLACE FUNCTION update_item_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.item_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_item_updated" BEFORE UPDATE ON "item" FOR EACH ROW EXECUTE PROCEDURE update_item_timestamp();

