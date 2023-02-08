import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

import '../action_button.dart';

class DetailsButtonRowBuilder extends StatelessWidget {
  const DetailsButtonRowBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    return SliverPadding(
      padding: state.contentPadding,
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250.0,
          mainAxisExtent: 45,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        delegate: SliverChildListDelegate(
          [
            // if (state.item.isPlayableOrCanHavePlayableChilren()) const PlayButton(maxWidth: double.infinity),
            if (state.item.hasTrailer()) const TrailerButton(maxWidth: double.infinity),
            if (state.item.isViewable()) const ViewedButton(maxWidth: double.infinity),
            if (state.item.isDownloable()) DownloadButton(maxWidth: double.infinity),
            const LikeButton(maxWidth: double.infinity),
            const ManageButton(maxWidth: double.infinity)
          ],
        ),
      ),
    );
  }
}
