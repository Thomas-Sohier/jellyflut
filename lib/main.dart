import 'package:database_downloads_api/database_downloads_api.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:items_api/items_api.dart';
import 'package:jellyfin_authentication_api/jellyfin_authentication_api.dart';
import 'package:jellyfin_downloads_api/jellyfin_downloads_api.dart';
import 'package:jellyflut/bootstrap.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/services/dio/dio_helper.dart';
import 'package:live_tv_api/live_tv_api.dart';
import 'package:music_player_api/music_player_api.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:streaming_api/streaming_api.dart';
import 'package:users_api/users_api.dart';

import './shared/app_init/app_init.dart' as impl;
import 'providers/theme/theme_provider.dart';
import 'shared/shared_prefs.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await impl.init();
  await SharedPrefs.init();
  await EasyLocalization.ensureInitialized();
  await setUpAndroidTv();
  final packageInfo = await PackageInfo.fromPlatform();

  // Providers
  final dioClient = DioHelper.generateDioClient();
  final themeProvider = ThemeProvider();
  final database = AppDatabase().getDatabase;
  final authenticationApi = JellyfinAuthenticationApi(dioClient: dioClient);
  final databaseDownloadsApi = DatabaseDownloadsApi(database: database);
  final jellyfinDownloadsApi = JellyfinDownloadsApi(dioClient: dioClient);
  final streamingApi = StreamingApi(dioClient: dioClient);
  final itemsApi = ItemsApi(dioClient: dioClient);
  final usersApi = UsersApi(dioClient: dioClient);
  final liveTvApi = LiveTvApi(dioClient: dioClient);
  final musicPlayerApi = MusicPlayerApi();

  await bootstrap(
      database: database,
      themeProvider: themeProvider,
      dioClient: dioClient,
      packageInfo: packageInfo,
      downloadsApi: databaseDownloadsApi,
      remoteDownloadsApi: jellyfinDownloadsApi,
      authenticationApi: authenticationApi,
      itemsApi: itemsApi,
      usersApi: usersApi,
      streamingApi: streamingApi,
      liveTvApi: liveTvApi,
      musicPlayerApi: musicPlayerApi);
}
