import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/view_button/cubit/view_cubit.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ViewButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;
  final Item item;

  const ViewButton({required this.item, this.padding = const EdgeInsets.all(10), this.size = 26});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewCubit(context.read<ItemsRepository>(), item: item),
      child: ViewButtonView(padding: padding, size: size),
    );
  }
}

class ViewButtonView extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;

  const ViewButtonView({required this.padding, required this.size});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewCubit, ViewState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.status) {
          case ViewStatus.initial:
          case ViewStatus.loading:
          case ViewStatus.failure:
          case ViewStatus.success:
            return state.isViewed
                ? ViewButtonChecked(padding: padding, size: size)
                : ViewButtonUnchecked(padding: padding, size: size);
          default:
            return ViewButtonUnchecked(padding: padding, size: size);
        }
      },
    );
  }
}

class ViewButtonChecked extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;

  const ViewButtonChecked({required this.padding, required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: context.read<ViewCubit>().toggleFavorite,
        child: Padding(
          padding: padding,
          child: Icon(Icons.check_box_outline_blank, size: size),
        ));
  }
}

class ViewButtonUnchecked extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;

  const ViewButtonUnchecked({required this.padding, required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: context.read<ViewCubit>().toggleFavorite,
        child: Padding(
          padding: padding,
          child: Icon(Icons.check_box, color: Colors.green.shade600, size: size),
        ));
  }
}
