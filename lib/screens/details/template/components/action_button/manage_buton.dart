part of '../action_button.dart';

class ManageButton extends StatefulWidget {
  final Item item;
  final double maxWidth;

  const ManageButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  _ManageButtonState createState() => _ManageButtonState();
}

class _ManageButtonState extends State<ManageButton> {
  late final FormBloc<Item> formBloc;
  late final DetailsBloc detailsBloc;

  @override
  void initState() {
    formBloc = FormBloc<Item>();
    // ignore: unnecessary_this
    detailsBloc = BlocProvider.of<DetailsBloc>(this.context);
    final i = widget.item.copyWithItem(item: widget.item);
    formBloc.add(CurrentForm<Item>(formGroup: FormGroup({}), value: i));
    formBloc.stream.listen((state) {
      if (state is FormValidState) {
        closeDialogAndResetForm();
      } else if (state is RefreshedState) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    formBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaletteButton('manage'.tr(),
        onPressed: () => dialog(context),
        minWidth: 40,
        maxWidth: widget.maxWidth,
        borderRadius: 4,
        icon: Icon(Icons.settings, color: Colors.black87));
  }

  void dialog(BuildContext context) {
    showDialog(
      builder: (_) => ResponsiveBuilder.builder(
          mobile: () => editInfosFullscreen(context),
          tablet: () => editInfos(context),
          desktop: () => editInfos(context)),
      context: context,
    );
  }

  Widget editInfos(BuildContext context) {
    return AlertDialog(
        title: Text('edit_infos'.tr()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CancelButton(onPressed: closeDialogAndResetForm),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SubmitButton(onPressed: submitFormAndUpdateView))
        ],
        content: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 300, maxHeight: 700, minWidth: 350, maxWidth: 500),
            child: form.FormBuilder<Item>(formBloc: formBloc)));
  }

  Widget editInfosFullscreen(BuildContext context) {
    return AlertDialog(
        title: Text('edit_infos'.tr()),
        insetPadding: EdgeInsets.zero,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CancelButton(onPressed: closeDialogAndResetForm),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SubmitButton(onPressed: submitFormAndUpdateView))
        ],
        content: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: double.maxFinite,
                maxHeight: double.maxFinite,
                minWidth: double.maxFinite,
                maxWidth: double.maxFinite),
            child: form.FormBuilder<Item>(
              formBloc: formBloc,
            )));
  }

  void submitFormAndUpdateView() {
    formBloc.add(FormSubmitted());

    final item = formBloc.value.copyWithItem(item: formBloc.value);
    detailsBloc.add(DetailsUpdateItem(item: item));
    formBloc.add(RefreshForm());
  }

  void closeDialogAndResetForm() {
    customRouter.pop();
    formBloc.add(RefreshForm());
  }
}
