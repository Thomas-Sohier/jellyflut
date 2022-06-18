import 'package:drift/drift.dart';

class Servers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text()();
  TextColumn get name => text()();

  @override
  List<String> get customConstraints => ['UNIQUE (url)'];
}
