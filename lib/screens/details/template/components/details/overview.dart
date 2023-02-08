part of '../details_widgets.dart';

class OverviewDetailsWidget extends StatelessWidget {
  const OverviewDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (state.item.overview == null || state.item.overview!.isEmpty) {
      return const SizedBox();
    }
    return OutlinedButtonSelector(
      padding: EdgeInsets.all(4),
      onPressed: () => overviewDialog(context),
      alignment: Alignment.centerLeft,
      child: Text(
        state.item.overview!,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  void overviewDialog(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Theme(
              data: state.theme,
              child: AlertDialog(
                title: Text('overview'.tr()),
                titlePadding: const EdgeInsets.only(left: 8, top: 16, bottom: 12),
                contentPadding: const EdgeInsets.all(8.0),
                actions: [TextButton(autofocus: true, onPressed: context.router.root.pop, child: Text('ok'.tr()))],
                content: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: SelectableText(
                    state.item.overview!,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ));
        });
  }
}
