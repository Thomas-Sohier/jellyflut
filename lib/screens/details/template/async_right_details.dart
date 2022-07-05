import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/details/header.dart';
import 'package:jellyflut/screens/details/template/components/right_details.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';

class AsyncRightDetails extends StatelessWidget {
  const AsyncRightDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsBloc, DetailsState>(
        listener: (_, detailsState) => {},
        builder: (_, detailsState) {
          switch (detailsState.detailsStatus) {
            case DetailsStatus.initial:
            case DetailsStatus.loading:
              return const RightDetailsShimmer();
            case DetailsStatus.success:
              return const RightDetails();
            default:
              return const SizedBox();
          }
        });
  }
}

class RightDetailsShimmer extends StatelessWidget {
  const RightDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: [
          const SizedBox(height: 48),
          const Header(),
          const SkeletonRightDetails(),
        ],
      ),
    );
  }
}
