part of '../action_button.dart';

class ManageButton extends StatefulWidget {
  final Item item;
  final double maxWidth;

  const ManageButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  _ManageButtonState createState() => _ManageButtonState();
}

class _ManageButtonState extends State<ManageButton> with AppThemeGrabber {
  late final DetailsBloc detailsBloc;
  late final FormBloc<Item> formBloc;

  @override
  void initState() {
    formBloc = FormBloc<Item>();
    detailsBloc = BlocProvider.of<DetailsBloc>(context);
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
    return Theme(
      data: getThemeData,
      child: Material(
        color: Colors.transparent,
        child: Center(child: dialogBuilder(context)),
      ),
    );
  }

  Widget dialogBody(BuildContext context, [bool expanded = false]) {
    return DialogStructure(
        formBloc: formBloc,
        expanded: expanded,
        onClose: closeDialogAndResetForm,
        onSubmit: submitFormAndUpdateView);
  }

  Widget dialogBuilder(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth > 960) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600, maxHeight: 800),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: dialogBody(context)),
            ));
      }
      return dialogBody(context, true);
    });
  }

  void submitFormAndUpdateView() {
    formBloc.add(FormSubmitted());
    detailsBloc.add(DetailsUpdateItem(item: formBloc.value));
    formBloc.add(RefreshForm());
  }

  void closeDialogAndResetForm() {
    customRouter.pop();
  }
}
