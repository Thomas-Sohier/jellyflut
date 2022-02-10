import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/server/user_item.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';

import '../../database/database.dart';

class UserSelection extends StatelessWidget {
  final Server server;
  const UserSelection({Key? key, required this.server}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users =
        AppDatabase().getDatabase.usersDao.watchUsersByserverId(server.id);
    return StreamBuilder<List<User>>(
        stream: users,
        builder: (_, a) {
          if (a.hasData) {
            return listUser(a.data, context);
          }
          return const SizedBox();
        });
  }

  Widget listUser(List<User>? users, BuildContext context) {
    if (users != null && users.isNotEmpty) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select users',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: users.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final u = users.elementAt(index);
                      return UserItem(
                        user: u,
                        onUserSelection: (user) {
                          AuthService.changeUser(
                                  user.name,
                                  user.password,
                                  server.url,
                                  server.id,
                                  user.settingsId,
                                  user.id)
                              .catchError((error) {
                            customRouter.pop();
                            SnackbarUtil.message(
                                error.toString(), Icons.error, Colors.red);
                          });
                        },
                      );
                    }),
              ),
            ],
          ));
    }
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_off_sharp),
                Text('No users found'),
              ],
            ),
          ],
        ));
  }
}
