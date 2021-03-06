import 'package:moor/moor.dart';

class Servers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text()();
  TextColumn get name => text()();
}
