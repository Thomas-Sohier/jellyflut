import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/auth/serverForm.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;

import 'loginForm.dart';

class AuthParent extends StatefulWidget {
  final VoidCallback? onAuthenticated;

  const AuthParent({Key? key, this.onAuthenticated}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AuthParentState();
  }
}

class _AuthParentState extends State<AuthParent> {
  bool _first = true;

  void changeChildren() {
    setState(() {
      _first = !_first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: ListView(children: [
            SizedBox(
              height: paddingTop + 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                    tag: 'logo',
                    child: Image(
                      image: AssetImage('img/jellyfin_logo.png'),
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                    )),
                SizedBox(height: 24),
                Hero(
                  tag: 'logo_text',
                  child: Text(
                    'Jellyfin',
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ),
              ],
            ),
            Stack(alignment: Alignment.center, children: [
              Container(
                  constraints: BoxConstraints(maxWidth: 600),
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
                  top: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        constraints: BoxConstraints(maxWidth: 300),
                        height: 60,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: personnal_theme.jellyPurple,
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
                        ])),
                  ),
                )
            ]),
          ]),
        ));
  }
}
