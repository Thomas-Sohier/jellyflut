import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jellyflut/screens/home/components/jellyfin_logo.dart';

import '../details/template/components/user_icon.dart';
import 'components/download_button.dart';
import 'components/search_button.dart';
import 'components/settings_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 48),
        Flexible(child: SearchButton()),
        const SizedBox(width: 6),
        SettingsButton(),
        const SizedBox(width: 6),
        DownloadButton(),
        const SizedBox(width: 12),
        UserIcon(),
        const SizedBox(width: 18),
      ],
    );
  }

  List<Widget> logoAndText() {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      return <Widget>[
        const SizedBox(width: 8),
        Hero(tag: 'logo', child: const JellyfinLogo()),
        const Padding(padding: EdgeInsets.fromLTRB(6, 0, 0, 0)),
        Hero(
          tag: 'logo_text',
          child: Text('Jellyfin',
              style: TextStyle(fontSize: 22, fontFamily: 'Quicksand')),
        )
      ];
    }
    return [];
  }
}
