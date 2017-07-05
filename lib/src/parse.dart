import 'package:graphql_parser/graphql_parser.dart';
import 'schema.dart';

GraphQLSchema buildSchema(String text) {
  var parser = new Parser(scan(text));
  return const _SchemaBuilder().visitDocument(parser.parseDocument());
}

class _SchemaBuildContext {
  GraphQLObjectType query, mutation;

  // Todo: Ensure there is a query
  GraphQLSchema toSchema() =>
      new GraphQLSchema(query: query, mutation: mutation);
}

class _SchemaBuilder {
  const _SchemaBuilder();

  GraphQLSchema visitDocument(DocumentContext ctx) {
    var build = new _SchemaBuildContext();

    for (var def in ctx.definitions) {
      if (def is OperationDefinitionContext)
        visitOperationDefinition(def, build);
      else if (def is FragmentDefinitionContext)
        visitFragmentDefinition(def, build);
    }

    return build.toSchema();
  }

  void visitOperationDefinition(
      OperationDefinitionContext ctx, _SchemaBuildContext build) {
    if (ctx.isQuery) {
      if (build.query != null)
        throw new StateError(
            'Cannot define multiple query types within a schema.');
      build.query = visitQueryTypeDefinition(ctx, build);
    }

    // Todo: mutation, or throw error if neither
  }

  GraphQLObjectType visitQueryTypeDefinition(
      OperationDefinitionContext ctx, _SchemaBuildContext build) {
    // TODO: Variables???
    var fields = visitSelectionSet(ctx.selectionSet, build);
    return objectType(ctx.name, fields);
  }

  List<GraphQLField> visitSelectionSet(
      SelectionSetContext ctx, _SchemaBuildContext build) {
    return ctx.selections.map((f) => visitSelection(f, build));
  }

  GraphQLField visitSelection(SelectionContext ctx, _SchemaBuildContext build) {
    if (ctx.field != null) return visitField(ctx.field);
  }

  GraphQLField visitField(FieldContext field) {
    return new GraphQLField(field.fieldName.name);
  }
}
