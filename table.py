class Table:
    def __init__(self, name):
        self._name = name
        self._fields = {}
        self._relations = {}
