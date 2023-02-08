import 'package:drift/drift.dart';
import '../database.dart';

void from2to3(Database d, Migrator m, int target) async {
  if (target == 3) {
    // we added the dueDate property in the change from version 1 to
    // version 2
    await m.addColumn(d.settings, d.settings.directPlay);
  }
}
