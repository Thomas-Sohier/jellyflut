import 'package:database_downloads_api/database_downloads_api.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:items_api/items_api.dart';
import 'package:jellyflut/bootstrap.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:sqlite_database/sqlite_database.dart';

import './shared/app_init/app_init.dart' as impl;
import 'shared/shared_prefs.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await impl.init();
  await SharedPrefs().init();
  await EasyLocalization.ensureInitialized();
  await setUpAndroidTv();
  final authenticated = await AuthService.isAuth();

  // Providerss
  final databaseDownloadsApi = DatabaseDownloadsApi(
    database: AppDatabase().getDatabase,
  );
  final itemsApi = ItemsApi(serverUrl: server.url, userId: userJellyfin!.id, dioClient: dio);

  bootstrap(authenticated: authenticated, downloadsApi: databaseDownloadsApi, itemsApi: itemsApi);
}
