import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/musicProvider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  DartVLC.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await setUpSharedPrefs();
  await setUpAndroidTv();
  runApp(Jellyflut());
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
      loaderColor: personnal_theme.jellyPurple,
    );
  }
}

class Jellyflut extends StatelessWidget {
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: MusicProvider(),
        child: Shortcuts(
            // needed for AndroidTV to be able to select
            shortcuts: shortcuts,
            child: MaterialApp.router(
              title: 'JellyFlut',
              theme: personnal_theme.Theme.defaultThemeData,
              debugShowCheckedModeBanner: false,
              routerDelegate:
                  customRouter.delegate(initialRoutes: [HomeRoute()]),
              routeInformationParser: customRouter.defaultRouteParser(),
            )));
  }
}
