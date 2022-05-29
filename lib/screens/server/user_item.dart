import 'package:flutter/material.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';
import 'package:moor/moor.dart' hide Column;

import '../../shared/utils/color_util.dart';

class UserItem extends StatelessWidget {
  final User user;
  final void Function(User user) onUserSelection;
  const UserItem({super.key, required this.user, required this.onUserSelection});

  @override
  Widget build(BuildContext context) {
    final inUse = user.id == userApp!.id;
    return Row(
      children: [
        Expanded(
          child: Card(
              color: ColorUtil.darken(
                  Theme.of(context).colorScheme.background, 0.05),
              child: Ink(
                  child: InkWell(
                      onTap: () => onUserSelection(user),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 32),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 4, 24, 4),
                              child: Icon(Icons.person, size: 16),
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      user.name.capitalize(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    if (inUse)
                                      Text('in use',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary)),
                                  ]),
                            ),
                          ],
                        ),
                      )))),
        ),
        IconButton(
            onPressed: () async {
              final u = UsersCompanion(id: Value(user.id));
              await AppDatabase().getDatabase.usersDao.deleteUser(u);
              if (inUse) await AuthService.logout();
            },
            icon: Icon(Icons.delete,
                color: Theme.of(context).colorScheme.secondary))
      ],
    );
  }
}
