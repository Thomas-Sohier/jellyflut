import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/screens/server/user_selection.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:sqlite_database/sqlite_database.dart';

class ServerItem extends StatelessWidget {
  final bool isInUse;
  final ServersWithUsers serverWithUser;
  const ServerItem({super.key, required this.serverWithUser, this.isInUse = false});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: ColorUtil.darken(Theme.of(context).colorScheme.background, 0.05),
        child: Ink(
          child: InkWell(
            onTap: () => showModalBottomSheet(
                context: context,
                enableDrag: true,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                ),
                constraints: BoxConstraints(maxWidth: 600, maxHeight: 400),
                builder: (_) => UserSelection(server: serverWithUser.server)),
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
                              Text('#${serverWithUser.server.id} - ${serverWithUser.server.name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ]),
                            Text(serverWithUser.server.url,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall),
                            inUsedText(context),
                            nbUsers(context)
                          ]),
                    ),
                    IconButton(onPressed: () => deleteServer(context), icon: Icon(Icons.remove_circle))
                  ]),
            ),
          ),
        ));
  }

  Widget inUsedText(final BuildContext context) {
    if (isInUse) {
      return Text('In use',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary));
    }
    return const SizedBox();
  }

  Widget nbUsers(final BuildContext context) {
    return Text('${serverWithUser.users.length} users',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary));
  }

  void deleteServer(BuildContext context) {
    final serverCompanion = serverWithUser.server.toCompanion(true);
    AppDatabase().getDatabase.serversDao.deleteServer(serverCompanion).then((int nbRowsDeleted) {
      if (nbRowsDeleted == 0) {
        return SnackbarUtil.message(
            messageTitle: 'Error, no server deleted', icon: Icons.error, color: Colors.red, context: context);
      }
      return SnackbarUtil.message(
          messageTitle: 'Server deleted', icon: Icons.remove_done, color: Colors.green, context: context);
    }).catchError((error) {
      SnackbarUtil.message(
          messageTitle: 'Error, no server deleted, ${error.toString()}',
          icon: Icons.error,
          color: Colors.red,
          context: context);
    });
  }
}
