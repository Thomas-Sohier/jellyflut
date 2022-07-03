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

void bootstrap({required bool authenticated, required DownloadsApi downloadsApi, required ItemsApi itemsApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final downloadsRepository = DownloadsRepository(downloadsApi: downloadsApi);
  final itemsRepository = ItemsRepository(itemsApi: itemsApi);

  runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async => runApp(
          App(authenticated: authenticated, downloadsRepository: downloadsRepository, itemsRepository: itemsRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
