import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jellyflut/components/card/tabButton.dart';
import 'package:jellyflut/components/expandedSection.dart';
import 'package:jellyflut/components/infosButton.dart';
import 'package:jellyflut/components/peoplesList.dart';
import 'package:jellyflut/components/unorderedList.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/itemType.dart';
import 'package:jellyflut/models/mediaStreamType.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/details/itemDialogActions.dart';
import 'package:jellyflut/screens/stream/model/audiotrack.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/shared/shared.dart';

import 'cardItemWithChild.dart';

class CardInfos extends StatefulWidget {
  CardInfos(this.item);

  final Item item;

  @override
  State<StatefulWidget> createState() => _CardInfosState();
}

class _CardInfosState extends State<CardInfos> {
  late bool _infos;
  late AudioTrack audioValue;
  late Subtitle subValue;
  late List<DropdownMenuItem<AudioTrack>> audioTracks;
  late List<DropdownMenuItem<Subtitle>> subtitles;
  late StreamModel streamModel;

  @override
  void initState() {
    super.initState();
    _infos = false;
    streamModel = StreamModel();
    audioTracks = audioDropdownItems(widget.item);
    subtitles = subDropdownItems(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return Column(
      children: [
        if (item.mediaSources != null) sourceDropdown(item),
        Row(
          children: [
            actionIcons(item),
            Spacer(),
            if (item.userData?.playbackPositionTicks != null)
              Text(printDuration(Duration(
                      microseconds: (item.userData!.playbackPositionTicks / 10)
                          .round())) +
                  ' - '),
            if (item.runTimeTicks != null)
              Text(printDuration(Duration(microseconds: item.getDuration()))),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: InfosButton(
                    onTap: () => setState(() {
                          _infos = !_infos;
                        })))
          ],
        ),
        details(item, context),
      ],
    );
  }

