import 'package:flutter/widgets.dart';

class FormController<T> extends ChangeNotifier {
  final T value;
  final VoidCallback onError;
  final Function(T) onSucces;

  FormController({
    required this.value,
    required this.onSucces,
    required this.onError,
  });

  void submit() {
    notifyListeners();
  }
}
