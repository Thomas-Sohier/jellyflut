part of 'sections.dart';

class TranscodeCodecPopupButton extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<String>>? popupButtonKey;

  const TranscodeCodecPopupButton({super.key, this.popupButtonKey});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      key: popupButtonKey,
      initialValue: context.read<SettingsBloc>().state.databaseSetting.preferredTranscodeAudioCodec,
      onSelected: (String? codec) => context
          .read<SettingsBloc>()
          .add(SettingsUpdateRequested(databaseSettingDto: DatabaseSettingDto(preferredTranscodeAudioCodec: codec))),
      itemBuilder: (BuildContext c) => _playerListTile(c),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) =>
                previous.databaseSetting.preferredTranscodeAudioCodec !=
                current.databaseSetting.preferredTranscodeAudioCodec,
            builder: (_, state) {
              return Text(state.databaseSetting.preferredTranscodeAudioCodec, style: TextStyle());
            }),
        const Icon(Icons.arrow_drop_down),
      ]),
    );
  }

  List<PopupMenuEntry<String>> _playerListTile(BuildContext context) {
    final languageItems = <PopupMenuEntry<String>>[];
    getTranscodeAudioCodecOptions().forEach((String codec) => languageItems.add(CheckedPopupMenuItem(
          value: codec,
          checked: context.read<SettingsBloc>().state.databaseSetting.preferredTranscodeAudioCodec == codec,
          child: Text(codec),
        )));
    return languageItems;
  }

  List<String> getTranscodeAudioCodecOptions() {
    return TranscodeAudioCodec.values.map((e) => e.name).toList();
  }
}
