part of 'sections.dart';

class VideoPlayerPopupButton extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<String>>? popupButtonKey;

  const VideoPlayerPopupButton({super.key, this.popupButtonKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.databaseSetting.preferredPlayer != current.databaseSetting.preferredPlayer,
      builder: (_, state) => PopupMenuButton<String>(
        key: popupButtonKey,
        initialValue: state.databaseSetting.preferredPlayer,
        onSelected: (String? player) => context
            .read<SettingsBloc>()
            .add(SettingsUpdateRequested(databaseSettingDto: DatabaseSettingDto(preferredPlayer: player))),
        itemBuilder: (BuildContext c) => _playerListTile(c),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(state.databaseSetting.preferredPlayer, style: TextStyle()),
          Icon(Icons.arrow_drop_down),
        ]),
      ),
    );
  }

  List<PopupMenuEntry<String>> _playerListTile(BuildContext context) {
    final setting = context.read<SettingsBloc>().state.databaseSetting;
    final languageItems = <PopupMenuEntry<String>>[];
    StreamingSoftware.getVideoPlayerOptions(context).forEach((player) => languageItems.add(CheckedPopupMenuItem(
          value: player.name,
          checked: setting.preferredPlayer == player.name,
          child: Text(player.name),
        )));
    return languageItems;
  }
}
