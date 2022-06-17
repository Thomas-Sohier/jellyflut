import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';

import '../../../database/database.dart';

class DirectPlaySwitch extends StatefulWidget {
  final Database database;
  DirectPlaySwitch({super.key, required this.database});

  @override
  State<DirectPlaySwitch> createState() => _DirectPlaySwitchState();
}

class _DirectPlaySwitchState extends State<DirectPlaySwitch> {
  late ValueNotifier<bool> switchValue;
  late final Future<Setting> settingFuture;

  Future<Setting> get getCurrentSettings =>
      widget.database.settingsDao.getSettingsById(userApp!.settingsId);

  @override
  void initState() {
    switchValue = ValueNotifier(false);
    getCurrentSettings.then((s) {
      switchValue.value = s.directPlay;
    });
    super.initState();
  }

  void directPlayNewValue(bool value) async {
    final setting = await getCurrentSettings;
    final s = setting.toCompanion(true).copyWith(directPlay: Value(value));
    await widget.database.settingsDao.updateSettings(s);
    switchValue.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: switchValue,
        builder: (_, value, ___) {
          return Switch(value: value, onChanged: directPlayNewValue);
        });
  }
}
