import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/shared/shared.dart';

import '../../cubit/stream_cubit.dart';

class CurrentPositionPlayer extends StatelessWidget {
  const CurrentPositionPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: context.read<StreamCubit>().state.controller?.getPositionStream(),
      initialData: Duration.zero,
      builder: (context, snapshot) {
        return Text(printDuration(snapshot.data ?? Duration.zero));
      },
    );
  }
}
