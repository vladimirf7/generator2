import os
import sys

import yaml

from statements import CREATE_TABLE, CREATE_TRIGGER
from table import Table


class Generator:
    def __init__(self, file_in, file_out):
        self._file_in = file_in
        self._file_out = file_out
        self._statements = []
        self._tables = []


    def create_objects(self):
        with open(self._file_in, 'r') as f:
            doc = yaml.load(f)

        for table_name in doc:
            table = Table(table_name.lower())

            for key, value in doc[table_name]['fields'].items():
                table._fields[key.lower()] = value.lower()

            for key, value in doc[table_name]['relations'].items():
                table._relations[key.lower()] = value.lower()

            self._tables.append(table)


    def create_sql_tables(self):

        for table in self._tables:
            sql_fields = []
            for field_name, field_value in table._fields.items():
                sql_fields.append('"{0}_{1}" {2}'.format(
                    table._name, field_name, field_value, ))
            self._statements.append(CREATE_TABLE.format(
                table._name, ',\n    '.join(sql_fields)))


    def create_sql_trigers(self):
        for table in self._tables:
            self._statements.append(CREATE_TRIGGER.format(table._name))


    def write_file(self):
        with open(self._file_out, 'w') as f:
            for stmt in self._statements:
                f.write(stmt)
        print('SQL query saved to {0}'.format(os.path.abspath(self._file_out)))


    def save_statements(self):
        self.create_objects()
        self.create_sql_tables()
        self.create_sql_trigers()
        self.write_file()
