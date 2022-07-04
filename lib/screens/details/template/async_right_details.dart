import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/mixins/details_mixin.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/details/header.dart';
import 'package:jellyflut/screens/details/template/components/right_details.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class AsyncRightDetails extends StatefulWidget {
  final Item item;
  final BoxConstraints constraints;

  AsyncRightDetails({super.key, required this.item, required this.constraints});

  @override
  State<AsyncRightDetails> createState() => _AsyncRightDetailsState();
}

class _AsyncRightDetailsState extends State<AsyncRightDetails> with DetailsMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsBloc, DetailsState>(
        bloc: getDetailsBloc,
        listener: (_, detailsState) => {},
        builder: (_, detailsState) {
          return FutureBuilder<Item>(
              future: detailsState.detailsInfosFuture.item,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RightDetails(
                      item: snapshot.data!,
                      posterAndLogoWidget: Header(item: widget.item, constraints: widget.constraints));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView(
                    children: [
                      const SizedBox(height: 48),
                      Header(item: widget.item, constraints: widget.constraints),
                      const SkeletonRightDetails(),
                    ],
                  ),
                );
              });
        });
  }
}
