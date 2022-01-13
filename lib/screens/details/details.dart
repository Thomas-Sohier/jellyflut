import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/large_details.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:rxdart/subjects.dart';

import 'components/photo_item.dart';

class Details extends StatefulWidget {
  final Item item;
  final String? heroTag;

  const Details({required this.item, required this.heroTag});

  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late final DetailsBloc detailsBloc;

  @override
  void initState() {
    detailsBloc = DetailsBloc(getDetailsInfos());
    detailsBloc.getItemBackgroundColor(widget.item);
    super.initState();
  }

  @override
  void dispose() {
    detailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicPlayerFAB(
        child: BlocProvider<DetailsBloc>(
            create: (context) => detailsBloc,
            child: Scaffold(
                extendBody: true,
                backgroundColor: Colors.transparent,
                body: BlocListener<DetailsBloc, DetailsState>(
                    bloc: detailsBloc,
                    listener: (context, state) {
                      if (state is DetailsLoadedState) {
                        setState(() {});
                      }
                    },
                    child: widget.item.type != ItemType.PHOTO
                        ? LargeDetails(
                            item: widget.item, heroTag: widget.heroTag)
                        : PhotoItem(
                            item: widget.item, heroTag: widget.heroTag)))));
  }

  DetailsInfosFuture getDetailsInfos() {
    final item = offlineMode
        ? Future.value(widget.item)
        : ItemService.getItem(widget.item.id);

    return DetailsInfosFuture(
        item: item,
        dominantColor:
            BehaviorSubject<Future<List<Color>>>.seeded(Future.value([])));
  }
}
