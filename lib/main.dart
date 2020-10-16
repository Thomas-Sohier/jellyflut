import 'package:flutter/material.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/collection/collectionMain.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/splash/splash.dart';
import 'package:jellyflut/screens/start/parentStart.dart';
import 'package:jellyflut/screens/stream/stream.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService();
  init();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => MusicPlayer(),
        child: MaterialApp(
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
            '/details': (context) => Details(),
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(builder: (BuildContext context) => Home());
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text(widget.title),
        // ),
        backgroundColor: Colors.white,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF3E2247), Color(0xFF003C50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.

                child: Container())));
  }
}
