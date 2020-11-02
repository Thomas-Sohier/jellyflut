import 'package:flutter/material.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/screens/collection/collectionMain.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/splash/splash.dart';
import 'package:jellyflut/screens/start/parentStart.dart';
import 'package:jellyflut/screens/stream/stream.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService();
  await init();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JellyFlut',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: color1,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Splash(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => ParentStart(),
        '/home': (context) => Home(),
        '/collection': (context) => CollectionMain(),
        '/watch': (context) => Stream(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) => Home());
      },
    );
  }
}
