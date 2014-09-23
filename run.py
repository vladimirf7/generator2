from relation import Relation, Cardinality

a = Relation('article', 'tag', Cardinality.many_many)
b = Relation('tag', 'article', Cardinality.many_many)

print(a.table_name)
print(b.table_name)
