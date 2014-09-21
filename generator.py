import os
import sys

import yaml

from relation import Relation, Cardinality
from statements import CREATE_TABLE, CREATE_TRIGGER, CREATE_JUNCTION_TABLE
from table import Table


class Generator:
    def __init__(self, file_in, file_out):
        self._file_in = file_in
        self._file_out = file_out
        self._statements = []
        self._tables = {}
        self._relations = set()

    def create_tables(self):
        with open(self._file_in, 'r') as f:
            doc = yaml.load(f)

        for table_name in doc:
            table = Table(table_name.lower())

            for key, value in doc[table_name]['fields'].items():
                table._fields[key.lower()] = value.lower()

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
                        raise Exception('Two-way relation error')

    def create_relation(self, self_table, other_table):
        self_other = self_table._relations[other_table._name]
        other_self = other_table._relations[self_table._name]

        self.print_relation(self_table, other_table)

        if self_other == 'many' and other_self == 'many':
            self._relations.add(Relation(self_table._name, other_table._name,
                                            Cardinality.many_many))
        if self_other == 'one' and other_self == 'many':
            self._relations.add(Relation(self_table._name, other_table._name,
                                            Cardinality.one_many))
        if self_other == 'many' and other_self == 'one':
            self._relations.add(Relation(other_table._name, self_table._name,
                                            Cardinality.one_many))

    def create_sql_tables(self):
        for table in self._tables.values():
            sql_fields = []
            for field_name, field_value in table._fields.items():
                sql_fields.append('"{0}_{1}" {2}'.format(
                    table._name, field_name, field_value, ))
            self._statements.append(CREATE_TABLE.format(
                table._name, ',\n    '.join(sql_fields)))

    def create_sql_trigers(self):
        for table in self._tables.values():
            self._statements.append(CREATE_TRIGGER.format(table._name))

    def write_file(self):
        with open(self._file_out, 'w') as f:
            for stmt in self._statements:
                f.write(stmt)
        print('SQL query saved to {0}'.format(os.path.abspath(self._file_out)))

    def print_relation(self, self_table, other_table):
        self_other = self_table._relations[other_table._name]
        other_self = other_table._relations[self_table._name]
        right = '1' if self_other == 'one' else '*'
        left = '1' if other_self == 'one' else '*'

        output = '{self} {l}----{r} {other}'.format(
            self = self_table._name, other = other_table._name,
            l = left, r = right
        )
        print(output)

    def create_junction_table(self, self_table, other_table):
        self._statements.append(CREATE_JUNCTION_TABLE.format(self_table._name,
                                                             other_table._name))
   
    def save_statements(self):
        self.create_tables()
        self.create_sql_tables()
        self.verify_relations()
        self.create_sql_trigers()
        self.write_file()
