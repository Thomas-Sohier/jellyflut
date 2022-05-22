part of '../details_widgets.dart';

class OverviewDetailsWidget extends StatefulWidget {
  final String? overview;

  const OverviewDetailsWidget({Key? key, required this.overview})
      : super(key: key);

  @override
  _OverviewDetailsWidgetState createState() => _OverviewDetailsWidgetState();
}

class _OverviewDetailsWidgetState extends State<OverviewDetailsWidget>
    with AppThemeGrabber {
  late String? overview;

  @override
  void initState() {
    overview = widget.overview;
    super.initState();
  }

  @override
  void didUpdateWidget(OverviewDetailsWidget oldWidget) {
    overview = widget.overview;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (overview == null || overview!.isEmpty) return const SizedBox();
    return OutlinedButtonSelector(
      padding: EdgeInsets.all(4),
      onPressed: () => overviewDialog(context),
      alignment: Alignment.centerLeft,
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
          return Theme(
              data: getThemeData,
              child: Builder(
                  // Create an inner BuildContext so that we can refer to
                  // the Theme with Theme.of().
                  builder: (BuildContext dialogContext) => AlertDialog(
                        title: Text('overview'.tr()),
                        titlePadding:
                            const EdgeInsets.only(left: 8, top: 16, bottom: 12),
                        contentPadding: const EdgeInsets.all(8.0),
                        actions: [
                          TextButton(
                              autofocus: true,
                              onPressed: customRouter.pop,
                              child: Text('ok'.tr()))
                        ],
                        content: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: SelectableText(
                            overview!,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      )));
        });
  }
}
