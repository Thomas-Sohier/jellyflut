import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/screens/home/components/jellyfin_logo.dart';

class TitleBar extends StatelessWidget {
  final Widget? child;
  const TitleBar({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowBorder(
        color: Colors.grey.shade900,
        width: 1,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(color: Colors.grey.shade900),
              child: WindowTitleBarBox(
                  child: Row(children: [
                Expanded(
                    child: MoveWindow(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Hero(tag: 'logo', child: const JellyfinLogo()),
                        Padding(padding: const EdgeInsets.only(left: 6)),
                        Material(
                          color: Colors.transparent,
                          child: Text('Jellyfin',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Quicksand')),
                        )
                      ],
                    ),
                  ),
                )),
                WindowButtons()
              ]))),
          Expanded(
              child:
                  child ?? Container(color: Theme.of(context).backgroundColor))
        ]));
  }
}
