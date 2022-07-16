import 'dart:async';
import 'dart:developer';

import 'package:authentication_api/authentication_api.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:downloads_api/downloads_api.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:items_api/items_api.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/app/app.dart';
import 'package:jellyflut/app/app_bloc_observer.dart';
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/shared/shared_prefs.dart';
import 'package:live_tv_api/live_tv_api.dart';
import 'package:live_tv_repository/live_tv_repository.dart';
import 'package:music_player_api/music_player_api.dart';
import 'package:music_player_repository/music_player_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:users_api/users_api.dart';
import 'package:users_repository/users_repository.dart';

import 'providers/theme/theme_provider.dart';

void bootstrap(
    {required Database database,
    required ThemeProvider themeProvider,
    required Dio dioClient,
    required PackageInfo packageInfo,
    required AuthenticationApi authenticationApi,
    required DownloadsApi downloadsApi,
    required ItemsApi itemsApi,
    required UsersApi usersApi,
    required LiveTvApi liveTvApi,
    required MusicPlayerApi musicPlayerApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final authenticationRepository = AuthenticationRepository(
      authenticationApi: authenticationApi,
      database: database,
      sharedPreferences: SharedPrefs.sharedPrefs,
      dioClient: dioClient);
  final settingsRepository = SettingsRepository(database: database, authenticationRepository: authenticationRepository);
  final downloadsRepository = DownloadsRepository(downloadsApi: downloadsApi);
  final itemsRepository =
      ItemsRepository(itemsApi: itemsApi, database: database, authenticationrepository: authenticationRepository);
  final usersRepository = UsersRepository(usersApi: usersApi, authenticationRepository: authenticationRepository);
  final musicPlayerRepository = MusicPlayerRepository(musicPlayerApi: musicPlayerApi);
  final liveTvRepository = LiveTvRepository(liveTvApi: liveTvApi, authenticationrepository: authenticationRepository);

  // Init auth bloc here to use it down the tree in AppView
  // Needed to route correctly without context
  final authBloc = AuthBloc(
      authenticationRepository: authenticationRepository,
      authenticated: authenticationRepository.currentUser.isNotEmpty);

  final appRouter = AppRouter(authGuard: AuthGuard(authBloc: authBloc));

  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async => runApp(
          App(
              database: database,
              themeProvider: themeProvider,
              appRouter: appRouter,
              packageInfo: packageInfo,
              authBloc: authBloc,
              settingsRepository: settingsRepository,
              authenticationRepository: authenticationRepository,
              downloadsRepository: downloadsRepository,
              itemsRepository: itemsRepository,
              usersRepository: usersRepository,
              liveTvRepository: liveTvRepository,
              musicPlayerRepository: musicPlayerRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
