import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/title_bar/title_bar.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/downloads/download_provider.dart';
import 'package:jellyflut/providers/home/home_provider.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/home/components/jellyfin_logo.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  DartVLC.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  final auth = await AuthService.isAuth();
  await EasyLocalization.ensureInitialized();
  await setUpSharedPrefs();
  await setUpAndroidTv();

  // Prepare windows title bar while loading app
  // Only on computer
  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    doWhenWindowReady(() {
      appWindow.alignment = Alignment.center;
      appWindow.title = 'Jellyflut';
      appWindow.show();
    });
  }

  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'translations',
      assetLoader: YamlAssetLoader(),
      fallbackLocale: Locale('en', 'US'),
      child: Jellyflut(authenticated: auth)));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      title: Text(''),
      loadingText: Text(''),
      styleTextUnderTheLoader: TextStyle(fontSize: 16),
      useLoader: false,
      loadingTextPadding: EdgeInsets.all(2),
      image: Image.asset('img/jellyfin_logo.png'),
      backgroundColor: Color(0xFF252525),
      photoSize: 80.0,
    );
  }
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

  Jellyflut({Key? key, required this.authenticated}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<Database>(
            create: (context) => Database(),
            dispose: (context, db) => db.close(),
          ),
          ChangeNotifierProvider<MusicProvider>(create: (_) => MusicProvider()),
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
                child: MaterialApp.router(
                  title: 'JellyFlut',
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  theme: personnal_theme.Theme.defaultThemeData,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    // Show only title bar on computer or we will have build error on phones
                    if (Platform.isMacOS ||
                        Platform.isLinux ||
                        Platform.isWindows) {
                      return TitleBar(child: child);
                    }
                    return child ?? const SizedBox();
                  },
                  routerDelegate: customRouter.delegate(
                      initialRoutes: [HomeRouter()],
                      navigatorObservers: () =>
                          <NavigatorObserver>[AutoRouteObserver()]),
                  routeInformationParser: customRouter.defaultRouteParser(),
                ))));
  }
}
