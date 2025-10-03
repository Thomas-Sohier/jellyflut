import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

const double _kPosterHeight = 220.0;
const double _kPosterLabelHeight = 40.0;
const double _kHorizontalPadding = 12.0;
const double _kItemSpacing = 8.0;
const double _kDefaultAspectRatio = 2 / 3;

class ItemList extends StatelessWidget {
  final EdgeInsets padding;

  const ItemList({this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    final peoples = context.read<DetailsBloc>().state.item.people;
    const posterWidth = _kPosterHeight * _kDefaultAspectRatio;

    return SizedBox(
      height: _kPosterHeight + _kPosterLabelHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
        itemCount: peoples.length,
        itemExtent: posterWidth + _kItemSpacing,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: _kItemSpacing),
            child: ItemPoster(
              peoples[index].asItem(),
              clickable: true,
              showOverlay: false,
              showLogo: false,
              showParent: false,
            ),
          );
        },
      ),
    );
  }
}
