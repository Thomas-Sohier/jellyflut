import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut/screens/home/home_cubit/home_cubit.dart';
import 'package:jellyflut/screens/home/home_drawer_cubit/home_drawer_cubit.dart';
import 'package:jellyflut/screens/home/home_scaffold.dart';
import 'package:jellyflut/screens/home/home_tabs_cubit/home_tabs_cubit.dart';

@RoutePage()
class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(itemsRepository: context.read<ItemsRepository>())..init(),
        ),
        BlocProvider<HomeTabsCubit>(create: (context) => HomeTabsCubit()),
        BlocProvider<HomeDrawerCubit>(create: (context) => HomeDrawerCubit()),
      ],
      child: const ParentHomeView(),
    );
  }
}

class ParentHomeView extends StatelessWidget {
  const ParentHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (_, state) {
        switch (state.status) {
          case HomeStatus.success:
            return HomeScaffold(routes: state.routes);
          case HomeStatus.unauthorized:
            // Ceci est un effet de bord, à gérer via un BlocListener de préférence
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.router.root.replace(AuthRoute());
            });
            return const SizedBox();
          case HomeStatus.failure:
            return const Scaffold(body: Center(child: Text('Error loading home')));
          default:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
