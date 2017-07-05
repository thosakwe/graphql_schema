library graphql_schema.src.schema;

import 'dart:async';
part 'argument.dart';
part 'field.dart';
part 'gen.dart';
part 'object_type.dart';
part 'scalar.dart';
part 'type.dart';
part 'validation_result.dart';

class GraphQLSchema {
  final List<GraphQLField> fields = [];
  final GraphQLObjectType query;
  final GraphQLObjectType mutation;

  GraphQLSchema({this.query, this.mutation});
}
