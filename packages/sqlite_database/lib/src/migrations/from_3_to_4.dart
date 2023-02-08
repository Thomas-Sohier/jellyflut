import 'package:drift/drift.dart';
import '../database.dart';

void from3to4(Database d, Migrator m, int target) async {
  if (target == 4) {
    // we added the dueDate property in the change from version 1 to
    // version 2
    await m.addColumn(d.userApp, d.userApp.jellyfinUserId);
  }
}
