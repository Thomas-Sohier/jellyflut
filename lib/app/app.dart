import 'package:downloads_provider/downloads_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/downloads/download_provider.dart';
import 'package:jellyflut/providers/home/home_provider.dart';
import 'package:jellyflut/providers/home/home_tabs_provider.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/shared/custom_scroll_behavior.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_database/sqlite_database.dart';

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.authenticated,
      required this.downloadsRepository});

  final bool authenticated;
  final DownloadsRepository downloadsRepository;

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
            child: MultiRepositoryProvider(
                providers: [
                  RepositoryProvider.value(value: downloadsRepository)
                ],
                child: EasyLocalization(
                    supportedLocales: [
                      Locale('en', 'US'),
                      Locale('fr', 'FR'),
                      Locale('de', 'DE')
                    ],
                    path: 'translations',
                    assetLoader: YamlAssetLoader(),
                    fallbackLocale: Locale('en', 'US'),
                    child: const AppView()))));
  }
}

class ShortcutsWrapper extends StatelessWidget {
  final Widget child;
  const ShortcutsWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        // needed for AndroidTV to be able to select
        shortcuts: shortcuts,
        child: child);
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
        routerDelegate: customRouter.delegate(initialRoutes: [HomeRouter()]),
        routeInformationParser: customRouter.defaultRouteParser(),
      );
    });
  }
}

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
