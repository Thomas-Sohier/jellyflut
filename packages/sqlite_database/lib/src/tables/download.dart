import 'dart:convert';
import '../serializer/json_deserializer.dart';
import '../serializer/json_serializer.dart';
import 'package:drift/drift.dart';

class JsonConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonConverter();

  @override
  Map<String, dynamic>? mapToDart(String? fromDb) => fromDb == null
      ? null
      : json.decode(fromDb, reviver: JsonDeserializer.jellyfinDeserializer);

  @override
  String? mapToSql(Map<String, dynamic>? value) =>
      jsonEncode(value, toEncodable: JsonSerializer.jellyfinSerializer);
}

class Downloads extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get path => text()();
  BlobColumn get primary => blob().nullable()();
  BlobColumn get backdrop => blob().nullable()();
  TextColumn get item => text().map(const JsonConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
