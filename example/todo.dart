import 'package:graphql_schema/graphql_schema.dart';

final GraphQLSchema manualTodoSchema = new GraphQLSchema(
    query: objectType('Todo', [
  field('text', type: GraphQLString.nonNullable()),
  field('created_at', type: GraphQLDate)
]));

final GraphQLSchema parsedTodoSchema = buildSchema('''
query Todo { text: String!, created_at: Date }
''');

main() {
  print(parsedTodoSchema.fields.map((f) => f.name));
}
