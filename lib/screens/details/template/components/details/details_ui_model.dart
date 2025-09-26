import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

class DetailsUIModel extends ChangeNotifier {
  ScreenLayout _layout = ScreenLayout.mobile;
  BoxConstraints _constraints = const BoxConstraints();
  bool _isPinned = false;
  Timer? _debounce;

  ScreenLayout get layout => _layout;
  BoxConstraints get constraints => _constraints;
  bool get isPinned => _isPinned;

  /// Met à jour l'état du layout et notifie les auditeurs SEULEMENT si la valeur change.
  void updateLayout(ScreenLayout newLayout) {
    if (_layout == newLayout) return;
    _layout = newLayout;
    notifyListeners();
  }

  /// Met à jour l'état "épinglé" et notifie les auditeurs SEULEMENT si la valeur change.
  void updatePinnedState(bool newPinnedState) {
    if (_isPinned == newPinnedState) return;
    _isPinned = newPinnedState;
    notifyListeners();
  }

  void updatePinnedStateFromShrink(double shrinkOffset) {
    updatePinnedState(shrinkOffset > 0);
  }

  /// Met à jour les contraintes avec un debounce pour la performance.
  /// La notification ne sera envoyée qu'après la fin du délai d'inactivité.
  void updateConstraints(
    BoxConstraints newConstraints, {
    Duration debounceDuration = const Duration(milliseconds: 250),
  }) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(debounceDuration, () {
      if (_constraints == newConstraints) return;

      _constraints = newConstraints;
      notifyListeners();
    });
  }
}
