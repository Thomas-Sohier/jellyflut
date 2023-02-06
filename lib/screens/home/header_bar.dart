import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/home/home_drawer_cubit/home_drawer_cubit.dart';

import '../details/template/components/user_icon.dart';
import 'components/download_button.dart';
import 'components/search_button.dart';
import 'components/settings_button.dart';
import 'home_drawer_tabs_builder.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(width: 48),
            Expanded(child: SearchButton()),
            SizedBox(width: 6),
            SettingsButton(),
            SizedBox(width: 6),
            DownloadButton(),
            SizedBox(width: 12),
            UserIcon(),
            SizedBox(width: 12),
          ],
        ),
        const BottomTabBar()
      ],
    ));
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDrawerCubit, HomeDrawerState>(
        builder: (_, state) =>
            Text(state.name, style: Theme.of(context).textTheme.headlineMedium));
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

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
