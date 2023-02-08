part of 'sections.dart';

class AudioBitrateValueEditor extends StatefulWidget {
  const AudioBitrateValueEditor({super.key});

  @override
  State<AudioBitrateValueEditor> createState() => _AudioBitrateValueEditorState();
}

class _AudioBitrateValueEditorState extends State<AudioBitrateValueEditor> {
  late final TextEditingController controller;
  late final BehaviorSubject<String> textControllerStreamValue = BehaviorSubject<String>();

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(() => textControllerStreamValue.add(controller.value.text));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) =>
            previous.databaseSetting.preferredPlayer != current.databaseSetting.preferredPlayer,
        builder: (_, state) {
          return Text('${state.databaseSetting.maxAudioBitrate / 1000000} Mbps');
        });
  }

  void editBitrateValue(BuildContext context) async {
    final settings = context.read<SettingsBloc>().state.databaseSetting;
    controller.value = TextEditingValue(text: settings.maxAudioBitrate.toString());
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (c) {
          return AlertDialog(
              title: Text(
                'Edit max audio bitrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              actions: [
                TextButton(onPressed: context.router.root.pop, child: Text('cancel'.tr())),
                TextButton(onPressed: audioBitrateNewValue, child: Text('save'.tr()))
              ],
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                        keyboardType: TextInputType.number,
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'max_bitrate'.tr(),
                          labelStyle: TextStyle(),
                        )),
                    const SizedBox(height: 12),
                    StreamBuilder<String>(
                        stream: textControllerStreamValue,
                        initialData: settings.maxAudioBitrate.toString(),
                        builder: (c, s) {
                          return Text(
                            controller.value.text.isNotEmpty ? '${int.parse(s.data!) / 1000000} Mbps' : '0 Mbps',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        })
                  ]));
        });
  }

  Future<void> audioBitrateNewValue() async {
    context.read<SettingsBloc>().add(
        SettingsUpdateRequested(databaseSettingDto: DatabaseSettingDto(maxAudioBitrate: int.parse(controller.text))));
    await context.router.root.pop();
  }
}
