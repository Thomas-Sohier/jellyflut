import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/start/parentStart.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  DartVLC.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Jellyflut());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Widget> initMain() async {
    var futures = <Future>[];
    futures.add(isAuth());
    futures.add(Future.delayed(Duration(seconds: 2)));
    var resp = await Future.wait(futures);
    if (resp[0]) {
      return Future.value(Home());
    }
    return Future.value(ParentStart());
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      title: Text(''),
      loadingText: Text(''),
      styleTextUnderTheLoader: TextStyle(fontSize: 16),
      useLoader: false,
      loadingTextPadding: EdgeInsets.all(2),
      navigateAfterFuture: initMain(),
      image: Image.asset('img/jellyfin_logo.png'),
      backgroundColor: Color(0xFF252525),
      photoSize: 80.0,
      loaderColor: jellyPurple,
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Jellyflut extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: MusicPlayer(),
        child: Shortcuts(
            // needed for AndroidTV to be able to select
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet.fromSet(<LogicalKeyboardKey>{
                LogicalKeyboardKey.select,
                LogicalKeyboardKey.enter,
                LogicalKeyboardKey.space,
                LogicalKeyboardKey.mediaPlayPause,
                LogicalKeyboardKey.mediaPlay,
              }): const ActivateIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowDown):
                  const DirectionalFocusIntent(TraversalDirection.down,
                      ignoreTextFields: false),
              LogicalKeySet(LogicalKeyboardKey.arrowUp):
                  const DirectionalFocusIntent(TraversalDirection.up,
                      ignoreTextFields: false),
              LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                  const DirectionalFocusIntent(TraversalDirection.left,
                      ignoreTextFields: false),
              LogicalKeySet(LogicalKeyboardKey.arrowRight):
                  const DirectionalFocusIntent(TraversalDirection.right,
                      ignoreTextFields: false),
            },
            child: MaterialApp(
              title: 'JellyFlut',
              navigatorKey: navigatorKey,
              theme: ThemeData(
                primarySwatch: jellyPurple,
                brightness: Brightness.light,
                visualDensity: VisualDensity.comfortable,
              ),
              home: MyApp(),
              routes: {
                '/login': (context) => ParentStart(),
                '/home': (context) => Home(),
              },
              onUnknownRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                    builder: (BuildContext context) => Home());
              },
            )));
  }
}
