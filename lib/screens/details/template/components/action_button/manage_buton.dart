part of '../action_button.dart';

class ManageButton extends StatelessWidget {
  final double maxWidth;
  const ManageButton({super.key, this.maxWidth = 150});

  @override
  Widget build(BuildContext context) {
    return PaletteButton('manage'.tr(),
        onPressed: () => dialog(context),
        minWidth: 40,
        borderRadius: 4,
        maxWidth: maxWidth,
        icon: Icon(Icons.settings, color: Colors.black87));
  }

  void dialog(BuildContext superContext) {
    showDialog(
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      builder: (context) => MultiBlocProvider(providers: [
        BlocProvider.value(value: superContext.read<DetailsBloc>()),
        BlocProvider(
            create: (_) => FormBloc(
                itemsRepository: context.read<ItemsRepository>(), item: superContext.read<DetailsBloc>().state.item)
              ..add(InitForm())),
      ], child: const Dialog()),
      context: superContext,
    );
  }
}

class Dialog extends StatelessWidget {
  const Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.read<DetailsBloc>().state.theme,
      child: Material(
        color: Colors.transparent,
        child: Center(child: dialogBuilder(context)),
      ),
    );
  }

  Widget dialogBuilder(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
        bloc: context.read<DetailsBloc>(),
        buildWhen: (previous, current) => previous.screenLayout != current.screenLayout,
        builder: (_, state) {
          if (state.screenLayout == ScreenLayout.desktop) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600, maxHeight: 800),
                  child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(4)), child: dialogBody()),
                ));
          }
          return dialogBody(expanded: true);
        });
  }

  Widget dialogBody({bool expanded = false}) {
    return BlocConsumer<FormBloc, FormState>(
      listener: (context, state) {
        if (state.formStatus == FormStatus.submitted) {
          context.read<DetailsBloc>().add(DetailsItemUpdate(item: state.item));
          context.read<FormBloc>().add(ResetForm());
          context.router.root.pop();
        }
      },
      builder: (context, state) => DialogStructure(
          expanded: expanded,
          onClose: context.router.root.pop,
          onSubmit: () => context.read<FormBloc>().add(FormSubmitted())),
    );
  }
}
