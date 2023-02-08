part of '../details_widgets.dart';

class TaglineDetailsWidget extends StatelessWidget {
  const TaglineDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (state.item.taglines.isEmpty) return const SizedBox();
    return Padding(
        padding: EdgeInsets.only(top: 36),
        child: SelectableText(
          '“ ${state.item.taglines.first} „',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontStyle: FontStyle.italic)
              .copyWith(fontFamily: 'Quicksand'),
        ));
  }
}
