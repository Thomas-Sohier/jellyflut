import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:downloads_api/downloads_api.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:items_api/items_api.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/app/app.dart';
import 'package:jellyflut/app/app_bloc_observer.dart';
import 'package:users_api/users_api.dart';
import 'package:users_repository/users_repository.dart';

void bootstrap(
    {required bool authenticated,
    required DownloadsApi downloadsApi,
    required ItemsApi itemsApi,
    required UsersApi usersApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final downloadsRepository = DownloadsRepository(downloadsApi: downloadsApi);
  final itemsRepository = ItemsRepository(itemsApi: itemsApi);
  final usersRepository = UsersRepository(usersApi: usersApi);

  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async => runApp(
          App(
              authenticated: authenticated,
              downloadsRepository: downloadsRepository,
              itemsRepository: itemsRepository,
              usersRepository: usersRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
