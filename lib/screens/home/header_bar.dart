import 'package:flutter/material.dart';
import 'package:jellyflut/components/layout_builder_screen.dart';

import '../details/template/components/user_icon.dart';
import 'components/download_button.dart';
import 'components/search_button.dart';
import 'components/settings_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LayoutBuilderScreen(
      builder: (_, constraints, type) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          !type.isMobile
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(width: 12),
                    _AppLogo(),
                    SizedBox(width: 12),
                    _AppBarTitle(),
                  ],
                )
              : const SizedBox(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: !type.isMobile ? 12 : 48),
                const Flexible(child: SearchButton()),
                const SizedBox(width: 6),
                const SettingsButton(),
                const SizedBox(width: 6),
                const DownloadButton(),
                const SizedBox(width: 12),
                const UserIcon(),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Jellyflut', style: Theme.of(context).textTheme.headline4);
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Image(
        image: AssetImage('img/icon/rounded_logo.png'),
        alignment: Alignment.center,
        height: 42,
      ),
    );
  }
}
