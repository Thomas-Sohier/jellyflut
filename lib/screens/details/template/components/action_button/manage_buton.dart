part of '../action_button.dart';

class ManageButton extends StatelessWidget {
  const ManageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FormBloc<Item>(context.read<ItemsRepository>()), child: const ManageButtonView());
  }
}

class ManageButtonView extends StatelessWidget {
  const ManageButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return PaletteButton('manage'.tr(),
        onPressed: () => dialog(context),
        minWidth: 40,
        borderRadius: 4,
        icon: Icon(Icons.settings, color: Colors.black87));
  }

  void dialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      builder: (c) => dialogParent(c, context),
      context: context,
    );
  }

  Widget dialogParent(BuildContext currentContext, BuildContext parentContext) {
    return Theme(
      data: currentContext.read<ThemeProvider>().getThemeData,
      child: Material(
        color: Colors.transparent,
        child: Center(child: dialogBuilder(parentContext)),
      ),
    );
  }

  Widget dialogBuilder(BuildContext parentContext) {
    return BlocBuilder<DetailsBloc, DetailsState>(
        bloc: parentContext.read<DetailsBloc>(),
        buildWhen: (previous, current) => previous.screenLayout != current.screenLayout,
        builder: (context, state) {
          if (state.screenLayout == ScreenLayout.desktop) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600, maxHeight: 800),
                  child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(4)), child: dialogBody(context)),
                ));
          }
          return dialogBody(parentContext, true);
        });
  }

  Widget dialogBody(BuildContext parentContext, [bool expanded = false]) {
    return BlocConsumer<FormBloc<Item>, FormState>(
      bloc: parentContext.read<FormBloc<Item>>(),
      listener: (context, state) => {},
      builder: (context, state) => DialogStructure(
          formBloc: parentContext.read<FormBloc<Item>>(),
          expanded: expanded,
          onClose: closeDialogAndResetForm,
          onSubmit: () => submitFormAndUpdateView(parentContext)),
    );
  }

  void submitFormAndUpdateView(BuildContext parentContext) {
    parentContext.read<FormBloc<Item>>().add(FormSubmitted());
    parentContext.read<DetailsBloc>().add(DetailsItemUpdate(item: parentContext.read<FormBloc<Item>>().value));
    parentContext.read<FormBloc<Item>>().add(RefreshForm());
  }

  void closeDialogAndResetForm() {
    customRouter.pop();
  }
}
