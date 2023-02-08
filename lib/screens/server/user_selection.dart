import 'package:authentication_repository/authentication_repository.dart' hide Server;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/auth/models/server_dto.dart';
import 'package:jellyflut/screens/server/user_item.dart';
import 'package:sqlite_database/sqlite_database.dart';

class UserSelection extends StatelessWidget {
  final Server server;
  const UserSelection({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    // TODO add cubit here
    final users = context.read<AuthenticationRepository>().getUsersForServerId(server.id);
    return FutureBuilder<List<UserAppData>>(
        future: users,
        builder: (_, a) {
          if (a.hasData) {
            return listUser(a.data, context);
          }
          return const SizedBox();
        });
  }

  Widget listUser(List<UserAppData>? users, BuildContext context) {
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
                          context.read<AuthBloc>().add(LogoutRequested());
                          context.read<AuthBloc>().add(AuthServerAdded(ServerDto(url: server.url, name: server.name)));
                          context.read<AuthBloc>().add(RequestAuth(username: user.name, password: user.password));
                        });
                  },
                ))
              ]));
    }
    return _NoUsers();
  }
}

class _NoUsers extends StatelessWidget {
  const _NoUsers();

  @override
  Widget build(BuildContext context) {
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
