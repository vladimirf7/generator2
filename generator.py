import os
import sys

import yaml

from relation import Relation, Cardinality
from statements import (CREATE_TABLE, CREATE_TRIGGER, CREATE_JUNCTION_TABLE, 
                        ALTER_TABLE_FK, ALTER_TABLE_CONSTRAINT)
from table import Table


class Generator:
    def __init__(self, file_in, file_out):
        self._file_in = file_in
        self._file_out = file_out
        self._statements_table = []
        self._statements_alter = []
        self._statements_trigger = []
        self._tables = {}
        self._relations = set()

    def create_tables(self):
        with open(self._file_in, 'r') as f:
            doc = yaml.load(f)

        for table_name in doc:
            table = Table(table_name.lower())

            for key, value in doc[table_name]['fields'].items():
                table._fields[key.lower()] = value.lower()

            if 'relations' in doc[table_name].keys():
                for key, value in doc[table_name]['relations'].items():
                    table._relations[key.lower()] = value.lower()

            self._tables[table_name.lower()] = table

    def verify_relations(self):
        for self_table_name, self_table in self._tables.items():
            for other_table_name, other_table_rel in self_table._relations.items():
                if other_table_name in self._tables:
                    other_table = self._tables[other_table_name]

                    if self_table_name in other_table._relations:
                        self.create_relation(self_table, other_table)
                    else:
                        raise Exception('Two-way relation error in YAML file ')

    def create_sql_tables(self):
        for table in self._tables.values():
            sql_fields = []
            for field_name, field_value in table._fields.items():
                sql_fields.append('"{0}_{1}" {2}'.format(
                    table._name, field_name, field_value, ))
            self._statements_table.append(CREATE_TABLE.format(
                table._name, ',\n    '.join(sql_fields)))
    
    def create_sql_relations(self):
        for rel in self._relations:
            if rel._cardinality == Cardinality.one_many:
                self.create_sql_foreign_keys(rel._origin, rel._destination)
            if rel._cardinality == Cardinality.many_many:
                self.create_sql_junction_table(rel)
    
    def create_relation(self, self_table, other_table):
        self_other = self_table._relations[other_table._name]
        other_self = other_table._relations[self_table._name]

        if self_other == 'many' and other_self == 'many':
            self._relations.add(Relation(self_table._name, other_table._name,
                                            Cardinality.many_many))
        if self_other == 'one' and other_self == 'many':
            self._relations.add(Relation(self_table._name, other_table._name,
                                            Cardinality.one_many))
        if self_other == 'many' and other_self == 'one':
            self._relations.add(Relation(other_table._name, self_table._name,
                                            Cardinality.one_many))

    def create_sql_foreign_keys(self, self_table, other_table):
        self._statements_alter.append(ALTER_TABLE_FK.format(
            self_table = self_table,
            other_table = other_table)
        )

    def create_sql_junction_table(self, relation):
        self._statements_table.append(CREATE_JUNCTION_TABLE.format(
            self_table = relation._origin,
            other_table = relation._destination)
        )
        self._statements_alter.append(ALTER_TABLE_CONSTRAINT.format(
            table_name = relation.table_name,
            fk_table_name = relation._origin
        ))
        self._statements_alter.append(ALTER_TABLE_CONSTRAINT.format(
            table_name = relation.table_name,
            fk_table_name = relation._destination
        ))

    def create_sql_trigers(self):
        for table in self._tables.values():
            self._statements_trigger.append(CREATE_TRIGGER.format(table._name))
        for relation in self._relations:
            self._statements_trigger.append(CREATE_TRIGGER.format(relation.table_name))

    def write_file(self):
        with open(self._file_out, 'w') as f:
            for stmt in self._statements_table:
                f.write(stmt)
            for stmt in self._statements_alter:
                f.write(stmt)
            for stmt in self._statements_trigger:
                f.write(stmt)
        print('SQL query saved to {0}'.format(os.path.abspath(self._file_out)))
  
    def save_statements(self):
        self.create_tables()
        self.verify_relations()
        self.create_sql_tables()
        self.create_sql_relations()
        self.create_sql_trigers()
        self.write_file()
