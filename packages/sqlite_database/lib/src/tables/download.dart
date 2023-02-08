import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class JsonConverter extends TypeConverter<Item, String> {
  const JsonConverter();

  @override
  Item fromSql(String fromDb) => Item.fromJson(json.decode(fromDb));

  @override
  String toSql(Item value) => json.encode(value.toJson());
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
