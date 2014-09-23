CREATE_TABLE = '''\
CREATE TABLE "{0}" (
    "{0}_id" SERIAL PRIMARY KEY,
    {1},
    "{0}_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "{0}_updated" timestamp DEFAULT CURRENT_TIMESTAMP
);

'''

CREATE_TRIGGER = '''\
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

CREATE_JUNCTION_TABLE = '''\
CREATE TABLE "{self_table}__{other_table}" (
    "{self_table}_id" INTEGER NOT NULL,
    "{other_table}_id" INTEGER NOT NULL,
    "{self_table}__{other_table}_created" timestamp DEFAULT CURRENT_TIMESTAMP,
    "{self_table}__{other_table}_updated" timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("{self_table}_id", "{other_table}_id")
);

'''

ALTER_TABLE_FK = '''\
ALTER TABLE "{self_table}" ADD "{other_table}_id" INTEGER NOT NULL,
    ADD CONSTRAINT "fk_{self_table}_{other_table}_id" FOREIGN KEY ("{other_table}_id") REFERENCES "{other_table}" ("{other_table}_id");

'''

ALTER_TABLE_CONSTRAINT = '''\
ALTER TABLE "{table_name}"
    ADD CONSTRAINT "fk_{table_name}_{fk_table_name}_id" FOREIGN KEY ("{fk_table_name}_id") REFERENCES "{fk_table_name}" ("{fk_table_name}_id");
    
'''
