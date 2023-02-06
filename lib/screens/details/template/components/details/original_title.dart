part of '../details_widgets.dart';

class OriginalTitleDetailsWidget extends StatelessWidget {
  const OriginalTitleDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (!state.item.haveDifferentOriginalTitle()) return const SizedBox();
    return Align(
        alignment: Alignment.centerLeft,
        child: SelectableText(
          state.item.originalTitle!,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headlineSmall,
        ));
  }
}
