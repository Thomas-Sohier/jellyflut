import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/details/header.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';

import 'components/right_details.dart';

class AsyncRightDetails extends StatelessWidget {
  const AsyncRightDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
        buildWhen: (previous, current) => previous.detailsStatus != current.detailsStatus,
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
    return ListView(
      children: const [
        Header(),
        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: SkeletonRightDetails()),
      ],
    );
  }
}
