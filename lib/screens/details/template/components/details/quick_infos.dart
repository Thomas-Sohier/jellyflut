import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/details_widgets.dart';

class QuickInfos extends StatelessWidget {
  const QuickInfos({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    return Row(
      children: [
        Expanded(
          child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                if (state.item.hasRatings()) Critics(item: state.item),
                const InfosDetailsWidget(),
              ]),
        ),
      ],
    );
  }
}
