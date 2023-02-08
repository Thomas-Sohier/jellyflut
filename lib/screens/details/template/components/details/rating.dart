part of '../details_widgets.dart';

class RatingDetailsWidget extends StatelessWidget {
  const RatingDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (state.item.officialRating == null) return SizedBox();
    return Container(
      padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
      decoration: BoxDecoration(
          border: Border.all(width: 1, style: BorderStyle.solid, color: Theme.of(context).colorScheme.onBackground),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Text(state.item.officialRating!,
          textAlign: TextAlign.justify, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
