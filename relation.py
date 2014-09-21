
from enum import Enum

class Relation:

    def __init__(self, origin, destination, cardinality):
        self._origin = origin
        self._destination = destination
        self._cardinality = cardinality

    def __eq__(self, other):
        return (
            (self._origin == other._origin) or
            (self._origin == other._destination)
            ) and (
            (self._destination == other._destination) or
            (self._destination == other._origin)
            )

    def __hash__(self):
        return hash((self._origin, self._destination))

class Cardinality(Enum):
    one_many = 1
    many_many = 2
