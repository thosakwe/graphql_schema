part of graphql_schema.src.schema;

abstract class GraphQLType<Value, Serialized> {
  Serialized serialize(Value value);
  Value deserialize(Serialized serialized);
  ValidationResult<Serialized> validate(String key, Serialized input);
  GraphQLType<Value, Serialized> nonNullable();
}

class GraphQLArrayType<Value, Serialized>
    extends GraphQLType<List<Value>, List<Serialized>>
    with _NonNullableMixin<List<Value>, List<Serialized>> {
  final GraphQLType<Value, Serialized> type;
  GraphQLArrayType(this.type);
}

abstract class _NonNullableMixin<Value, Serialized>
    implements GraphQLType<Value, Serialized> {
  GraphQLType<Value, Serialized> _nonNullableCache;
  GraphQLType<Value, Serialized> nonNullable() => _nonNullableCache ??=
      new _GraphQLNonNullableType<Value, Serialized>._(this);
}

class _GraphQLNonNullableType<Value, Serialized>
    extends GraphQLType<Value, Serialized> {
  final GraphQLType<Value, Serialized> type;
  _GraphQLNonNullableType._(this.type);

  @override
  GraphQLType<Value, Serialized> nonNullable() {
    throw new UnsupportedError(
        'Cannot call nonNullable() on a non-nullable type.');
  }
}
