
from enum import Enum

class Relation:

    def __init__(self, origin, destination, cardinality):
        self._origin = origin
        self._destination = destination
        self._cardinality = cardinality

    @property
    def table_name(self):
        if self._origin < self._destination:
            return '{0}__{1}'.format(self._origin, self._destination)
        else:
            return '{1}__{0}'.format(self._origin, self._destination)

    def __eq__(self, other):
        return (
            (self._origin == other._origin) or
            (self._origin == other._destination)
            ) and (
            (self._destination == other._destination) or
            (self._destination == other._origin)
            )

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return hash(self.table_name)

    def __repr__(self):
        return '{0} {1} {2}'.format(
            self._origin, self._cardinality, self._destination
        )

class Cardinality(Enum):
    one_many = 1
    many_many = 2
