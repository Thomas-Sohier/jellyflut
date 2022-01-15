import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/title_bar/linux_title_bar.dart';
import 'package:jellyflut/components/title_bar/macos_title_bar.dart';
import 'package:jellyflut/components/title_bar/windows_title_bar.dart';

class TitleBar extends StatefulWidget {
  final Widget? child;
  const TitleBar({Key? key, this.child}) : super(key: key);

  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  late final Widget _titleBar;
  late final Widget _body;

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      _titleBar = WindowsTitleBar();
    } else if (Platform.isLinux) {
      _titleBar = LinuxTitleBar();
    } else if (Platform.isMacOS) {
      _titleBar = MacOsTitleBar();
    }

    _body = widget.child ?? const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return WindowBorder(
        color: Colors.grey.shade900,
        width: 1,
        child: Column(children: [_titleBar, Expanded(child: _body)]));
  }
}
