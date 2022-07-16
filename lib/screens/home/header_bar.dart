import 'package:flutter/material.dart';

import '../details/template/components/user_icon.dart';
import 'components/download_button.dart';
import 'components/search_button.dart';
import 'components/settings_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(width: 48),
          Flexible(child: SearchButton()),
          SizedBox(width: 6),
          SettingsButton(),
          SizedBox(width: 6),
          DownloadButton(),
          SizedBox(width: 12),
          UserIcon(),
          SizedBox(width: 18),
        ],
      ),
    );
  }
}
