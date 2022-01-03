import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/detailed_item_poster.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
import 'package:jellyflut/screens/collection/bloc/collection_bloc.dart';
import 'package:uuid/uuid.dart';

class CarouselSliderBuilder extends StatefulWidget {
  CarouselSliderBuilder({Key? key}) : super(key: key);

  @override
  _CarouselSliderBuilderState createState() => _CarouselSliderBuilderState();
}

class _CarouselSliderBuilderState extends State<CarouselSliderBuilder> {
  late final CarrousselProvider carrousselProvider;
  late final CollectionBloc collectionBloc;

  @override
  void initState() {
    super.initState();
    carrousselProvider = CarrousselProvider();
    collectionBloc = BlocProvider.of<CollectionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
        bloc: collectionBloc,
        builder: (context, collectionState) {
          if (collectionBloc.items.isEmpty) {
            return const SizedBox();
          } else {
            final unplayedItems = collectionBloc.carouselSliderItems;
            return Column(children: [
              SizedBox(height: 24),
              CarouselSlider(
                  options: CarouselOptions(
                      aspectRatio: (16 / 9),
                      viewportFraction: (16 / 9) / 2,
                      enlargeCenterPage: true,
                      pageSnapping: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 10),
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.horizontal,
                      initialPage: carrousselProvider.item != null
                          ? unplayedItems.indexOf(carrousselProvider.item!)
                          : 0,
                      // onPageChanged: (index, _) =>
                      //     carrousselProvider.changeItem(items[index]),
                      height: 300),
                  items: unplayedItems.map<Widget>((item) {
                    var heroTag = item.id + Uuid().v4();
                    return DetailedItemPoster(
                      item: item,
                      textColor: Colors.white,
                      heroTag: heroTag,
                    );
                  }).toList())
            ]);
          }
        });
  }
}
