part of '../details_widgets.dart';

class TitleDetailsWidget extends StatelessWidget {
  const TitleDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (state.item.name == null) return SizedBox();
    return Flexible(
        child: Align(
      alignment: Alignment.centerLeft,
      child: SelectableText(
        state.item.name!,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ));
  }
}
