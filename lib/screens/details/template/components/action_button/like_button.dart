part of '../action_button.dart';

class LikeButton extends StatelessWidget {
  final double maxWidth;

  const LikeButton({super.key, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    return PaletteButton(
      'like'.tr(),
      onPressed: () => state.item.isFavorite() ? unsetItemFav(context) : setItemFav(context),
      borderRadius: 4,
      minWidth: 40,
      maxWidth: maxWidth,
      icon: state.item.isFavorite()
          ? Icon(Icons.favorite, color: Colors.red.shade900)
          : Icon(Icons.favorite_border, color: Colors.black87),
    );
  }

  void setItemFav(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    context.read<ItemsRepository>().favItem(state.item.id).then((UserData userData) => {
          // TODO simple cubit to save state
          // setState(() {
          //   widget.item.userData!.isFavorite = userData.isFavorite;
          // }),
          // showToast('add_item_favorite'.tr(args: [widget.item.name ?? '']), fToast, duration: Duration(seconds: 3))
        });
  }

  void unsetItemFav(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    context.read<ItemsRepository>().unfavItem(state.item.id).then((UserData userData) => {
          // TODO simple cubit to save state
          // setState(() {
          //   widget.item.userData!.isFavorite = userData.isFavorite;
          // }),
          // showToast('remove_item_favorite'.tr(args: [widget.item.name ?? '']), fToast, duration: Duration(seconds: 3))
        });
  }
}