  Widget sourceDropdown(Item item) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: DropdownButtonHideUnderline(
                child: Container(
              height: 36,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: DropdownButton<AudioTrack>(
                  value: audioTracks.isNotEmpty
                      ? audioTracks
                          .firstWhere((audioTrack) =>
                              audioTrack.value!.jellyfinSubtitleIndex ==
                              audioValue.jellyfinSubtitleIndex)
                          .value
                      : null,
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  isDense: true,
                  elevation: 16,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black),
                  hint: Text('Audio'),
                  onChanged: (AudioTrack? audioTrack) {
                    if (audioTrack != null) {
                      setState(() {
                        audioValue = audioTrack;
                        streamModel.setAudioStreamIndex(audioTrack);
                      });
                    }
                  },
                  items: audioTracks),
            ))),
        Spacer(
          flex: 1,
        ),
        Expanded(
            flex: 5,
            child: DropdownButtonHideUnderline(
              child: Container(
                height: 36,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: DropdownButton<Subtitle>(
                    value: subtitles.isNotEmpty
                        ? subtitles
                            .firstWhere((subtitle) =>
                                subtitle.value!.jellyfinSubtitleIndex ==
                                subValue.jellyfinSubtitleIndex)
                            .value
                        : null,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    isDense: true,
                    isExpanded: true,
                    style: TextStyle(color: Colors.black),
                    hint: Text('Subtitles'),
                    onChanged: (Subtitle? subtitle) {
                      if (subtitle != null) {
                        setState(() {
                          subValue = subtitle;
                          streamModel.setSubtitleStreamIndex(subtitle);
                        });
                      }
                    },
                    items: subtitles),
              ),
            )),
      ],
    );
  }

  Widget tabs(Item item, BuildContext context) {
    var isPerson = item.type == ItemType.PERSON;
    return DefaultTabController(
        // The number of tabs / content sections to display.
        length: isPerson ? 2 : 3,
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 250),
            child: Column(
              children: [
                TabBar(tabs: [
                  TabButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    ),
                  ),
                  if (!isPerson)
                    TabButton(
                      icon: Icon(
                        Icons.person_outline,
                        color: Colors.black,
                      ),
                    ),
                  TabButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.black,
                    ),
                  ),
                ]),
                Flexible(
                    child: TabBarView(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: infos(item, context),
                  ),
                  if (!isPerson)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PeoplesList(item.people!),
                    ),
                  Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ItemDialogActions(item, null),
                      ))
                ]))
              ],
            )));
  }

  Widget details(Item item, BuildContext context) {
    return ExpandedSection(expand: _infos, child: tabs(item, context));
  }

  Widget infos(Item item, BuildContext context) {
    var titleStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
    var valueStyle = TextStyle(fontSize: 16);
    var formatter = DateFormat('dd-MM-yyyy');
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          if (item.videoType != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video : ',
                  style: titleStyle,
                ),
                UnorderedList(
                    texts: item.mediaStreams!
                        .where(
                            (element) => element.type == MediaStreamType.VIDEO)
                        .map((e) => e.displayTitle! + ', ' + e.codec!)
                        .toList()),
              ],
            ),
          if (item.container != null)
            Row(
              children: [
                Text(
                  'Container : ',
                  style: titleStyle,
                ),
                Text(
                  item.container!,
                  style: valueStyle,
                ),
              ],
            ),
          if (item.dateCreated != null)
            Row(
              children: [
                Text(
                  'Date added : ',
                  style: titleStyle,
                ),
                Text(
                  formatter.format(item.dateCreated!),
                  style: valueStyle,
                ),
              ],
            ),
          if (item.hasSubtitles != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sous titre : ',
                  style: titleStyle,
                ),
                UnorderedList(
                    texts: item.mediaStreams!
                        .where((element) =>
                            element.type == MediaStreamType.SUBTITLE)
                        .map((e) => e.displayTitle! + ', ' + e.codec!)
                        .toList())
              ],
            ),
          if (item.mediaStreams != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Audio : ',
                  style: titleStyle,
                ),
                UnorderedList(
                    texts: item.mediaStreams!
                        .where(
                            (element) => element.type == MediaStreamType.AUDIO)
                        .map((e) => e.displayTitle! + ', ' + e.codec!)
                        .toList()),
              ],
            )
        ]));
  }

  List<DropdownMenuItem<AudioTrack>> audioDropdownItems(Item item) {
    if (item.mediaSources == null) return <DropdownMenuItem<AudioTrack>>[];

    // Find the default sub to choose
    var audioList = item.mediaSources!.first.mediaStreams!
        .where((element) => element.type == MediaStreamType.AUDIO)
        .toList();

    var defaultAudio = audioList.firstWhere(
      (element) => element.isDefault!,
      orElse: () => audioList.first,
    );
    audioValue = AudioTrack(
        index: audioList.indexOf(defaultAudio),
        jellyfinSubtitleIndex: defaultAudio.index,
        name: defaultAudio.displayTitle ?? 'Unknow');
    streamModel.setAudioStreamIndex(audioValue);

    // Find all audio to fill dropdown
    return audioList
        .map((audioTrack) => AudioTrack(
            index: audioList.indexOf(audioTrack),
            jellyfinSubtitleIndex: audioTrack.index,
            name: audioTrack.displayTitle ?? 'Unknow'))
        .map<DropdownMenuItem<AudioTrack>>(
            (AudioTrack? value) => DropdownMenuItem<AudioTrack>(
                  value: value,
                  child: Text(value?.name ?? 'Unknown'),
                ))
        .toList();
  }

  List<DropdownMenuItem<Subtitle>> subDropdownItems(Item item) {
    if (item.mediaSources == null) return <DropdownMenuItem<Subtitle>>[];

    // Find the default sub to choose
    var subList = item.mediaSources!.first.mediaStreams!
        .where((element) => element.type == MediaStreamType.SUBTITLE)
        .toList();
    if (subList.isNotEmpty) {
      var defaultSub = subList.firstWhere(
        (element) => element.isDefault!,
        orElse: () => subList.first,
      );
      subValue = Subtitle(
          index: subList.indexOf(defaultSub),
          jellyfinSubtitleIndex: defaultSub.index,
          name: defaultSub.displayTitle ?? 'Unknow');
      streamModel.setSubtitleStreamIndex(subValue);
    }

    // Find all subtitles to fill dropdown
    var subDropdownList = subList
        .map((subtitle) => Subtitle(
            index: subList.indexOf(subtitle),
            jellyfinSubtitleIndex: subtitle.index,
            name: subtitle.displayTitle ?? 'Unknow'))
        .map<DropdownMenuItem<Subtitle>>((Subtitle? value) =>
            DropdownMenuItem<Subtitle>(
                value: value, child: Text(value?.name ?? 'Unknown')))
        .toList();

    return subDropdownList;
  }
}
