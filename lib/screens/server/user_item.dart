import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/shared/extensions/string_extensions.dart';

import '../../shared/utils/color_util.dart';

class UserItem extends StatelessWidget {
  final User user;
  final void Function(User user) onUserSelection;
  const UserItem({Key? key, required this.user, required this.onUserSelection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: ColorUtil.darken(Theme.of(context).colorScheme.background, 0.05),
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
                      Text(
                        user.name.capitalize(),
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                ))));
  }
}
