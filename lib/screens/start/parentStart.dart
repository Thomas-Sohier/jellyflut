import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/home/background.dart';
import 'package:jellyflut/screens/start/loginForm.dart';
import 'package:jellyflut/screens/start/serverForm.dart';
import 'package:jellyflut/shared/theme.dart';

class ParentStart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ParentStartState();
  }
}

class _ParentStartState extends State<ParentStart> {
  bool _first = true;

  changeChildren() {
    setState(() {
      _first = !_first;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
          SizedBox(height: size.height * 0.15),
          Hero(
              tag: 'logo',
              child: Image(
                image: AssetImage('img/jellyfin_logo.png'),
                width: 120.0,
                alignment: Alignment.center,
              )),
          SizedBox(height: size.height * 0.03),
          Hero(
            tag: 'logo_text',
            child: Text(
              'Jellyfin',
              style: TextStyle(fontSize: 48, color: Colors.white),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Stack(children: [
            Container(
                padding: EdgeInsets.only(top: 25),
                child: Card(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          firstChild: ServerForm(
                            onPressed: changeChildren,
                          ),
                          secondChild: LoginForm(onPressed: changeChildren),
                          crossFadeState: _first
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        )))),
            if (!_first)
              Positioned.fill(
                  child: LayoutBuilder(builder: (context, constraints) {
                return Padding(
                    padding: EdgeInsets.only(
                        // top: constraints.biggest.height * .8,,
                        left: constraints.biggest.width * .25,
                        right: constraints.biggest.width * .25,
                        bottom: constraints.biggest.height * .87),
                    child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: jellyPurple,
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0))),
                        child: Stack(alignment: Alignment.center, children: [
                          Positioned.fill(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.dns,
                                    color: Colors.white,
                                  ))),
                          Positioned.fill(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    server.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )))
                        ])));
              }))
          ])
        ]))));
  }
}
