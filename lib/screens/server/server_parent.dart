import 'package:authentication_repository/authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/server/server_item.dart';
import 'package:sqlite_database/sqlite_database.dart';

class ServerParent extends StatefulWidget {
  ServerParent({super.key});

  @override
  State<ServerParent> createState() => _ServerParentState();
}

class _ServerParentState extends State<ServerParent> {
  late final Database _database;
  late final ScrollController _scrollController;
  late final Stream<List<ServersWithUsers>> _serversWithUsers;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase().getDatabase;
    _scrollController = ScrollController();
    _serversWithUsers = _database.serversDao.watchAllServersWithUserApp;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'servers'.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        )),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: StreamBuilder<List<ServersWithUsers>>(
                stream: _serversWithUsers,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        key: UniqueKey(),
                        itemCount: snapshot.data?.length,
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (_, index) {
                          final serverWithUser = snapshot.data!.elementAt(index);
                          final currentServer = context.read<AuthenticationRepository>().currentServer;
                          final isInUse = serverWithUser.server.id == currentServer.id;
                          return ServerItem(
                              key: ValueKey(serverWithUser), serverWithUser: serverWithUser, isInUse: isInUse);
                        });
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  return const SizedBox();
                }),
          ),
        ));
  }
}
