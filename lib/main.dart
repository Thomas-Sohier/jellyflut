import 'package:flutter/material.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/collection/collectionMain.dart';
import 'package:jellyflut/screens/home/home.dart';
import 'package:jellyflut/screens/start/parentStart.dart';
import 'package:jellyflut/screens/stream/streamBP.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
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
    DatabaseService();
    futures.add(isAuth());
    futures.add(Future.delayed(Duration(seconds: 1)));
    var resp = await Future.wait(futures);
    if (resp[0]) {
      return Future.value(Home());
    }
    return Future.value(ParentStart());
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: initMain(),
      image: Image.asset('img/jellyfin_logo.png'),
      backgroundColor: Colors.grey[900],
      photoSize: 80.0,
      loaderColor: color1,
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Jellyflut extends StatelessWidget {
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
      home: MyApp(),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // '/': (context) => Splash(),
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

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Welcome In SplashScreen Package"),
          automaticallyImplyLeading: false),
      body: new Center(
        child: new Text(
          "Done!",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
      ),
    );
  }
}
