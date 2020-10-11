import 'package:flutter/material.dart';
import 'package:jellyflut/models/server.dart';
import 'package:jellyflut/screens/home/background.dart';
import 'package:jellyflut/shared/shared.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          SizedBox(height: size.height * 0.15),
          Hero(
              tag: "logo",
              child: Image(
                image: AssetImage('img/jellyfin_logo.png'),
                width: 120.0,
                alignment: Alignment.center,
              )),
          SizedBox(height: size.height * 0.03),
          Hero(
            tag: "logo_text",
            child: Text(
              "Jellyfin",
              style: TextStyle(fontSize: 48, color: Colors.white),
            ),
          )
        ]));
  }
}
