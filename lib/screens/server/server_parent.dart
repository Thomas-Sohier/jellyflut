import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/database/class/servers_with_users.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/server/server_item.dart';

class ServerParent extends StatefulWidget {
  ServerParent({Key? key}) : super(key: key);

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
    _serversWithUsers = _database.serversDao.watchAllServersWithUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'servers'.tr(),
          style: Theme.of(context).textTheme.headline5,
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
                          final serverWithUser =
                              snapshot.data!.elementAt(index);
                          final isInUse =
                              serverWithUser.server.id == userApp!.serverId;
                          return ServerItem(
                              key: ValueKey(serverWithUser),
                              serverWithUser: serverWithUser,
                              isInUse: isInUse);
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
