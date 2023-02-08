part of '../action_button.dart';

class ViewedButton extends StatelessWidget {
  final double maxWidth;

  const ViewedButton({super.key, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    return PaletteButton(
      'viewed'.tr(),
      onPressed: () => state.item.isPlayed() ? unsetItemViewed(context) : setItemViewed(context),
      borderRadius: 4,
      minWidth: 40,
      maxWidth: maxWidth,
      icon: state.item.isPlayed()
          ? Icon(Icons.check_box, color: Colors.green.shade900)
          : Icon(Icons.check_box_outline_blank, color: Colors.black87),
    );
  }

  void setItemViewed(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    context.read<ItemsRepository>().viewItem(state.item.id).then((UserData userData) => {
          // state.item.userData?.played = userData.played;
          // TODO simple cubit to save state
          // showToast('mark_item_viewed'.tr(args: [state.item.name ?? '']), fToast)
        });
  }

  void unsetItemViewed(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    context.read<ItemsRepository>().unviewItem(state.item.id).then((UserData userData) => {
          // TODO simple cubit to save state
          // setState(() {
          //   widget.item.userData?.played = userData.played;
          // }),
          // showToast('mark_item_unviewed'.tr(args: [widget.item.name ?? '']), fToast)
        });
  }
}
