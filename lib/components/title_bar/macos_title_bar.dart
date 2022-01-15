import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/title_bar/windows_buttons.dart';
import 'package:jellyflut/screens/home/components/jellyfin_logo.dart';

class MacOsTitleBar extends StatelessWidget {
  const MacOsTitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.grey.shade900),
        child: WindowTitleBarBox(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
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
        ));
  }
}
