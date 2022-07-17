part of '../details_widgets.dart';

class TaglineDetailsWidget extends StatelessWidget {
  const TaglineDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (state.item.taglines.isEmpty) return SizedBox();
    return SelectableText(
      '“ ${state.item.taglines.first} „',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontStyle: FontStyle.italic)
          .copyWith(fontFamily: 'Quicksand'),
    );
  }
}
