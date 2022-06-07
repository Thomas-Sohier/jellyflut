import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/downloads/download_provider.dart';
import 'package:jellyflut/providers/home/home_provider.dart';
import 'package:jellyflut/providers/home/home_tabs_provider.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import 'shared/custom_scroll_behavior.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  await DartVLC.initialize();
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final auth = await AuthService.isAuth();
  await EasyLocalization.ensureInitialized();
  await setUpSharedPrefs();
  await setUpAndroidTv();

  runApp(EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('de', 'DE')
      ],
      path: 'translations',
      assetLoader: YamlAssetLoader(),
      fallbackLocale: Locale('en', 'US'),
      child: Jellyflut(authenticated: auth)));
}

class Jellyflut extends StatelessWidget {
  final bool authenticated;
  final shortcuts = <LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
    LogicalKeySet.fromSet(<LogicalKeyboardKey>{
      LogicalKeyboardKey.select,
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.space,
      LogicalKeyboardKey.gameButtonSelect,
      LogicalKeyboardKey.gameButtonStart,
      LogicalKeyboardKey.open,
      LogicalKeyboardKey.mediaPlayPause,
      LogicalKeyboardKey.mediaPlay,
    }): const ActivateIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowDown): const DirectionalFocusIntent(
        TraversalDirection.down,
        ignoreTextFields: false),
    LogicalKeySet(LogicalKeyboardKey.arrowUp): const DirectionalFocusIntent(
        TraversalDirection.up,
        ignoreTextFields: false),
    LogicalKeySet(LogicalKeyboardKey.arrowLeft): const DirectionalFocusIntent(
        TraversalDirection.left,
        ignoreTextFields: false),
    LogicalKeySet(LogicalKeyboardKey.arrowRight): const DirectionalFocusIntent(
        TraversalDirection.right,
        ignoreTextFields: false),
  };

  Jellyflut({super.key, required this.authenticated});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<Database>(
            create: (context) => Database(),
            dispose: (context, db) => db.close(),
          ),
          ChangeNotifierProvider<SearchProvider>(
              create: (_) => SearchProvider()),
          ChangeNotifierProvider<MusicProvider>(create: (_) => MusicProvider()),
          ChangeNotifierProvider<HomeTabsProvider>(
              create: (_) => HomeTabsProvider()),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<DownloadProvider>(
              create: (_) => DownloadProvider()),
          ChangeNotifierProvider<HomeCategoryProvider>(
              create: (_) => HomeCategoryProvider()),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AuthBloc(authenticated: authenticated),
                lazy: false,
              ),
            ],
            child: Shortcuts(
                // needed for AndroidTV to be able to select
                shortcuts: shortcuts,
                child: Consumer<ThemeProvider>(
                    builder: (context, ThemeProvider themeNotifier, child) {
                  FlutterNativeSplash.remove();
                  return MaterialApp.router(
                    title: 'JellyFlut',
                    locale: context.locale,
                    debugShowCheckedModeBanner: false,
                    scrollBehavior: CustomScrollBehavior(),
                    supportedLocales: context.supportedLocales,
                    theme: themeNotifier.getThemeData,
                    localizationsDelegates: context.localizationDelegates,
                    routerDelegate:
                        customRouter.delegate(initialRoutes: [HomeRouter()]),
                    routeInformationParser: customRouter.defaultRouteParser(),
                  );
                }))));
  }
}
