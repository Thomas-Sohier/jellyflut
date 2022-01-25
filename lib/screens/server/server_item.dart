import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/database/class/servers_with_users.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';

class ServerItem extends StatelessWidget {
  final bool isInUsed;
  final ServersWithUsers serverWithUser;
  const ServerItem(
      {Key? key, required this.serverWithUser, this.isInUsed = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: ColorUtil.darken(Theme.of(context).colorScheme.background, 0.05),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                  child: Icon(CommunityMaterialIcons.server),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                              '#${serverWithUser.server.id} - ${serverWithUser.server.name}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1),
                        ]),
                        Text(serverWithUser.server.url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle2),
                        inUsedText(context),
                        nbUsers(context)
                      ]),
                ),
                IconButton(
                    onPressed: deleteServer, icon: Icon(Icons.remove_circle))
              ]),
        ));
  }

  Widget inUsedText(final BuildContext context) {
    if (isInUsed) {
      return Text('In used',
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Theme.of(context).colorScheme.secondary));
    }
    return const SizedBox();
  }

  Widget nbUsers(final BuildContext context) {
    return Text('${serverWithUser.users.length} users',
        style: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: Theme.of(context).colorScheme.tertiary));
  }

  void deleteServer() {
    final serverCompanion = serverWithUser.server.toCompanion(true);
    AppDatabase()
        .getDatabase
        .serversDao
        .deleteServer(serverCompanion)
        .then((int nbRowsDeleted) {
      if (nbRowsDeleted == 0) {
        return SnackbarUtil.message(
            'Error, no server deleted', Icons.error, Colors.red);
      }
      return SnackbarUtil.message(
          'Server deleted', Icons.remove_done, Colors.green);
    }).catchError((error) {
      SnackbarUtil.message('Error, no server deleted, ${error.toString()}',
          Icons.error, Colors.red);
    });
  }
}
