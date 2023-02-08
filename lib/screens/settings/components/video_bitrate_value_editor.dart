part of 'sections.dart';

class VideoBitrateValueEditor extends StatefulWidget {
  const VideoBitrateValueEditor({super.key});

  @override
  State<VideoBitrateValueEditor> createState() => _VideoBitrateValueEditorState();
}

class _VideoBitrateValueEditorState extends State<VideoBitrateValueEditor> {
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
            previous.databaseSetting.maxVideoBitrate != current.databaseSetting.maxVideoBitrate,
        builder: (_, state) {
          return Text('${state.databaseSetting.maxVideoBitrate / 1000000} Mbps');
        });
  }

  void editBitrateValue(BuildContext context) async {
    final settings = context.read<SettingsBloc>().state.databaseSetting;
    controller.value = TextEditingValue(text: settings.maxVideoBitrate.toString());
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (c) {
          return AlertDialog(
              title: Text(
                'Edit max video bitrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              actions: [
                TextButton(onPressed: context.router.root.pop, child: Text('cancel'.tr())),
                TextButton(onPressed: videoBitrateNewValue, child: Text('save'.tr()))
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
                        initialData: settings.maxVideoBitrate.toString(),
                        builder: (c, s) {
                          return Text(
                            controller.value.text.isNotEmpty ? '${int.parse(s.data!) / 1000000} Mbps' : '0 Mbps',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
                          );
                        })
                  ]));
        });
  }

  Future<void> videoBitrateNewValue() async {
    context.read<SettingsBloc>().add(
        SettingsUpdateRequested(databaseSettingDto: DatabaseSettingDto(maxVideoBitrate: int.parse(controller.text))));
    await context.router.root.pop();
  }
}
