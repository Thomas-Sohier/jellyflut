import 'package:flutter/material.dart';

class Background extends ChangeNotifier {
  /// Internal, private state of the background.
  late Image _image;

  /// The current image
  Image get image => _image;

  /// Adds [image] to background. This and [removeAll] are the only ways to modify the
  /// background from the outside.
  void changeImage(Image i) {
    _image = i;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes image from the background.
  // void remove() {
  //   _image = null;
  //   // This call tells the widgets that are listening to this model to rebuild.
  //   notifyListeners();
  // }
}
