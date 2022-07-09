import 'package:flutter/material.dart';
import 'package:jellyflut/components/people_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/shared/responsive_builder.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class PeoplesList extends StatefulWidget {
  final List<People> persons;
  final Color fontColor;
  final EdgeInsets padding;

  const PeoplesList(this.persons, {this.fontColor = Colors.black, this.padding = EdgeInsets.zero});

  @override
  State<StatefulWidget> createState() => _PeoplesListState();
}

class _PeoplesListState extends State<PeoplesList> {
  late Color fontColor;

  @override
  void initState() {
    fontColor = widget.fontColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [Expanded(child: listPeoples(widget.persons))]);
  }

  Widget listPeoples(List<People> peoples) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          itemCount: peoples.length,
          scrollDirection: Axis.horizontal,
          padding: widget.padding,
          itemBuilder: (context, index) {
            final person = peoples[index];
            final item = Item(
                name: person.name,
                id: person.id,
                imageBlurHashes: person.imageBlurHashes,
                imageTags: Map<String, String>.from({ImageType.PRIMARY.value: person.primaryImageTag ?? ''}),
                type: ItemType.Person);
            return ResponsiveBuilder.builder(
                mobile: () => largeScreenTemplate(item, person, index),
                tablet: () => largeScreenTemplate(item, person, index),
                desktop: () => largeScreenTemplate(item, person, index));
          }),
    );
  }

  Widget phonePoster(Item item, People person, int index) {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 5, child: PeoplePoster(person: person, onPressed: (heroTag) => onTap(item, person, heroTag))),
            Flexible(
                fit: FlexFit.loose,
                child: Text(
                  person.name ?? '',
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: TextStyle(color: fontColor.withAlpha(240), fontSize: 16),
                )),
            if (person.role != null)
              Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    person.role!,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(color: fontColor.withAlpha(200), fontSize: 12),
                  ))
          ],
        ));
  }

  Widget largeScreenTemplate(Item item, People person, int index) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: PeoplePoster(
          person: person, bigPoster: true, clickable: true, onPressed: (heroTag) => onTap(item, person, heroTag)),
    );
  }

  Future<void> onTap(Item item, People person, String heroTag) {
    return customRouter.push(DetailsRoute(item: item, heroTag: heroTag));
  }
}
