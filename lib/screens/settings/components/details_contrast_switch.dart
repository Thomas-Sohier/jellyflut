import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';

class DetailsContrastSwitch extends StatelessWidget {
  const DetailsContrastSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.detailsPageContrasted != current.detailsPageContrasted,
        builder: (_, state) => Switch(
            value: state.detailsPageContrasted,
            onChanged: (contrast) =>
                context.read<SettingsBloc>().add(DetailsPageContrastChangeRequested(detailsPageContrasted: contrast))));
  }
}
