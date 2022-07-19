import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/details/poster.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
        buildWhen: ((previous, current) => previous.screenLayout != current.screenLayout),
        builder: ((context, state) {
          switch (state.screenLayout) {
            case ScreenLayout.desktop:
              if (state.item.hasLogo()) return Logo(item: state.item);
              return const SizedBox();
            case ScreenLayout.mobile:
            default:
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: itemPosterHeight),
                  child: const Poster(),
                ),
              );
          }
        }));
  }
}
