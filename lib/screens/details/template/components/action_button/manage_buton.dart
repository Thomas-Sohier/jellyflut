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
      if (state is FormSubmittedState) {
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
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      builder: (c) => dialogParent(c),
      context: context,
    );
  }

  Widget dialogParent(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(child: dialogBuilder(context)),
    );
  }

  Widget dialogBody(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).dialogBackgroundColor,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black26))),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: closeDialogAndResetForm,
                            icon: Icon(Icons.close)),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text('edit_infos'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                      ],
                    ))),
            Flexible(child: form.FormBuilder<Item>(formBloc: formBloc)),
            DecoratedBox(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Colors.black26))),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: closeDialogAndResetForm,
                            child: Text('cancel'.tr(),
                                style: TextStyle(fontSize: 18))),
                        TextButton(
                            onPressed: submitFormAndUpdateView,
                            child: Text('edit'.tr(),
                                style: TextStyle(fontSize: 18)))
                      ]),
                )),
          ]),
    );
  }

  Widget dialogBuilder(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth > 960) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600, maxHeight: 800),
              child: dialogBody(context)),
        );
      }
      return dialogBody(context);
    });
  }

  void submitFormAndUpdateView() {
    formBloc.add(FormSubmitted());
    detailsBloc.add(DetailsUpdateItem(item: formBloc.value));
    formBloc.add(RefreshForm());
  }

  void closeDialogAndResetForm() {
    customRouter.pop();
    // formBloc.add(RefreshForm());
  }
}
