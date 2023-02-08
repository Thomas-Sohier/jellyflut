import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_repository/settings_repository.dart';

import '../bloc/settings_bloc.dart';

class DirectPlaySwitch extends StatelessWidget {
  const DirectPlaySwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.databaseSetting.directPlay != current.databaseSetting.directPlay,
        builder: (_, state) => Switch(
            value: state.databaseSetting.directPlay,
            onChanged: (directPlay) => context
                .read<SettingsBloc>()
                .add(SettingsUpdateRequested(databaseSettingDto: DatabaseSettingDto(directPlay: directPlay)))));
  }
}
