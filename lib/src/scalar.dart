part of graphql_schema.src.schema;

final GraphQLScalarType<String, String> GraphQLString =
    new _GraphQLStringType._();

final GraphQLScalarType<DateTime, String> GraphQLDate =
    new _GraphQLDateType._();

abstract class GraphQLScalarType<Value, Serialized>
    extends GraphQLType<Value, Serialized> with _NonNullableMixin {}

class _GraphQLStringType extends GraphQLScalarType<String, String> {
  _GraphQLStringType._();

  @override
  String serialize(String value) => value;

  @override
  String deserialize(String serialized) => serialized;

  @override
  ValidationResult<String> validate(String key, String input) =>
      new ValidationResult<String>._ok(input);
}

class _GraphQLDateType extends GraphQLScalarType<DateTime, String>
    with _NonNullableMixin<DateTime, String> {
  _GraphQLDateType._();

  @override
  String serialize(DateTime value) => value.toIso8601String();

  @override
  DateTime deserialize(String serialized) => DateTime.parse(serialized);

  @override
  ValidationResult<String> validate(String key, String input) {
    try {
      DateTime.parse(input);
      return new ValidationResult<String>._ok(input);
    } on FormatException {
      return new ValidationResult<String>._failure(
          ['$key must be an ISO 8601-formatted date string.']);
    }
  }
}
