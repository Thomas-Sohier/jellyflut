import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

import '../action_button.dart';

class DetailsButtonRowBuilder extends StatelessWidget {
  const DetailsButtonRowBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    return Wrap(
      direction: Axis.horizontal,
      spacing: 10,
      runSpacing: 10,
      children: [
        if (state.item.isPlayableOrCanHavePlayableChilren())
          LayoutBuilder(builder: (context, constraints) {
            final buttonExpanded = constraints.maxWidth < 600;
            if (buttonExpanded) return const PlayButton(maxWidth: double.infinity);
            if (!buttonExpanded) return const PlayButton();
            return const SizedBox();
          }),
        if (state.item.hasTrailer()) const TrailerButton(),
        if (state.item.isViewable()) const ViewedButton(),
        if (state.item.isDownloable()) const DownloadButton(),
        const LikeButton(),
        const ManageButton()
      ],
    );
  }
}
