part of graphql_schema.src.schema;

class GraphQLObjectType
    extends GraphQLType<Map<String, dynamic>, Map<String, dynamic>>
    with _NonNullableMixin<Map<String, dynamic>, Map<String, dynamic>> {
  final String name;
  final List<GraphQLField> fields = [];

  GraphQLObjectType(this.name);

  @override
  Map<String, dynamic> serialize(Map value) {
    return value.keys.fold<Map<String, dynamic>>({}, (out, k) {
      var field = fields.firstWhere((f) => f.name == k, orElse: () => null);
      if (field == null)
        return out;
      return out..[k] = field.serialize(value[k]);
    });
  }

  @override
  Map<String, dynamic> deserialize(Map value) {
    return value.keys.fold<Map<String, dynamic>>({}, (out, k) {
      var field = fields.firstWhere((f) => f.name == k, orElse: () => null);
      if (field == null)
        throw new UnsupportedError('Unexpected field "$k" encountered in map.');
      return out..[k] = field.deserialize(value[k]);
    });
  }
}
