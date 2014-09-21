CREATE_TABLE = '''
CREATE TABLE "{0}" (
    "{0}_id" SERIAL PRIMARY KEY,
    {1},
    "{0}_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "{0}_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

'''

CREATE_TRIGGER = '''
CREATE OR REPLACE FUNCTION update_{0}_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.{0}_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';
CREATE TRIGGER "tr_{0}_updated" BEFORE UPDATE ON "{0}" FOR EACH ROW \
EXECUTE PROCEDURE update_{0}_timestamp();

'''

CREATE_JUNCTION_TABLE = '''
CREATE TABLE "{0}__{1}" (
    "{0}_id" INTEGER NOT NULL,
    "{1}_id" INTEGER NOT NULL,
    PRIMARY KEY ("{0}_id", "{1}_id")
);
'''
