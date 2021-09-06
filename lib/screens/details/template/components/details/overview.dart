part of '../details_widgets.dart';

class OverviewDetailsWidget extends StatelessWidget {
  final String? overview;
  const OverviewDetailsWidget({Key? key, required this.overview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (overview == null) return SizedBox();
    return Text(
      overview!,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}
