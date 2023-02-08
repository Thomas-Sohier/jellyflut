import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/people_poster.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class PeoplesList extends StatelessWidget {
  final EdgeInsets padding;

  const PeoplesList({this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    final peoples = context.read<DetailsBloc>().state.item.people;
    return SizedBox(
      height: 230,
      child: ListView.builder(
          itemCount: peoples.length,
          addAutomaticKeepAlives: false,
          scrollDirection: Axis.horizontal,
          controller: ScrollController(),
          itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: PeoplePoster(
                  person: peoples[index],
                  bigPoster: true,
                  clickable: true,
                  notFoundPlaceholder: const NotFoundActorPlaceholder(),
                  onPressed: (heroTag) => onTap(peoples[index], heroTag, context),
                ),
              )),
    );
  }

  Future<void> onTap(People person, String heroTag, BuildContext context) {
    return context.router.root.push(r.DetailsPage(item: person.asItem(), heroTag: heroTag));
  }
}

class NotFoundActorPlaceholder extends StatelessWidget {
  const NotFoundActorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.secondary,
        child: Center(
            child: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.onSecondary,
        )),
      ),
    );
  }
}
