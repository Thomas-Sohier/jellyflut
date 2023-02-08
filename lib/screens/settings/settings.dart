import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:jellyflut/screens/settings/components/sections.dart';

import 'bloc/settings_bloc.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'settings'.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        )),
        body: BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) => previous.settingsStatus != current.settingsStatus,
            builder: (context, state) {
              switch (state.settingsStatus) {
                case SettingsStatus.success:
                  return const SettingsView();
                case SettingsStatus.initial:
                case SettingsStatus.loading:
                  return const LoadingSettingsView();
                default:
                  return const LoadingSettingsView();
              }
            }));
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: SettingsList(
          contentPadding: EdgeInsets.only(bottom: 30),
          backgroundColor: Theme.of(context).colorScheme.background,
          darkBackgroundColor: Theme.of(context).primaryColorDark,
          lightBackgroundColor: Theme.of(context).primaryColorLight,
          sections: [
            VideoPlayerSection().build(context),
            AudioPlayerSection().build(context),
            InfosSection().build(context),
            // DownloadPathSection().build(context),
            InterfaceSection().build(context),
            ThemeSection().build(context),
            AccountSection().build(context)
          ],
        ),
      ),
    );
  }
}

class LoadingSettingsView extends StatelessWidget {
  const LoadingSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    ));
  }
}
