import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/people_poster.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
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
            return Padding(
              padding: EdgeInsets.only(right: 10),
              child: PeoplePoster(
                person: person,
                bigPoster: true,
                clickable: true,
                notFoundPlaceholder: const NotFoundActorPlaceholder(),
                onPressed: (heroTag) => onTap(person, heroTag),
              ),
            );
          }),
    );
  }

  Future<void> onTap(People person, String heroTag) {
    return context.router.root.push(r.DetailsPage(item: person.asItem(), heroTag: heroTag));
  }
}

class NotFoundActorPlaceholder extends StatelessWidget {
  const NotFoundActorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.background,
        child: Center(
            child: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.onBackground,
        )),
      ),
    );
  }
}
