import 'package:authentication_repository/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/seasons/cubit/season_cubit.dart';
import 'package:jellyflut/screens/settings/bloc/settings_bloc.dart';
import 'package:jellyflut/shared/shared_prefs.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'details_download_cubit/details_download_cubit.dart';
import 'template/components/photo_item.dart';
import 'template/large_details.dart';

@RoutePage()
class DetailsPage extends StatelessWidget {
  final Item item;
  final String? heroTag;

  const DetailsPage({required this.item, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const MusicPlayerFAB(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<SeasonCubit>(
            create: (blocContext) => SeasonCubit(itemsRepository: context.read<ItemsRepository>(), item: item),
          ),
          BlocProvider<DetailsDownloadCubit>(
            create: (blocContext) =>
                DetailsDownloadCubit(item: item, downloadsRepository: context.read<DownloadsRepository>()),
          ),
          BlocProvider<DetailsBloc>(
            create: (blocContext) => DetailsBloc(
              item: item,
              heroTag: heroTag,
              sharedPreferences: SharedPrefs.sharedPrefs,
              themeProvider: context.read<ThemeProvider>(),
              itemsRepository: context.read<ItemsRepository>(),
              downloadsRepository: context.read<DownloadsRepository>(),
              authenticationRepository: context.read<AuthenticationRepository>(),
              contrastedPage: context.read<SettingsBloc>().state.detailsPageContrasted,
            )..add(DetailsInitRequested(item: item)),
          ),
        ],
        child: const DetailsView(),
      ),
    );
  }
}

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      buildWhen: (previous, current) => previous.theme != current.theme,
      builder: (context, state) {
        return Theme(
          data: state.theme,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: state.theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
            ),
            child: const _DetailsContent(),
          ),
        );
      },
    );
  }
}

// Le contenu réel de la page, maintenant dans son propre widget stateless
// pour garantir qu'il n'est pas reconstruit par le changement de thème.
class _DetailsContent extends StatelessWidget {
  const _DetailsContent();

  @override
  Widget build(BuildContext context) {
    final itemType = context.select((DetailsBloc bloc) => bloc.state.item.type);

    return Scaffold(body: itemType != ItemType.Photo ? const LargeDetailsWrapper() : const PhotoItem());
  }
}
