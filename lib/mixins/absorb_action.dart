import 'dart:async';

import 'package:flutter/material.dart';

/// Un mixin pour empêcher l'exécution d'actions multiples et rapides (double-clic).
mixin AbsorbAction {
  bool _isActionAbsorbed = false;

  /// Exécute la fonction fournie [actionToRun] une seule fois et ignore les appels
  /// suivants pendant une courte durée (par défaut 500ms).
  ///
  /// Ceci est utile pour les boutons de navigation afin d'éviter de pousser
  /// la même route plusieurs fois sur la pile.
  @protected
  void action(void Function() actionToRun, {Duration debounceDuration = const Duration(milliseconds: 500)}) {
    if (_isActionAbsorbed) {
      return; // Ignore l'action si une autre est déjà en cours.
    }

    _isActionAbsorbed = true;
    actionToRun(); // Exécute l'action fournie.

    // Après la durée spécifiée, autorise à nouveau les actions.
    Future.delayed(debounceDuration, () {
      _isActionAbsorbed = false;
    });
  }
}
