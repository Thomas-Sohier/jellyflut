import 'package:flutter/material.dart';
import 'package:jellyflut/screens/home/components/jellyfin_logo.dart';

import '../details/template/components/user_icon.dart';
import 'components/download_button.dart';
import 'components/search_button.dart';
import 'components/settings_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 8,
        ),
        Hero(tag: 'logo', child: const JellyfinLogo()),
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
        ),
        Hero(
          tag: 'logo_text',
          child: Text(
            'Jellyfin',
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontFamily: 'Quicksand'),
          ),
        ),
        Spacer(),
        SearchButton(),
        SettingsButton(),
        const SizedBox(width: 12),
        DownloadButton(),
        const SizedBox(width: 18),
        UserIcon(),
        const SizedBox(width: 18),
      ],
    );
  }
}
