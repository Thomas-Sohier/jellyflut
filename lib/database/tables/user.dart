import 'package:moor/moor.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get password => text()();
  TextColumn get apiKey => text()();
  IntColumn get settingsId => integer().withDefault(const Constant(0))();
  IntColumn get serverId => integer().withDefault(const Constant(0))();

  @override
  List<String> get customConstraints => ['UNIQUE (name,server_id)'];
}
