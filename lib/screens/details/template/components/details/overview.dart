part of '../details_widgets.dart';

class OverviewDetailsWidget extends StatelessWidget {
  final String? overview;
  const OverviewDetailsWidget({Key? key, required this.overview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (overview == null || overview!.isEmpty) return const SizedBox();
    return OutlinedButtonSelector(
      padding: EdgeInsets.all(4),
      onPressed: () => overviewDialog(context),
      child: Text(
        overview!,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  void overviewDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('overview'.tr()),
            titlePadding: const EdgeInsets.only(left: 8, top: 16, bottom: 12),
            contentPadding: const EdgeInsets.all(8.0),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              TextButton(
                  autofocus: true,
                  onPressed: customRouter.pop,
                  child: Text('ok'.tr()))
            ],
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Text(
                overview!,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          );
        });
  }
}
