import 'package:authentication_repository/authentication_repository.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/downloads/downloads_bloc/downloads_bloc.dart';
import 'package:jellyflut/screens/home/home_tabs_cubit/home_tabs_cubit.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';
import 'package:jellyflut/screens/settings/bloc/settings_bloc.dart';
import 'package:jellyflut/shared/custom_scroll_behavior.dart';
import 'package:jellyflut/shared/shared_prefs.dart';
import 'package:live_tv_repository/live_tv_repository.dart';
import 'package:music_player_repository/music_player_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:streaming_repository/streaming_repository.dart';
import 'package:users_repository/users_repository.dart';

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.database,
      required this.appRouter,
      required this.authBloc,
      required this.packageInfo,
      required this.themeProvider,
      required this.authenticationRepository,
      required this.settingsRepository,
      required this.downloadsRepository,
      required this.itemsRepository,
      required this.usersRepository,
      required this.liveTvRepository,
      required this.streamingRepository,
      required this.musicPlayerRepository});

  final Database database;
  final r.AppRouter appRouter;
  final AuthBloc authBloc;
  final PackageInfo packageInfo;
  final AuthenticationRepository authenticationRepository;
  final SettingsRepository settingsRepository;
  final DownloadsRepository downloadsRepository;
  final ItemsRepository itemsRepository;
  final UsersRepository usersRepository;
  final LiveTvRepository liveTvRepository;
  final StreamingRepository streamingRepository;
  final MusicPlayerRepository musicPlayerRepository;
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<Database>.value(value: database),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(value: authBloc),
              BlocProvider<DownloadsBloc>(
                create: (_) => DownloadsBloc(
                  downloadsRepository: downloadsRepository,
                )..add(const DownloadsSubscriptionRequested()),
              ),
              BlocProvider<SettingsBloc>(
                create: (_) => SettingsBloc(
                    settingsRepository: settingsRepository,
                    authenticationRepository: authenticationRepository,
                    sharedPreferences: SharedPrefs.sharedPrefs,
                    packageInfo: packageInfo)
                  ..add(const SettingsInitRequested()),
                lazy: false,
              ),
              BlocProvider(
                create: (c) => HomeTabsCubit(),
                lazy: false,
              ),
              BlocProvider(
                create: (c) => MusicPlayerBloc(
                  database: database,
                  itemsRepository: itemsRepository,
                  musicPlayerRepository: musicPlayerRepository,
                  streamingRepository: streamingRepository,
                  theme: themeProvider.getThemeData,
                ),
                lazy: false,
              ),
            ],
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider.value(value: authenticationRepository),
                RepositoryProvider.value(value: settingsRepository),
                RepositoryProvider.value(value: downloadsRepository),
                RepositoryProvider.value(value: itemsRepository),
                RepositoryProvider.value(value: usersRepository),
                RepositoryProvider.value(value: musicPlayerRepository),
                RepositoryProvider.value(value: liveTvRepository),
                RepositoryProvider.value(value: streamingRepository)
              ],
              child: EasyLocalization(
                  supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR'), Locale('de', 'DE')],
                  path: 'translations',
                  assetLoader: YamlAssetLoader(),
                  fallbackLocale: Locale('en', 'US'),
                  child: ShortcutsWrapper(child: AppView(appRouter: appRouter))),
            )));
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
  final r.AppRouter appRouter;

  const AppView({super.key, required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, ThemeProvider themeNotifier, child) {
      FlutterNativeSplash.remove();
      return MaterialApp.router(
        title: 'JellyFlut',
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        scrollBehavior: const CustomScrollBehavior(),
        supportedLocales: context.supportedLocales,
        theme: themeNotifier.getThemeData,
        localizationsDelegates: context.localizationDelegates,
        routeInformationParser: appRouter.defaultRouteParser(),
        routerDelegate: appRouter.delegate(initialRoutes: [r.HomeRouter()]),
        builder: (contextRouter, router) => BlocListener<AuthBloc, AuthState>(
            listener: (_, state) {
              if (!state.authStatus.isAuthenticated) {
                appRouter.replace(r.LoginPage());
              }
            },
            child: router),
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
  LogicalKeySet(LogicalKeyboardKey.arrowDown):
      const DirectionalFocusIntent(TraversalDirection.down, ignoreTextFields: false),
  LogicalKeySet(LogicalKeyboardKey.arrowUp):
      const DirectionalFocusIntent(TraversalDirection.up, ignoreTextFields: false),
  LogicalKeySet(LogicalKeyboardKey.arrowLeft):
      const DirectionalFocusIntent(TraversalDirection.left, ignoreTextFields: false),
  LogicalKeySet(LogicalKeyboardKey.arrowRight):
      const DirectionalFocusIntent(TraversalDirection.right, ignoreTextFields: false),
};
