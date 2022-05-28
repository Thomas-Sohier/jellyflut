part of 'sections.dart';

class VideoPlayerPopupButton extends StatefulWidget {
  final String? initialValue;
  final Setting setting;
  final Database database;
  final GlobalKey<PopupMenuButtonState<String>>? popupButtonKey;

  const VideoPlayerPopupButton(
      {Key? key,
      required this.setting,
      required this.database,
      this.popupButtonKey,
      this.initialValue})
      : super(key: key);

  @override
  _VideoPlayerPopupButtonState createState() => _VideoPlayerPopupButtonState();
}

class _VideoPlayerPopupButtonState extends State<VideoPlayerPopupButton> {
  String? currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue ?? widget.setting.preferredPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      key: widget.popupButtonKey,
      initialValue: currentValue,
      onSelected: (String? player) => setValue(player),
      itemBuilder: (BuildContext c) => _playerListTile(c),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(currentValue ?? '', style: TextStyle()),
        Icon(Icons.arrow_drop_down),
      ]),
    );
  }

  List<PopupMenuEntry<String>> _playerListTile(BuildContext context) {
    final languageItems = <PopupMenuEntry<String>>[];
    StreamingSoftware.getVideoPlayerOptions()
        .forEach((player) => languageItems.add(CheckedPopupMenuItem(
              value: player.name,
              checked: currentValue == player.name,
              child: Text(player.name),
            )));
    return languageItems;
  }

  void setValue(String? value) async {
    if (value != null) {
      final selectedValue = value.toLowerCase();
      final newSetting = widget.setting
          .toCompanion(true)
          .copyWith(preferredPlayer: Value(selectedValue));
      await widget.database.settingsDao.updateSettings(newSetting);
      setState(() {
        currentValue = value;
      });
    }
  }
}
