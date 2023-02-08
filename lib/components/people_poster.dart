import 'package:flutter/material.dart';

import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:uuid/uuid.dart';

class PeoplePoster extends StatefulWidget {
  final People person;
  final Widget? notFoundPlaceholder;
  final bool clickable;
  final bool bigPoster;
  final Function(String)? onPressed;

  PeoplePoster(
      {super.key,
      required this.person,
      this.onPressed,
      this.bigPoster = false,
      this.clickable = true,
      this.notFoundPlaceholder});

  @override
  State<PeoplePoster> createState() => _PeoplePosterState();
}

class _PeoplePosterState extends State<PeoplePoster> {
  // Dpad navigation
  late String posterHeroTag;
  late final heroTag;

  @override
  void initState() {
    heroTag = '${widget.person.id}-${Uuid().v1()}-person';
    super.initState();
  }

  Future<void> onTap() {
    if (widget.onPressed != null) {
      return widget.onPressed!(heroTag);
    }
    return Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    final finalPoster = widget.bigPoster
        ? BigPersonPoster(heroTag: heroTag, person: widget.person, notFoundPlaceholder: widget.notFoundPlaceholder)
        : PersonPoster(heroTag: heroTag, person: widget.person, notFoundPlaceholder: widget.notFoundPlaceholder);
    if (widget.clickable) {
      return OutlinedButtonSelector(onPressed: onTap, child: finalPoster);
    }
    return finalPoster;
  }
}

class PersonPoster extends StatelessWidget {
  final String heroTag;
  final People person;
  final Widget? notFoundPlaceholder;
  const PersonPoster({super.key, required this.heroTag, required this.person, this.notFoundPlaceholder});
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: heroTag,
        child: AspectRatio(
            aspectRatio: 2 / 3,
            child: AsyncImage(
              item: person.asItem(),
              notFoundPlaceholder: notFoundPlaceholder,
              boxFit: BoxFit.contain,
            )));
  }
}

class BigPersonPoster extends StatelessWidget {
  final String heroTag;
  final People person;
  final Widget? notFoundPlaceholder;
  const BigPersonPoster({super.key, required this.heroTag, required this.person, this.notFoundPlaceholder});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: heroTag,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AsyncImage(
                    item: person.asItem(),
                    notFoundPlaceholder: notFoundPlaceholder,
                    boxFit: BoxFit.contain,
                  ),
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.black87,
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0, 0.1, 0.25],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            person.name ?? '',
                            overflow: TextOverflow.clip,
                            softWrap: false,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          if (person.role != null)
                            Text(
                              person.role!,
                              overflow: TextOverflow.clip,
                              softWrap: false,
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}

MaterialStateProperty<double> buttonElevation() {
  return MaterialStateProperty.resolveWith<double>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
        return 2;
      }
      return 0; // defer to the default
    },
  );
}

MaterialStateProperty<BorderSide> buttonBorderSide(BuildContext context) {
  return MaterialStateProperty.resolveWith<BorderSide>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.focused)) {
        return BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.onBackground,
        );
      }
      return BorderSide(width: 0, color: Colors.transparent); // defer to the default
    },
  );
}
