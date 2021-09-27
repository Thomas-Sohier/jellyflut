import 'package:dart_vlc/dart_vlc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/screens/form/bloc/form_bloc.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  DartVLC.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setUpSharedPrefs();
  await setUpAndroidTv();
  final auth = await AuthService.isAuth();
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
    return ChangeNotifierProvider.value(
        value: MusicProvider(),
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => FormBloc(),
              ),
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
                  routerDelegate:
                      customRouter.delegate(initialRoutes: [HomeRouter()]),
                  routeInformationParser: customRouter.defaultRouteParser(),
                ))));
  }
}
