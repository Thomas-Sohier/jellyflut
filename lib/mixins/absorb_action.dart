import 'dart:async';

import 'package:flutter/material.dart';

/// This mixin allow to prevent the action to be called multiple times
mixin AbsordAction<T extends StatefulWidget> on State<T> {
  late bool absorbing;

  @override
  void initState() {
    super.initState();
    absorbing = false;
  }

  void action(Function func) {
    if (!absorbing) {
      absorbing = true;
      Future.value(func.call()).whenComplete(() => absorbing = false);
    }
  }
}
