part of '../action_button.dart';

class ManageButton extends StatelessWidget {
  final Item item;
  final double maxWidth;

  const ManageButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('manage'.tr(),
        onPressed: () => dialog(context),
        minWidth: 40,
        maxWidth: maxWidth,
        borderRadius: 4,
        icon: Icon(Icons.settings, color: Colors.black87));
  }

  void dialog(BuildContext context) {
    showDialog(
      builder: (_) => ResponsiveBuilder.builder(
          mobile: () =>
              editInfosFullscreen(context, () => onSuccessEvent(context)),
          tablet: () => editInfos(context, () => onSuccessEvent(context)),
          desktop: () => editInfos(context, () => onSuccessEvent(context))),
      context: context,
    );
  }

  Widget editInfos(BuildContext context, VoidCallback onSucess) {
    return AlertDialog(
        title: Text('edit_infos'.tr()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CancelButton(onPressed: customRouter.pop),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SubmitButton(
                  onPressed: () =>
                      BlocProvider.of<FormBloc>(context).add(FormSubmitted())))
        ],
        content: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 300, maxHeight: 700, minWidth: 350, maxWidth: 500),
            child: FormBuilder(item: item, onSuccess: onSucess)));
  }

  Widget editInfosFullscreen(BuildContext context, VoidCallback onSuccess) {
    return AlertDialog(
        title: Text('edit_infos'.tr()),
        insetPadding: EdgeInsets.zero,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CancelButton(onPressed: customRouter.pop),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SubmitButton(
                  onPressed: () =>
                      BlocProvider.of<FormBloc>(context).add(FormSubmitted())))
        ],
        content: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: double.maxFinite,
                maxHeight: double.maxFinite,
                minWidth: double.maxFinite,
                maxWidth: double.maxFinite),
            child: FormBuilder(
              item: item,
              onSuccess: onSuccess,
            )));
  }

  void onSuccessEvent(BuildContext context) {
    customRouter.pop();
    BlocProvider.of<DetailsBloc>(context).add(DetailsItemUpdated(item: item));
  }
}
