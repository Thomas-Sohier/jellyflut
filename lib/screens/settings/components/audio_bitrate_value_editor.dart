part of 'sections.dart';

class AudioBitrateValueEditor extends StatefulWidget {
  final Database database;
  AudioBitrateValueEditor({Key? key, required this.database}) : super(key: key);

  @override
  _AudioBitrateValueEditorState createState() =>
      _AudioBitrateValueEditorState();
}

class _AudioBitrateValueEditorState extends State<AudioBitrateValueEditor> {
  late int _maxBitrateValue;
  late String maxBitrate;
  late Setting setting;
  late final Future<Setting> settingFuture;
  late final TextEditingController controller;
  late final BehaviorSubject<String> textControllerStreamValue =
      BehaviorSubject<String>();

  @override
  void initState() {
    settingFuture =
        widget.database.settingsDao.getSettingsById(userApp!.settingsId);
    settingFuture.then((value) {
      setting = value;
      _maxBitrateValue = value.maxAudioBitrate;
      maxBitrate = _maxBitrateValue.toString();
    });
    controller = TextEditingController();
    controller.addListener(() {
      textControllerStreamValue.add(controller.value.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Setting>(
        future: settingFuture,
        builder: (c, s) {
          if (s.hasData) {
            return Text('${_maxBitrateValue / 1000000} Mbps');
          }
          return const SizedBox();
        });
  }

  void editBitrateValue(BuildContext context) async {
    controller.value = TextEditingValue(text: _maxBitrateValue.toString());
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (c) {
          return AlertDialog(
              title: Text('Edit max audio bitrate'),
              actions: [
                CancelButton(onPressed: () => customRouter.pop()),
                SubmitButton(onPressed: () {
                  maxBitrate = controller.text;
                  _maxBitrateValue = int.parse(maxBitrate);
                  final s = setting
                      .toCompanion(true)
                      .copyWith(maxAudioBitrate: Value(_maxBitrateValue));
                  AppDatabase().getDatabase.settingsDao.updateSettings(s);
                  setState(() {});
                  customRouter.pop();
                })
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
                            border: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade600, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 2.0)))),
                    const SizedBox(height: 12),
                    StreamBuilder<String>(
                        stream: textControllerStreamValue,
                        initialData: maxBitrate,
                        builder: (c, s) {
                          return Text(
                            controller.value.text.isNotEmpty
                                ? '${int.parse(s.data!) / 1000000} Mbps'
                                : '0 Mbps',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: Colors.grey.shade400),
                          );
                        })
                  ]));
        });
  }
}
