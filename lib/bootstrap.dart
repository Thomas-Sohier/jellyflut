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
import 'package:jellyflut/shared/shared_prefs.dart';
import 'package:music_player_api/music_player_api.dart';
import 'package:music_player_repository/music_player_repository.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:users_api/users_api.dart';
import 'package:users_repository/users_repository.dart';

import 'providers/theme/theme_provider.dart';

void bootstrap(
    {required Database database,
    required ThemeProvider themeProvider,
    required Dio dioClient,
    required AuthenticationApi authenticationApi,
    required DownloadsApi downloadsApi,
    required ItemsApi itemsApi,
    required UsersApi usersApi,
    required MusicPlayerApi musicPlayerApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final authenticationRepository = AuthenticationRepository(
      authenticationApi: authenticationApi,
      database: database,
      sharedPreferences: SharedPrefs.sharedPrefs,
      dioClient: dioClient);
  final downloadsRepository = DownloadsRepository(downloadsApi: downloadsApi);
  final itemsRepository =
      ItemsRepository(itemsApi: itemsApi, database: database, authenticationrepository: authenticationRepository);
  final usersRepository = UsersRepository(usersApi: usersApi, authenticationRepository: authenticationRepository);
  final musicPlayerRepository = MusicPlayerRepository(musicPlayerApi: musicPlayerApi);

  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async => runApp(
          App(
              database: database,
              themeProvider: themeProvider,
              authenticationRepository: authenticationRepository,
              downloadsRepository: downloadsRepository,
              itemsRepository: itemsRepository,
              usersRepository: usersRepository,
              musicPlayerRepository: musicPlayerRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
