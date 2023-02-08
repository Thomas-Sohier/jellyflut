import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/fav_button/cubit/fav_cubit.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class FavButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;
  final Item item;

  const FavButton({required this.item, this.padding = const EdgeInsets.all(10), this.size = 26});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavCubit(context.read<ItemsRepository>(), item: item),
      child: FavButtonView(padding: padding, size: size),
    );
  }
}

class FavButtonView extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;

  const FavButtonView({required this.padding, required this.size});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavCubit, FavState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.status) {
          case FavStatus.initial:
          case FavStatus.loading:
          case FavStatus.failure:
          case FavStatus.success:
            return state.isFav
                ? FavButtonChecked(padding: padding, size: size)
                : FavButtonUnchecked(padding: padding, size: size);
          default:
            return FavButtonUnchecked(padding: padding, size: size);
        }
      },
    );
  }
}

class FavButtonChecked extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;

  const FavButtonChecked({required this.padding, required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: context.read<FavCubit>().toggleFavorite,
        child: Padding(
          padding: padding,
          child: Icon(Icons.favorite, color: Colors.red.shade600, size: size),
        ));
  }
}

class FavButtonUnchecked extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double size;

  const FavButtonUnchecked({required this.padding, required this.size});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: context.read<FavCubit>().toggleFavorite,
        child: Padding(
          padding: padding,
          child: Icon(Icons.favorite_border, size: size),
        ));
  }
}
