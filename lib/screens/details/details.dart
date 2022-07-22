import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/subtree_builder.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/settings/bloc/settings_bloc.dart';
import 'package:jellyflut/shared/shared_prefs.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'template/components/photo_item.dart';
import 'template/large_details.dart';

class DetailsPage extends StatelessWidget {
  final Item item;
  final String? heroTag;

  const DetailsPage({required this.item, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailsBloc>(
        create: (blocContext) => DetailsBloc(
            item: item,
            heroTag: heroTag,
            contrastedPage: !context.read<SettingsBloc>().state.detailsPageContrasted,
            screenLayout: MediaQuery.of(context).size.width <= 960 ? ScreenLayout.mobile : ScreenLayout.desktop,
            sharedPreferences: SharedPrefs.sharedPrefs,
            themeProvider: context.read<ThemeProvider>(),
            authenticationRepository: context.read<AuthenticationRepository>(),
            itemsRepository: context.read<ItemsRepository>())
          ..add(DetailsInitRequested(item: item)),
        child: const DetailsView());
  }
}

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SubtreeBuilder(
        builder: (_, child) {
          return BlocBuilder<DetailsBloc, DetailsState>(
              buildWhen: (previousState, currentState) => previousState.theme != currentState.theme,
              builder: (_, state) => Theme(
                  data: state.theme,
                  child: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: state.theme.colorScheme.onBackground.computeLuminance() > 0.5
                              ? Brightness.light
                              : Brightness.dark),
                      child: child ?? const SizedBox())));
        },
        child: Scaffold(
            body: context.read<DetailsBloc>().state.item.type != ItemType.Photo
                ? const LargeDetails()
                : const PhotoItem()));
  }
}
